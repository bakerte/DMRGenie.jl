const DNDMenu = ({
  nodeId,
  setNodeId,
  edgeId,
  setEdgeId,
  freeNodesId,
  setFreeNodesId,
  rank,
  setRank,
  tensorColor,
  setTensorColor,
  backendErrorPath
}) => {
  const { getEdges, getNodes } = ReactFlow.useReactFlow();

  // called at the start of dragging a tensor
  const onDragStart = (event, nodeType) => {
    event.dataTransfer.setData("application/reactflow", nodeType);
    event.dataTransfer.effectAllowed = "move";
  };

  const [activeOption, setActiveOption] = React.useState('None'); // keeps track of which operation is active

  const [copiedNodes, setCopiedNodes] = React.useState([]); // nodes to copy
  const [copiedEdges, setCopiedEdges] = React.useState([]); // edges to copy
  const [newCopy, setNewCopy] = React.useState(false); // checks if something is being pasted multiple times
  const [rankShown, setRankShown] = React.useState(2); // the rank of the tensor to be dragged and dropped

  const defaultColorCode = "50"; // default color value
  const defaultColor = "hsl(" + defaultColorCode + ", 100%, 80%)"; // default color

  // Choose to hide or not, is the output of the tensor operations
  var resultComponent = outputPath === "VOID" ? 
    <>
    </>
    :
    <>
      <div id="results" name="results" className="download-button">
          <a href={outputPath} download>
              <p id="download-path">Download Output</p>
          </a>
      </div>
    </>


  // returns the drag and drop menu
  return (
    <div className="menu">
      <div className='menu-section-label'>Drag and Drop</div>
      <div
        className="dnd-tensor menu-operation"
        onDragStart={(event) => onDragStart(event, "tensor")}
        onDragEnd={() => {
          // We don't need to worry about nodesBefore or edgesBefore for
          // creation, just for operations (contraction, svd, etc.)
          updateHistory('CREATION', [], [], [], [], [], getNodes(), getEdges())
        }}
        draggable
      >
        Tensor
        <div>
          <label className="menu-input-label">Rank:</label>
          <input
            className = "menu-input"
            type="number"
            value={rankShown}
            onChange={(e) => {
              const newVal = Number(e.target.value);
              if (newVal==""){
                setRankShown("");
                setRank(1);
              } else if (newVal<1){
                setRankShown("");
                setRank(1);
              } else if (newVal>4) {
                setRankShown(4);
                setRank(4);
              } else {
                setRankShown(newVal);
                setRank(newVal);
              }
            }}
          ></input>
        </div>
      </div>
      <UploadOption nodeId = {nodeId} setNodeId = {setNodeId} edgeId={edgeId} setEdgeId={setEdgeId} freeNodeId={freeNodesId} setFreeNodeId={setFreeNodesId} activeOption={activeOption} setActiveOption={setActiveOption} tensorColor={tensorColor}/>

      <div class="slider-container">
        <input class="custom-slider-range"
               id="color-slider"
               type="range" 
               min="1" 
               max="100" 
               value={tensorColor} 
               onChange={(e) => {
              setTensorColor(e.target.value);
            }}>
        </input>
      </div>

      <div className='menu-section-label'>Tensor Operations</div>
      <ContractOption nodeId = {nodeId} setNodeId = {setNodeId} activeOption={activeOption} setActiveOption={setActiveOption} defaultColorCode={defaultColorCode} defaultColor={defaultColor}/>

      <div className='menu-section-label'>Decompositions</div>
      <SVDOption nodeId = {nodeId} setNodeId = {setNodeId} edgeId={edgeId} setEdgeId={setEdgeId} activeOption={activeOption} setActiveOption={setActiveOption} defaultColorCode={defaultColorCode} defaultColor={defaultColor}/>
      <QROption nodeId = {nodeId} setNodeId = {setNodeId} edgeId={edgeId} setEdgeId={setEdgeId} activeOption={activeOption} setActiveOption={setActiveOption} defaultColorCode={defaultColorCode} defaultColor={defaultColor}/>
      <LQOption nodeId = {nodeId} setNodeId = {setNodeId} edgeId={edgeId} setEdgeId={setEdgeId} activeOption={activeOption} setActiveOption={setActiveOption} defaultColorCode={defaultColorCode} defaultColor={defaultColor}/>
      <EigenvalueOption nodeId = {nodeId} setNodeId = {setNodeId} edgeId={edgeId} setEdgeId={setEdgeId} freeNodesId={freeNodesId} setFreeNodesId={setFreeNodesId} activeOption={activeOption} setActiveOption={setActiveOption} defaultColorCode={defaultColorCode} defaultColor={defaultColor}/>

      <div className='menu-section-label'>Edit Functions</div>
      <SplitEdges freeNodesId={freeNodesId} setFreeNodesId={setFreeNodesId} edgeId={edgeId} setEdgeId={setEdgeId} activeOption={activeOption} setActiveOption={setActiveOption}/>
      <ConnectEdges edgeId={edgeId} setEdgeId={setEdgeId} activeOption={activeOption} setActiveOption={setActiveOption}/>

      <Copy setCopiedNodes={setCopiedNodes} setCopiedEdges={setCopiedEdges} nodeId={nodeId} setNodeId={setNodeId} edgeId={edgeId} setEdgeId={setEdgeId} freeNodeId={freeNodesId} setFreeNodeId={setFreeNodesId} setNewCopy={setNewCopy}/>
      <Paste copiedNodes={copiedNodes} copiedEdges={copiedEdges} nodeId={nodeId} setNodeId={setNodeId} edgeId={edgeId} setEdgeId={setEdgeId} freeNodeId={freeNodesId} setFreeNodeId={setFreeNodesId} newCopy={newCopy} setNewCopy={setNewCopy}/>
      <Undo />
      <Redo />

      {/* Form submit */}
      <br />
      <form action="/build" method="POST" enctype="multipart/form-data"
            onsubmit="btnSubmit.disabled = true; loading(); return true;">

        <input id="frontendData" name="frontendData" type="hidden" value={JSON.stringify(networkHistory)} />
        <input className="final-submit" type="submit" id="btnSubmit" name="btnSubmit" value="Run Network Steps"/>

      </form>
      {/*<div>*/}
        <div className="error-message backend-error">{backendErrorPath}</div>
        {resultComponent}
      {/*</div>*/}
  
    </div>
  );
};
