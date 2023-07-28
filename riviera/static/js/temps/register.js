const modalRegister = document.getElementById('modal__register');
modalRegister.classList.remove('hidden');
modalRegister.querySelector('.modal__main').addEventListener('click', function(e) {
    e.stopPropagation();})