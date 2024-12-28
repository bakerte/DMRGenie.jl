const ContractOption = ({ nodeId, setNodeId, activeOption, setActiveOption, defaultColorCode, defaultColor}) => {
  const activeOptionId = 'Contract';

  const [tensorOne, setTensorOne] = React.useState("");
  const [tensorTwo, setTensorTwo] = React.useState("");
  const [error, setError] = React.useState("");

  const { getEdges, setEdges, getNode, setNodes, getNodes, deleteElements } = ReactFlow.useReactFlow();
  const edges = getEdges();
  const nodes = getNodes();
  const nodesBefore = getNodes(); // For history
  const edgesBefore = getEdges(); // For history

  const contractTensors = 
    () => {
      const tensorOneId = tensorOne.trim();
      const tensorTwoId = tensorTwo.trim();
      const nodeOne = getNode(tensorOneId); // the first tensor to contract
      const nodeTwo = getNode(tensorTwoId); // the second tensor to contract

      // checks if the nodes exist
      if ((nodeOne==undefined)||(nodeTwo==undefined)){
        setError("Node does not exist")
        return 
      }

      const toKeep = new Array(edges.length).fill(true); // true if the edge should be kept, false if it should be removed
      let nodesToRemove = []; // Id of nodes that need to be removed (will be invisible nodes)
      let numToRemove = 0; // the number of edges to remove
      let numEdgesConnected = 0; // counts the total number of edges connected to the tensorOne and tensorTwo
      let rank = nodeOne.data.rank + nodeTwo.data.rank

      // need to compare edges with each other in the loop below
      let edgeOne;
      let edgeTwo;
      let foundMatch;
      let firstTarget;
      let secondTarget;

      for (let i = 0; i<edges.length; i++){
        edgeOne = edges[i];

        if (!edgeOne.data.chosenDim){
          setError("Undefined dimension");
          return

        // checks if the edge directly connects nodeOne and nodeTwo
        } else if (((edgeOne.source==tensorOneId)&&(edgeOne.target==tensorTwoId))||((edgeOne.source==tensorTwoId)&&(edgeOne.target==tensorOneId))){
          toKeep[i] = false;
          numToRemove += 1;
          numEdgesConnected += 2;
          rank -= 2

        // checking if the given edge represents a free index
        } else if ((edgeOne.source==tensorOneId)||(edgeOne.source==tensorTwoId)){
          numEdgesConnected += 1;
          foundMatch = false;
          for (let j = i+1; j<edges.length; j++){
            edgeTwo = edges[j];

            // check if the free edges are named the same thing
            if ((edgeOne.label==edgeTwo.label)&&((edgeTwo.source==tensorOneId)||(edgeTwo.source==tensorTwoId))){
              // checks if the dimensions of the edges match
              firstTarget = getNode(edgeOne.target);
              secondTarget = getNode(edgeTwo.target)

              if (edgeOne.data.dim != edgeTwo.data.dim){
                setError("Edge dimension does not match");
                return 

              } else if (foundMatch){
                setError("Multiple edges have the same name");
                return

              } else if (firstTarget.type!="invisible" || secondTarget.type!="invisible"){
                setError("Only free indices with the same name can be contracted");
                return;

              } else { // if the edges match in label and dimension then they are contracted
                toKeep[i] = false;
                toKeep[j] = false;
                foundMatch = true;
                nodesToRemove = nodesToRemove.concat(edgeOne.target);
                nodesToRemove = nodesToRemove.concat(edgeTwo.target);
                numToRemove += 2; // it is two because I start the seocnd loop at i+1, so we will consider A v.s. B but not B v.s. A
                rank -= 2;
              }
            } 
          }

        } else if ((edgeOne.source==tensorOneId)||(edgeOne.target==tensorOneId)||(edgeOne.source==tensorTwoId)||(edgeOne.target==tensorTwoId)) { // the case of being connected to another node not being contracted
          numEdgesConnected += 1;
        }
      }

      // there were no connections between the tensors
      if (numToRemove==0){
        setError("The chosen tensors have no common indices");
        return 

      } else if (numEdgesConnected != (nodeOne.data.rank+nodeTwo.data.rank)){
        setError("There still exists undefined indices")
        return 
      }

      let edgesToKeep = new Array(edges.length-numToRemove); // the edges to keep
      let edgesToRemove = new Array(numToRemove); // the edges to remove

      let removePos = 0; // indexing the edges to remove
      let keepPos = 0; // indexing the edges to keep

      // sorts which edges are kept and which edges are removed
      for (let i = 0; i<edges.length; i++){
        if (toKeep[i]){
          edgesToKeep[keepPos++] = edges[i];
        } else {
          edgesToRemove[removePos++] = edges[i];
        }
      }

      // the position of the new tensor
      const position = {
        x: (nodeOne.position.x + nodeTwo.position.x) / 2,
        y: (nodeOne.position.y + nodeTwo.position.y) / 2,
      };

      const id = `${nodeId}`; // the Id of the new tensor

      let j = 0; // indexing the handle number
      let edge, edgeSource, edgeTarget;

      // updates the target and source of the edges
      for (let i = 0; i < edgesToKeep.length; i++) {
        edge = edgesToKeep[i];
        edgeTarget = edge.target;
        edgeSource = edge.source;

        // changes the target of the current edge
        if (edgeTarget == tensorOneId || edgeTarget == tensorTwoId) {
          edge.target = id;
          edge.targetHandle = id + ": handles" + j++;
          edge.data.chosenDim = true;
        // changes the source of the current edge
        } else if (edgeSource == tensorOneId || edgeSource == tensorTwoId) {
          edge.source = id;
          edge.sourceHandle = id + ": handles" + j++;
          edge.data.chosenDim = true;
        }
      }

      // creating the new node
      const newNode = {
        id: id,
        type: "tensor",
        style:{backgroundColor: defaultColor},
        position,
        data: { rank: rank , mutable: false,label: "Contracted Tensor", color: defaultColorCode},
      };

      // updating the nodes
      const nodesAfter = nodes.filter((node) => node.id != tensorOneId && node.id != tensorTwoId && !nodesToRemove.includes(node.id)).concat(newNode)


      setNodes(nodesAfter);
      setEdges(edgesToKeep);
      setNodeId((oldNodeId) => oldNodeId+1) // only update the nodeId if the function runs
      setError("");

      updateHistory(
        "CONTRACTION",
        nodesBefore,
        edgesBefore,
        [nodeOne, nodeTwo],
        [], // Not needed
        [newNode],
        nodesAfter,
        edgesToKeep
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
        Contract
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
          Contract
        </button>
        <div className="error-message">{error}</div>
        <div className="menu-input-container">
          <label className="menu-input-label">Tensor One ID: </label>
          <input
          className="menu-input"
            type="text"
            placeholder="1"
            value={tensorOne}
            onChange={(e) => {
              setTensorOne(e.target.value);
            }}
          ></input>
          <label className="menu-input-label">Tensor Two ID: </label>
          <input
            className="menu-input"
            type="text"
            placeholder="2"
            value={tensorTwo}
            onChange={(e) => {
              setTensorTwo(e.target.value);
            }}
          ></input>
        </div>
        <button
          className="menu-submit-button"
          onClick={contractTensors}
        >
          Submit
        </button>
      </div>
    );
  }
};
