function ShowRequiredOutputs() {
  // Hamiltonian DMRG
  var hamiltonianDMRG = document.getElementById("hamiltonian_dmrg");
  var hamVal = hamiltonianDMRG.getAttribute("value"); // We will always have a hamiltonian value on output so check with this

  // Measurements
  var measurements = document.getElementById("measurements");
  if (hamVal != "NaN") {
    measurements.style.display = "block";
  } else {
    measurements.style.display = "none";
  }

  if (hamVal != "NaN") {
    hamiltonianDMRG.style.display = "block";
  } else {
    hamiltonianDMRG.style.display = "none";
  }

  // Symmetry DMRG
  var symmetryDMRG = document.getElementById("dmrg_with_symmetries");
  var symVal = symmetryDMRG.getAttribute("value");

  if (symVal != "NaN") {
    symmetryDMRG.style.display = "block";
  } else {
    symmetryDMRG.style.display = "none";
  }

  // Dense Correlation Matrix
  var denseCorrelationMatrix = document.getElementById(
    "dense_correlation_matrix"
  );
  var denseMatrixPath = denseCorrelationMatrix.getAttribute("value");
  if (denseMatrixPath) {
    denseCorrelationMatrix.style.display = "block";
  } else {
    denseCorrelationMatrix.style.display = "none";
  }

  // Dense Correlation Function
  var denseCorrelationFunction = document.getElementById(
    "dense_correlation_function"
  );
  var denseFunctionPath = denseCorrelationFunction.getAttribute("value");
  if (denseFunctionPath) {
    denseCorrelationFunction.style.display = "block";
  } else {
    denseCorrelationFunction.style.display = "none";
  }

  // Symmetry Correlation Matrix
  var symmetryCorrelationMatrix = document.getElementById(
    "symmetry_correlation_matrix"
  );
  var symMatrixPath = symmetryCorrelationMatrix.getAttribute("value");
  if (symMatrixPath) {
    symmetryCorrelationMatrix.style.display = "block";
  } else {
    symmetryCorrelationMatrix.style.display = "none";
  }

  // Symmetry Correlation Function
  var symmetryCorrelationFunction = document.getElementById(
    "symmetry_correlation_function"
  );
  var symFunctionPath = symmetryCorrelationFunction.getAttribute("value");
  if (symFunctionPath) {
    symmetryCorrelationFunction.style.display = "block";
  } else {
    symmetryCorrelationFunction.style.display = "none";
  }
}
