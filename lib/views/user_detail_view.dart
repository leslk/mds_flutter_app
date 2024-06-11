import 'package:flutter/material.dart';
import 'package:mds_flutter_app/common/button.dart';
import 'package:mds_flutter_app/common/input.dart';
import 'package:mds_flutter_app/main.dart';
import 'package:mds_flutter_app/models/user.dart';
import 'package:mds_flutter_app/services/utils.dart';

/// The view for the user detail page
/// The user can see his own profile and edit his informations
class UserDetailView extends StatefulWidget {
  const UserDetailView({super.key});

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  User? _user;
  int? _myId;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  /// Get the user object from the API
  Future<User> _getUser(int userId) async {
    User user = await User.getUser(userId);
    return user;
  }

  /// Update the user object with the new values
  Future<void> _updateUser() async {
    try {
      User updatedUser = await User.updateUser(_user!.id!, {
        "username": _userNameController.text,
        "firstname": _firstNameController.text,
        "lastname": _lastNameController.text,
        "email": _emailController.text,
      });
      // Update the user object and display a success message
      setState(() => _user = updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Informations modifiées avec succès", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      // Display an error message if the update failed
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Erreur lors de la modification des informations", style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
        backgroundColor: Colors.red,
      ));
    }
  }

  /// Display the user header with the user icon
  Widget _displayUserHeader() {
    return Container(
        color: primaryColor,
        width: double.infinity,
        height: 200,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Positioned(
              bottom: -40,
              child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: darkerGrey,
                        blurRadius: 10,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.person, size: 100, color: primaryColor),
                  )),
            ),
          ],
        ));
  }

  Column _displayEditionInputFields() {
    // Display all input fields as a column
    return Column(
      children: [
        Input(
          controller: _userNameController,
          hintText: "Nom d'utilisateur",
          isPassword: false,
        ),
        const SizedBox(height: 16),
        Input(
          controller: _emailController,
          hintText: "Email",
          isPassword: false,
        ),
        const SizedBox(height: 16),
        Input(
          controller: _firstNameController,
          hintText: "Prénom",
          isPassword: false,
        ),
        const SizedBox(height: 16),
        Input(
          controller: _lastNameController,
          hintText: "Nom",
          isPassword: false,
        ),
        const SizedBox(height: 16),
        Button(
            onPressed: () async {
              Navigator.pop(context);
              await _updateUser();
            },
            text: "Modifier les informations")
      ],
    );
  }

  Dialog _displayProfileEditionDialog() {
    // Return the content of the bottom sheet modal when editing the user profile
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      alignment: Alignment.bottomCenter,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(width: double.infinity, color: Colors.white, child: _displayEditionInputFields()),
        ),
      ),
    );
  }

  Widget _displayEditInfoButton() {
    // Return the pen button that allows the user to edit his own profile
    return IconButton(
      icon: const Icon(Icons.edit, color: primaryColor),
      onPressed: () async {
        // show dialod with full width in the bottom of the screen
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return _displayProfileEditionDialog();
          },
        );
      },
    );
  }

  Widget _displayUserInfo(userId) {
    // Display the second part of the screen containing user info
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: lightGrey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Display edit button only if main user is on his own profile
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [userId != _myId! ? const SizedBox() : _displayEditInfoButton()]),

                    // Display user info
                    Row(children: [const Text("Nom: ", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)), Text(_user!.lastname)]),
                    Row(children: [const Text("Prénom: ", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)), Text(_user!.firstname)]),
                    Row(children: [const Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)), Text(_user!.email)]),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _displayUserDetail(int userId) {
    // Return the main layout of the screen divided in two parts
    return Column(
      children: <Widget>[
        Expanded(flex: 1, child: _displayUserHeader()),
        const SizedBox(height: 60),
        Expanded(flex: 3, child: _displayUserInfo(userId)),
      ],
    );
  }

  Future<void> _loadUser(int userId) async {
    // Load the user object that will be displayed on this view
    _myId = await Token.getId();
    User user = await _getUser(userId);

    _emailController.text = user.email;
    _userNameController.text = user.username;
    _firstNameController.text = user.firstname;
    _lastNameController.text = user.lastname;

    setState(() => _user = user);
  }

  /// Get the user object from the API & display the user picture and info
  @override
  Widget build(BuildContext context) {
    final int userId = ModalRoute.of(context)!.settings.arguments as int;
    if (_user == null) {
      _loadUser(userId);
    }

    return Scaffold(
        appBar: AppBar(
            title: Text(_user != null ? '${_user!.firstname} ${_user!.lastname}' : "", style: const TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.white,
            )),
        body: Center(
          child: _user == null ? const CircularProgressIndicator() : _displayUserDetail(userId),
        ));
  }
}
