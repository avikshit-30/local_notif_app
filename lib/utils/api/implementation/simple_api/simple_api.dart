import 'package:http/http.dart' as http;

import '../../../logger.dart';
import '../../core/abstract_api.dart';
import '../../core/http_method.dart';
import 'abstract_simple_params.dart';

class SimpleAPI<MODEL, PARAM extends AbstractSimpleParameters>
    extends AbstractAPI<MODEL, PARAM, http.BaseRequest, http.Response> {
//  SimpleAPIParams _params = SimpleAPIParams();
  final PARAM params;

  final bool resetParamsOnExecute;

//  final void Function()? onExecuteCompleteListener;

  SimpleAPI(
      {required String completeUrl,
      required MODEL Function(String) factory,
      required HTTPMethod method,
      required this.params,
      this.resetParamsOnExecute = false,
      super.changeListener})
      : super(
            completeUrl: completeUrl,
            factory: factory,
            httpMethod: method.value);

  @override
  Future<http.BaseRequest> generateRequest() async {
    String finalUrl = params.getFormattedUrl(completeUrl);
    if (finalUrl.endsWith('#')) {
      finalUrl = removeLastLetter(finalUrl);
    } else {
      if (!finalUrl.endsWith('/') &&
          super.httpMethod == HTTPMethod.post.value) {
        finalUrl += '/';
      }
    }

    http.BaseRequest request;

    debugLog(debugTag, finalUrl);

    if (params.getFiles().isNotEmpty) {
      var mpRequest = http.MultipartRequest(httpMethod, Uri.parse(finalUrl));
      mpRequest.headers.clear();
      mpRequest.headers.addAll(params.getHeaders());
      mpRequest.headers.addAll({
        "Content-Type": 'multipart/form-data',
//        "Accept": 'application/json'
      });
//    request.fields.addAll(other)
      params.getBodyUnencoded().forEach((key, value) {
        mpRequest.fields[key] = value;
        //jsonEncode(value);
      });
      var files = params.getFiles();

      for (int i = 0; i < params.getFiles().keys.length; i++) {
        var key = files.keys.elementAt(i);
        mpRequest.files
            .add(await http.MultipartFile.fromPath(key, files[key]!));
      }
      request = mpRequest;
    } else {
      var simpleReq = http.Request(httpMethod, Uri.parse(finalUrl));
      simpleReq.headers.clear();
      simpleReq.headers.addAll(params.getHeaders());
      simpleReq.headers.addAll({"Content-Type": 'application/json'});
      simpleReq.body = params.getBodyEncoded();
      request = simpleReq;
    }

//params.

/*
    params.getFiles().forEach((key, value) async {
      request.files.add(await http.MultipartFile.fromPath(key, value));
    });
    */
//    request.fields = params.getBodyEncoded();

    if (resetParamsOnExecute) {
      debugLog("API ${MODEL.toString()}", "Parameters reset after execute.");
      params.reset();
    }

    return request;
  }

  @override
  PARAM get requestParams => params;

/*
  @override
  void setRequestParams(SimpleAPIParams params) {
    _params = params;
  }
*/
}

String removeLastLetter(String input) {
  if (input.isEmpty) {
    return input; // Handle empty string case if needed
  }

  return input.substring(0, input.length - 1);
}

/*
@Riverpod(keepAlive: true)
MatchResultRepo matchResultRepo(MatchResultRepoRef ref){
  return MatchResultRepo(ref: ref);
}
*/