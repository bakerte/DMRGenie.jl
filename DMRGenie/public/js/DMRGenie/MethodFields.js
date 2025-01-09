function SystemChange() {
  var selected = document.getElementById("system");
  var selectedValue = selected.options[selected.selectedIndex].value;
  if (selectedValue == "input") {
    document.getElementById("system_input_file").style.display = "inline";
  } else {
    document.getElementById("system_input_file").style.display = "none";
  }
}
