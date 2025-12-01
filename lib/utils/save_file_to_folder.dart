import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

    // Future<void> saveFileToUserSelectedLocation(BuildContext context, String filename, Uint8List fileBytes) async {
    //   try {
    //     final filePath = await FlutterFileDialog.saveFile(
    //       params: SaveFileDialogParams(
    //         fileName: filename,
    //         data: fileBytes,
    //         // mimeType: "application/octet-stream", // Adjust mimeType as needed
    //         // Optional: You can set a directory to start in
    //         // directory: await getApplicationDocumentsDirectory(),
    //       ),
    //     );

    //     if (filePath != null) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('File saved to: $filePath')),
    //       );
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('File save cancelled.')),
    //       );
    //     }
    //   } catch (e) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Error saving file: $e')),
    //     );
    //   }
    // }

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
    // Step 1 — Let the user pick any file
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

    // Step 3 — Copy the selected JSON file into the main location
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
