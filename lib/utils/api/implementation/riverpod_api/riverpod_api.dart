import 'package:http/http.dart';
import 'package:riverpod/riverpod.dart';

import '../simple_api/abstract_simple_params.dart';
import '../simple_api/simple_api.dart';

class RiverpodAPI<MODEL, PARAM extends AbstractSimpleParameters>
    extends SimpleAPI<MODEL, PARAM> {
  final Ref ref;

  final bool requiresAuth;

  RiverpodAPI(
      {required super.completeUrl,
      required super.factory,
      required super.method,
      required super.params,
      required this.ref,
      super.resetParamsOnExecute = false,
      this.requiresAuth = true})
      : super(changeListener: () {
          ref.notifyListeners();
        });

  @override
  Future<BaseRequest> generateRequest() async {
    var req = (await super.generateRequest());

    return req;

    /*
    var request = http.Request(httpMethod, Uri.parse(completeUrl));
    request.headers.clear();
    request.headers.addAll(_params.getHeaders());
    request.body = _params.getBody();

    if (resetParamsOnExecute) {
      debugLog("API ${MODEL.toString()}", "Parameters reset after execute.");
      _params = SimpleAPIParams();
    }

    return request;
    */
  }
/*
  @override
  Future<void> execute() async {
    await super.execute();
    print("State: ${state}");
  }
*/
}
