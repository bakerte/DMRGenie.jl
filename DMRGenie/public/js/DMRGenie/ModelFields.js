var num_correlation_function_ops = 1;
var num_symmetries = 1;
var num_indeces_list = [1];

function uncheckCorrelationCheckboxIfTooLarge(send_alert = false) {
  var num_tensors = document.getElementById("num_tensors").value;

  if (num_tensors > 15) {
    if (send_alert) {
      alert(
        "The number of tensors cannot be greater than 15 to obtain Correlation Functions"
      );
    }

    var correlation_box = document.getElementById("correlation_box");
    correlation_box.checked = false;
    document.getElementById("correlation_content").style.display = "none";
    document.getElementById("correlation_border_div").style.borderStyle =
      "none";
  }
}

function HideOrShowCorrelationOptions() {
  var correlation_box = document.getElementById("correlation_box");

  // Computation Limitation
  // This limit is also imposed in routes.jl
  uncheckCorrelationCheckboxIfTooLarge(true);

  if (correlation_box.checked) {
    document.getElementById("correlation_content").style.display = "block";
    document.getElementById("correlation_border_div").style.borderStyle =
      "inset";
  } else {
    document.getElementById("correlation_content").style.display = "none";
    document.getElementById("correlation_border_div").style.borderStyle =
      "none";
  }
}

function uncheckSymmetryCheckboxIfTooLarge(send_alert = false) {
  var num_tensors = document.getElementById("num_tensors").value;

  if (num_tensors > 50) {
    if (send_alert) {
      alert(
        "The number of tensors cannot be greater than 50 to apply Symmetries"
      );
    }

    var symmetry_box = document.getElementById("symmetry_box");
    symmetry_box.checked = false;
    document.getElementById("symmetry_content").style.display = "none";
    document.getElementById("symmetry_border_div").style.borderStyle = "none";
  }
}

function HideOrShowSymmetryElements() {
  var symmetry_box = document.getElementById("symmetry_box");

  // Computation Limitation
  // This limit is also imposed in routes.jl
  uncheckSymmetryCheckboxIfTooLarge(true);
  if (symmetry_box.checked) {
    document.getElementById("symmetry_content").style.display = "block";
    document.getElementById("symmetry_border_div").style.borderStyle = "inset";
  } else {
    document.getElementById("symmetry_content").style.display = "none";
    document.getElementById("symmetry_border_div").style.borderStyle = "none";
  }
}

function HideOrShowNonUniformElements() {
  var symmetry_box = document.getElementById("non_uniform_box");
  if (symmetry_box.checked) {
    document.getElementById("non_uniform_span").style.display = "block";
    document.getElementById("non_uniform_content").style.display = "block";
    document.getElementById("range_span[1]").style.display = "block";
  } else {
    document.getElementById("non_uniform_span").style.display = "none";
    document.getElementById("non_uniform_content").style.display = "none";
    document.getElementById("range_span[1]").style.display = "none";
  }
}

function HideOrShowModelOptions() {
  var selected = document.getElementById("default_model");
  var selectedValue = selected.options[selected.selectedIndex].value;
  if (selectedValue == "none") {
    document.getElementById("non_default_model_options").style.display =
      "block";
  } else {
    document.getElementById("non_default_model_options").style.display = "none";
  }
}

function ZnChange(i) {
  var selected = document.getElementById("sym[" + i + "]");
  var selectedValue = selected.options[selected.selectedIndex].value;
  if (selectedValue == "Zn") {
    document.getElementById("Zn[" + i + "]").style.display = "inline";
  } else {
    document.getElementById("Zn[" + i + "]").style.display = "none";
  }
}

function SizeCheck() {
  var uploadField = document.getElementById("system_input_file");

  // TODO - Choose max file size - For now it is 2 MB
  if (uploadField.files[0].size > 2097152) {
    alert("File is too big!");
    uploadField.value = "";
  }
}

function CreateNewCorrelationFunctionInput() {
  if (num_correlation_function_ops < 8) {
    num_correlation_function_ops += 1;
    const op_num = num_correlation_function_ops;

    var select_id = "correlation_function_op[" + op_num + "]";

    var DOMSelect = document.createElement("select");
    DOMSelect.setAttribute("id", select_id);
    DOMSelect.setAttribute("name", select_id);
    DOMSelect.setAttribute("style", "margin-top:2px; margin-right:28px;");

    const m_opt1 = document.createElement("option");
    const m_opt2 = document.createElement("option");
    const m_opt3 = document.createElement("option");
    const m_opt4 = document.createElement("option");
    const m_opt5 = document.createElement("option");
    const m_opt6 = document.createElement("option");
    const m_opt7 = document.createElement("option");

    m_opt1.value = "Id";
    m_opt2.value = "Sp";
    m_opt3.value = "Sm";
    m_opt4.value = "Sx";
    m_opt5.value = "Sy";
    m_opt6.value = "Sz";
    m_opt7.value = "O";

    m_opt1.text = "Id";
    m_opt2.text = "Sp";
    m_opt3.text = "Sm";
    m_opt4.text = "Sx";
    m_opt5.text = "Sy";
    m_opt6.text = "Sz";
    m_opt7.text = "O";

    DOMSelect.add(m_opt1, null);
    DOMSelect.add(m_opt2, null);
    DOMSelect.add(m_opt3, null);
    DOMSelect.add(m_opt4, null);
    DOMSelect.add(m_opt5, null);
    DOMSelect.add(m_opt6, null);
    DOMSelect.add(m_opt7, null);

    document.getElementById("additional_ops").appendChild(DOMSelect);
    document
      .getElementById("additional_ops")
      .appendChild(document.createElement("br"));
  }
}

function CreateNewSymmetrySelect(sym_id, add_linebreak = true) {
  if (num_symmetries < 10) {
    // 10 unique symmetries max
    num_symmetries += 1;
    const sym_num = num_symmetries;

    var select_id = "sym[" + sym_num + "]";
    var Zn_id = "Zn[" + sym_num + "]";
    var Zn_val_id = "Zn_val[" + sym_num + "]";

    // Add a new symmetry select
    var DOMSelect = document.createElement("select");
    DOMSelect.setAttribute("id", select_id);
    DOMSelect.setAttribute("name", select_id);
    DOMSelect.setAttribute("style", "margin-top:2px; margin-right:28px;");

    DOMSelect.onchange = function () {
      ZnChange(sym_num);
    };

    const m_opt1 = document.createElement("option");
    const m_opt2 = document.createElement("option");
    m_opt1.value = "U1";
    m_opt2.value = "Zn";
    m_opt1.text = "U1";
    m_opt2.text = "Zn";

    DOMSelect.add(m_opt1, null);
    DOMSelect.add(m_opt2, null);
    document.getElementById(sym_id).appendChild(DOMSelect);

    // Add new initially hidden box for the option of Zn
    var DOMhidden = document.createElement("span");
    DOMhidden.setAttribute("id", Zn_id);
    DOMhidden.setAttribute("name", Zn_id);
    DOMhidden.classList.add("init-hidden");

    var DOMInput = document.createElement("input");
    DOMInput.setAttribute("type", "number");
    DOMInput.setAttribute("id", Zn_val_id);
    DOMInput.setAttribute("name", Zn_val_id);
    DOMInput.setAttribute("style", "margin-left:4px");

    DOMhidden.appendChild(DOMInput);
    document.getElementById(sym_id).appendChild(DOMhidden);

    if (add_linebreak) {
      document.getElementById(sym_id).appendChild(document.createElement("br"));
    }
  }
}

function CreateNewPhysicalIndex() {
  if (num_indeces_list.length < 10) {
    // 10 unique physical indeces max
    num_indeces_list[num_indeces_list.length] = 1;
    const idx = num_indeces_list.length;

    document.getElementById("num_physical_indeces").value = idx.toString();

    document
      .getElementById("non_uniform_content")
      .appendChild(document.createElement("br"));

    // Physical Index
    var DOMIdxSpan = document.createElement("span");
    DOMIdxSpan.setAttribute("id", "phys_idx_span[" + idx + "]");
    DOMIdxSpan.setAttribute("name", "phys_idx_span[" + idx + "]");
    document.getElementById("non_uniform_content").appendChild(DOMIdxSpan);

    var DOMLabel = document.createElement("label");
    DOMLabel.setAttribute("for", "physical_index[" + idx + "][1]");
    DOMLabel.innerHTML = "Physical Index " + idx + ": ";

    DOMIdxSpan.appendChild(DOMLabel);
    DOMIdxSpan.appendChild(document.createElement("br"));

    var DOMNumber = document.createElement("input");
    DOMNumber.setAttribute("type", "number");
    DOMNumber.setAttribute("id", "physical_index[" + idx + "][1]");
    DOMNumber.setAttribute("name", "physical_index[" + idx + "][1]");
    DOMNumber.setAttribute("required", "required");
    // DOMNumber.setAttribute("style", "margin-right:4px; margin-top:2px");
    DOMIdxSpan.appendChild(DOMNumber);

    document
      .getElementById("non_uniform_content")
      .appendChild(document.createElement("br"));

    // Range
    var DOMLabel = document.createElement("label");
    DOMLabel.setAttribute("for", "range_start[" + idx + "]");
    DOMLabel.innerHTML = "Range " + idx + ": ";

    document.getElementById("non_uniform_content").appendChild(DOMLabel);
    document.getElementById("non_uniform_content").appendChild(document.createElement("br"));

    var DOMRangeStart = document.createElement("input");
    DOMRangeStart.setAttribute("type", "number");
    DOMRangeStart.setAttribute("id", "range_start[" + idx + "]");
    DOMRangeStart.setAttribute("name", "range_start[" + idx + "]");
    DOMRangeStart.setAttribute("required", "required");
    DOMRangeStart.setAttribute("style", "margin-right:4px; margin-top:2px");
    DOMRangeStart.setAttribute("min", "1");
    document.getElementById("non_uniform_content").appendChild(DOMRangeStart);

    var DOMRangeStop = document.createElement("input");
    DOMRangeStop.setAttribute("type", "number");
    DOMRangeStop.setAttribute("id", "range_stop[" + idx + "]");
    DOMRangeStop.setAttribute("name", "range_stop[" + idx + "]");
    DOMRangeStop.setAttribute("required", "required");
    DOMRangeStop.setAttribute("min", "1");
    document.getElementById("non_uniform_content").appendChild(DOMRangeStop);

    document
      .getElementById("non_uniform_content")
      .appendChild(document.createElement("br"));
  }
}

function CreatePhysicalIndexNumberInputs() {
  var idx = 1;
  while (idx <= num_indeces_list.length) {
    while (num_indeces_list[idx - 1] < num_symmetries) {
      num_indeces_list[idx - 1] += 1;
      var DOMPhysicalIndexInput = document.createElement("input");
      DOMPhysicalIndexInput.setAttribute("type", "number");
      DOMPhysicalIndexInput.setAttribute(
        "id",
        "physical_index[" + idx + "][" + num_indeces_list[idx - 1] + "]"
      );
      DOMPhysicalIndexInput.setAttribute(
        "name",
        "physical_index[" + idx + "][" + num_indeces_list[idx - 1] + "]"
      );

      if (idx != 1 || num_indeces_list[idx - 1] != 2) {
        // This prevents a spacing bug
        DOMPhysicalIndexInput.setAttribute("style", "margin-left:4px");
      }
      document
        .getElementById("phys_idx_span[" + idx + "]")
        .appendChild(DOMPhysicalIndexInput);
    }
    idx += 1;
  }
}
