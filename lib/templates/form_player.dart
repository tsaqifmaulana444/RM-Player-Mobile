import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPlayer extends StatefulWidget {
  final Map? player;
  const AddPlayer({
    super.key,
    this.player,
  });

  @override
  State<AddPlayer> createState() => _AddPlayerState();
}

class _AddPlayerState extends State<AddPlayer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController shirtNumberController = TextEditingController();
  TextEditingController previousClubController = TextEditingController();
  TextEditingController pictureController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final player = widget.player;
    if (player != null) {
      isEdit = true;
      final name = player["name"];
      final nationality = player["nationality"];
      final shirtNumber = player["shirt_number"];
      final previousClub = player["previous_club"];
      final picture = player["picture"];
      nameController.text = name;
      nationalityController.text = nationality;
      shirtNumberController.text = int.parse(shirtNumber.toString()).toString();
      previousClubController.text = previousClub;
      pictureController.text = picture;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(isEdit ? "Edit Player" : "Add Player")),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Player's Name"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: nationalityController,
            decoration: const InputDecoration(hintText: "Player's Nationality"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: shirtNumberController,
            decoration:
                const InputDecoration(hintText: "Player's Shirt Number"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: previousClubController,
            decoration:
                const InputDecoration(hintText: "Player's Previous Club"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: pictureController,
            decoration: const InputDecoration(hintText: "Player's Image"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(
              isEdit ? "Update" : "Submit"
            )
          )
        ],
      ),
    );
  }

    Future<void> updateData() async {
      // data form
      final name = nameController.text;
      final nationality = nationalityController.text;
      final shirtNumber = shirtNumberController.text;
      final previousClub = previousClubController.text;
      final picture = pictureController.text;
      final data = widget.player;
      final playerId = data?["_id"];
      final body = {
        "name": name,
        "nationality": nationality,
        "shirt_number": shirtNumber,
        "previous_club": previousClub,
        "picture": picture,
      };

      // update data
      final url = "http://127.0.0.1:8000/player/$playerId";
      final uri = Uri.parse(url);
      final response = await http.put(uri,
          body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

      // show message
      if (response.statusCode == 200) {
        nameController.text = "";
        nationalityController.text = "";
        shirtNumberController.text = "";
        previousClubController.text = "";
        pictureController.text = "";
        showSuccessMessage("Data Successfully Update");
      } else {
        showErrorMessage("Failed To Update");
      }
    }


    Future<void> submitData() async {
    // data form
    final name = nameController.text;
    final nationality = nationalityController.text;
    final shirtNumber = shirtNumberController.text;
    final previousClub = previousClubController.text;
    final picture = pictureController.text;
    final body = {
      "name": name,
      "nationality": nationality,
      "shirt_number": shirtNumber,
      "previous_club": previousClub,
      "picture": picture,
    };

    // post data
    const url = "http://127.0.0.1:8000/player";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    // show message
    if (response.statusCode == 201) {
      nameController.text = "";
      nationalityController.text = "";
      shirtNumberController.text = "";
      previousClubController.text = "";
      pictureController.text = "";
      showSuccessMessage("Data Successfully Created");
    } else {
      showErrorMessage("Failed To Post");
    }
  }

  void showSuccessMessage(String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String msg) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
