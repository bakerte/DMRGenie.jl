function TensorNode({ id, data, selected, ...props }) {

  // how far apart to place the handles
  const [dimensions, setDimensions] = React.useState({
    width: 10,
    height: 10,
  });

  // the default for the tensor sizes
  const [tensorDimensions, setTensorDimensions] = React.useState({
    width: 53,
    height: 53,
  });

  const ref = React.useRef(null);

  // changes the distance between the handles
  React.useLayoutEffect(() => {
    setDimensions({
      width: ref.current.offsetWidth,
      height: ref.current.offsetHeight,
    });
  }, [tensorDimensions]);

  // calculating how many handles needed per size to make it as balanced as possible
  const handlesPerSide = [
    Math.ceil(data.rank / 4),
    Math.ceil((data.rank - 1) / 4),
    Math.ceil((data.rank - 2) / 4),
    Math.ceil((data.rank - 3) / 4),
  ];

  // changes the tensor size
  React.useEffect(() => {
    setTensorDimensions({
      width: Math.floor(data.rank / 16) * 53+53,
      height: Math.floor(data.rank / 16) * 53+53,
    });
  });

  // the styling of the tensor
  const tensorStyle = {
    width: `${tensorDimensions.width}px`,
    height: `${tensorDimensions.height}px`,
    fontSize: "12px",
  };

  // returns ReactFlow.Handle elements positioned in the correct position
  const getHandles = () => {
    // the handles are placed first at the top then bottom then left then right
    const positions = [
      ReactFlow.Position.Top,
      ReactFlow.Position.Bottom,
      ReactFlow.Position.Left,
      ReactFlow.Position.Right,
    ];

    // this chooses the correct positioning (done with styling) of the handles
    let handles = new Array(data.rank);
    for (let i = 0; i < data.rank; i++) {
      let style =
        i % 4 == 0 || i % 4 == 1
          ? {
              left:
                ((Math.floor(i / 4) + 1) * dimensions.width) /
                (handlesPerSide[i % 4] + 1),
            }
          : {
              top:
                ((Math.floor(i / 4) + 1) * dimensions.height) /
                (handlesPerSide[i % 4] + 1),
            };

      handles[i] = (
        <ReactFlow.Handle
          id={id + ": handles" + i}
          type="source"
          position={positions[i % 4]}
          isConnectable={1}
          style={style}
        />
      );
    }
    return handles;
  };

  return (
    <div className="tensor-node" style={tensorStyle} ref={ref}>
      {getHandles()}
      <p className="tensor-id">
        <small>ID: {id}</small>
      </p>
      <p className="tensor-description" >
        <small>{data.label}</small>
      </p>
    </div>
  );
}
