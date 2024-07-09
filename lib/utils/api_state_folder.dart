import 'package:flutter/material.dart';
import 'package:local_notif_app/utils/api/core/api_state_holder.dart';

import '../constants/textstyles.dart';
import 'api/core/api_state.dart';

class ApiStateFolder extends StatelessWidget {
  final List<ApiStateHolder> repos;
//  final loclTillAllComplete;
  final void Function()? onRefresh;
  final Widget Function() buildLoaded;
  final Widget Function()? buildLoading;
  final Widget Function()? buildError;
  final bool showOldDataOnError;
  final bool showInitialAsLoaded;
  final bool skiploading;
  final bool showOldDataWhileLoading;
  final bool defaultErrorStateIsBouncy;

  const ApiStateFolder(
      {required this.repos,
      required this.buildLoaded,
      this.buildError,
      this.buildLoading,
      this.showOldDataOnError = false,
      this.showInitialAsLoaded = false,
      this.showOldDataWhileLoading = false,
      this.skiploading = false,
      this.defaultErrorStateIsBouncy = true,
      this.onRefresh,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (onRefresh == null) {
      return buildInternal(context);
    }
    return buildInternal(context);
  }

  Widget _buildErrorInternal() {
    if (buildError == null) {
      return defaultErrorStateIsBouncy
          ? Center(
              child: Text(
                'Some error occured.\nPlease refresh/try again \nlater.',
                style: w400.size14.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            )
          : Center(
              child: Text(
              'Some error occured. Please refresh/try again later.',
              style: w400.size14.copyWith(color: Colors.red),
            ));
    }
    return buildError!();
  }

  Widget buildInternal(BuildContext context) {
    bool failed = false;
    bool loading = false;
    bool initial = false;

    for (int i = 0; i < repos.length; i++) {
      if (repos[i]
              .state
              .hasError /* &&
          (!showOldDataOnError || !repos[i].state.hasData)*/
          ) {
        failed = true;
      } else if (repos[i].state.isOngoing) {
        loading = true;
      } else if (repos[i].state == APIState.initial) {
        initial = true;
      }
    }

    if (failed && !showOldDataOnError) {
      return _buildErrorInternal();
    } else if (((loading && !showOldDataWhileLoading) ||
        (initial && !showInitialAsLoaded))) {
      if (skiploading) {
        return buildLoaded();
      } else {
        return buildLoading == null
            ? const Center(
                child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                    )),
              )
            : buildLoading!();
      }
    } else {
      return buildLoaded();
    }
  }
}
