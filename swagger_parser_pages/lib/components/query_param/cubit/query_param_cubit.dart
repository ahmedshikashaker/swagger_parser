import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:swagger_parser_pages/components/query_param/query_param_value.dart';

part 'query_param_state.dart';

part 'query_param_cubit.freezed.dart';

class QueryParamCubit extends Cubit<QueryParamState> {
  QueryParamCubit() : super(const QueryParamState.initial());

  final List<QueryParamValue> querys = [];

  void addQuery(QueryParamValue query) {
    querys.add(query);
    emit(QueryParamState.addQuery(query));
  }

  void removeQuery(QueryParamValue query) {
    querys.remove(query);
    emit(QueryParamState.removeQuery(query));
  }

  void removeAllQueries() {
    querys.clear();
    emit(const QueryParamState.removeAllQueries());
  }

  List<String> get nonEmptyQueryParam => querys
      .where((element) => element.queryName != null)
      .map((e) => e.queryName!)
      .toList();
}
