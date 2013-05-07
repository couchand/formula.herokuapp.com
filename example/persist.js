function loadFormula() {
    if ( localStorage ) {
        document.getElementById('src').value = localStorage.getItem('formula');
    }
}
function saveFormula(formula) {
    if ( localStorage ) {
        localStorage.setItem('formula', formula);
    }
}
