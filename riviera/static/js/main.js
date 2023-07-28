/* slider */

const slider = new Swiper(".slider", {
    loop: true,
    grabCursor: true,
    parallax: true,
    speed: 1000,
    keyboard: {
        enable: true,
    },

    pagination: {
        el: ".swiper-pagination",
        clickable: true,
        renderBullet: function (index, className) {
            return '<span class="' + className + '">' + (index + 1) + "</span>";
        },
    },
});

/* YandexMap */

ymaps.ready(init);
function init() {
  
    var map = new ymaps.Map("map", {
        center: [55.784923, 37.265223],
        zoom: 12
    });

    var placemark = new ymaps.Placemark([55.784923, 37.265223], {}, {
        iconLayout: 'default#image',
        iconImageHref: '/static/img/main/location.svg',
        icon_imagesize: [40, 40],
        iconImageOffset: [-20, -40]
    });

    map.controls.remove('zoomControl');
    map.controls.remove('searchControl');
    map.controls.remove('trafficControl');
    map.controls.remove('geolocationControl');
    map.controls.remove('typeSelector');
    map.controls.remove('rulerControl');
    map.controls.remove('trafficControl');
    map.behaviors.disable(['scrollZoom']);
    map.geoObjects.add(placemark);
};

/* NavMobile */

const navBtn = document.querySelector('.nav__toggle');
const navBtnIcon = document.querySelector('.nav__btn-icon');
const nav = document.querySelector('.nav');

navBtn.onclick = function(){
    nav.classList.toggle('nav-mobile');
    navBtnIcon.classList.toggle('nav__btn-icon-active');
    document.body.classList.toggle('no-scroll');
};

document.querySelector('.nav__list').onclick = function() {
    nav.classList.toggle('nav-mobile');
    navBtnIcon.classList.toggle('nav__btn-icon-active');
    document.body.classList.toggle('no-scroll');
};

/* modal */

const modalButtons = document.querySelectorAll('[data-modal-btn]');
const modalClosebuttons = document.querySelectorAll('[data-modal-close]');
const allModals = document.querySelectorAll('[data-modal]');

modalButtons.forEach(function(item) {
    item.addEventListener('click', function() {
        const modalId = this.dataset.modalBtn;
        const modal = document.querySelector('#' + modalId);
        modal.classList.remove('hidden');
        modal.querySelector('.modal__main').addEventListener('click', function(e) {
            e.stopPropagation();
        });
    })
});

modalClosebuttons.forEach(function(item) {
    item.addEventListener('click', function() {
        const modal = this.closest('[data-modal]');
        modal.classList.add('hidden');
    })
});

allModals.forEach(function(item) {
    item.addEventListener('click', function() {
        this.classList.add('hidden');
    })
});

/* PhoneMask */

const phoneMaskreg = document.querySelector('#phone');
const phoneMaskfb = document.querySelector('#phone_fb');
const pm = new Inputmask('+7(999)-999-99-99');
pm.mask(phoneMaskreg);
pm.mask(phoneMaskfb);

/* EmailMask */

const emailMask = document.querySelector('#email');
const em = new Inputmask('email');
em.mask(emailMask);