parser.yy = module.exports;
var slickgrid;

function loadFields() {
    loadFormula(function(f) {
        loadData(function(d) {
            if ( !!f & !d ) {
                return getTemplate();
            }

            var cols = [];

            $.each( d, function (i, row) {
                if ( i === 0 ) {
                    $.each( row, function (col) {
                        if ( col === 'actual' ) return;
                        cols.push( field( col ) );
                    });
                    return;
                }
            });

            createSlickGrid( d, cols );
        });
    });
}

function field( property, minWidth ) {
    return {
        minWidth: property === 'message' ? 250 : 30,
        editor: Slick.Editors.Text,
        name: property,
        field: property,
        id: property
    };
}

function getTemplate() {
    var formula = $('#src').val();

    if ( !isValid( formula ) ) {
        return;
    }

    saveFormula(formula);

    $.get('test', { formula: formula }, function( unbound ) {
        $('#data').val( unbound );

        var columns = [];

        columns.push( field( 'message' ) );

        $.each( unbound, function(index, property) {
            if ( property !== 'expected' && property !== 'actual' && property !== 'message' ) {
                columns.push( field( property ) );
            }
        });

        columns.push( field( 'expected' ) );

        createSlickGrid([], columns);
    });
}

function createSlickGrid( rows, cols ) {
    slickgrid = new Slick.Grid('#dataGrid', rows, cols, {
        asyncEditorLoading: false,
        editable: true,
        enableAddRow: true,
        enableCellNavigation: true,
        enableColumnReorder: false
    });

    slickgrid.setSelectionModel( new Slick.CellSelectionModel() );
    slickgrid.registerPlugin( new Slick.CellExternalCopyManager() );

    slickgrid.onAddNewRow.subscribe(function (e, args) {
        var item = args.item;
        slickgrid.invalidateRow(slickgrid.getData().length);
        slickgrid.getData().push(item);
        slickgrid.updateRowCount();
        slickgrid.render();
    });
}

function runTests() {
    var formula = $('#src').val();
    var data = slickgrid.getData();
    var failures = {};

    if ( !isValid( formula ) ) {
        return;
    }

    saveFormula(formula);
    saveData(data);

    $.get('test', { formula: formula, data: data }, function( results ) {
        $.each( results, function (index, result) {
            if ( result.actual !== result.expected ) {
                failures[index] = { actual: 'failure' };
            }
        });

        var cols = slickgrid.getColumns();
        var foundActual = false;
        for ( var i in cols ) {
            foundActual = foundActual || cols[i].field === 'actual';
        }
        if ( !foundActual ) {
            cols.push( field( 'actual' ) );
            slickgrid.setColumns( cols );
        }

        slickgrid.setData( results );
        slickgrid.setCellCssStyles('failures', failures);
        slickgrid.render();
    });
}
