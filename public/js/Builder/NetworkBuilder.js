///////////////////
// History Stuff //
///////////////////

// Network history initialization
const Struct = (...keys) => ((...v) => keys.reduce((o, k, i) => {o[k] = v[i]; return o} , {}))
const Step = Struct(
  'id',
  'operation',
  'allNodesBefore',
  'allEdgesBefore',
  'nodesInvolved',
  'edgesInvolved',
  'resultantNodes',
  'allNodesAfter',
  'allEdgesAfter'
)
var networkHistory = [
  Step(1, 'INIT', [], [], [], [], [], [], [], [])
];
var historyIdx = 0;
var historyLength = 1;

function updateHistory(
  operationType,
  allNodesBefore,
  allEdgesBefore,
  nodesInvolved,
  edgesInvolved,
  resultantNodes,
  allNodesAfter,
  allEdgesAfter
) {
  // Delete future history branch
  while (historyIdx < historyLength-1) {
    networkHistory.pop();
    historyLength--;
  }
  // Add history
  historyLength++;
  networkHistory.push(
    Step(
      historyLength,
      operationType,
      allNodesBefore,
      allEdgesBefore,
      nodesInvolved,
      edgesInvolved,
      resultantNodes,
      allNodesAfter,
      allEdgesAfter
    )
  );
  historyIdx++;

  try {
    // Store the history on a div so we can get it on the backend
    var outputPathElement = document.getElementById("frontendData");
    outputPathElement.setAttribute("value", JSON.stringify(networkHistory));
  } catch {
    // The component has not loaded in yet.
  }
}



/////////////////////
// Main Components //
/////////////////////

const initialNodes = [];
const initialEdges = [];

const nodeTypes = { tensor: TensorNode, invisible: InvisibleNode }; // the custom nodes
const edgeTypes = { index: DimensionEdge }; // the custom edges

// This is a disgusting hack! But it should work
const outputPathElement = document.getElementById("outputPath");
const outputPath = outputPathElement.getAttribute("value");

const backendErrorPathElement = document.getElementById("backendError");
const backendErrorPath = backendErrorPathElement.getAttribute("value");

function NetworkBuilder() {
  const [nodes, setNodes, onNodesChange] =
    ReactFlow.useNodesState(initialNodes); // the initial nodes
  const [edges, setEdges, onEdgesChange] =
    ReactFlow.useEdgesState(initialEdges); // the initial edges
  const [colorMenu, setColorMenu] = React.useState(null); // the initial menu
  const [reactFlowInstance, setReactFlowInstance] = React.useState(null); // used to get the functions from ReactFlow
  const ref = React.useRef(null); // reference

  const connectingNodeId = React.useRef(null); // for adding a node on edge drop
  const connectingHandleId = React.useRef(null); // for adding the correct edge on edge drop

  const [eId, setEId] = React.useState(1); // the edge ID
  const [freeNodesId, setFreeNodesId] = React.useState(1); // the ID used for tensors that represent free indices
  const [nodeId, setNodeId] = React.useState(1); // the node ID

  const [rank, setRank] = React.useState(2); // the rank of the current tensor to be dragged

  const [tensorsCreated, setTensorsCreated] = React.useState(0); // the number of tensors created

  const [tensorColor,setTensorColor] = React.useState("50"); // the color of the tensors


  // 
  const deleteNodesAndEdges = () => {
  	const selectedNodes = nodes.filter((node) => node.selected);
  	const selectedEdges = edges.filter((edge) => edge.selected);
  	let edgesToDelete = [];
  	let currentNode;
  	let currentEdge;
  	let currentEdgesToDelete;

  	for (let i = 0; i<selectedNodes.length; i++){
  		currentNode = selectedNodes[i];
  		currentEdgesToDelete = edges.filter((edge) => edge.source==currentNode.id || edge.target==currentNode.id);
  	}

  	for (let j = 0; j<selectedEdges.length; j++){

  	}
  }

  // when two node handles are connected
  const onConnect = (params) => {
    // reset the information for add node on drop
    connectingNodeId.current = null;
    connectingHandleId.current = null;

    // the information for the edge that connects the nodes
    const newEdge = {
      id: `e${eId}`,
      label: `e${eId}`,
      data: { dim: 1, chosenDim: false, lineStyle: "Bezier"},
      type: "index",
      ...params,
    };

    // updating the edge ID
    setEId((oldEId) => oldEId + 1);

    // updating the list of edges
    setEdges((eds) => {
      return ReactFlow.addEdge(newEdge, eds);
    });
  };

  // when a edge is being dragged from a handle but has not connected with another node yet
  const onConnectStart = (params, { handleId, nodeId }) => {
    connectingNodeId.current = nodeId; // the ID of the source node
    connectingHandleId.current = handleId; // the ID of the source handle
    let currentEdge;

    for (let i = 0; i < edges.length; i++) {
      currentEdge = edges[i];

      if (currentEdge.sourceHandle == handleId) {
        connectingNodeId.current = null;
    		connectingHandleId.current = null;
      }
    }

  }

  const onConnectEnd = (event) => {
    if (!connectingNodeId.current) return;

    const targetIsPane = event.target.classList.contains("react-flow__pane"); // makes sure the target is the window

    // if the target is the network canvas then the index in a free index otherwise nothing happens
    if (targetIsPane) {
      // we need to remove the wrapper bounds, in order to get the correct position
      const position = reactFlowInstance.screenToFlowPosition({
        x: event.clientX,
        y: event.clientY,
      });

      const id = `f${freeNodesId}`; // the ID of the invisible node

      const newNode = { id, type: "invisible", position, data: {mutable: true} }; // creating the new node

      setFreeNodesId((oldFreeNodesId) => oldFreeNodesId + 1); // updating the oldFreeNodesID

      setNodes((nds) => nds.concat(newNode)); // adding the new node

      // updating the edges by adding the new edge
      setEdges((eds) =>
        eds.concat({
          id: `e${eId}`,
          label: `e${eId}`,
          type: "index",
          source: connectingNodeId.current,
          sourceHandle: connectingHandleId.current,
          target: id,
          targetHandle: id,
          data: { dim: 1, chosenDim: false, lineStyle: "Free"},
        })
      );

      setEId((oldEId) => oldEId + 1); // updating the edge ID
    }
  };

  // the color menu that allows the user to change the color of tensors
  const onNodeColorMenu =
    (event, node) => {
      // Prevent native context menu from showing (when you normally right click a page)
      event.preventDefault();

      // Calculate position of the info menu. We want to make sure it doesn"t get positioned off-screen.
      const pane = ref.current.getBoundingClientRect();

      // the information required to position and display the menu
      setColorMenu({
        node: node,
        top: event.clientY,
        left: event.clientX,
      });
    }

  // Close the color menu if it's open whenever the window is clicked.
  const onPaneClick = React.useCallback(() => setColorMenu(null), [setColorMenu]);

  // allows the tensors to be dragged onto the canvas
  const onDragOver = React.useCallback((event) => {
    event.preventDefault();
    event.dataTransfer.dropEffect = "move";
  }, []);

 // when a node has been dropped on the canvas
  const onDrop = 
    (event) => {
      event.preventDefault();

      const type = event.dataTransfer.getData("application/reactflow");

      // check if the dropped element is valid
      if (typeof type === "undefined" || !type) {
        return;
      } else if (tensorsCreated==10){ // the limit of tensors on a canvas is 10
      	return;
      }

      // calculates the position to place the new node
      const position = reactFlowInstance.screenToFlowPosition({
        x: event.clientX,
        y: event.clientY,
      });

      const color = "hsl(" + tensorColor + ", 100%, 80%)"; // the color of the new tensor

      const newNode = { id: `${nodeId}`, type, position, style:{backgroundColor: color}, data: { rank: rank, mutable: true, label: "", color: tensorColor}}; // making the new tensor
      setNodeId((oldNodeId) => oldNodeId+1) // updating the node ID

      setNodes((nds) => nds.concat(newNode)); // updating the nodes
      setTensorsCreated((oldVal) => oldVal+1); // updating the number of tensors created
    }

    // checks if the connection between two tensors is valid
  const isValidConnection = (connection) => {
    const sourceHandle = connection.sourceHandle;
    const targetHandle = connection.targetHandle;
    let currentEdge;

    for (let i = 0; i < edges.length; i++) {
      currentEdge = edges[i];

      // this checks if the handle has been connected to something else already, only one connection per handle is allowed
      if (
        currentEdge.sourceHandle == sourceHandle ||
        currentEdge.targetHandle == targetHandle ||
        currentEdge.sourceHandle == targetHandle ||
        currentEdge.targetHandle == sourceHandle
      ) {
        return false;
      }
    }
    return true;
  };


  // called when edges are deleted, deletes invisible tensors if the edge is connected to invisible tensors and checks that the edge is not connected to mutable tensors
  const onEdgesDelete = (eds) => {
  	let nodesToDelete = [];
  	let sourceNode, targetNode;

  	for (let i = 0; i<eds.length; i++){
	  	sourceNode = reactFlowInstance.getNode(eds[i].source);
			targetNode = reactFlowInstance.getNode(eds[i].target);

			// checking if the target and source tensors are mutable
			if (sourceNode.data.mutable && targetNode.data.mutable || !nodes.includes(sourceNode)){
				if (targetNode.type == "invisible"){
					nodesToDelete = nodesToDelete.concat(targetNode.id);
				}
			}
  	}

	  setNodes((oldNodes) => oldNodes.filter((node) => !nodesToDelete.includes(node.id)));

  };

  // this is called whenever a change is made to an edge, but we only do something if the edge is being removed
  // this exists so that non-mutable tensors do not get changed
  function handleEdgesChange(changes) {
    const validChanges = changes.filter((change) => {
    	if (change.type == "remove"){ // checks if the edge is being removed
    		const currentEdge = reactFlowInstance.getEdge(change.id);
    		const sourceNode = reactFlowInstance.getNode(currentEdge.source);
    		const targetNode = reactFlowInstance.getNode(currentEdge.target);

	    	if (sourceNode.data.mutable && targetNode.data.mutable){
	    		// we accept the changes to remove the edge
	    		return true;
	    	} else {
	    		// we reject the changes the remove the edge
	    		return false;
	    	}

    	} else {
    		return true // we accept changes to the edge
    	}
    })
   	
		// apply the changes we kept
    onEdgesChange(validChanges);
  }

// the purpose of this function is to cause edge splits when a node is deleted instead of deleting all edges attatched
  const onNodesDelete = (nds) => {
  	let currentNode, currentEdge, newNode, targetNode;
  	let numNewFreeNodes = 0; 
  	let newFreeNodes = [];

  	let updatedEdges = [];

  	// loops through the nodes to delete
  	for (let i= 0; i<nds.length; i++){
  		currentNode = nds[i];

  		// we only consider deleting edges if we are currently trying to delete a tensor node
  		if (currentNode.type == "tensor"){
  			for (let j=0; j<edges.length; j++){
	  			currentEdge = edges[j];

	  			// making sure the edge is not attached it itself
	  			if (currentEdge.target!=currentEdge.source){
		  			// checks if the current node is the current edge target
		  			if (currentEdge.target == currentNode.id){ // if the current node is a tensor and a target then it must be connected to another tensor
		  				newFreeNodes = newFreeNodes.concat({ id: `f${freeNodesId+numNewFreeNodes}`, type: "invisible", position: currentNode.position, data: {mutable: true} });
		  				currentEdge.target = `f${freeNodesId+numNewFreeNodes}`;
		  				currentEdge.targetHandle = `f${freeNodesId+numNewFreeNodes++}`;
		  				currentEdge.data.lineStyle = "Free";
		  				updatedEdges = updatedEdges.concat(currentEdge);
		  				
		  				// checks if the current node is the current edge source
		  			} else if (currentEdge.source == currentNode.id){
		  					targetNode = reactFlowInstance.getNode(currentEdge.target);

		  					// checks if the target node is a free node or another tensor
		  					if (targetNode.type == "tensor" ){
		  						newFreeNodes = newFreeNodes.concat({ id: `f${freeNodesId+numNewFreeNodes}`, type: "invisible", position: currentNode.position, data: {mutable: true} });
		  						// need to swap the target and source because free nodes are ALWAYS the target
		  						currentEdge.source = currentEdge.target
		  						currentEdge.sourceHandle = currentEdge.targetHandle
		  						currentEdge.target = `f${freeNodesId+numNewFreeNodes}`;
		  						currentEdge.targetHandle = `f${freeNodesId+numNewFreeNodes++}`;
		  						currentEdge.data.lineStyle = "Free";
		  						updatedEdges = updatedEdges.concat(currentEdge);

		  					}

		  			}
	  			}
	  		}
  		}

  		// sets the edges
  		setEdges((oldEdges) => oldEdges.filter((edge) => {
  			if (updatedEdges.length != 0){
  				for (let i=0; i<updatedEdges.length; i++){
	  				if (edge.id==updatedEdges[i].id){
	  					return false;
	  				} else {
	  					return true;
	  				}
  				}
  			} else {
  				return true;
  			}
  		}).concat(updatedEdges));

  		setFreeNodesId((oldVal) => oldVal+numNewFreeNodes);
  		setNodes((oldNodes) => oldNodes.concat(newFreeNodes));


  	}
  }

 // PURPOSE OF THIS IS TO PRINT THE CURRENT NODES AND EDGES
 //   React.useEffect(() => {
 // 		console.log(edges);
 //  },[edges]);

 // React.useEffect(() => {
 // 		console.log(nodes);
 //  },[nodes]);

  return (
    <div className="dndflow">
      <ReactFlow.ReactFlowProvider>
        <div id="network_canvas" className="reactflow-wrapper">
          {
            <ReactFlow.ReactFlow
              connectionMode={ReactFlow.ConnectionMode.Loose}
              ref={ref}
              nodes={nodes}
              edges={edges}
              onNodesChange={onNodesChange}
              onEdgesChange={handleEdgesChange}
              onConnect={onConnect}
              onInit={setReactFlowInstance}
              onDrop={onDrop}
              onDragOver={onDragOver}
              nodeTypes={nodeTypes}
              edgeTypes={edgeTypes}
              onConnectStart={onConnectStart}
              onConnectEnd={onConnectEnd}
              isValidConnection={isValidConnection}
              onEdgesDelete={onEdgesDelete}
              onNodesDelete={onNodesDelete}

              onNodeContextMenu={onNodeColorMenu}
              onPaneClick={onPaneClick}

              proOptions={{hideAttribution: true}}
            >
              <ReactFlow.Controls />
              <ReactFlow.MiniMap pannable="true" zoomable="true" />
              <ReactFlow.Background variant="dots" gap={12} size={1} />
            </ReactFlow.ReactFlow>
          }
        </div>

        <DNDMenu 
        nodeId={nodeId} 
        setNodeId={setNodeId}
        edgeId = {eId}
        setEdgeId = {setEId}
        freeNodesId = {freeNodesId}
        setFreeNodesId = {setFreeNodesId}
        rank={rank}
        setRank = {setRank}
        tensorColor = {tensorColor}
        setTensorColor={setTensorColor}
        backendErrorPath={backendErrorPath}
        >
        </DNDMenu>

        {colorMenu && <ColorMenu onClick={onPaneClick} {...colorMenu} />}
      </ReactFlow.ReactFlowProvider>
    </div>
  );
}

const domNode = document.getElementById("networkDisplay");
const root = ReactDOM.createRoot(domNode); // where the React components are displayed

root.render(<NetworkBuilder />);
