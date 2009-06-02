function(doc) {
  // This should be returned:
  emit(4, 5);
  
  // This should not:
  emit(doc['some_non_existant_property'].length, null);
}