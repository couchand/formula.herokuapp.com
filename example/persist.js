function loadFormula(cb) {
    if ( localStorage ) {
        var formula = localStorage.getItem('formula');
        if ( !!formula ) {
            document.getElementById('src').value = formula;
            if ( !!cb && "function" === typeof cb) {
                cb(formula);
            }
        }
    }
}
function saveFormula(formula) {
    if ( localStorage ) {
        localStorage.setItem('formula', formula);
    }
}

function loadData(cb) {
    if ( localStorage ) {
        var data = localStorage.getItem('test-data');
        if ( !!data ) {
            data = JSON.parse( data );
            if ( !!cb && "function" === typeof cb) {
                cb(data);
            }
        }
    }
}
function saveData(data) {
    if ( localStorage ) {
        localStorage.setItem('test-data', JSON.stringify(data));
    }
}
