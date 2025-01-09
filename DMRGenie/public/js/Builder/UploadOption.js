const UploadOption = ({nodeId, setNodeId, edgeId, setEdgeId, freeNodeId, setFreeNodeId,activeOption, setActiveOption, tensorColor}) => {
  const activeOptionId = 'Upload';

  const [file, setFile] = React.useState("");
  const [error, setError] = React.useState("");
  const [indexNames, setIndexNames] = React.useState("");
  const [indexDimensions, setIndexDimensions] = React.useState("");

  const { getEdges, setEdges, getNodes, setNodes, screenToFlowPosition} = ReactFlow.useReactFlow();
  const edges = getEdges();
  const nodes = getNodes();

  const makeCustomNode = () => {
    const edgeNames = indexNames.split(",").map((name) => name.trim()) // first group of indices
    const edgeDimensions = indexDimensions.split(",").map((dimension) => dimension.trim()) // second group of indices

    if (edgeNames.length != edgeDimensions.length){
      setError("The number of names given does not match the number of dimensions given");
      return;
    } else if (indexNames==""){
      setError("Invalid index names");
      return;
    } else if (indexDimensions==""){
      setError("Invalid edge dimensions");
      return;
    }

    const selectedFile = document.getElementById("file").files[0];

    if (selectedFile === undefined){
      setError("No file uploaded");
      return;
    }

    const nodeRank = edgeNames.length
    
    const networkCanvas = document.getElementById("network_canvas");

    const networkCanvasPosition = networkCanvas.getBoundingClientRect()

    const position = screenToFlowPosition({
          x: networkCanvasPosition.left+networkCanvasPosition.width/2,
          y: networkCanvasPosition.top+networkCanvasPosition.height/2,
        });

    const newNode = {
        id: `${nodeId}`,
        type: "tensor",
        position,
        style: {backgroundColor: "hsl(" + tensorColor + ", 100%, 50%)"},
        data: { rank: nodeRank , mutable: false,label: "Custom Tensor", color: tensorColor, input: ""},
      };

    const handlesPerSide = [
        Math.ceil(nodeRank / 4),
        Math.ceil((nodeRank - 1) / 4),
        Math.ceil((nodeRank - 2) / 4),
        Math.ceil((nodeRank - 3) / 4),
      ];

    let newEdge;
    let newFreeTensor;
    let currentEdgeDimension;

    let allNewEdges = []
    let allNewFreeTensors = []

    for (let i=0; i<nodeRank; i++){
      currentEdgeDimension = edgeDimensions[i]

      if (isNaN(currentEdgeDimension)){
        setError("Invalid edge dimensions");
        return;
      } else if (Number(currentEdgeDimension)!=Math.floor(Number(currentEdgeDimension))){
        setError("Invalid edge dimensions");
        return;

      }

      newFreeTensor = { id:`f${freeNodeId+i}`, type: "invisible", position: {x: position.x+25, y:position.y-100}};
      newEdge = {}

      newEdge = {
        id: `e${edgeId+i}`,
        label: `${edgeNames[i]}`,
        source: `${nodeId}`,
        sourceHandle: `${nodeId}` + ": handles"+`${i}`,
        target: `f${freeNodeId+i}`,
        targetHandle: `f${freeNodeId+i}`,
        data: {
          dim: currentEdgeDimension,
          chosenDim: true,
          lineStyle: "Free",
        },
        type: "index",
      };

      allNewFreeTensors = allNewFreeTensors.concat(newFreeTensor);
      allNewEdges = allNewEdges.concat(newEdge);

    }



    const newNodes = nodes.concat(newNode, allNewFreeTensors);
    const newEdges = edges.concat(allNewEdges);
    setNodes(newNodes);
    setEdges(newEdges);

    setNodeId((oldNodeId) => oldNodeId+1);
    setFreeNodeId((oldFreeNodeId) => oldFreeNodeId+edgeNames.length);
    setEdgeId((oldEdgeId) => oldEdgeId+edgeNames.length);
    setError("");

    var fileReader = new FileReader();

    fileReader.onload = function(){
      // We only need the data for the backend so we get it at the end
      // Otherwise issues occur
      newNode.data.input = fileReader.result

      updateHistory(
        "UPLOAD",
        nodes,
        edges,
        newNode,
        allNewEdges,
        [],
        newNodes,
        newEdges
      );
    }

    // Check filetype for safety
    if (selectedFile.name.search('.txt') !== -1) {
      // Read the uploaded data
      fileReader.readAsText(selectedFile);
    }
  }







  if (activeOption != activeOptionId) {
    return (
      <button
        className="menu-operation"
        onClick={() => {
          setActiveOption(activeOptionId);
        }}
      >
        Upload
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
          Upload
        </button>

        <div className="error-message">{error}</div>
        <div className="menu-input-container">
          <div class="hover-text">
            <img src="/img/runner/hint.png" className="hint-img"></img>
            <span class="tooltip-text" id="left">
              Tensors must be in Julia array syntax (see tutorial).
              Index names and dimensions must be paired and ordered according to DMRjulia conventions.
              If these requirements are not met, then the computation will fail.
            </span>
          </div>
          <label className="menu-input-label">Index Names:</label>
          <input
            className="menu-input"
            type="text"
            placeholder="e1,e2,etc."
            value={indexNames}
            onChange={(e) => {
              setIndexNames(e.target.value);
            }}
          ></input>
          <label className="menu-input-label">Index Dimensions:</label>
          <input
            className="menu-input"
            type="text"
            placeholder="2,1,2"
            value={indexDimensions}
            onChange={(e) => {
              setIndexDimensions(e.target.value);
            }}
          ></input>

          <div className="paddingWrapper">
            <div className="inputWrapper">
              <label className="menu-input-label" for="file">Choose file</label>
              <input 
                id="file"
                name="file"
                class="fileInput"
                type="file"
                accept=".txt"
                onChange={(e) => {
                  setFile(e.target.value);
                }}
              />
            </div>
          </div>
          <label id="input-label">{file.split("path\\")[1]}</label>

        </div>
        <button
          className="menu-submit-button"
          onClick={makeCustomNode}
        >
          Submit
        </button>
      </div>
    );
  }
};
