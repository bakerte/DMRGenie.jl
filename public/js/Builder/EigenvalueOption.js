const EigenvalueOption = ({
  nodeId,
  setNodeId,
  edgeId,
  setEdgeId,
  freeNodesId,
  setFreeNodesId,
  activeOption, setActiveOption,
  defaultColorCode, defaultColor}) => {
  const activeOptionId = 'EigenValue';

  const [toEigen, setToEigen] = React.useState(false);
  const [tensor, setTensor] = React.useState("");
  const [error, setError] = React.useState("");

  const { getEdges, setEdges, getNode, setNodes, getNodes } = ReactFlow.useReactFlow();

  const eigenDecomposition = 
    () => {
      const tensorId = tensor.trim();
      const currentTensor = getNode(tensorId);

      if (currentTensor==undefined){
        setError("Node does not exist")
        return 
      }

      const nodes = getNodes(); // list of all the nodes
      const edges = getEdges(); // list of all edges

      const nodesBefore = getNodes(); // For history
      const edgesBefore = getEdges();

      let totalDim = 1;
      let hasEdges = false;
      let nodesToRemove = [];
      let edgesToRemove = [];

      let currentEdge;
      let targetNode;
      let numEdges = 0;

      for (let i = 0; i<edges.length; i++){
        currentEdge = edges[i];

        // since the tensor to do the eigenvalue decomposition needs to be independent it should be a source for every node
        if (currentEdge.source==tensorId) { 
          targetNode = getNode(currentEdge.target);
          totalDim *= currentEdge.data.dim
          hasEdges = true;
          numEdges += 1;

          if (currentEdge.chosenDim){
            setError("Undefined dimension");
            return;

          } else if (targetNode.type=="invisible"){
            nodesToRemove = nodesToRemove.concat(currentEdge.target); // adding the ID of the target to nodes to remove
            edgesToRemove = edgesToRemove.concat(currentEdge.id);
          } else {
            setError("Selected tensor is not isolated");
            return;
          }

        } else if (currentEdge.target==tensorId){
            setError("Selected tensor is not isolated");
            return;
        }
      }

      const numEigenval = Math.sqrt(totalDim);


      if ((numEigenval != Math.floor(numEigenval))||(!hasEdges)){
        setError("The tensor can not be reshaped into a square matrix");
        return;
      } else if (numEdges != currentTensor.data.rank) {
        setError("Not all indices defined");
        return;
      }

      // top free tensor
      const freeNodeOnePosition = {
        x: currentTensor.position.x + currentTensor.width/2, // may be an issue here with 75, depends on tensor size...
        y: currentTensor.position.y - 200 +currentTensor.height/2,
      };

      // bottom free tensor
      const freeNodeTwoPosition = {
        x: currentTensor.position.x + currentTensor.width/2,
        y: currentTensor.position.y + 200,
      };

      // P
      const nodeOnePosition = {
        x: currentTensor.position.x,
        y: currentTensor.position.y - 100,
      };

      // D
      const nodeTwoPosition = {
        x: currentTensor.position.x,
        y: currentTensor.position.y,
      };

      // P^-1
      const nodeThreePosition = {
        x: currentTensor.position.x,
        y: currentTensor.position.y + 100,
      };

      // note mutable: true will be valid for every free node because delete deletion depends on the tensors
      const freeNodeOne = { id: `f${freeNodesId}`, type: "invisible", position: freeNodeOnePosition, data: {mutable: true} }
      const freeNodeTwo = { id: `f${freeNodesId+1}`, type: "invisible", position: freeNodeTwoPosition, data: {mutable: true} }

      // P
      const nodeOne = {
        id: `${nodeId}`,
        type: "tensor",
        style:{backgroundColor: defaultColor},
        position: nodeOnePosition,
        data: { rank: 2, mutable: false, label: "Eigenvectors", color: defaultColorCode},
      };

      // D
      const nodeTwo = {
        id: `${nodeId+1}`,
        type: "tensor",
        style:{backgroundColor: defaultColor},
        position: nodeTwoPosition,
        data: { rank: 2, mutable: false, label: "Diagonal", color: defaultColorCode },
      };

      // P^-1
      const nodeThree = {
        id: `${nodeId+2}`,
        type: "tensor",
        style:{backgroundColor: defaultColor},
        position: nodeThreePosition,
        data: { rank: 2, mutable: false, label: "Inverse Eigenvectors",color: defaultColorCode },
      };

      // free top tensor to P
      const edgeOne = {
        id: `e${edgeId}`,
        label: `e${edgeId}`,
        source: `${nodeId}`,
        sourceHandle: `${nodeId}` + ": handles0",
        target: `f${freeNodesId}`,
        targetHandle: `f${freeNodesId}`,
        data: {
          dim: numEigenval,
          chosenDim: true,
          lineStyle: "Free",
        },
        type: "index",
      };
      // P to D
      const edgeTwo = {
        id: `e${edgeId+1}`,
        label: `e${edgeId+1}`,
        source: `${nodeId}`,
        sourceHandle: `${nodeId}` + ": handles1",
        target: `${nodeId+1}`,
        targetHandle: `${nodeId+1}` + ": handles0",
        data: {
          dim: numEigenval,
          chosenDim: true,
          lineStyle: "Free",
        },
        type: "index",
      };

      // D to P^-1
      const edgeThree = {
        id: `e${edgeId+2}`,
        label: `e${edgeId+2}`,
        source: `${nodeId+1}`,
        sourceHandle: `${nodeId+1}`+ ": handles1",
        target: `${nodeId+2}`,
        targetHandle: `${nodeId+2}`+ ": handles0",
        data: {
          dim: numEigenval,
          chosenDim: true,
          lineStyle: "Free",
        },
        type: "index",
      };

      // P^-1 to bottom free tensor
      const edgeFour = {
        id: `e${edgeId+3}`,
        label: `e${edgeId+3}`,
        source: `${nodeId+2}`,
        sourceHandle: `${nodeId+2}`+ ": handles1",
        target: `f${freeNodesId+1}`,
        targetHandle: `f${freeNodesId+1}`,
        data: {
          dim: numEigenval,
          chosenDim: true,
          lineStyle: "Free",
        },
        type: "index",
      };

      const nodesAfter = nodes.filter((node) => (node.id != tensorId) && (!nodesToRemove.includes(node.id))).concat(nodeOne, nodeTwo, nodeThree, freeNodeOne, freeNodeTwo);
      const edgesAfter = edges.filter((edge) => !edgesToRemove.includes(edge.id)).concat(edgeOne, edgeTwo, edgeThree, edgeFour);

      setNodes(nodesAfter);
      setEdges(edgesAfter);

      setEdgeId((oldEdgeId) => oldEdgeId+4);
      setNodeId((oldNodeId) => oldNodeId+3);
      setFreeNodesId((oldFreeNodesId) => oldFreeNodesId+2);
      setError("");

      updateHistory(
        'EIGEN',
        nodesBefore,
        edgesBefore,
        [currentTensor],
        [], // TODO
        [nodeOne, nodeTwo, nodeThree],
        nodesAfter,
        edgesAfter
      )

    }


  if (activeOptionId != activeOption) {
    return (
      <button
        className="menu-operation"
        onClick={() => {
          setActiveOption(activeOptionId);
        }}
      >
        Eigenvalue
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
          Eigenvalue
        </button>
        <div className="error-message">{error}</div>
        <div className="menu-input-container">
          <label className="menu-input-label">Tensor ID: </label>
          <input
            className="menu-input"
            type="text"
            placeholder="1"
            value={tensor}
            onChange={(e) => {
              setTensor(e.target.value);
            }}
          ></input>
        </div>
        <button
          className="menu-submit-button"
          onClick={eigenDecomposition}
        >
          Submit
        </button>
      </div>
    );
  }
};
