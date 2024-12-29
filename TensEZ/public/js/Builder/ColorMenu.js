const ColorMenu = ({ node, top, left, ...props }) => {
  const {setNodes, getNodes, setEdges } = ReactFlow.useReactFlow();
  return (
  <div style={{ top, left}} className="color-menu" {...props}>
      <input class="custom-slider-range"
                 id="color-slider"
                 type="range" 
                 min="1" 
                 max="100" 
                 value={node.data.color} 
                 onChange={(e) => {
                    const nodes = getNodes();
                    const updatedNodes = nodes.filter((currentNode) => !(currentNode.id==node.id))

                    // changes the color information for the node object
                    node.data.color = e.target.value
                    node.style.backgroundColor = "hsl(" + e.target.value + ", 100%, 80%)";
                    setNodes(updatedNodes.concat(node))
              }}>
      </input>
  </div>
  );
};
