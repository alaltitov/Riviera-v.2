const utilityForm = document.querySelector('.s_utility');
console.log(utilityForm);
utilityForm.classList.add('hidden');

const modalUtility = document.getElementById('modal__utility');
modalUtility.classList.remove('hidden');
modalUtility.querySelector('.modal__main').addEventListener('click', function(e) {
    e.stopPropagation();});
