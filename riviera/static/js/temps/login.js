const modalLogin = document.getElementById('modal__login');
modalLogin.classList.remove('hidden');
modalLogin.querySelector('.modal__main').addEventListener('click', function(e) {
    e.stopPropagation();})
