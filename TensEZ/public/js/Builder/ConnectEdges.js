const ConnectEdges = ({edgeId, setEdgeId, activeOption, setActiveOption}) => {
  const activeOptionId = 'Connect';

  const [toConnect, setToConnect] = React.useState(false);
  const [edgeOne, setEdgeOne] = React.useState("");
  const [edgeTwo, setEdgeTwo] = React.useState("");
  const [error, setError] = React.useState("");

  const { getEdges, setEdges, getNodes, setNodes, getNode } = ReactFlow.useReactFlow();
  const edges = getEdges();
  const nodes = getNodes();

  const ConnectEdge = 
    () => {
      const edgeOneLabel = edgeOne.trim(); // the first edge to connect
      const edgeTwoLabel = edgeTwo.trim(); // the second edge to connect
      const edgesToConnect = edges.filter((edge) => (edge.label==edgeOneLabel)||(edge.label==edgeTwoLabel)); // the edges to delete

      const targetEdgeOne = getNode(edgesToConnect[0].target); // the invisible node of the first edge
      const targetEdgeTwo = getNode(edgesToConnect[1]. target); // the invisible node of the second edge

      // checks for invalid input
      if (edgesToConnect==undefined || edgesToConnect.length<2){
        setError("Edge does not exist");
        return
      } else if (edgesToConnect.length > 2){
        setError("More than 2 edges with same label");
        return
      } else if (targetEdgeOne.type=="tensor" || targetEdgeTwo.type=="tensor"){
        setError("Both indices must be free indices");
        return
      }

      const firstEdge = edgesToConnect[0]
      const secondEdge =  edgesToConnect[1]

      // checks if the edge dimensions match
      if (firstEdge.data.dim != secondEdge.data.dim){
        setError("Dimensions do not match");
        return
      } else if ((firstEdge.data.chosenDim==false)||(secondEdge.data.chosenDim==false)){
        setError("Undefined dimension");
        return
      }

      // the new edge that connects the tensors directly
      const newEdge = {
        id: `e${edgeId}`,
        label: `${edgeOneLabel}`,
        source: firstEdge.source,
        sourceHandle: firstEdge.sourceHandle,
        target: secondEdge.source,
        targetHandle: secondEdge.sourceHandle,
        data: {
          dim: firstEdge.data.dim,
          chosenDim: true,
          lineStyle: "Bezier",
        },
        type: "index",
      };

      // updates the nodes and edges
      const nodesAfter = (nds) => nds.filter((node) => (node.id!=firstEdge.target)&&(node.id!=secondEdge.target))
      const edgesAfter = (eds) => eds.filter((edge) => (edge.label!=edgeOneLabel)&&(edge.label!=edgeTwoLabel)).concat(newEdge)
      setNodes(nodesAfter);
      setEdges(edgesAfter);

      setEdgeId((oldEdgeId) => oldEdgeId+1);
      setError("");

      updateHistory(
        "CONNECT-EDGES",
        [],
        [],
        [],
        [firstEdge, secondEdge, newEdge],
        [],
        nodesAfter,
        edgesAfter
      )
    }


  if (activeOption != activeOptionId) {
    return (
      <button
        className="menu-operation"
        onClick={() => {
          setActiveOption(activeOptionId);
        }}
      >
        Connect Edge
      </button>
    );
  } else {
    return (
      <div className="active-menu-operation">
        <button
          className="menu-operation"
          onClick={() => {
            setActiveOption('None');
          }}
        >
          Connect Edge
        </button>
        <div className="error-message">{error}</div>
        <div className="menu-input-container">
          <label className="menu-input-label">Edge One: </label>
          <input
            className="menu-input"
            type="text"
            placeholder="e1"
            value={edgeOne}
            onChange={(e) => {
              setEdgeOne(e.target.value);
            }}
          ></input>
          <label className="menu-input-label">Edge Two: </label>
          <input
            className="menu-input"
            type="text"
            placeholder="e2"
            value={edgeTwo}
            onChange={(e) => {
              setEdgeTwo(e.target.value);
            }}
          ></input>
        </div>
        <button
          className="menu-submit-button"
          onClick={ConnectEdge}
        >
          Submit
        </button>
      </div>
    );
  }
};
