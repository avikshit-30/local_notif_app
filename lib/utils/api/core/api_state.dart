enum ErrorType {
  none,
  netError,
  modelParseError
}

enum APIState {
  initial(hasData: false, isOngoing: false, error: ErrorType.none),
  ongoingWithoutOldData(hasData: false, isOngoing: true, error: ErrorType.none),
  ongoingWithOldData(hasData: true, isOngoing: true, error: ErrorType.none),
  modelParseFailedWithoutOldData(hasData: false, isOngoing: false, error: ErrorType.modelParseError),
  modelParseFailedWithOldData(hasData: true, isOngoing: false, error: ErrorType.modelParseError),
  internetErrorWithoutOldData(hasData: false, isOngoing: false, error: ErrorType.netError),
  internetErrorWithOldData(hasData: true, isOngoing: false, error: ErrorType.netError),
  success(hasData: true, isOngoing: false, error: ErrorType.none);

  final ErrorType error;

  final bool hasData;
  bool get hasInternetError => error == ErrorType.netError;
  bool get hasError => error != ErrorType.none;
  final bool isOngoing;

  const APIState({required this.hasData, required this.isOngoing, required this.error});

  APIState convertToOngoing() {
    return hasData ? APIState.ongoingWithOldData : ongoingWithoutOldData;
    /*
    if (this == initial) {
      return APIState.ongoingWithoutOldData;
    } else if (isOngoing) {
      return this;
    } else if (this == APIState.failedWithOldData) {
      return APIState.ongoingWithOldData;
    } else if ()
    */
  }
}