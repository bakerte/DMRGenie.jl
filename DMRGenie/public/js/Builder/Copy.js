const Copy = ({setCopiedNodes, setCopiedEdges, nodeId, setNodeId, edgeId, setEdgeId, freeNodeId, setFreeNodeId, setNewCopy}) => {
	const [error, setError] = React.useState("");
	const [copying, setCopying] = React.useState(false);
	const { getEdges, setEdges, getNodes, setNodes } = ReactFlow.useReactFlow();
	const cmdAndCPressed = ReactFlow.useKeyPress(["Meta+c","Strg+c"]);

  React.useEffect(() => {
    if (!cmdAndCPressed) {
      setCopying(false);
    }
  }, [cmdAndCPressed]);

	const copy = 
		() => {
			const edges = getEdges();
			const nodes = getNodes();

    	const selectedNodes = nodes.filter((node) => node.selected) // findig the nodes selected to copy 
    	let nodesToCopy = [] // nodes to copy
    	let edgesToCopy = [] // edges to copy 
    	let currentNode; // current node to copy
    	let tempNodesToCopy; // list of nodes to copy 
    	let tempEdgesToCopy; // list of edges to copy 
    	let numNodesToCopy = 0; // the number of copied nodes
    	let numEdgesToCopy = 0; // the number of copied edges
    	let numFreeNodesToCopy = 0; // the number of copied free nodes
    	let newName = {};

    	for (let j = 0; j<selectedNodes.length; j++){
			const parentNodeId = selectedNodes[j].id
    		currentNode = selectedNodes[j] // current node to copy
	    	tempNodesToCopy = ReactFlow.getOutgoers(currentNode,nodes,edges) // gets the target nodes of the current node
	    	tempEdgesToCopy = edges.filter((edge) => (edge.source==currentNode.id)) // gets the edges to copy

	    	for (let i = 0; i<tempNodesToCopy.length; i++){ // copying the free nodes, these will ALWAYS be target nodes
	    		if (tempNodesToCopy[i].type=="invisible"){
		    		tempNodesToCopy[i].selected = true;

		    		newName[tempNodesToCopy[i].id] = `f${freeNodeId+numFreeNodesToCopy}`; // storing the old name as and new name
		    		tempNodesToCopy[i].id = `f${freeNodeId+numFreeNodesToCopy++}`;

		    		tempNodesToCopy[i].position = {
						  x: tempNodesToCopy[i].position.x + 50,
						  y: tempNodesToCopy[i].position.y + 50
						};
		    	} 
	    	}

	    	if (currentNode.type == "tensor"){
	    		currentNode.selected = false;

				// For copying on backend
				currentNode.data.parentNodeId = parentNodeId;

		    	newName[currentNode.id] = `${nodeId+numNodesToCopy}`;
		    	currentNode.id = `${nodeId+numNodesToCopy++}`;
				currentNode.position = {
					x: currentNode.position.x + 50,
					y: currentNode.position.y + 50
				};
				nodesToCopy = nodesToCopy.concat(currentNode);
	    	}

	    	nodesToCopy = nodesToCopy.concat(tempNodesToCopy);
	    	edgesToCopy = edgesToCopy.concat(tempEdgesToCopy);

    	}

	    let handleNumberOne;
	    let handleNumberTwo;

  		for (let k = 0; k<edgesToCopy.length; k++){
  			if (!edgesToCopy[k].data.chosenDim){
  				setError("Undefined dimension")
  				return
  			}
    		edgesToCopy[k].selected = true; // just in case the edge was not selected when copying
    		edgesToCopy[k].id = `e${edgeId+numEdgesToCopy++}`
    		edgesToCopy[k].label = edgesToCopy[k].id

    		// making sure the edges connect to the right handles
    		handleNumberOne = edgesToCopy[k].sourceHandle[edgesToCopy[k].sourceHandle.length-1] // this returns the number of the handle
    		handleNumberTwo = edgesToCopy[k].targetHandle[edgesToCopy[k].targetHandle.length-1] // this returns the number of the handle

    		// changing the connection names of the edge to match the new names
    		edgesToCopy[k].source = `${newName[edgesToCopy[k].source]}`
    		edgesToCopy[k].sourceHandle = `${edgesToCopy[k].source}` + ": handles" + handleNumberOne
				edgesToCopy[k].target = `${newName[edgesToCopy[k].target]}`
				edgesToCopy[k].targetHandle = `${edgesToCopy[k].target}` + ": handles" + handleNumberTwo

				if ((edgesToCopy[k].source=="undefined")||(edgesToCopy[k].target=="undefined")){
					setError("Selected tensors are not isolated");
					return
				}
    	}

    	// update copied edges and nodes
    	setCopiedNodes(nodesToCopy);
    	setCopiedEdges(edgesToCopy);

    	setEdgeId((oldEdgeId) => oldEdgeId+numEdgesToCopy);
    	setNodeId((oldNodeId) => oldNodeId+numNodesToCopy);
    	setFreeNodeId((oldFreeNodeId) => oldFreeNodeId+numFreeNodesToCopy);
    	setNewCopy(true);
    	setError("");

    }

  if (cmdAndCPressed && !copying) {
  	setCopying(true);
  	copy();
  }


	return (
		<>
			<div label="error-message">{error}</div>
			<button
			className="menu-operation"
			onClick={copy}
			>
			Copy
			</button>
		</>
  )
}