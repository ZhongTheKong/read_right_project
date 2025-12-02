import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

Future<void> saveExistingJsonToUserLocation(
  BuildContext context,
  String sourcePath,
  String suggestedFileName,
) async {
  try {
    final filePath = await FlutterFileDialog.saveFile(
      params: SaveFileDialogParams(
        sourceFilePath: sourcePath,   // <— this copies the existing file
        fileName: suggestedFileName,  // <— suggested filename
      ),
    );

    if (filePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File saved to: $filePath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save canceled')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

Future<void> importJsonFile(BuildContext context, String destinationPath) async {
  try {
    // Let the user pick any file
    final pickedFilePath = await FlutterFileDialog.pickFile(
      params: const OpenFileDialogParams(
        dialogType: OpenFileDialogType.document,
      ),
    );

    if (pickedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file selected')),
      );
      return;
    }

    // Copy the selected JSON file into the main location
    final sourceFile = File(pickedFilePath);
    await sourceFile.copy(destinationPath);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('JSON file imported to: $destinationPath')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error importing file: $e')),
    );
  }
}
