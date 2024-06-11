import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/input.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/common/main_title.dart';
import 'package:mds_flutter_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final TextEditingController _searchController = TextEditingController();
  int? _myId;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() => _myId = prefs.getInt("id"));
    });
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<User> _getSortedUsers(List<User> users) {
    // Return a given list of users with main user on top
    if (_myId == null) return users;

    // Try to find current user and put it to the top of the list
    for (int i = 0; i < users.length; i++) {
      if (users[i].id! == _myId) {
        users.insert(0, users.removeAt(i));
        break;
      }
    }
    return users;
  }

  List<User> _getFilteredUsers(List<User> users) {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return _getSortedUsers(users);
    } else {
      List<User> userList = users.where((user) {
        return user.username.toLowerCase().contains(query) || user.email.toLowerCase().contains(query) || user.firstname.toLowerCase().contains(query) || user.lastname.toLowerCase().contains(query);
      }).toList();
      return _getSortedUsers(userList);
    }
  }

  Card _displayUserCard(User user) {
    return Card(
      color: lightGrey,
      elevation: 0,
      child: ListTile(
          leading: const Icon(
            Icons.person,
            size: 40,
            color: primaryColor,
          ),
          title: Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(user.email),
          onTap: () {
            Navigator.pushNamed(arguments: user.id, context, '/users/:id');
          }),
    );
  }

  FutureBuilder _displayUserList() {
    return FutureBuilder<List<User>>(
      future: User.getUsers(),
      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If an error occured while fetching users:
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Erreur lors du chargement des utilisateurs",
                textAlign: TextAlign.center,
              ),
            );
          }

          // There is some data to show:
          if (snapshot.hasData) {
            List<User> filteredUsers = _getFilteredUsers(snapshot.data!);

            // Users list is empty:
            if (filteredUsers.isEmpty) {
              return const Center(
                child: Text("Aucun utilisateur"),
              );
            }

            // Users list is not empty:
            return ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return _displayUserCard(filteredUsers[index]);
              },
            );
          }
        }

        // Still no data to show, waiting for getUsers function to end:
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainTitle(text: "Utilisateurs"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Input(controller: _searchController, hintText: "search", isPassword: false),
          const SizedBox(height: 16),
          Expanded(child: _displayUserList()),
        ]),
      ),
    );
  }
}
