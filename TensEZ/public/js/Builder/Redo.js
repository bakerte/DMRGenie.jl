const Redo = () => {
	const { setEdges, setNodes } = ReactFlow.useReactFlow();

	return (
    <button
        className="menu-operation"
        onClick={() => {
            historyIdx = historyIdx >= historyLength-1 ? historyIdx : historyIdx+1;
            setNodes(networkHistory[historyIdx].allNodesAfter);
            setEdges(networkHistory[historyIdx].allEdgesAfter);
        }}
    >
        Redo
    </button>
  )
}