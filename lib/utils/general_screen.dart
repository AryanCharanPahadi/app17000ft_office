import 'package:flutter/material.dart';

class ExceptionClass extends StatefulWidget {
  String? message;
  String? assetsUrl;
  String? buttonText;

   ExceptionClass({this.message, this.assetsUrl,this.buttonText,super.key});
  

  @override
  State<ExceptionClass> createState() => _ExceptionClassState();
}

class _ExceptionClassState extends State<ExceptionClass> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Center(child: Image.asset(widget.assetsUrl!)),
             const Text('Oops!!',style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),),

             Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Text(widget.message!,style: const TextStyle(color: Colors.grey,fontSize: 25,fontWeight: FontWeight.bold),),
            ),
          ElevatedButton(onPressed: (){
            
          }, child:  Text(widget.buttonText!)),

        ],
      ),
    );
  }
}