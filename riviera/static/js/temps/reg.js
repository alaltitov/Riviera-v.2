const modalReg = document.getElementById('modal__reg');
modalReg.classList.remove('hidden');
modalReg.querySelector('.modal__main').addEventListener('click', function(e) {
    e.stopPropagation();})
