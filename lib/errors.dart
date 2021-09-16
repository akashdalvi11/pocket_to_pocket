enum Errors { sessionExpired, networkError }
errorHandler(Errors e) {
  return e.toString();
}
