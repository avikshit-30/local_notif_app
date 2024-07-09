import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_notif_app/utils/api/core/either.dart';

import '../../global_settings.dart';
import '../../logger.dart';
import 'api_state.dart';
import 'api_state_holder.dart';
import 'http_client_singleton.dart';
//import 'package:studydeck_revamp/testing/api/test_model.dart';

abstract class AbstractAPI<
    RESULT_MODEL,
    REQUEST_PARAM,
    REQUEST_TYPE extends http.BaseRequest,
    RESPONSE_TYPE extends http.BaseResponse> extends ApiStateHolder {
  // extends APITransformer<void, RM> {

  String get debugTag => "[API]: (${RESULT_MODEL.toString()})";
  String get errorTag => "[API ERROR]: (${RESULT_MODEL.toString()})";

  bool get resetWhileRefreshing => true;
  bool get allowConcurrentRequests => false;

  final String completeUrl;
  final String httpMethod;
  final RESULT_MODEL Function(String) factory;
  final int? timeoutSeconds;

  RESULT_MODEL? _currentResult;
  RESULT_MODEL? _lastestValidResult;
  DateTime? _lastSuccessfulCallTime;
  DateTime? get lastSuccessfulCallTime => _lastSuccessfulCallTime;
  REQUEST_PARAM get requestParams;

  APIState _currentState = APIState.initial;

  RESULT_MODEL? get currentResult => _currentResult;
  RESULT_MODEL? get lastestValidResult => _currentResult ?? _lastestValidResult;
  @override
  APIState get state => _currentState;
  @override
  set state(APIState val) {
    state = val;
  }

  final void Function()? onConcurrentRequestRejectListener;
  final void Function()? changeListener;

  AbstractAPI(
      {required this.completeUrl,
      required this.factory,
      required this.httpMethod,
      this.timeoutSeconds = GlobalSettings.defaultTimeoutSecs,
      this.onConcurrentRequestRejectListener,
      this.changeListener})
      : super();

  Future<REQUEST_TYPE> generateRequest();

  Future<RESPONSE_TYPE> sendActual() async {
    if (RESPONSE_TYPE == http.Response) {
      var req = await generateRequest();
      debugLog(debugTag, req.toString());
      Future<http.StreamedResponse> sentReq;

      if (timeoutSeconds != null) {
        sentReq = HttpClientSingleton.instance
            .send(req)
            .timeout(Duration(seconds: timeoutSeconds!));
      } else {
        sentReq = HttpClientSingleton.instance.send(req);
      }
      return (await http.Response.fromStream(await sentReq)) as RESPONSE_TYPE;
    } else {
      throw UnimplementedError("sendActual must be implemented");
    }
  }

  RESULT_MODEL parse(RESPONSE_TYPE response) {
    if (response is http.Response) {
      //debugLog(debugTag, response.body);
      return factory(response.body);
    } else {
      throw UnimplementedError(
          "parse is not implemnted for ${response.runtimeType}");
    }
  }

  void _callOnChangeListener() {
    if (changeListener != null) {
      changeListener!();
    }
  }

  void _changeDataAndState(
      RESULT_MODEL? current, RESULT_MODEL? latestValid, APIState newState,
      {bool notifyIfSameState = true}) {
    if (newState == APIState.success) {
      _lastSuccessfulCallTime = DateTime.now();
    }

    _currentResult = current;
    _lastestValidResult = lastestValidResult;
    bool stateChanged = newState == _currentState;
    _currentState = newState;

    if (stateChanged && !notifyIfSameState) {
      return;
    }
    _callOnChangeListener();
  }

  @mustCallSuper
  void clear() {
    _changeDataAndState(null, null, APIState.initial);
  }

  Future<void> execute() async {
    if (allowConcurrentRequests) {
      if (state.isOngoing) {
        if (onConcurrentRequestRejectListener != null) {
          onConcurrentRequestRejectListener!();
        }
        return;
      }
    }

    if (resetWhileRefreshing) {
      _changeDataAndState(
          null, _lastestValidResult, APIState.ongoingWithOldData);
    } else {
      _changeDataAndState(null, null, APIState.ongoingWithoutOldData);
    }

    try {
      var res = await sendActual().toEither();
      res.fold((rawModel) {
        var parsed = parse((rawModel));
        debugLog(debugTag, "Parse Successful");
        debugLog(debugTag, parsed);
        if (int.parse(rawModel.statusCode.toString()[0]) == 4) {
          try {
            _changeDataAndState(
                parsed,
                _lastestValidResult,
                _lastestValidResult == null
                    ? APIState.modelParseFailedWithoutOldData
                    : APIState.modelParseFailedWithOldData);
          } catch (e) {
            _changeDataAndState(
                null,
                _lastestValidResult,
                _lastestValidResult == null
                    ? APIState.modelParseFailedWithoutOldData
                    : APIState.modelParseFailedWithOldData);
          }
        } else {
          _changeDataAndState(parsed, parsed, APIState.success);
        }
      }, (err) {
        debugLog(debugTag, err!);
        if (err is SocketException || err is TimeoutException) {
//          print("ERRORRRRRRRRRRR: ${err.runtimeType}");
          _changeDataAndState(
              null,
              _lastestValidResult,
              _lastestValidResult == null
                  ? APIState.internetErrorWithoutOldData
                  : APIState.internetErrorWithOldData);
        } else {
          _changeDataAndState(
              null,
              _lastestValidResult,
              _lastestValidResult == null
                  ? APIState.modelParseFailedWithoutOldData
                  : APIState.modelParseFailedWithOldData);
        }

        throw err;
      });
    } catch (e) {
      if (e is SocketException || e is TimeoutException) {
//          print("ERRORRRRRRRRRRR: ${err.runtimeType}");
        _changeDataAndState(
            null,
            _lastestValidResult,
            _lastestValidResult == null
                ? APIState.internetErrorWithoutOldData
                : APIState.internetErrorWithOldData);
      } else {
        _changeDataAndState(
            null,
            _lastestValidResult,
            _lastestValidResult == null
                ? APIState.modelParseFailedWithoutOldData
                : APIState.modelParseFailedWithOldData);
      }
    }
  }
}
