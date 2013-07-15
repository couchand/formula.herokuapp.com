function gTextArea() {
    var el = document.getElementById('src'),
        console = document.getElementById('console'),
        consoleText = document.getElementById('consoleText');

    if ( !isValid( el.value ) ) {
        return;
    }

    renderTree( buildTree( parser.parse( el.value ) ) );
    saveFormula(el.value);
}

function renderTree(treeData) {
    var barHeight = 20,
        barWidth = 200;

    // Create a svg canvas
    var vis = d3.select("#viz").html(null).append("svg:svg")
        .attr("width", 700)
        .attr("height", 400)
      .append("svg:g")
        .attr("transform", "translate(40, 20)");

    // Create a tree "canvas"
    var tree = d3.layout.tree()
        .size([400,100]);

    var diagonal = d3.svg.diagonal()
    // change x and y (for the left to right tree)
        .projection(function(d) { return [d.y, d.x]; });

    // Preparing the data for the tree layout, convert data into an array of nodes
    var nodes = tree.nodes(treeData);
    // Create an array with all the links
    var links = tree.links(nodes);

    nodes.forEach(function(n, i) {
        n.x = i * barHeight;
    });

    var link = vis.selectAll("pathlink")
        .data(links)
      .enter().append("svg:path")
        .attr("class", "link")
        .attr("d", diagonal)

    var node = vis.selectAll("g.node")
        .data(nodes)
      .enter().append("svg:g")
      .attr("class", "node")
        .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; })

    // Add the dot at every node
    node.append("svg:rect")
        .attr("y", -barHeight / 2)
        .attr("height", barHeight)
        .attr("width", barWidth);

    // place the name atribute left or right depending if children
    node.append("svg:text")
        .attr("dx", 5.5)
        .attr("dy", 3.5)
        .attr("class", "label")
        .text(function(d) { return d.name; });
}
