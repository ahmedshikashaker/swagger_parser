import 'package:flutter/material.dart';
import 'package:swagger_parser/swagger_parser.dart';
import 'package:swagger_parser_pages/utils/file_utils.dart';

class ModuleCreationScreen extends StatefulWidget {
  const ModuleCreationScreen({super.key});

  @override
  State<ModuleCreationScreen> createState() => _ModuleCreationScreenState();
}

class _ModuleCreationScreenState extends State<ModuleCreationScreen> {
  final moduleGenerationController = TextEditingController();
  final featureGenerationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                _createModuleInput(),
                const SizedBox(width: 16,),
                SizedBox(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                    onPressed:  () async {
                            final module = await ModuleGenerator.generateModule(
                                moduleGenerationController.text,);
                            generateModuleArchive(module, moduleGenerationController.text);
                          },
                    child: const Text('Generate Module'),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                _createFeatureInput(),
                const SizedBox(width: 16,),
                SizedBox(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Generate Feature'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _createModuleInput() {
    return SizedBox(
      height: 76,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: moduleGenerationController,
          decoration: const InputDecoration(
              label: Text('Module Name'), contentPadding: EdgeInsets.all(10)),
        ),
      ),
    );
  }

  Widget _createFeatureInput() {
    return SizedBox(
      height: 76,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: featureGenerationController,
          decoration: const InputDecoration(
              label: Text('Feature Name'), contentPadding: EdgeInsets.all(10),),
        ),
      ),
    );
  }
}
