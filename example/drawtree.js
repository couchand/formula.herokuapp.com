function gTextArea() {
    var el = document.getElementById('src'),
        console = document.getElementById('console'),
        consoleText = document.getElementById('consoleText');

    console.className = '';
    consoleText.innerHTML = '';
    try {
        renderTree( buildTree( parser.parse( el.value ) ) );
        saveFormula(el.value);
    }
    catch (ex) {
        console.className = 'err';
        consoleText.innerHTML = '' + ex;
    }
}

function renderTree(treeData) {
    // Create a svg canvas
    var vis = d3.select("#viz").html(null).append("svg:svg")
        .attr("width", 700)
        .attr("height", 400)
      .append("svg:g")
        .attr("transform", "translate(40, 0)"); // shift everything to the right

    // Create a tree "canvas"
    var tree = d3.layout.cluster()
        .size([400,600]);

    var diagonal = d3.svg.diagonal()
    // change x and y (for the left to right tree)
        .projection(function(d) { return [d.y, d.x]; });

    // Preparing the data for the tree layout, convert data into an array of nodes
    var nodes = tree.nodes(treeData);
    // Create an array with all the links
    var links = tree.links(nodes);

    console.log(treeData)
    console.log(nodes)
    console.log(links)

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
    node.append("svg:ellipse")
        .attr("rx", 33.5)
        .attr("ry", 9.5);

    // place the name atribute left or right depending if children
    node.append("svg:text")
        .attr("x", -1)
        .attr("dy", 5)
        .attr("text-anchor", function(d) { return "middle"; })// d.children ? "end" : "start"; })
        .attr("class", "label")
        .text(function(d) { return d.name; })
}
