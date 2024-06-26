import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/screen/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading= true;
  List items=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text("TODO List",style: TextStyle(color: Colors.white),)),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text("No item in Todo",style: TextStyle(fontSize: 20),),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index){
                final item= items[index] as Map;
                final id= item['_id'] as String;
                return Card(
                  color: Colors.black26,
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index+1}')),
                  title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                        onSelected: (value){
                            if(value == 'edit'){
                              //open edit page
                              NavigateToEditPage(item);
                            }
                            else if(value == 'delete'){
                              //delete and remove item
                              deleteById(id);
                            }
                        },
                        itemBuilder: (context)
                    {
                      return [
                        PopupMenuItem(
                            child: Text("Edit"),
                            value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: 'delete',
                        )
                              
                      ];
                    }),
                                ),
                );
            },),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: NavigateToAddPage,
          label:Text("Add Todo"),),

    );
  }
  Future <void> NavigateToEditPage(Map item) async{
    final route= MaterialPageRoute(builder: (context)=> AddTodoPage(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future <void> NavigateToAddPage() async{
    final route= MaterialPageRoute(builder: (context)=> AddTodoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future <void> deleteById(String id) async{
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if(response.statusCode == 200){
        final filtered = items.where((element) => element['_id'] != id).toList();
        setState(() {
          items=filtered;
        });
    }else{
      showErrorMessage("deletion failed");
    }
  }

  Future <void> fetchTodo() async{
    setState(() {
      isLoading = true;
    });
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode ==200){
      final json =jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });

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
