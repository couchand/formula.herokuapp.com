            parser.yy = module.exports;
            var slickgrid;

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
                });
            }
            function runTests() {
                var formula = $('#src').val();
                var data = $('#data').val();
                var columns = [], rows = [];
                var failures = {};

                if ( !isValid( formula ) ) {
                    return;
                }

                saveFormula(formula);

                $.get('test', { formula: formula, data: data }, function( results ) {
                    var resultTable = $('#results').empty();
                    var row = $('<tr>');

                    columns.push( field( 'message', 250 ) );

                    $.each( results[0], function(property, value) {
                        row.append( $('<th>').text( property ) );

                        if ( property !== 'expected' && property !== 'actual' && property !== 'message' ) {
                            columns.push( field( property ) );
                        }
                    });
                    row.appendTo( resultTable );

                    columns.push( field( 'expected' ) );
                    columns.push( field( 'actual' ) );

                    $.each( results, function (index, result) {
                        var row = $('<tr>'), dataRow = {};

                        row.append( $('<td>').text( result.message ) );

                        $.each( result, function(property, value) {
                            dataRow[property] = value;

                            if ( property !== 'expected' && property !== 'actual' && property !== 'message' ) {
                                row.append( $('<td>').text( value ) );
                            }
                        });

                        row.append( $('<td>').text( result.expected ) );

                        var actual = $('<td>').text( result.actual );
                        if ( result.actual !== result.expected ) {
                            actual.addClass('failure');

                            failures[index] = { actual: 'failure' };
                        }
                        row.append( actual );

                        rows.push( dataRow );
                        row.appendTo( resultTable );
                    });

                    slickgrid = new Slick.Grid('#dataGrid', rows, columns, {
                        editable: true,
                        enableAddRow: true,
                        enableColumnReorder: false
                    });
                    slickgrid.setCellCssStyles('failures', failures);
                });
            }
