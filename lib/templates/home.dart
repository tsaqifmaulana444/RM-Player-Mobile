import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rm_crud/templates/form_player.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> datas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
                "List Of Real Madrid Players & Ex-players",
                style: TextStyle(fontSize: 16)
            )
        ),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: Visibility(
            visible: datas.isNotEmpty,
            replacement: const Center(
              child: Text("No Data")
            ),
            child: ListView.builder(
              itemCount: datas.length,
              itemBuilder: (context, index) {
                final player = datas[index];
                final playerId = player['_id'] as String;
                return ListTile(
                    title: Text(player['name']),
                    subtitle: Text(player['nationality']),
                    leading: player['picture'] == ""
                        ? const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://i.pinimg.com/736x/fa/4f/0d/fa4f0db883d36fbfcfe76c06d9012be0.jpg"),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(player['picture']),
                          ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "delete") {
                          deleteById(playerId);
                        } else if (value == "edit") {
                          navigateToEditPage(player);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: "edit",
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
                            value: "delete",
                            child: Text("Delete"),
                          ),
                        ];
                      },
                    ));
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Icon(Icons.add)),
    );
  }

  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(builder: (context) => const AddPlayer());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> navigateToEditPage(Map player) async{
    final route = MaterialPageRoute(
        builder: (context) => AddPlayer(player: player)
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

  Future<void> deleteById(String playerId) async{
    final url = "http://127.0.0.1:8000/player/$playerId";
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      final filtered = datas.where((element) => element["_id"] != playerId).toList();
      setState(() {
        datas = filtered;
      });
      showSuccessMessage("Data Successfully Deleted");
    } else {
      showErrorMessage("Unable To Delete");
    }
  }

  Future<void> fetchData() async {
    const url = "http://127.0.0.1:8000/player";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      setState(() {
        datas = json.cast<Map<String, dynamic>>();
      });
    }
    setState(() {
      isLoading = false;
    });
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
