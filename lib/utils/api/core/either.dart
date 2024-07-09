class Either<L, R> {
  L? left;
  R? right;

  Either({this.left, this.right}) {
    if (left == null && right == null) {
      throw ArgumentError("Both left & right cannot be present");
    } else if (left != null && right != null) {
      throw ArgumentError("Both left & right cannot be null");
    }
  }

  void fold (void Function(L) leftHandler, void Function(R) rightHandler) {
    if (left != null) {
      leftHandler(left as L);
    }
    if (right != null) {
      rightHandler(right as R);
    }
  }


  R throwLasError() {
    if (left != null) {
      throw Exception(left.toString());
    }
    return right!;
  }

  L throwRasError() {
    if (right != null) {
      throw Exception(right.toString());
    }
    return left!;
  }
}

extension EitherFutureExtension<T> on Future<T> {
  Future<Either<T, Object?>> toEither() async {
    try {
      var result = await this;
      return Either(left: result);
    } catch (e) {
      return Either(right: e);
    }
  }
}