import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracker/screens/add_expensescreen.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  final String title;
  SecondPage({Key? key, required this.title}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  CollectionReference<Map<String, dynamic>>? collectionRef;

  @override
  void initState() {
    super.initState();
    collectionRef = FirebaseFirestore.instance.collection(widget.title);
  }

  Future<void> deleteExpenseDocument(String docId) async {
    await collectionRef?.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    num count = 0;
    DateTime now = DateTime.now();

    String formattedDate = "${now.day}-${now.month}-${now.year}";
    String formattedTime = "${now.hour}:${now.minute}";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), // Displaying the title in the app bar
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(title: widget.title),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: collectionRef?.snapshots() ?? Stream.empty(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final data = snapshot.data?.docs ?? [];
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      count = count + num.parse(snapshot.data!.docs[index]['money']);
                      final document = data[index];
                      return Dismissible(
                        key: Key(document.id),
                        onDismissed: (direction) {
                          deleteExpenseDocument(document.id);
                        },
                        background: Container(
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                snapshot.data!.docs[index]['title'].toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Amount: \$${snapshot.data!.docs[index]['money'].toString()}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    snapshot.data!.docs[index]['date'].toString(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    snapshot.data!.docs[index]['time'].toString(),
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     'Total Count: ${count.toString()}',
          //     style: TextStyle(
          //       fontSize: 20.0,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
