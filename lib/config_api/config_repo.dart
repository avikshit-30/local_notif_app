import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/api/core/http_method.dart';
import '../utils/api/implementation/riverpod_api/riverpod_api.dart';
import '../utils/factory_utils.dart';
import '../utils/urls.dart';
import 'config_model.dart';
import 'config_params.dart';

part 'config_repo.g.dart';

@Riverpod(keepAlive: true)
RiverpodAPI<List<ConfigModel>, ConfigParams> configRepo(ConfigRepoRef ref) {
  return RiverpodAPI<List<ConfigModel>, ConfigParams>(
    completeUrl: URLs.complete(""),
    factory: FactoryUtils.listFromString(ConfigModel.fromJson),
    params: ConfigParams(),
    method: HTTPMethod.get,
    ref: ref,
  );
}
