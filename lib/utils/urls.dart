class URLs {
  static const String serverUrl = "https://ssmssunoff.vercel.app/messmenu.json";

  static String complete(String local) {
    return serverUrl + local;
  }
}
