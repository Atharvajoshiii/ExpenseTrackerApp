import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracker/screens/secondpage.dart';
import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  final String title;
  AddExpenseScreen({super.key,required this.title});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final postcontroller = TextEditingController();
  final moneycontroller = TextEditingController();
CollectionReference<Map<String, dynamic>>? firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance.collection(widget.title);
  }
  // database me ek table crete ho jayega post naam ka , yaha pe firebase database ka ek instance create kiya hai jo vo table to reference karega
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      title: Text(" Add expense for ${widget.title}"),
    ),
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SizedBox(height: 30,),
          TextFormField(
            controller: postcontroller,
            decoration: InputDecoration(
              hintText: "Add Expense Discription",
              
              border: OutlineInputBorder(

              )
            ),
            
          ),
          SizedBox(height: 30,),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: moneycontroller,
            decoration: InputDecoration(
              hintText: "Add Money",
              
              border: OutlineInputBorder(

              )
            ),
            
          ),
          SizedBox(height: 30,),
          ElevatedButton(onPressed: (){
            String id = DateTime.now().millisecondsSinceEpoch.toString();
            DateTime now = DateTime.now();

            String formattedDate = "${now.day}-${now.month}-${now.year}";
            String formattedTime = "${now.hour}:${now.minute}";
            firestore?.doc(id).set({
              'title':postcontroller.text.toString(),
              'money':moneycontroller.text.toString(),
              'date':formattedDate,
              'time':formattedTime,

              'id':id

            }).then((value){
              setState(() {
              //loading=false;
            });
            Navigator.pop(context);


            }).onError((error, stackTrace){
              //Utils().toastMessege(error.toString());
            });

          }, child: Text("ADD EXPENSE"))
          
            

            
          
        ],
      ),
    ),
    );
    
  }
}