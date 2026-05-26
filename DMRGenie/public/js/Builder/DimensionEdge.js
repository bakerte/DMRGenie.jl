function DimensionEdge({
  id,
  data,
  label,
  sourceX,
  sourceY,
  targetX,
  targetY,
  sourcePosition,
  targetPosition,
  ...props
}) {
  const [isSet, setIsSet] = React.useState(data.chosenDim); // boolean for if the 
  const [setName, setSetName] = React.useState(false);
  const { setEdges } = ReactFlow.useReactFlow();
  const { getEdges, getNodes } = ReactFlow.useReactFlow();
  const [dimInput, setDimInput] = React.useState(1);
  const [nameInput, setNameInput] = React.useState(label);

  let edgePath, labelX, labelY, offsetX, offsetY;

  // the linestyle
  if (data.lineStyle == "Free") {
    [edgePath, labelX, labelY, offsetX, offsetY] =
      ReactFlow.getSimpleBezierPath({
        sourceX: sourceX,
        sourceY: sourceY,
        sourcePosition: sourcePosition,
        targetX: targetX,
        targetY: targetY,
        targetPosition: targetPosition,
      });
  } else {
    [edgePath, labelX, labelY, offsetX, offsetY] = ReactFlow.getBezierPath({
      sourceX: sourceX,
      sourceY: sourceY,
      sourcePosition: sourcePosition,
      targetX: targetX,
      targetY: targetY,
      targetPosition: targetPosition,
    });
  }

  const getLabel = () => {
  	// allows index dimension input
    if (!isSet) {
      return (
        <div
          className="edge-input-container"
          style={
            labelStyle
          }
        >
          <label className="edge-input-label">Edge Dimension: </label>
          <input
          	className="edge-input-number"
            type="number"
            value={dimInput}
            onChange={(e) => {
            	const newVal = Number(e.target.value);

              if (e.target.value === "") {
                // No input for typing convenience
                setDimInput("");
              } else {
                if (newVal<1){
                  setDimInput("");
                } else if (newVal>5) {
                  setDimInput(5);
                } else {
                  setDimInput(newVal);
                }
              }
            }}
          ></input>
          <button
          	className="edge-submit-button"
            onClick={() => {
            	if (dimInput==Math.floor(dimInput)){
            		setEdges((edges) => {
		                let edgeToUpdate = edges.filter((edge) => {
		                  return edge.id == id;
		                });
		                let otherEdges = edges.filter((edge) => {
		                  return edge.id != id;
		                });

                    if (dimInput=="") {
                      // Handle case of no input
		                  edgeToUpdate[0].data.dim = Math.floor(1);
                    } else {
		                  edgeToUpdate[0].data.dim = Math.floor(dimInput);
                    }
                    edgeToUpdate[0].data.chosenDim = true;
		                return [...otherEdges, ...edgeToUpdate];
		              });
            		setIsSet(true);

                // We don't need to worry about nodesBefore or edgesBefore for
                // creation, just for operations (contraction, svd, etc.)
                updateHistory('CREATION', [], [], [], [], [], getNodes(), getEdges())
            	}
            }}
          >
            Submit
          </button>
        </div>
      );
    } else if (setName) { // if the edge dimension has been input then the edge can be renamed
      return (
        <div
          className="edge-input-container"
          style={
            labelStyle
          }
        >
          <label className="edge-input-label">New Name: </label>
          <input
          className="edge-input-text"
            type="text"
            value={nameInput}
            onChange={(e) => {
              setNameInput(e.target.value);
            }}
          ></input>
          <button
          	className="edge-submit-button"
            onClick={() => {
              setEdges((edges) => {

                let edgeToUpdate = edges.filter((edge) => {
                  return edge.id == id;
                });
                let otherEdges = edges.filter((edge) => {
                  return edge.id != id;
                });
                edgeToUpdate[0].label = nameInput;
                return [...otherEdges, ...edgeToUpdate];
              });
              setSetName(false);

              // We don't need to worry about nodesBefore or edgesBefore for
              // creation, just for operations (contraction, svd, etc.)
              updateHistory('CREATION', [], [], [], [], [], getNodes(), getEdges())
            }}
          >
            Submit
          </button>
        </div>
      );
    } else {
    	// otherwise the edge label is returned as a button that can be clicked to change the edge label
      return (
        <button
        className="edge-toggle"
          style={labelStyle}
          onClick={() => {
            setSetName(true);
          }}
        >
          {label + ": " + data.dim}
        </button>
      );
    }
  };

  const labelStyle = {
    transform: `translate(-50%, -50%) translate(${labelX}px,${labelY}px)`,
  };

  return (
    <>
      <ReactFlow.BaseEdge path={edgePath} />
      <ReactFlow.EdgeLabelRenderer>{getLabel()}</ReactFlow.EdgeLabelRenderer>
    </>
  );
}
