from flask import render_template, url_for, request, redirect, flash
from flask_login import login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
from io import BytesIO
import base64
import pandas as pd
from matplotlib.figure import Figure
import uuid
from yookassa import Configuration, Payment

from riviera import application, db
from riviera.models import Users, Profiles, Utilities, Service, Payments, Texts, Feedbacks
from riviera.forms import LoginForm, RegisterForm, SendUtility, SendPayment, FeedbackForm


@application.route('/index')
@application.route('/')
def index():

    return render_template('index.html')

@application.route('/main', methods=['POST', 'GET'])
def main():
    
    if current_user.is_authenticated:
        return redirect(url_for('analytics'))
    
    text = db.session.execute(db.select(Texts).filter_by(page='main')).scalars().all()
    
    form_register = RegisterForm()
    form_login = LoginForm()
    form_feedback = FeedbackForm()
    
    return render_template('main.html', form_register=form_register, form_login=form_login,
                           form_feedback=form_feedback, text=text)
    

@application.route('/register', methods=['POST', 'GET'])
def register():
    
    text = db.session.execute(db.select(Texts).filter_by(page='main')).scalars().all()

    form_register = RegisterForm()
    form_login = LoginForm()
    form_feedback = FeedbackForm()

    if form_register.validate_on_submit():

        hash_password = generate_password_hash(form_register.password.data)
        user = Users(login=form_register.login.data, password=hash_password, date=datetime.utcnow())

        db.session.add(user)
        db.session.flush()

        profile = Profiles(name=form_register.name.data, tel=form_register.tel.data, email=form_register.email.data,
                           address=form_register.address.data, balance=0, account=user.id, user_id=user.id)

        db.session.add(profile)
        db.session.flush()

        utility = Utilities(date=datetime.utcnow(), value_electro=0, value_gas=0, value_water=0,
                            summ=0, user_id=user.id)

        db.session.add(utility)
        db.session.commit()

        if all([user, profile, utility]):

            flash('Вы успешно зарегистрированы. Авторизуйтесь', 'register_success')
            return redirect(request.args.get('next') or url_for('login'))
        else:
            flash('Ошибка при регистрации', 'register_danger')

    return render_template('main.html', form_register=form_register, form_login=form_login,
                           form_feedback=form_feedback, text=text)


@application.route('/login', methods=['POST', 'GET'])
def login():

    if current_user.is_authenticated:
        return redirect(url_for('analytics'))

    form_register = RegisterForm()
    form_login = LoginForm()
    form_feedback = FeedbackForm()
    
    text = db.session.execute(db.select(Texts).filter_by(page='main')).scalars().all()

    if form_login.validate_on_submit():
        user = db.session.execute(db.select(Users).filter_by(login=form_login.login.data)).scalar()

        if user and check_password_hash(user.password, form_login.password.data):
            check = form_login.remember.data
            login_user(user, remember=check)
            return redirect(request.args.get('next') or url_for('analytics'))
        else:
            flash('Неправильное имя пользователя и/или пароль', 'login_danger')

    return render_template('main.html', form_register=form_register, form_login=form_login,
                           form_feedback=form_feedback, text=text)


@application.route('/feedback', methods=['POST'])
def feedback():
    
    text = db.session.execute(db.select(Texts).filter_by(page='main')).scalars().all()
    
    form_register = RegisterForm()
    form_login = LoginForm()
    form_feedback = FeedbackForm()
    
    if form_feedback.validate_on_submit():

        feedback = Feedbacks(name=form_feedback.name.data, tel=form_feedback.tel.data)
        db.session.add(feedback)
        db.session.commit()

        if feedback:
            flash('Заявка отправлена', 'feedback_success')
            return redirect(url_for('main'))
        else:
            flash('Заявка не отправлена', 'feedback_danger')

    return render_template('main.html', form_register=form_register, form_login=form_login,
                           form_feedback=form_feedback, text=text)

@application.route('/lk', methods=['GET'])
@login_required
def lk():
    
    profile = db.session.execute(db.select(Profiles).filter_by(user_id=current_user.id)).scalar()
            
    return render_template('analytics.html', profile=profile)
    

@application.route('/logout', methods=['POST', 'GET'])
@login_required
def logout():

    logout_user()
    return redirect(url_for('main'))


@application.route('/history')
@login_required
def history():
    
    form_utility = SendUtility(user=current_user.id)

    profile = db.session.execute(db.select(Profiles).filter_by(user_id=current_user.id)).scalar()
    payments = db.session.execute(db.select(Payments).filter_by(user_id=current_user.id)).scalars().all()
    utility = db.session.execute(db.select(Utilities).filter_by(user_id=current_user.id)).scalars().all()
    balance_sum = sum([int(i.payment_summ) for i in payments if i.status == 1])

    debet = pd.Series([(i.date, i.summ) for i in utility])
    kredit = pd.Series([(i.date, i.payment_summ) for i in payments if i.status == 1])
    df_debet = pd.DataFrame([int(i[1]) / 100 for i in debet], index=[i[0] for i in debet]).\
        rename(columns={0: 'debet'})

    if not kredit.empty:
        df_kredit = pd.DataFrame([int(i[1]) / 100 for i in kredit], index=[i[0] for i in kredit]).\
            rename(columns={0: 'kredit'})
        df = pd.concat([df_debet, df_kredit], axis=0).sort_index().fillna(0)
    else:
        df = df_debet
        df['kredit'] = pd.Series()
        df = df.fillna(0)
    df['balance'] = round(df.kredit.cumsum() - df.debet.cumsum(), 2)

    return render_template('history.html', utility=utility, profile=profile, balance_sum=balance_sum, df=df, 
                           payments=payments, form_utility=form_utility)
    
    

@application.route('/analytics')
@login_required
def analytics():
    
    form_utility = SendUtility(user=current_user.id)
    
    profile = db.session.execute(db.select(Profiles).filter_by(user_id=current_user.id)).scalar()
    utility = db.session.execute(db.select(Utilities).filter_by(user_id=current_user.id)).scalars().all()
    payments = db.session.execute(db.select(Payments).filter_by(user_id=current_user.id)).scalars().all()
    service = db.session.execute(db.select(Service)).scalars().all()
    
    """ Secret Key и ID тестового 'магазина' для приема платежей по Ю-Кассе """
    Configuration.account_id = '221121'
    Configuration.secret_key = 'test_ncmxV6aAcu96URvfWIjUo2brCBAPB6wybqWMYi-ilWo'
    
    for payment in payments:
        payment_id = Payment.find_one(payment.payment_id)  # запрос о платеже в "Юкассу"
        if payment_id.status == 'succeeded':
            payment.status = True
            db.session.commit()

    payments_summ = sum([int(i.payment_summ) for i in payments if i.status])
    utility_summ = sum(int(i.summ) for i in utility)
    profile.balance = payments_summ - utility_summ
    db.session.commit()
            
    flag = len(utility) > 1
    flag_pay = len(payments) > 0
    electro_value = []
    gas_value = []
    water_value = []

    if len(utility) <= 6:
        date = [i.date.strftime('%m-%Y') for i in utility][1:]

        for i in range(len(utility))[1:][::-1]:
            electro_value.append(utility[i].value_electro - utility[i - 1].value_electro)
            gas_value.append(utility[i].value_gas - utility[i - 1].value_gas)
            water_value.append(utility[i].value_water - utility[i - 1].value_water)
    else:
        date = [i.date.strftime('%m-%Y') for i in utility][-6:]

        for i in range(len(utility))[-6:][::-1]:
            electro_value.append(utility[i].value_electro - utility[i - 1].value_electro)
            gas_value.append(utility[i].value_gas - utility[i - 1].value_gas)
            water_value.append(utility[i].value_water - utility[i - 1].value_water)
    
    if flag:
        chart_pie = [(utility[-1].value_electro - utility[-2].value_electro) * service[0].tariff / 100, 
                    (utility[-1].value_gas - utility[-2].value_gas) * service[1].tariff / 100,
                    (utility[-1].value_water - utility[-2].value_water) * service[2].tariff / 100]
    else:
        chart_pie = []
            
    return render_template('analytics.html', profile=profile, utility=utility,
                           payments=payments, service=service, flag=flag, flag_pay=flag_pay,
                           date=date, electro_value=electro_value,
                           gas_value=gas_value, water_value=water_value, 
                           chart_pie=chart_pie, form_utility=form_utility)
    
    
@application.route('/utility', methods=['POST', 'GET'])
@login_required
def utility():
    
    profile = db.session.execute(db.select(Profiles).filter_by(user_id=current_user.id)).scalar()
    utility = db.session.execute(db.select(Utilities).filter_by(user_id=current_user.id)).scalars().all()
    payments = db.session.execute(db.select(Payments).filter_by(user_id=current_user.id)).scalars().all()
    service = db.session.execute(db.select(Service)).scalars().all()
    
    form_utility = SendUtility(user=current_user.id)

    if form_utility.validate_on_submit():

        value_electro = form_utility.electro.data
        value_gas = form_utility.gas.data
        value_water = form_utility.water.data

        summ = (int(value_electro) - utility[-1].value_electro) * service[0].tariff / 100 + \
               (int(value_gas) - utility[-1].value_gas) * service[1].tariff / 100 + \
               (int(value_water) - utility[-1].value_water) * service[2].tariff / 100 + service[3].tariff / 100

        utility = Utilities(date=datetime.utcnow(), value_electro=value_electro, value_gas=value_gas,
                            value_water=value_water, summ=int(summ * 100), user_id=current_user.id)

        db.session.add(utility)
        db.session.commit()

        if utility:
            flash('Показания успешно переданы', 'utility_success')
            return redirect(request.args.get('next') or url_for('utility'))
        else:
            flash('Ошибка при передаче показаний', 'utility_danger')
            
    return render_template('utility.html', form_utility=form_utility, profile=profile, utility=utility,
                           payments=payments, service=service,)


@application.route('/pay', methods=['POST', 'GET'])
@login_required
def pay():

    profile = db.session.execute(db.select(Profiles).filter_by(user_id=current_user.id)).scalar()
    utility = db.session.execute(db.select(Utilities).filter_by(user_id=current_user.id)).scalars().all()
    service = db.session.execute(db.select(Service)).scalars().all()

    form_payment = SendPayment(balance=profile.balance)

    if form_payment.validate_on_submit():
        summ = form_payment.payment.data
    else:
        return render_template('pay.html', profile=profile, utility=utility, service=service,
                           form_payment=form_payment)

    """ Secret Key и ID тестового 'магазина' для приема платежей по Ю-Кассе """
    Configuration.account_id = '221121'
    Configuration.secret_key = 'test_ncmxV6aAcu96URvfWIjUo2brCBAPB6wybqWMYi-ilWo'
    
    summ = summ.replace(',', '')
    
    payment = Payment.create({
        "amount": {
            "value": summ,
            "currency": "RUB"
        },
        "confirmation": {
            "type": "redirect",
            "return_url": "http://www.riviera.alaltitov.ru/analytics"
        },
        "capture": True,
        "description": profile.user_id
    }, uuid.uuid4())
    
    

    payment_db = Payments(date=datetime.utcnow(), payment_id=payment.id, payment_summ=int(float(summ.replace(',', '')) * 100),
                          status=False, user_id=current_user.id)

    db.session.add(payment_db)
    db.session.commit()

    confirmation_url = payment.confirmation.confirmation_url
    return redirect(confirmation_url)

    

