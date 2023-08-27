import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swagger_parser_pages/components/query_param/cubit/query_param_cubit.dart';
import 'package:swagger_parser_pages/components/query_param/query_param_value.dart';

class QueryParamItem extends StatefulWidget {
  const QueryParamItem({required this.value, super.key});

  final QueryParamValue value;

  @override
  State<QueryParamItem> createState() => _QueryParamItemState();
}

class _QueryParamItemState extends State<QueryParamItem> {
  final queryController = TextEditingController();

  @override
  void initState() {
    queryController.text = widget.value.queryName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QueryParamCubit>();
    return Row(
      children: [
        _createQueryInput(),
        const SizedBox(
          width: 16,
        ),
        SizedBox(
          height: 40,
          width: 150,
          child: ElevatedButton(
            onPressed: () async {
              cubit.removeQuery(widget.value);
            },
            child: const Text('remove'),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
      ],
    );
  }

  Widget _createQueryInput() {
    return SizedBox(
      height: 76,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: queryController,
          onChanged: (text) {
            widget.value.queryName = queryController.text;
          },
          decoration: InputDecoration(
            filled: true,
            label: Text(widget.value.fieldName),
            contentPadding: const EdgeInsets.all(10),
          ),
        ),
      ),
    );
  }
}
