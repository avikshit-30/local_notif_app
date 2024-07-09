import 'api_state.dart';

abstract class ApiStateHolder {
  APIState get state;
  set state(APIState state);
}