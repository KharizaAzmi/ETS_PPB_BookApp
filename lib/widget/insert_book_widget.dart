import 'package:flutter/material.dart';
import 'package:bookshelf/model/book.dart';

class InsertBookWidget extends StatefulWidget {
  final Book? book;
  final ValueChanged<String> onSubmit;

  const InsertBookWidget({Key? key, this.book, required this.onSubmit}) : super(key: key);

  @override
  State<InsertBookWidget> createState() => _InsertBookWidgetState();
}

class _InsertBookWidgetState extends State<InsertBookWidget> {
  final titlecontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titlecontroller.text = widget.book?.title ?? '';
    descriptioncontroller.text = widget.book?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;
    return Column(
      children: [
        AlertDialog(
          title: Text(isEditing ? 'Edit book' : 'Add book'),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  controller: titlecontroller,
                  decoration: const InputDecoration(hintText: 'Title'),
                  validator: (value) => value != null && value.isEmpty ? 'Title is required' : null,
                ),
                TextFormField(
                  autofocus: true,
                  controller: descriptioncontroller,
                  decoration: const InputDecoration(hintText: 'Deskripsi'),
                  validator: (value) => value != null && value.isEmpty ? 'Isi deskripsi' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()){
                  widget.onSubmit(titlecontroller.text);
                }
              },
              child: const Text('OK'),
            )
          ],
        ),
      ],
    );
  }
}
