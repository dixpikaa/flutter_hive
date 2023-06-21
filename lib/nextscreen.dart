import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/create.dart';

import 'model.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late Box dataBox;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dataBox = Hive.box<Data>('data_box');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add your Todo",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ShowData()));
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  "My Drawer",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                )),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("Search Todos"),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("My Profile"),
              onTap: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable: dataBox.listenable(),
                builder: (context, box, _) {
                  var todos = box.values.toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];

                      _titleController.text = todo.title;
                      _descriptionController.text = todo.description;

                      return Card(
                          margin: EdgeInsets.all(10),
                          child: ExpansionTile(
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            subtitle: Text(todo.description),
                            leading: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          title:
                                              Center(child: Text('Edit Todos')),
                                          content: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: Form(
                                              key: _formKey,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    TextFormField(
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter title';
                                                        }
                                                        return null;
                                                      },
                                                      controller:
                                                          _titleController,
                                                      decoration:
                                                          InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    TextFormField(
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter description';
                                                        }
                                                        return null;
                                                      },
                                                      maxLines: 5,
                                                      controller:
                                                          _descriptionController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "description",
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () => {
                                                    if (_formKey.currentState!
                                                        .validate())
                                                      {
                                                        _formKey.currentState!
                                                            .save(),
                                                        editTodo(
                                                            todo,
                                                            _titleController
                                                                .text,
                                                            _descriptionController
                                                                .text),
                                                        Navigator.of(context)
                                                            .pop()
                                                      }
                                                  },
                                                ),
                                                TextButton(
                                                    child: Text('cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    })
                                              ],
                                            )
                                          ]);
                                    });
                              },
                              icon: Icon(Icons.edit),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Icon(
                                        Icons.error,
                                        color: Colors.red.shade600,
                                      ),
                                      content: Text(
                                          'Are you sure you want to delete this item???'),
                                      actions: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("cancel")),
                                              TextButton(
                                                  child: Text(
                                                    'delete anyway',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () => {
                                                        deleteTodo(todo),
                                                        Navigator.of(context)
                                                            .pop()
                                                      }),
                                            ]),
                                      ],
                                    );
                                  },
                                );
                              },

                              //=> deleteTodo(todo),
                              icon: Icon(Icons.delete),
                            ),
                          ));
                    },
                  );
                }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          )
        ],
      ),
    );
  }

  void deleteTodo(Data todo) {
    todo.delete();
  }

  Future<void> editTodo(Data todo, String title, String description) async {
    todo.title = title;
    todo.description = description;
    todo.save();
  }
}
