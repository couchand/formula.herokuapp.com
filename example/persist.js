function loadFormula(cb) {
    if ( localStorage ) {
        var formula = localStorage.getItem('formula');
        if ( !!formula ) {
            document.getElementById('src').value = formula;
            if ( !!cb && "function" === typeof cb) {
                cb();
            }
        }
    }
}
function saveFormula(formula) {
    if ( localStorage ) {
        localStorage.setItem('formula', formula);
    }
}
