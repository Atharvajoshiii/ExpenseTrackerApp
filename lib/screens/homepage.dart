import 'package:expensetracker/screens/secondpage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/widgets/creditcard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final expenselist = ["Food", "Shopping", "Home", "Bank", "Travelling"];

  TextEditingController _textFieldController = TextEditingController();
  late DatabaseReference databaseRef;

  @override
  void initState() {
    super.initState();
    databaseRef = FirebaseDatabase.instance.ref('expenses');
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Enter expense'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_textFieldController.text.isNotEmpty) {
                  String id = DateTime.now().millisecondsSinceEpoch.toString();

                  databaseRef.child(id).set({
                    'title': _textFieldController.text.toString(),
                    'id': id,
                  }).then((_) {
                    Navigator.pop(context);
                    _textFieldController.clear();
                  }).catchError((error) {
                    print("Failed to add expense: $error");
                  });
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GradientCreditCard(
              onTopRightButtonClicked: () {},
              cardIcon: Icon(Icons.add),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade900],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Expenses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _showDialog,
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: Text("Loading"),
                query: databaseRef,
                itemBuilder: (context, snapshot, animation, index) {
                  final title=snapshot.child('title').value.toString();
                  final id = snapshot.key.toString();

                  return Dismissible(
                    key: Key(id),
                    onDismissed: (_) {
                      databaseRef.child(id).remove();
                    },
                    child: Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          title,
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Implement what you want on tile tap
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>SecondPage(title: title)));
                        },
                      ),
                    ),
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
