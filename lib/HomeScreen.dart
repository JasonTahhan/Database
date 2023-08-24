import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'UserInfo.dart';
import 'database.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserInfo> users = [];

  void _showAddUserDialog() {
    String firstName = '';
    String lastName = '';
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'First Name'),
                onChanged: (value) {
                  firstName = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onChanged: (value) {
                  lastName = value;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((selectedDateTime) {
                    setState(() {
                      selectedDate = selectedDateTime;
                    });
                  });
                },
                child: Text('Select Date'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (firstName.length >= 2 &&
                    lastName.length >= 2 &&
                    selectedDate != null) {
                  String userId = Uuid().v4();
                  UserInfo newUser = UserInfo(
                    userId: userId,
                    firstName: firstName,
                    lastName: lastName,
                    dateOfBirth: selectedDate!,
                  );

                  DataBase.instance.insertUser(newUser); 

                  setState(() {
                    users.add(newUser);
                  });

                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Validation Error'),
                        content: Text('Please fill in all fields correctly.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    List<UserInfo> loadedUsers = await DataBase.instance.getAllUsers();
    setState(() {
      users = loadedUsers;
    });
  }

  Future<void> deleteUser(String userId) async {
    await DataBase.instance.deleteUser(userId);

    setState(() {
      users.removeWhere((user) => user.userId == userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Login'),
        titleTextStyle: TextStyle(fontSize: 30),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          String avatarText =
              '${users[index].firstName[0]}${users[index].lastName[0]}'
                  .toUpperCase();

          final DateFormat formatter = DateFormat('MMM dd, yyyy');
          final String formattedDate =
              formatter.format(users[index].dateOfBirth);

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  avatarText,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.blue,
              ),
              title: Text('${users[index].firstName} ${users[index].lastName}'),
              subtitle: Text(
                'DOB: $formattedDate',
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  deleteUser(users[index].userId); 
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
