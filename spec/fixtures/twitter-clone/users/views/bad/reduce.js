function(key, values) {
  // This should throw an error:
  return values[0]['some_non_existant_property'].length;
}