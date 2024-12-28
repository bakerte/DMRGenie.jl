function BuildFormFields($amount) {
  var $container = document.getElementById("hamiltonian_components"),
    $item,
    $field,
    $i;
  $container.innerHTML = "";

  const max = 12;

  // Set a border for style
  if ($amount > 0) {
    document.getElementById("hamiltonian_border_div").style.borderStyle =
      "inset";
  } else {
    document.getElementById("hamiltonian_border_div").style.borderStyle =
      "none";
  }

  for ($i = 1; $i <= $amount; $i++) {
    if ($i > max) {
      // Limited number of terms
      break;
    }

    $item = document.createElement("div");
    $item.style.margin = "3px";

    // Matrix Dropdown
    $field = document.createElement("span");
    $field.innerHTML = "Matrix " + $i + ":";
    $field.style.marginRight = "31px";
    $item.appendChild($field);

    $field = document.createElement("select");
    $field.name = "hamiltonian_matrix[" + $i + "]";

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
    m_opt7.text = "Zeros";

    $field.add(m_opt1, null);
    $field.add(m_opt2, null);
    $field.add(m_opt3, null);
    $field.add(m_opt4, null);
    $field.add(m_opt5, null);
    $field.add(m_opt6, null);
    $field.add(m_opt7, null);

    $item.appendChild($field);
    $container.appendChild($item);

    $item = document.createElement("div");
    $item.style.margin = "3px";

    // Integer
    $field = document.createElement("span");
    $field.innerHTML = "Constant " + $i + ":";
    $field.style.marginRight = "16px";
    $item.appendChild($field);

    $field = document.createElement("input");
    $field.name = "hamiltonian_value[" + $i + "]";
    $field.type = "number";
    $field.step = "any";
    $field.value = 1;

    $item.appendChild($field);
    $container.appendChild($item);

    // Operation Dropdown
    if ($i < $amount && $i < max) {
      $item = document.createElement("div");
      $item.style.margin = "3px";

      $field = document.createElement("span");
      $field.innerHTML = "Operation " + $i + ":";
      $field.style.marginRight = "10px";
      $item.appendChild($field);

      $field = document.createElement("select");
      $field.name = "operation[" + $i + "]";

      const o_opt1 = document.createElement("option");
      const o_opt2 = document.createElement("option");
      o_opt1.value = "+";
      o_opt2.value = "*";
      o_opt1.text = "+";
      o_opt2.text = "*";
      $field.add(o_opt1, null);
      $field.add(o_opt2, null);

      $item.appendChild($field);
      $container.appendChild($item);
    }

    // Add linebreak
    $container.appendChild(document.createElement("br"));
  }
}
