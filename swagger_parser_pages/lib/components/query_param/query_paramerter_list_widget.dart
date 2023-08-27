import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swagger_parser_pages/components/query_param/cubit/query_param_cubit.dart';
import 'package:swagger_parser_pages/components/query_param/query_param_item_widget.dart';

class QueryParameterListWidget extends StatefulWidget {
  const QueryParameterListWidget({super.key});

  @override
  State<QueryParameterListWidget> createState() => _QueryParameterListWidgetState();
}

class _QueryParameterListWidgetState extends State<QueryParameterListWidget> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<QueryParamCubit>();
    return Column(
      children: cubit.querys
          .map((e) => QueryParamItem(
                value: e,
              ))
          .toList(),
    );
  }
}
