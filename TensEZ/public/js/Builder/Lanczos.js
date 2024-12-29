const Lanczos = ({
  nodeId,
  setNodeId,
  edgeId,
  setEdgeId,
  freeNodesId,
  setFreeNodesId,
  activeOption, setActiveOption,
  defaultColorCode, defaultColor}) => {
  const activeOptionId = 'Lanczos';

  const [toLanczos, setToLanczos] = React.useState(false);
  //POSSIBLY NEED TO ADD MORE TENSORS, DEPENDS ON INPUT
  const [tensor, setTensor] = React.useState("");
  const [error, setError] = React.useState("");

  const { getEdges, setEdges, getNode, setNodes, getNodes } = ReactFlow.useReactFlow();

  const lanczosDecomposition = 
    () => {
  
    }


  if (activeOptionId != activeOption) {
    return (
      <button
        className="menu-operation"
        onClick={() => {
          setActiveOption(activeOptionId);
        }}
      >
        Lanczos
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
          Lanczos
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
        </div>
        <button
          className="menu-submit-button"
          onClick={lanczosDecomposition}
        >
          Submit
        </button>
      </div>
    );
  }
};