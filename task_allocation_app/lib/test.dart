import 'package:flutter/material.dart';

class CheckboxListScreen extends StatefulWidget {
  @override
  _CheckboxListScreenState createState() => _CheckboxListScreenState();
}

class _CheckboxListScreenState extends State<CheckboxListScreen> {
  bool _showScroll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkbox List"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showScroll = !_showScroll;
                });
              },
              child: Text('Open Checkbox List'),
            ),
            Visibility(
              visible: _showScroll,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        CheckboxListTile(
                          title: Text('Option 1'),
                          value: false,
                          onChanged: (newValue) {
                            // Handle checkbox value change
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Option 2'),
                          value: false,
                          onChanged: (newValue) {
                            // Handle checkbox value change
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Option 3'),
                          value: false,
                          onChanged: (newValue) {
                            // Handle checkbox value change
                          },
                        ),
                      ],
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
