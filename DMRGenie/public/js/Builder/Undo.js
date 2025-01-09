const Undo = () => {
	const { setEdges, setNodes } = ReactFlow.useReactFlow();

	return (
    <button
        className="menu-operation"
        onClick={() => {
            historyIdx = historyIdx-1 < 0 ? 0 : historyIdx-1;
            setNodes(networkHistory[historyIdx].allNodesAfter);
            setEdges(networkHistory[historyIdx].allEdgesAfter);
        }}
    >
        Undo
    </button>
  )
}