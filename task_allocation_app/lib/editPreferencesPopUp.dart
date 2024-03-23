import 'package:flutter/cupertino.dart';

class EditPreferences extends StatefulWidget {
  const EditPreferences({super.key});

  @override
  State<EditPreferences> createState() => _EditPreferencesState();
}

class _EditPreferencesState extends State<EditPreferences> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.77,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 248, 248, 248),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
