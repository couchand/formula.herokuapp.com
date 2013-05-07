function loadFormula() {
    if ( localStorage ) {
        document.getElementById('src').value = localStorage.getItem('formula');
    }
}
function saveFormula() {
    if ( localStorage ) {
        localStorage.setItem('formula', document.getElementById('src').value);
    }
}
