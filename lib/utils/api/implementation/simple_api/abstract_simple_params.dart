abstract class AbstractSimpleParameters {

  Map<String, String> getHeaders();
  String getBodyEncoded();

  Map<String, dynamic> getBodyUnencoded();
  Map<String, String> getFiles(); 

  String getFormattedUrl(String raw);
  String? get overriddenUrl;

  void reset ();
}