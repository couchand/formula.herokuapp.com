function isValid( text ) {
    var console = document.getElementById('console'),
        consoleText = document.getElementById('consoleText');

    consoleText.innerHTML = '';
    console.className = '';
    try {
        parser.parse( text );
        return true;
    }
    catch (ex) {
        consoleText.innerHTML = '' + ex;
        console.className = 'err';
    }
    return false;
}
