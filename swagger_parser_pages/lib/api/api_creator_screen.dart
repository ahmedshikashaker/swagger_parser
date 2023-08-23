import 'dart:math' as math;

import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:highlight/languages/json.dart';
import 'package:swagger_parser/swagger_parser.dart';

import 'package:swagger_parser_pages/api/api_generator_output.dart';
import 'package:swagger_parser_pages/components/code_editor_widget.dart';

// ignore: must_be_immutable
class APICreatorScreen extends StatefulWidget {

  const APICreatorScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<APICreatorScreen> {
  final TextEditingController _modelTextEditingController =
      TextEditingController();
  final TextEditingController _endpointTextEditingController =
      TextEditingController();

  final CodeController _requestController = CodeController(
    language: json,
  );
  final CodeController _responseController = CodeController(
    language: json,
  );
  final    GroupButtonController? buttonsController = GroupButtonController();

  ApiGeneratorOutput? apiGeneratorOutput;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(),);
  }

  Widget _buildBody() {
    return ListView(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _createMethodSelector(),
            Row(
              children: [_createModelNameInput(), _createEndPointInput()],
            ),
            CodeEditorWidget(
                title: 'Request body:',
                codeController: _requestController),
            CodeEditorWidget(
                title: 'Response:',
                codeController: _responseController),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_modelTextEditingController.text.isNotEmpty &&
                          _endpointTextEditingController.text.isNotEmpty) {
                        APIGenerator()
                            .generateAPICall(
                          modelName: _modelTextEditingController.text,
                          request: _requestController.text,
                          response: _responseController.text,
                          apiMethod: APIMethodType.values[buttonsController?.selectedIndex??1],
                          serviceName: _endpointTextEditingController.text,
                        ).then((value) async {
                              setState(() {
                                apiGeneratorOutput = value;
                              });
                        }).onError((error, stackTrace) {
                          //TODO error
                        });
                      } else {
                        //TODO error
                      }
                    },
                    child: const Text('Generate'),
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        APIGeneratorOutputScreen(apiGeneratorOutput: apiGeneratorOutput,key: Key(math.Random().nextInt(3344555).toString()),),
      ],
    );
  }

  Column _createMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Select Method:'),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GroupButton(
                  maxSelected: 1,
                  controller: buttonsController,
                  options: const GroupButtonOptions(
                    alignment: Alignment.center,
                    textPadding: EdgeInsets.all(10),
                    buttonHeight: 40,
                    selectedBorderColor: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  buttons: APIMethodType.values
                      .toList()
                      .map((e) => e.getName())
                      .toList()),
            ),
          ],
        )
      ],
    );
  }

  Widget _createModelNameInput() {
    return SizedBox(
      height: 76,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _modelTextEditingController,
          autofocus: false,
          decoration: const InputDecoration(
              label: Text('Service name'),
              contentPadding: EdgeInsets.all(10)),
        ),
      ),
    );
  }

  Widget _createEndPointInput() {
    return SizedBox(
      height: 76,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: _endpointTextEditingController,
          autofocus: false,
          decoration: const InputDecoration(
              label: Text('API Endpoint'), contentPadding: EdgeInsets.all(10)),
        ),
      ),
    );
  }

}
