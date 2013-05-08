parser.yy = module.exports;
var slickgrid;

function loadFields() {
    loadFormula(function(f) {
        loadData(function(d) {
            if ( !!f & !d ) {
                return getTemplate();
            }

            cols = [], rows = [], actualCol = -1;

            $.each( d.split('\n'), function (i, row) {
                if ( i === 0 ) {
                    $.each( row.split(','), function (j, col) {
                        if ( col === 'actual' ) {
                            actualCol = j;
                            return;
                        }
                        cols.push( field( col ) );
                    });
                    return;
                }

                var me = {};
                $.each( row.split(','), function (j, cell) {
                    if ( j === actualCol ) return;
                    me[cols[j].field] = cell;
                });
                rows.push( me );
            });

            slickgrid = new Slick.Grid('#dataGrid', rows, cols, {
                editable: true,
                enableAddRow: true,
                enableColumnReorder: false
            });
        });
    });
}

function field( property, minWidth ) {
    return {
        minWidth: !!minWidth ? minWidth : 30,
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

    $.get('test', { formula: formula }, function( template ) {
        $('#data').val( template );

        var columns = [];

        columns.push( field( 'message', 250 ) );

        $.each( template.split(','), function(index, property) {
            if ( property !== 'expected' && property !== 'actual' && property !== 'message' ) {
                columns.push( field( property ) );
            }
        });

        columns.push( field( 'expected' ) );
        columns.push( field( 'actual' ) );

        slickgrid = new Slick.Grid('#dataGrid', [], columns, {
            editable: true,
            enableAddRow: true,
            enableColumnReorder: false
        });
    });
}

function runTests() {
    var formula = $('#src').val();
    var data = $('#data').val();
    var failures = {};

    if ( !isValid( formula ) ) {
        return;
    }

    var table = [];
    var r = [];
    $.each( slickgrid.getColumns(), function( j, col ) {
        r.push( col.field );
    });
    table.push( r.join(',') );

    $.each( slickgrid.getData(), function( i, row ) {
        var r = [];

        $.each( slickgrid.getColumns(), function( j, col ) {
            r.push( row[col.field] );
        });

        table.push( r.join(',') );
    });

    if ( 1 < table.length ) {
        data = table.join('\n');
    }

    console.log(data);

    saveFormula(formula);
    saveData(data);

    $.get('test', { formula: formula, data: data }, function( results ) {
        $.each( results, function (index, result) {
            if ( result.actual !== result.expected ) {
                failures[index] = { actual: 'failure' };
            }
        });

        var cols = slickgrid.getColumns();
        cols.push( field( 'actual' ) );
        slickgrid.setColumns( cols );

        slickgrid.setData( results );
        slickgrid.setCellCssStyles('failures', failures);
        slickgrid.render();
    });
}
