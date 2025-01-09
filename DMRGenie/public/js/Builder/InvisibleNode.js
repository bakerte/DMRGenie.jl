function InvisibleNode({ id, ...props }) {
  // returns a node with one handle
  return (
    <div className="invisible-node">
      <ReactFlow.Handle
        id={id}
        type="source"
        position={ReactFlow.Top}
        isConnectable={false}
        style={{top: 5}}
      />
    </div>
  );
}
