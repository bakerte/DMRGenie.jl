const SVDOption = ({
  nodeId,
  setNodeId,
  edgeId,
  setEdgeId, activeOption, setActiveOption,
  defaultColorCode, defaultColor}) => {
  const activeOptionId = 'SVD';

  const [toSVD, setToSVD] = React.useState(false);
  const [indexGroupOne, setIndexGroupOne] = React.useState("");
  const [indexGroupTwo, setIndexGroupTwo] = React.useState("");
  const [tensor, setTensor] = React.useState("");
  const [error, setError] = React.useState("");

  const { getEdges, setEdges, getNode, setNodes, getNodes } = ReactFlow.useReactFlow();

  const performSVD = 
    () => {
      const tensorId = tensor.trim();
      const currentTensor = getNode(tensorId); // the tensor to perform the SVD on

      if (currentTensor==undefined){
        setError("Node does not exist")
        return 
      }

      const nodes = getNodes(); // list of all nodes
      const edges = getEdges(); // list of all edges
      const nodesBefore = getNodes(); // For history
      const edgesBefore = getEdges(); // For history


      const edgeGroupOne = indexGroupOne.split(",").map((edgeLabel) => edgeLabel.trim());//.map(trim); // first group of indices
      const edgeGroupTwo = indexGroupTwo.split(",").map((edgeLabel) => edgeLabel.trim());//.map(trim); // second group of indices

      if (currentTensor.data.rank > (edgeGroupOne.length+edgeGroupTwo.length)){
        setError("There still exists undefined indices or an ungrouped index");
        return 

      } else if (currentTensor.data.rank < (edgeGroupOne.length+edgeGroupTwo.length)) {
        setError("Total number of indices grouped exceeds tensor rank");
        return

      }

      const tensorOneRank = edgeGroupOne.length + 1; // U
      const tensorTwoRank = 2; // D
      const tensorThreeRank = edgeGroupTwo.length + 1; // V

      // tensor U position
      const tensorOnePosition = {
        x: currentTensor.position.x,
        y: currentTensor.position.y - 150,
      };

      // tensor D position
      const tensorTwoPosition = {
        x: currentTensor.position.x,
        y: currentTensor.position.y,
      };

      //tensor V position
      const tensorThreePosition = {
        x: currentTensor.position.x,
        y: currentTensor.position.y + 150,
      };

      const idOne = `${nodeId}`; // U ID
      const idTwo = `${nodeId+1}`; // D ID
      const idThree = `${nodeId+2}`; // V ID

      // U information
      const newNodeOne = {
        id: idOne,
        type: "tensor",
        style:{backgroundColor: defaultColor},
        position: tensorOnePosition,
        data: { rank: tensorOneRank, mutable: false, label: "U", color: defaultColorCode },
      };

      // D information
      const newNodeTwo = {
        id: idTwo,
        type: "tensor",
        style:{backgroundColor: defaultColor},
        position: tensorTwoPosition,
        data: { rank: tensorTwoRank, mutable: false, label: "D" ,color: defaultColorCode },
      };

      // V information
      const newNodeThree = {
        id: idThree,
        type: "tensor",
        style:{backgroundColor: defaultColor},
        position: tensorThreePosition,
        data: { rank: tensorThreeRank, mutable: false, label: "V",color: defaultColorCode  },
      };

      let j = 0;
      let k = 1; // starts at 1 to connect the first handle of V with D

      let prodOne = 1;
      let prodTwo = 1;
      let numUpdated = 0;
      let newDim;

      // the loop changes the source and target to the new tensors created for each edge
      for (let i = 0; i < edges.length; i++) {
        if (edges[i].source == tensorId) {
          numUpdated++;
          if (!edges[i].data.chosenDim){
            setError("Undefined dimension");
            return;

          } else if (edgeGroupOne.includes(edges[i].label)&&edgeGroupTwo.includes(edges[i].label)){ // checks if in both groups 
            setError("Index in both groups");
            return;

          } else if (edgeGroupOne.includes(edges[i].label)) { // checks if in the first group
            prodOne *= edges[i].data.dim;
            edges[i].source = idOne;
            edges[i].sourceHandle = idOne + ": handles" + j++;
            edges[i].data.chosenDim = true;
            // will connect the second handle of U with D
            if (j==1){
              j++
            }
          } else if (edgeGroupTwo.includes(edges[i].label)) {
            prodTwo *= edges[i].data.dim;
            edges[i].source = idThree;
            edges[i].sourceHandle = idThree + ": handles" + k++;
            edges[i].data.chosenDim = true;
          } else {
            setError("Undefined index")
            return 
          }
        } else if (edges[i].target == tensorId) {
            numUpdated++;
          if (!edges[i].data.chosenDim){
            setError("Undefined dimension")
            return

          } else if (edgeGroupOne.includes(edges[i].label)) {
            prodOne *= edges[i].data.dim;
            edges[i].target = idOne;
            edges[i].targetHandle = idOne + ": handles" + j++;
            edges[i].data.chosenDim = true;
            // we will connect the handle with j=1 to D for appearance purpose
            if (j==1){
              j++
            }
          } else if (edgeGroupTwo.includes(edges[i].label)) {
            prodTwo *= edges[i].data.dim;
            edges[i].target = idThree;
            edges[i].targetHandle = idThree + ": handles" + k++;
            edges[i].data.chosenDim = true;
          } else {
            setError("Undefined index")
            return 
          }
        }
      }

      if (numUpdated!=(currentTensor.data.rank)){
        setError("Tensor has at least one undefined index");
        return;
      }

      if (prodOne > prodTwo) {
        newDim = prodTwo;
      } else {
        newDim = prodOne;
      }

      // connects U and D
      const newEdgeOne = {
        id: `e${edgeId}`,
        label: `e${edgeId}`,
        source: idOne,
        sourceHandle: idOne + ": handles1",
        target: idTwo,
        targetHandle: idTwo + ": handles0",
        data: {
          dim: newDim,
          chosenDim: true,
          lineStyle: "Free",
        },
        type: "index",
      };

      // connects D and V
      const newEdgeTwo = {
        id: `e${edgeId+1}`,
        label: `e${edgeId+1}`,
        source: idTwo,
        sourceHandle: idTwo + ": handles1",
        target: idThree,
        targetHandle: idThree + ": handles0",
        data: {
          dim: newDim,
          chosenDim: true,
          lineStyle: "Free",
        },
        type: "index",
      };


      const nodesAfter = nodes.filter((node) => node.id != tensorId).concat(newNodeOne, newNodeTwo, newNodeThree)
      const edgesAfter = edges.concat(newEdgeOne, newEdgeTwo)
      setNodes(nodesAfter);
      setEdges(edgesAfter);

      setNodeId((oldNodeId) => oldNodeId+3);
      setEdgeId((oldEdgeId) => oldEdgeId+2);
      setError("");

      updateHistory(
        'SVD',
        nodesBefore,
        edgesBefore,
        [currentTensor],
        [edgeGroupOne, edgeGroupTwo],
        [newNodeOne, newNodeTwo, newNodeThree],
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
        SVD
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
          SVD
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
          <label className="menu-input-label">Group of Indices One: </label>
          <input
            className="menu-input"
            type="text"
            placeholder="e1,e2,etc."
            value={indexGroupOne}
            onChange={(e) => {
              setIndexGroupOne(e.target.value);
            }}
          ></input>
          <label className="menu-input-label">Group of Indices Two: </label>
          <input
            className="menu-input"
            type="text"
            placeholder="e3,e4,etc."
            value={indexGroupTwo}
            onChange={(e) => {
              setIndexGroupTwo(e.target.value);
            }}
          ></input>
        </div>
        <button
          className="menu-submit-button"
          onClick={performSVD}
        >
          Submit
        </button>
      </div>
    );
  }
};
