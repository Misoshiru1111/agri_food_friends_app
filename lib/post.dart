import 'dart:convert';
import 'dart:io';

import 'package:agri_food_freind/myData.dart';
import 'package:agri_food_freind/request/event/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' as editor;
// import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import 'request/event/event_list.dart';

// class Post extends StatelessWidget {
//   const Post({super.key, required this.userName});
// final String userName;
//   @override
//   Widget build(BuildContext context) {
//     return MyHomePage();
//   }
// }

class NotesBlockEmbed extends editor.CustomBlockEmbed {
  const NotesBlockEmbed(String value) : super(noteType, value);

  static const String noteType = 'notes';

  static NotesBlockEmbed fromDocument(editor.Document document) =>
      NotesBlockEmbed(jsonEncode(document.toDelta().toJson()));

  editor.Document get document => editor.Document.fromJson(jsonDecode(data));
}

class NotesEmbedBuilder implements editor.EmbedBuilder {
  NotesEmbedBuilder({required this.addEditNote});

  Future<void> Function(BuildContext context, {editor.Document? document})
      addEditNote;

  @override
  String get key => 'notes';

  @override
  Widget build(
    BuildContext context,
    editor.QuillController controller,
    editor.Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final notes = NotesBlockEmbed(node.value.data).document;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(
          notes.toPlainText().replaceAll('\n', ' '),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        leading: const Icon(Icons.notes),
        onTap: () => addEditNote(context, document: notes),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    // TODO: implement buildWidgetSpan
    throw UnimplementedError();
  }

  @override
  // TODO: implement expanded
  bool get expanded => throw UnimplementedError();

  @override
  String toPlainText(Embed node) {
    // TODO: implement toPlainText
    throw UnimplementedError();
  }
}

class Post extends StatelessWidget {
  Post({super.key, required this.userName});
  final String userName;
  editor.QuillController? _controller;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController titleC = TextEditingController();
  final EventRepo eventRepo = EventRepo();

  Future<String> _onImagePickCallback(File file) async {
    if (await Permission.photos.request().isGranted) {
      final appDocDir = await getApplicationDocumentsDirectory();
      final copiedFile =
          await file.copy('${appDocDir.path}/${basename(file.path)}');
      return copiedFile.path.toString();
    }
    return "";
  }

  Future<void> _addEditNote(BuildContext context,
      {editor.Document? document}) async {
    final isEditing = document != null;
    final quillEditorController = editor.QuillController(
      document: document ?? editor.Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.only(left: 16, top: 8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${isEditing ? 'Edit' : 'Add'} note'),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            )
          ],
        ),
        content: editor.QuillEditor.basic(),
      ),
    );

    if (quillEditorController.document.isEmpty()) return;

    final block = editor.BlockEmbed.custom(
      NotesBlockEmbed.fromDocument(quillEditorController.document),
    );
    final controller = _controller!;
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;

    if (isEditing) {
      final offset =
          editor.getEmbedNode(controller, controller.selection.start).offset;
      controller.replaceText(
          offset, 1, block, TextSelection.collapsed(offset: offset));
    } else {
      controller.replaceText(index, length, block, null);
    }
  }

  Widget build(BuildContext context) {
    _controller = editor.QuillController.basic();
    Widget quillEditor = editor.QuillEditor(
      // enableSelectionToolbar
      scrollController: ScrollController(),

      focusNode: FocusNode(),

      // placeholder: 'Add content',

      configurations: editor.QuillEditorConfigurations(
        autoFocus: true,
        expands: false,
        padding: EdgeInsets.zero,
        keyboardAppearance: Brightness.light,
        // controller: _controller!,
        readOnly: false,
        scrollable: true,
        enableSelectionToolbar: isMobile(),
        // embedBuilders: [
        //   ...FlutterQuillEmbeds.builders(),
        //   NotesEmbedBuilder(addEditNote: _addEditNote)
        // ],
      ),
    );
    var toolbar = editor.QuillToolbar();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('發文'),
        actions: [
          TextButton(
              onPressed: () {
                print("button post");
                print("title : " + titleC.text);
                String c = jsonEncode(_controller?.document.toDelta().toJson());
                print(c);
                eventRepo
                    .post(Event(
                  article_id: 0,
                  title: titleC.text,
                  content: c,
                  account: userName,
                  createTime: DateTime.now(),
                  msg: [],
                ))
                    .then((value) {
                  if (jsonDecode(value)['success'] == true) {
                    Navigator.pop(context);
                  }
                  print("need to print success");
                  print(jsonDecode(value)['success']);
                });
              },
              child: Text(
                "發布",
                style: TextStyle(color: Colors.white),
              ))
        ],
        backgroundColor: MyTheme.dartColor,
      ),
      body: Container(
        child: Column(children: [
          Row(
            children: [
              SizedBox(
                height: 30,
                width: MediaQuery.of(context).size.width - 50,
                child: TextField(
                  controller: titleC,
                  decoration: new InputDecoration.collapsed(hintText: '標題名稱'),
                ),
              )
            ],
          ),
          Text("文章內文"),
          Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          Container(child: toolbar)
        ]),
      ),
    );
  }
}
