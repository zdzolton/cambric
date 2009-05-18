function(doc) {
  var outdoc = { message: doc.message, author: doc.author };
  doc.followers.push(doc.author);
  doc.followers.forEach(function(f) {
      emit([f, doc.created_at], outdoc);
  });
};
