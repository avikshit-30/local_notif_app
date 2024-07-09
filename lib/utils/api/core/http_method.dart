enum HTTPMethod {
  get("GET"),
  post("POST"),
  put("PUT"),
  delete("DELETE"),
  patch("PATCH");

  final String value;
  
  const HTTPMethod(this.value);
}
