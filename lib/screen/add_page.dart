import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    final todo = widget.todo;
    super.initState();
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text =  title;
      descriptionController.text = description;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit? "Edit Todo":"Add Todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Title'
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Description',

            ),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: isEdit? updateData : submitData,
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.greenAccent)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(isEdit? "Update" : "Submit",style: TextStyle(color: Colors.black,fontSize: 16),),
              ))
        ],
      ),
    );
  }
  Future <void> updateData() async{
    final todo = widget.todo;
    if(todo ==null){
      print("you can not call updated without todo data");
      return;
    }
    final id =todo['_id'];
    final title= titleController.text;
    final description= descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    // submit update data to the server
    final url ="https://api.nstack.in/v1/todos/$id";

    final uri=Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},

    );

    if(response.statusCode==200){
      showSuccessMessage("Updation success");
    }else{
      showErrorMessage("Updation failed");
    }
  }
  Future <void> submitData() async{
      // get the data from form
      final title= titleController.text;
      final description= descriptionController.text;
      final body = {
        "title": title,
        "description": description,
        "is_completed": false,
      };
      //submit data to the server
      final url ="https://api.nstack.in/v1/todos";
      final uri=Uri.parse(url);
      final response = await http.post(
          uri,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'},

      );

      //show success message
    
      if(response.statusCode==201){
        titleController.text="";
        descriptionController.text="";
        print("Success");
        showSuccessMessage("creation success");
      }else{
        print("Creation failed");
        showErrorMessage("failed creation");
        print(response.body);
      }
  }

  void showSuccessMessage(String message){
    final snackBar=SnackBar(content: Text(message,style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message){
    final snackBar=SnackBar(content: Text(message,style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
