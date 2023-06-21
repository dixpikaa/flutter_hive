import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'model.dart';

class ShowData extends StatefulWidget {

  @override
  State<ShowData> createState() => _ShowDataState();
}


class _ShowDataState extends State<ShowData> {
  // late Box dataBox;
final TextEditingController _titleController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(

      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter title';
                }
                return null;
              },
              controller: _titleController,
              decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              maxLines: 5,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Description';
                }
        
                return null;
              },
              controller: _descriptionController,
              decoration: InputDecoration(
                  hintText: "discription",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                ElevatedButton(
                  onPressed: () async {
                     if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                 addTodo(_titleController.text, _descriptionController.text);
                                     Navigator.of(context).pop();}
              
                 
                  },
                  child: const Text(
                    "Submit",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }

// Add data to the hive box
  Future<bool> addTodo(String title, String description) async {
    final todo = Data()
      ..title = title
      ..description = description;
    // final box = Boxes.getTodo();
    try {
      final box = Hive.box<Data>('data_box');
      box.add(todo);
      return true;
    } catch (ex) {
      print("Hive add error: ${ex.toString()}");
      return false;
    }
  }


}
