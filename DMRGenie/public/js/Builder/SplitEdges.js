const SplitEdges = ({freeNodesId, setFreeNodesId, edgeId, setEdgeId, activeOption, setActiveOption}) => {
  const activeOptionId = 'Split';

  const [toSplit, setToSplit] = React.useState(false);
  const [edgeToSplit, setEdgeToSplit] = React.useState("");
  const [error, setError] = React.useState("");


  const { getEdge, getEdges, setEdges, getNode, setNodes } = ReactFlow.useReactFlow();
  const edges = getEdges();

  const splitEdge = 
    () => {
      const edgeToRemove = edges.filter((edge) => edge.label==edgeToSplit); // there should only be one edge that meets this condition
      const edgeToChange = edgeToRemove[0]; // the edge to split

      // checks for invalid input
      if (edgeToRemove == undefined){
        setError("Specified edge does not exist");
        return 

      } else if (edgeToRemove.length > 1){
        setError("Multiple edge with same name exist");
        return
      } else if (edgeToChange.data.chosenDim==false){
        setError("Undefined dimension");
        return
      }

      // the nodes to connect
      const nodeOne = getNode(edgeToChange.source);
      const nodeTwo = getNode(edgeToChange.target);

      // checks if the user is trying to split a free index
      if (nodeTwo.type == "invisible"){
        setError("Can not split a free index");
        return;
      }

      // the positioning of the invisible nodes is in the middle of the tensor nodes
      const position = {
        x: (nodeOne.position.x + nodeTwo.position.x) / 2,
        y: (nodeOne.position.y + nodeTwo.position.y) / 2,
      };

      // the new invisible nodes
      const newNodeOne = { id:`f${freeNodesId}`, type: "invisible", position };
      const newNodeTwo = { id:`f${freeNodesId+1}`, type: "invisible", position };

      // the new edges
      const newEdgeOne = {
        id: `e${edgeId}`,
        label: `${edgeToSplit}`,
        source: edgeToChange.source,
        sourceHandle: edgeToChange.sourceHandle,
        target: `f${freeNodesId}`,
        targetHandle: `f${freeNodesId}`,
        data: {
          dim: edgeToChange.data.dim,
          chosenDim: true,
          lineStyle: "Free",
        },
        type: "index",
      };

      const newEdgeTwo = {
        id: `e${edgeId+1}`,
        label: `${edgeToSplit}`,
        source: edgeToChange.target,
        sourceHandle: edgeToChange.targetHandle,
        target: `f${freeNodesId+1}`,
        targetHandle: `f${freeNodesId+1}`,
        data: {
          dim: edgeToChange.data.dim,
          chosenDim: true,
          lineStyle: "Free",
        },
        type: "index",
      };

      // updating the nodes and edges
      setNodes((nds) =>
        nds.concat(newNodeOne, newNodeTwo)
      );

      setEdges((eds) =>
        eds
          .filter((edge) => edge.label != edgeToSplit)
          .concat(newEdgeOne,newEdgeTwo)
      );
      setFreeNodesId((oldFreeNodesId) => oldFreeNodesId+2)
      setEdgeId((oldEdgeId) => oldEdgeId+2)

      setError("");

    }

  if (activeOption != activeOptionId) {
    return (
      <button
        className="menu-operation"
        onClick={() => {
          setActiveOption(activeOptionId);
        }}
      >
        Split Edge
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
          Split Edge
        </button>
        <div className="error-message">{error}</div>
        <div className="menu-input-container">
          <label className="menu-input-label">Edge To Split: </label>
          <input
            className="menu-input"
            type="text"
            placeholder="e1"
            value={edgeToSplit}
            onChange={(e) => {
              setEdgeToSplit(e.target.value);
            }}
          ></input>
        </div>
        <button
          className="menu-submit-button"
          onClick={splitEdge}
        >
          Submit
        </button>
      </div>
    );
  }
};