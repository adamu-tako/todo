import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/addtodo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String uid = '';

  @override
  void initState() {
    super.initState();
    getuid();
  }

  getuid() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            const Text("Todo"),
            const Text(
              "List",
              style: TextStyle(color: Colors.grey),
            ),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () => FirebaseAuth.instance.signOut(),
              child: const Icon(Icons.exit_to_app),
            )
          ],
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .doc(uid)
                .collection('userTasks')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No tasks found',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Add a new task or todo to continue',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          snapshot.data!.docs[index]['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black87),
                        ),
                        subtitle: Text(
                          snapshot.data!.docs[index]['description'],
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                        trailing: IconButton(
                          onPressed: () => FirebaseFirestore.instance
                              .collection('tasks')
                              .doc(uid)
                              .collection('userTasks')
                              .doc(snapshot.data!.docs[index].id)
                              .delete(),
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 50,
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodo()),
          ),
          backgroundColor: Colors.greenAccent,
          tooltip: 'Add Todo',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.add),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text('Add Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
