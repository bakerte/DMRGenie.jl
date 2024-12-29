const LQOption = ({
  nodeId,
  setNodeId,
  edgeId,
  setEdgeId,activeOption, setActiveOption,
  defaultColorCode, defaultColor}) => {

  const activeOptionId = 'LQ';

  const [toLQ, setToLQ] = React.useState(false);
  const [indexGroupOne, setIndexGroupOne] = React.useState("");
  const [indexGroupTwo, setIndexGroupTwo] = React.useState("");
  const [tensor, setTensor] = React.useState("");
  const [error, setError] = React.useState("");

  const { getEdges, setEdges, getNode, setNodes, getNodes } = ReactFlow.useReactFlow();

  const LQOperation = 
    () => {
      const tensorId = tensor.trim();
      const currentTensor = getNode(tensorId); // the tensor to perform the LQ on

      if (currentTensor==undefined){
        setError("Node does not exist")
        return 
      }

      const nodes = getNodes(); // list of all the nodes
      const edges = getEdges(); // list of all edges

      const nodesBefore = getNodes(); // For history
      const edgesBefore = getEdges();

      const edgeGroupOne = indexGroupOne.split(","); // first group of indices
      const edgeGroupTwo = indexGroupTwo.split(","); // the second group of indices

      if (currentTensor.data.rank > (edgeGroupOne.length+edgeGroupTwo.length)){
        setError("There still exists undefined indices or an ungrouped index");
        return 

      } else if (currentTensor.data.rank < (edgeGroupOne.length+edgeGroupTwo.length)) {
        setError("Total number of indices grouped exceeds tensor rank");
        return

      }

      const tensorOneRank = edgeGroupOne.length + 1; // L
      const tensorTwoRank = edgeGroupTwo.length + 1; // Q

      // tensor L position
      const tensorOnePosition = {
        x: currentTensor.position.x,
        y: currentTensor.position.y - 75,
      };

      // tensor Q position
      const tensorTwoPosition = {
        x: currentTensor.position.x,
        y: currentTensor.position.y + 75,
      };

      const idOne = `${nodeId}`; // L ID
      const idTwo = `${nodeId+1}`; // q ID

      // L information
      const newNodeOne = {
        id: idOne,
        type: "tensor",
        style:{backgroundColor: defaultColor},
        position: tensorOnePosition,
        data: { rank: tensorOneRank, mutable: false, label: "L" , color: defaultColorCode},
      };

      // Q information
      const newNodeTwo = {
        id: idTwo,
        type: "tensor",
        style:{backgroundColor: defaultColor},
        position: tensorTwoPosition,
        data: { rank: tensorTwoRank, mutable: false, label: "Q" , color: defaultColorCode},
      };

      let j = 0;
      let k = 1;

      let prodOne = 1;
      let prodTwo = 1;
      let numUpdated = 0;
      let newDim;

      // the loop changes the source and target to the new tensors created
      for (let i = 0; i < edges.length; i++) {
        if (edges[i].source == tensorId) {
          numUpdated++;
          if (!edges[i].data.chosenDim){
            setError("Undefined dimension")
            return
          } else if (edgeGroupOne.includes(edges[i].label)&&edgeGroupTwo.includes(edges[i].label)){ // checks if in both groups 
            setError("Index in both groups");
            return;

          } else if (edgeGroupOne.includes(edges[i].label)) { // checks if in the first group
            prodOne *= edges[i].data.dim;
            edges[i].source = idOne;
            edges[i].sourceHandle = idOne + ": handles" + j++;
            edges[i].data.chosenDim = true;
            // we will connect the handle with j=1 to D for appearance purpose
            if (j==1){
              j++
            }
          } else if (edgeGroupTwo.includes(edges[i].label)) {
            prodTwo *= edges[i].data.dim;
            edges[i].source = idTwo;
            edges[i].sourceHandle = idTwo + ": handles" + k++;
            edges[i].data.chosenDim = true;
          } else {
            setError("Ungrouped index")
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
            edges[i].target = idTwo;
            edges[i].targetHandle = idTwo + ": handles" + k++;
            edges[i].data.chosenDim = true;
          } else {
            setError("Ungrouped index")
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

      // connects Q and R
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


      const nodesAfter = nodes.filter((node) => node.id != tensorId).concat(newNodeOne, newNodeTwo)
      const edgesAfter = edges.concat(newEdgeOne)
      setNodes(nodesAfter);
      setEdges(edgesAfter);

      setEdgeId((oldEdgeId) => oldEdgeId+1)
      setNodeId((oldNodeId) => oldNodeId+2)
      setError("");

      updateHistory(
        'LQ',
        nodesBefore,
        edgesBefore,
        [currentTensor],
        [edgeGroupOne, edgeGroupTwo],
        [newNodeOne, newNodeTwo],
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
        LQ
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
          LQ
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
          onClick={LQOperation}
        >
          Submit
        </button>
      </div>
    );
  }
};