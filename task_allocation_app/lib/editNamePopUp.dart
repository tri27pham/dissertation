import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dataModel.dart';
import 'package:provider/provider.dart';

class EditName extends StatefulWidget {
  const EditName({super.key});

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  TextEditingController _nameFieldController = TextEditingController(text: '');

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameFieldController.text);
  }

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? '';
    _nameFieldController.text = name;
  }

  @override
  void initState() {
    super.initState();
    _loadName();
    // DataModel dataModel = DataModel();
    // setState(() {
    //   _nameFieldController.text = dataModel.name;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 248, 248, 248),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30, 25, 0, 5),
              child: Text(
                "NAME",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Center(
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 240, 240),
                    borderRadius:
                        BorderRadius.circular(5), // Set the radius to 5
                  ),
                  child: Transform.translate(
                    offset:
                        Offset(0, -2), // Adjust the vertical offset as needed
                    child: TextField(
                      controller: _nameFieldController,
                      decoration: InputDecoration(
                        hintText: "enter  name",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 196, 196, 196),
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    _saveName();
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // No rounding
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber.shade200),
                  ),
                  child: Text(
                    "CHANGE NAME",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
