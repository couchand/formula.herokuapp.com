function gTextArea() {
    var el = document.getElementById('src'),
        console = document.getElementById('console'),
        consoleText = document.getElementById('consoleText');

    if ( !isValid( el.value ) ) {
        return;
    }

    var tree = buildTree( parser.parse( el.value ) );
    tree.x0 = 0;
    tree.y0 = 0;
    renderTree( tree );
    saveFormula(el.value);
}

var barHeight = 20,
    barWidth = 350;
var root, tree, vis;
var nextId = 0;

function renderTree(treeData) {
    // Create a svg canvas
    vis = d3.select("#viz").html(null).append("svg:svg")
        .attr("width", 700)
        .attr("height", 400)
      .append("svg:g")
        .attr("transform", "translate(40, 20)");

    // Create a tree "canvas"
    tree = d3.layout.tree()
        .size([400,100]);

    updateTree(root = treeData);
}

function updateTree(source) {
    // Preparing the data for the tree layout, convert data into an array of nodes
    var nodes = tree.nodes(root);

    nodes.forEach(function(n, i) {
        n.id = n.id || ++nextId;
        n.x = i * barHeight;
        if (n.children && n.children.length === 0) n.children = null;
    });

    var node = vis.selectAll("g.node")
        .data(nodes, function(d) { return d.id; });

    var nodeEnter = node.enter()
      .append("svg:g")
        .attr("class", "node");

    // Add the dot at every node
    nodeEnter.append("svg:rect")
        .attr("y", -barHeight / 2)
        .attr("height", barHeight)
        .attr("width", barWidth);

    node.select("rect")
        .style("fill", color);

    node.attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

    // place the name atribute left or right depending if children
    nodeEnter.append("svg:text")
        .attr("dx", 5.5)
        .attr("dy", 3.5)
        .attr("class", "label");

    node.select("text")
        .text(function(d) { return d.name; });

    node.on("click", handleClick);

    node.exit().remove();

    nodes.forEach(function(d) {
        d.x0 = d.x;
        d.y0 = d.y;
    });
}

function handleClick(d) {
    if (d._name) {
        d.name = d._name;
        d._name = null;
    } else {
        d._name = d.name;
        d.name = d.value;
    }

    if (d.children) {
        d._children = d.children;
        d.children = null;
    } else {
        d.children = d._children;
        d._children = null;
    }
    updateTree(d);
}

function color(d) {
    return d._children ? "#3182bd" : d.children ? "#c6dbef" : "#fd8d3c";
}
