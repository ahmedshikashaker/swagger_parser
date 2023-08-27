part of 'query_param_cubit.dart';

@freezed
class QueryParamState with _$QueryParamState {
  const factory QueryParamState.initial() = _Initial;
  const factory QueryParamState.addQuery(QueryParamValue queryParamValue) = _Addquery;
  const factory QueryParamState.removeQuery(QueryParamValue queryParamValue) = _RemoveQuery;
  const factory QueryParamState.removeAllQueries() = _RemoveAllQueries;


}
