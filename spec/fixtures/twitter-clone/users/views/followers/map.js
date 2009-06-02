function(doc) {
  // FYI: This example assumes we're using usernames as the doc ID.
  doc['following'].forEach(function(user) {
    emit(user, doc['_id']);
  });
}
