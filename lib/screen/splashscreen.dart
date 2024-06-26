import 'package:flutter/material.dart';
import 'package:todo_app/screen/add_page.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  _navigatetohome(BuildContext context)async {
    await Future.delayed(Duration(milliseconds: 3000),(){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const AddTodoPage()));
  }

  @override
  Widget build(BuildContext context) {
    _navigatetohome(context);
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/splashlogo.jpg"),
      ),
    );
  }
}
