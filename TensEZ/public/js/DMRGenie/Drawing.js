const padding = 25;
const line_length = 25;
const box_length = 50;
var prev_graph_type = "";

function update() {
  var graph = document.getElementById("graph_type").value;
  let num_elements = document.getElementById("num_tensors").value;
  if (!num_elements || num_elements == "1") {
    return;
  }

  if (prev_graph_type == "peps") {
    revert_peps_canvas_context();
  } else if (prev_graph_type == "mera") {
    revert_mera_canvas_context();
  }

  if (graph == "scalar") {
    draw_scalar(num_elements, true);
  } else if (graph == "vector") {
    draw_vector(num_elements, true);
  } else if (graph == "matrix") {
    draw_matrix(num_elements, true);
  } else if (graph == "mps") {
    draw_mps(num_elements, true);
  } else if (graph == "mpo") {
    draw_mpo(num_elements, true);
  } else if (graph == "peps") {
    draw_peps(num_elements, num_elements, true);
  } else {
    draw_mera(num_elements, true);
  }

  prev_graph_type = graph;
}

// PEPS and MERA manipulate the canvas.
// Undo the canvas manipulations so that switching between graph types
// does not cause any unwanted streching or translation.
//
// NOTE: If changes are made to how draw_peps or draw_mera manipulate the canvas,
// the opposite must be done for revert_peps_canvas_context or revert_mera_canvas_context,
// respectively.
function revert_peps_canvas_context() {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  ctx.clearRect(0, 0, c.width, c.height);
  ctx.translate(c.width / 2, c.height / 2);
  ctx.rotate((45 * Math.PI) / 180);
  ctx.scale(1 / 0.6, 1 / 0.6);
  ctx.translate(-c.width / 2, -c.height / 2);
}

function revert_mera_canvas_context() {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  ctx.clearRect(0, 0, c.width, c.height);
  ctx.translate(-c.width / 4, -c.height / 8);
  ctx.scale(1 / 0.8, 1 / 0.8);
}

function loading() {
  document.getElementById("loading_div").style.display = "block";
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");
  ctx.clearRect(0, 0, c.width, c.height);
}

function find_scale(length_obj, num_elements, width) {
  let frame_padding = width - 50 * 2;
  let tot_space = (length_obj + 25) * num_elements;
  let ratio = frame_padding / tot_space;

  if (ratio > 1) {
    return 1;
  } else {
    return ratio;
  }
}

function find_x_start(length_obj, num_elements, width, scale, space) {
  let scale_obj;
  if (space != 0) {
    scale_obj = (length_obj + space) * scale;
  } else {
    scale_obj = length_obj * scale;
  }

  let tot_space = scale_obj * num_elements;
  let start = (width - tot_space) / 2;
  return start;
}

function find_y_start(height_obj, num_elements, height, scale, space) {
  let scale_obj;
  if (space) {
    scale_obj = (height_obj + 25) * scale;
  } else {
    scale_obj = height_obj * scale;
  }

  let tot_space = scale_obj * num_elements;
  let start = (height - tot_space) / 2;

  return start;
}

function draw_box(
  x_start,
  y_start,
  length,
  height,
  colour,
  scale,
  border_colour = "black"
) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  ctx.beginPath();
  ctx.roundRect(x_start, y_start, length * scale, height * scale, 5 * scale); // x, y, length(x), length(y)
  ctx.lineWidth = 8 * scale;
  ctx.strokeStyle = border_colour;
  ctx.stroke();
  ctx.fillStyle = colour;
  ctx.fill();
}

function draw_circle(
  x_middle,
  y_middle,
  colour,
  scale,
  border_colour = "black"
) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  ctx.beginPath();
  ctx.arc(x_middle, y_middle, 25 * scale, 0, 2 * Math.PI);
  ctx.lineWidth = 8 * scale;
  ctx.strokeStyle = border_colour;
  ctx.stroke();
  ctx.fillStyle = colour;
  ctx.fill();
}

function draw_line(x_start, y_start, x_end, y_end, scale) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  ctx.beginPath();
  ctx.moveTo(x_start, y_start); //x, y
  ctx.lineTo(x_end, y_end); // x, y
  ctx.lineWidth = 4 * scale;
  ctx.strokeStyle = "black";
  ctx.stroke();
}

function draw_line_polar(x_start, y_start, length, deg_angle, scale) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  let rad_angle = (deg_angle * Math.PI) / 180;
  let x_end = x_start + length * Math.cos(rad_angle); // note that the positive y value goes down instead of up
  let y_end = y_start - length * Math.sin(rad_angle);

  ctx.beginPath();
  ctx.moveTo(x_start, y_start); //x, y
  ctx.lineTo(x_end, y_end); // x, y
  ctx.lineWidth = 4 * scale;
  ctx.strokeStyle = "black";
  ctx.stroke();
}

function draw_triangle(left, top, right, colour, border_colour = "black") {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  // the triangle
  ctx.beginPath();
  ctx.moveTo(left[0], left[1]);
  ctx.lineTo(top[0], top[1]);
  ctx.lineTo(right[0], right[1]);
  ctx.lineTo(left[0], left[1]);
  ctx.closePath();

  //the outline
  ctx.lineWidth = 8;
  ctx.strokeStyle = border_colour;
  ctx.stroke();

  // the fill color
  ctx.fillStyle = colour;
  ctx.fill();
}

// draw_mera_box(x_start, y_start){
//     let c = document.getElementById("pictures");
//     let ctx = c.getContext("2d");

//     ctx.beginPath();
//     ctx.roundRect(x_start, y_start, 50*scale, 50*scale, 5*scale); // x, y, length(x), length(y)
//     ctx.lineWidth = 8*scale
//     ctx.strokeStyle = border_colour
//     ctx.stroke();
//     ctx.fillStyle = colour;
//     ctx.fill();

// }

function draw_scalar(num_elements, clear) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  if (clear) {
    ctx.clearRect(0, 0, c.width, c.height);
  }

  let space = 25;
  let length_obj = box_length;
  let height_obj = box_length;
  let scale = find_scale(length_obj, num_elements, c.width);
  let x_start = find_x_start(length_obj, num_elements, c.width, scale, space);
  let y_start = 300;

  ctx.strokeStyle = "black";

  while (num_elements) {
    draw_box(x_start, y_start, box_length, box_length, "#FF9797", scale);

    x_start += (length_obj + 25) * scale;
    num_elements -= 1;
  }
}

function draw_vector(num_elements, clear) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  if (clear) {
    ctx.clearRect(0, 0, c.width, c.height);
  }

  let space = 25;
  let length_obj = box_length;
  let height_obj = box_length + line_length;
  let scale = find_scale(length_obj, num_elements, c.width);
  let x_start = find_x_start(length_obj, num_elements, c.width, scale, space);
  let y_start = 300;

  ctx.strokeStyle = "black";

  while (num_elements) {
    // coordinates for the middle of the box to be drawn
    let x_middle = x_start + (box_length * scale) / 2;
    let y_middle = y_start + (box_length * scale) / 2;

    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
    draw_box(x_start, y_start, box_length, box_length, "#2FDDC5", scale);

    x_start += (length_obj + 25) * scale;
    num_elements -= 1;
  }
}

function draw_matrix(num_elements, clear) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  if (clear) {
    ctx.clearRect(0, 0, c.width, c.height);
  }

  let space = 25;
  let length_obj = box_length + 2 * line_length;
  let height_obj = box_length;
  let scale = find_scale(length_obj, num_elements, c.width);
  let x_start = find_x_start(length_obj, num_elements, c.width, scale, space);
  let y_start = 300;

  ctx.strokeStyle = "black";

  while (num_elements) {
    // coordinates for the middle of the box to be drawn
    let x_middle = x_start + (box_length * scale) / 2;
    let y_middle = y_start + (box_length * scale) / 2;
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 0, scale);
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 180, scale);
    draw_box(x_start, y_start, box_length, box_length, "#C8A2C8", scale);

    x_start += (length_obj + 25) * scale;
    num_elements -= 1;
  }
}

function draw_mps(num_elements, clear) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  if (clear) {
    ctx.clearRect(0, 0, c.width, c.height);
  }

  let length_obj = box_length + 2 * line_length;
  let height_obj = box_length + line_length;
  let scale = find_scale(length_obj, num_elements, c.width);

  let space = 0;
  let x_start = find_x_start(length_obj, num_elements, c.width, scale, space);
  let y_start = 300;

  let x_middle = x_start + (box_length * scale) / 2;
  let y_middle = y_start + (box_length * scale) / 2;

  ctx.strokeStyle = "black";

  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 0, scale);
  draw_box(
    x_start,
    y_start,
    box_length,
    box_length,
    "#F1DF0D",
    scale,
    "#F7BC27"
  );

  x_start += length_obj * scale;
  num_elements -= 1;

  while (num_elements > 1) {
    x_middle = x_start + (box_length * scale) / 2;
    y_middle = y_start + (box_length * scale) / 2;

    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 180, scale);
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 0, scale);
    draw_box(
      x_start,
      y_start,
      box_length,
      box_length,
      "#F1DF0D",
      scale,
      "#F7BC27"
    );

    x_start += length_obj * scale;
    num_elements -= 1;
  }

  x_middle = x_start + (box_length * scale) / 2;
  y_middle = y_start + (box_length * scale) / 2;

  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 180, scale);
  draw_box(
    x_start,
    y_start,
    box_length,
    box_length,
    "#F1DF0D",
    scale,
    "#F7BC27"
  );
}

function draw_mpo(num_elements, clear) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  if (clear) {
    ctx.clearRect(0, 0, c.width, c.height);
  }

  let space = 0;
  let length_obj = box_length + 2 * line_length;
  let height_obj = box_length + 2 * line_length;
  let scale = find_scale(length_obj, num_elements, c.width);
  let x_start = find_x_start(length_obj, num_elements, c.width, scale, space);
  let y_start = 300;

  let x_middle = x_start + (box_length * scale) / 2;
  let y_middle = y_start + (box_length * scale) / 2;

  ctx.strokeStyle = "black";

  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 270, scale);
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 0, scale);
  draw_box(
    x_start,
    y_start,
    box_length,
    box_length,
    "#24AD26",
    scale,
    "#2B782D"
  );

  x_start += length_obj * scale;
  num_elements -= 1;

  while (num_elements > 1) {
    x_middle = x_start + (box_length * scale) / 2;
    y_middle = y_start + (box_length * scale) / 2;

    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 270, scale);
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 180, scale);
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 0, scale);
    draw_box(
      x_start,
      y_start,
      box_length,
      box_length,
      "#24AD26",
      scale,
      "#2B782D"
    );

    x_start += length_obj * scale;
    num_elements -= 1;
  }

  x_middle = x_start + (box_length * scale) / 2;
  y_middle = y_start + (box_length * scale) / 2;

  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 270, scale);
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 180, scale);
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
  draw_box(
    x_start,
    y_start,
    box_length,
    box_length,
    "#24AD26",
    scale,
    "#2B782D"
  );
}

function draw_peps(num_rows, num_columns, clear) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  if (clear) {
    ctx.clearRect(0, 0, c.width, c.height);
  }

  let space = 0;
  let length_obj = box_length + 2 * line_length;
  let height_obj = box_length + 2 * line_length;
  let scale = find_scale(length_obj, num_columns, c.width); // will need to consider y elemenets as well
  let x_start = find_x_start(length_obj, num_columns, c.width, scale, space);
  let y_start = find_y_start(height_obj, num_rows, c.height, scale, space);

  // NOTE: If changes are made to how draw_peps or draw_mera manipulate the canvas,
  // the opposite must be done for revert_peps_canvas_context or revert_mera_canvas_context,
  // respectively.
  ctx.translate(c.width / 2, c.height / 2);
  ctx.rotate((-45 * Math.PI) / 180);
  ctx.scale(0.6, 0.6);
  ctx.translate(-c.width / 2, -c.height / 2);

  ctx.strokeStyle = "black";

  draw_edge_row(num_columns, x_start, y_start, "down");
  y_start += height_obj * scale;
  num_rows -= 1;

  while (num_rows != 1) {
    draw_inner_row(num_columns, x_start, y_start);
    y_start += height_obj * scale;
    num_rows -= 1;
  }

  draw_edge_row(num_columns, x_start, y_start, "up");
}

function draw_edge_row(num_elements, x_start, y_start, oritentation) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  let length_obj = box_length + 2 * line_length;
  let height_obj = box_length + line_length;
  let scale = find_scale(length_obj, num_elements, c.width);

  let x_middle = x_start + (box_length * scale) / 2;
  let y_middle = y_start + (box_length * scale) / 2;

  if (oritentation == "up") {
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
  } else {
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 270, scale);
  }
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 0, scale);
  draw_circle(x_middle, y_middle, "#24AD26", scale, "#2B782D");
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 45, scale);

  x_start += length_obj * scale;
  num_elements -= 1;

  while (num_elements > 1) {
    x_middle = x_start + (box_length * scale) / 2;
    y_middle = y_start + (box_length * scale) / 2;

    if (oritentation == "up") {
      draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
    } else {
      draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 270, scale);
    }
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 180, scale);
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 0, scale);
    draw_circle(x_middle, y_middle, "#24AD26", scale, "#2B782D");
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 45, scale);

    x_start += length_obj * scale;
    num_elements -= 1;
  }

  x_middle = x_start + (box_length * scale) / 2;
  y_middle = y_start + (box_length * scale) / 2;

  if (oritentation == "up") {
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
  } else {
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 270, scale);
  }
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 180, scale);
  draw_circle(x_middle, y_middle, "#24AD26", scale, "#2B782D");
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 45, scale);
}

function draw_inner_row(num_elements, x_start, y_start) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  let length_obj = box_length + 2 * line_length;
  let height_obj = box_length + 2 * line_length;
  let scale = find_scale(length_obj, num_elements, c.width);

  let x_middle = x_start + (box_length * scale) / 2;
  let y_middle = y_start + (box_length * scale) / 2;

  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 270, scale);
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 0, scale);
  draw_circle(x_middle, y_middle, "#24AD26", scale, "#2B782D");
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 45, scale);

  x_start += length_obj * scale;
  num_elements -= 1;

  while (num_elements > 1) {
    x_middle = x_start + (box_length * scale) / 2;
    y_middle = y_start + (box_length * scale) / 2;

    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 270, scale);
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 180, scale);
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 0, scale);
    draw_circle(x_middle, y_middle, "#24AD26", scale, "#2B782D");
    draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 45, scale);

    x_start += length_obj * scale;
    num_elements -= 1;
  }

  x_middle = x_start + (box_length * scale) / 2;
  y_middle = y_start + (box_length * scale) / 2;

  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 270, scale);
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 180, scale);
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 90, scale);
  draw_circle(x_middle, y_middle, "#24AD26", scale, "#2B782D");
  draw_line_polar(x_middle, y_middle, 2 * line_length * scale, 45, scale);
}

function draw_mera(num_columns, clear) {
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");

  if (clear) {
    ctx.clearRect(0, 0, c.width, c.height);
  }

  let space = 100; // THIS CALCULATION WILL BE VERY WRONG
  let length_obj = box_length * 2;
  let height_obj = box_length + 2 * line_length;
  let num_rows = 2 * Math.floor(num_columns / 2);
  let scale = find_scale(length_obj, num_columns, c.width); // will need to consider y elemenets as well
  let x_start = find_x_start(length_obj, num_columns, c.width, scale, space);
  let y_start =
    c.height - find_y_start(height_obj, num_rows, c.height, scale, space); // building the mera bottom up rather than top down

  // NOTE: If changes are made to how draw_peps or draw_mera manipulate the canvas,
  // the opposite must be done for revert_peps_canvas_context or revert_mera_canvas_context,
  // respectively.
  ctx.translate(c.width / 4, c.height / 8);
  ctx.scale(0.8, 0.8);

  let interation = 0;
  let last = [];
  let distance = 150 * scale;

  while (num_columns > 1) {
    last = draw_box_row(
      num_columns,
      distance,
      scale,
      [[x_start, y_start]],
      last
    );
    interation += 1;

    x_start += distance / 2;
    y_start -= (0.75 + 0.25 * interation) * height_obj;

    num_columns -= 1;

    last = draw_tri_row(
      num_columns,
      distance,
      scale,
      [[x_start, y_start]],
      last
    );
    interation += 1;

    x_start += distance / 2;
    y_start -= (1.75 + 0.25 * interation) * height_obj;

    num_columns /= 2;
    distance += distance;
  }
}

function draw_box_row(num_elements, space, scale, connect = [[0, 0]], last) {
  let x_coordinate = connect[0][0];
  let y_coordinate = connect[0][1];

  let line_end = new Array((num_elements - 1) * 2);

  let pos = 0;

  while (pos < 2 * num_elements) {
    draw_line_polar(
      x_coordinate + 25 * scale,
      y_coordinate - 25 * scale,
      100 * scale,
      270,
      scale
    );
    draw_line_polar(
      x_coordinate + 75 * scale,
      y_coordinate - 25 * scale,
      100 * scale,
      270,
      scale
    );

    if (last.length != 0) {
      let last_x = last[pos][0];
      let last_y = last[pos][1];
      draw_line(
        x_coordinate + 25 * scale,
        y_coordinate + 75 * scale,
        last_x,
        last_y,
        scale
      );

      last_x = last[pos + 1][0];
      last_y = last[pos + 1][1];
      draw_line(
        x_coordinate + 75 * scale,
        y_coordinate + 75 * scale,
        last_x,
        last_y,
        scale
      );
    }

    draw_box(
      x_coordinate,
      y_coordinate,
      2 * box_length,
      box_length,
      "#F1DF0D",
      scale
    );

    line_end[pos++] = [x_coordinate + 25 * scale, y_coordinate - 25 * scale];
    line_end[pos++] = [x_coordinate + 75 * scale, y_coordinate - 25 * scale];

    x_coordinate += space;
  }

  return line_end;
}

function draw_tri_row(num_elements, space, scale, connect = [(0, 0)], last) {
  //SCALE WILL CAUSE AN ISSUE LATER
  let c = document.getElementById("pictures");
  let ctx = c.getContext("2d");
  let x_coordinate = connect[0][0];
  let y_coordinate = connect[0][1];

  let line_end = new Array(num_elements);

  let pos = 0;

  while (pos < 2 * num_elements) {
    draw_line_polar(
      x_coordinate + 25 * scale,
      y_coordinate,
      25 * scale,
      270,
      scale
    );
    draw_line_polar(
      x_coordinate + 75 * scale,
      y_coordinate,
      25 * scale,
      270,
      scale
    );
    draw_line_polar(
      x_coordinate + 50 * scale,
      y_coordinate - 50 * scale,
      25 * scale,
      90,
      scale
    );

    let last_x = last[pos + 1][0];
    let last_y = last[pos + 1][1];
    draw_line(
      x_coordinate + 25 * scale,
      y_coordinate + 25 * scale,
      last_x,
      last_y,
      scale
    );

    last_x = last[pos + 2][0];
    last_y = last[pos + 2][1];
    draw_line(
      x_coordinate + 75 * scale,
      y_coordinate + 25 * scale,
      last_x,
      last_y,
      scale
    );

    // pos += 2

    draw_triangle(
      [x_coordinate, y_coordinate],
      [x_coordinate + 50 * scale, y_coordinate - 50 * scale],
      [x_coordinate + 100 * scale, y_coordinate],
      "#659BDF"
    );

    line_end[pos / 2] = [x_coordinate + 50 * scale, y_coordinate - 75 * scale];
    pos += 2;

    x_coordinate += space;
  }

  return line_end;
}
