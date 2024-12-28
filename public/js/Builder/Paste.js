const Paste = ({copiedNodes, copiedEdges, nodeId, setNodeId, edgeId, setEdgeId, freeNodeId, setFreeNodeId, newCopy, setNewCopy}) => {
	const { getEdges, setEdges, getNodes, setNodes } = ReactFlow.useReactFlow();
  const [pasting, setPasting] = React.useState(false);
  const cmdAndVPressed = ReactFlow.useKeyPress(["Meta+v","Strg+v"]);

  React.useEffect(() => {
    if (!cmdAndVPressed) {
      setPasting(false);
    }
  }, [cmdAndVPressed]);

  const paste = 
    () => {
      const edges = getEdges();
      const nodes = getNodes();

      if (!newCopy) { 
        let numFreeNodesToCopy = 0;
        let numNodesToCopy = 0;
        let numEdgesToCopy = 0;
        let newName = {};
        let currentNode, currentEdge;

        for (let i = 0; i<copiedNodes.length; i++){
          currentNode = copiedNodes[i] // current node to copy
          // console.log(JSON.parse(JSON.stringify(currentNode)))

          if (currentNode.type=="invisible"){ // checking if the node is a free node
            newName[currentNode.id] = `f${freeNodeId+numFreeNodesToCopy}`; // storing the old name as and new name
            currentNode.id = `f${freeNodeId+numFreeNodesToCopy++}`;

            currentNode.position = {
              x: currentNode.position.x + 50,
              y: currentNode.position.y + 50
            };
          }  else {
            newName[currentNode.id] = `${nodeId+numNodesToCopy}`;
            currentNode.id = `${nodeId+numNodesToCopy++}`;
            currentNode.position = {
              x: currentNode.position.x + 50,
              y: currentNode.position.y + 50
            };
          }
        }

        let handleNumberOne;
        let handleNumberTwo;

        for (let k = 0; k<copiedEdges.length; k++){
          currentEdge = copiedEdges[k]

          currentEdge.id = `e${edgeId+numEdgesToCopy++}`

          handleNumberOne = currentEdge.sourceHandle[currentEdge.sourceHandle.length-1] // this returns the number of the handle
          handleNumberTwo = currentEdge.targetHandle[currentEdge.targetHandle.length-1] // this returns the number of the handle

          currentEdge.source = `${newName[currentEdge.source]}`
          currentEdge.sourceHandle = `${currentEdge.source}` + ": handles" + handleNumberOne
          currentEdge.target = `${newName[currentEdge.target]}`
          currentEdge.targetHandle = `${currentEdge.target}` + ": handles" + handleNumberTwo
        }

        setEdgeId((oldEdgeId) => oldEdgeId+numEdgesToCopy);
        setNodeId((oldNodeId) => oldNodeId+numNodesToCopy);
        setFreeNodeId((oldFreeNodeId) => oldFreeNodeId+numFreeNodesToCopy);
      }

      const edgesAfter = edges
              .map((edge) => {
                if (edge.selected) {
                  edge.selected = true
                }

                return edge;
              }).concat(copiedEdges);

      const nodesAfter = nodes
              .map((node) => {
                if (node.selected) {
                  node.selected = true
                }

                return node;
              }).concat(copiedNodes);

      setEdges(() => edgesAfter);
      setNodes(() => nodesAfter);
      setNewCopy(() => false);

      if (copiedNodes.length !== 0 || copiedEdges.length !== 0) {
        updateHistory(
          'COPY-PASTE',
          [],
          [],
          copiedNodes,
          [],
          [],
          nodesAfter,
          edgesAfter
        )
      }
    }

  if (cmdAndVPressed && !pasting) {
    setPasting(true);
    paste();
  }
  
  return (
    <button
      className="menu-operation"
      onClick={paste}
    >
      Paste
    </button>
  );

}