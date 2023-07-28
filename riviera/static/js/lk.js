/* tab */

const tabHeaders = document.querySelectorAll('[data-tab]');
const contents = document.querySelectorAll('[data-tab-content]');

tabHeaders.forEach(function(item) {
    item.addEventListener('click', function() {
        contents.forEach(function(item) {
            item.classList.add('history__hidden');
        });
        tabHeaders.forEach(function(item) {
            item.classList.add('history__hover');
        });

        const content = document.querySelector('#' + this.dataset.tab);
        content.classList.remove('history__hidden');

        const tabHeader = document.querySelector('#' + 't_' + this.dataset.tab);
        tabHeader.classList.remove('history__hover');

    });
});

/* CurrencyMask */

const currencyMask = document.querySelector('#currency');
const cm = new Inputmask('currency');
cm.mask(currencyMask);
