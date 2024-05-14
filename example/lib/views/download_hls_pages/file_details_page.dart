import 'dart:io';

import 'package:download_manager/download_manager.dart';
import 'package:flutter/material.dart';

class FileDetailsPage extends StatefulWidget {
  const FileDetailsPage({super.key, required this.file});
  final File file;

  @override
  State<FileDetailsPage> createState() => _FileDetailsPageState();
}

class _FileDetailsPageState extends State<FileDetailsPage> {
  final List<String> fileContent = [];
  bool hasError = false;

  @override
  void initState() {
    widget.file.readAsLines().then(
      (value) {
        setState(() {
          fileContent.addAll(value);
        });
      },
    ).catchError(
      (error, stackTrace) {
        setState(() {
          hasError = true;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.file.fileName;
    final fileExtension = widget.file.fileExtension;
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            fileName,
          ),
          actions: [
            if (fileExtension == "m3u8")
              IconButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => VideoPage(videoFile: widget.file),
                  //   ),
                  // );
                },
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.green.shade700,
                ),
              )
          ],
        ),
        body: (fileExtension == 'jpg' ||
                fileExtension == 'png' ||
                fileExtension == 'jpeg')
            ? Image.file(
                widget.file,
                width: double.infinity,
                height: double.infinity,
              )
            : hasError
                ? const Center(
                    child: Text(
                      "Error when trying to read this file",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        fileContent.length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              fileContent[index],
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}
