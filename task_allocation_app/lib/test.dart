import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isButtonVisible = true; // Initially set to true
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      // Update button visibility based on focus
      isButtonVisible = !_focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus(); // Remove focus from any text fields
      },
      child: Column(
        children: [
          // Your text fields here
          TextField(focusNode: _focusNode),
          TextField(focusNode: _focusNode),
          // Button visibility controlled by isButtonVisible
          if (isButtonVisible)
            ElevatedButton(
              onPressed: () {
                // Button action
              },
              child: Text('Button'),
            ),
          // Original content (hidden initially)
          if (!isButtonVisible)
            Container(
              width: 200,
              height: 200,
              color: Colors.blue,
              child: Center(
                child: Text(
                  'Original Content',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class HiddenButtonContainer extends StatefulWidget {
//   final bool isButtonVisible;
//   final VoidCallback onTap;

//   const HiddenButtonContainer(
//       {Key? key, required this.isButtonVisible, required this.onTap})
//       : super(key: key);

//   @override
//   _HiddenButtonContainerState createState() => _HiddenButtonContainerState();
// }

// class _HiddenButtonContainerState extends State<HiddenButtonContainer> {
//   late bool isButtonVisible;
//   double buttonWidth = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     isButtonVisible = widget.isButtonVisible;
//     buttonWidth = isButtonVisible ? 50.0 : 0.0; // Change width of button
//   }

//   void toggleButtonVisibility() {
//     setState(() {
//       isButtonVisible = !isButtonVisible;
//       buttonWidth = isButtonVisible ? 50.0 : 0.0; // Change width of button
//       widget.onTap(); // Notify the parent widget about tap
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: toggleButtonVisibility,
//       child: Container(
//         color: Colors.grey[200],
//         padding: EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Tap to show/hide button',
//                 style: TextStyle(fontSize: 16.0),
//               ),
//             ),
//             AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               width: buttonWidth,
//               child: isButtonVisible
//                   ? ElevatedButton(
//                       onPressed: () {
//                         // Button action
//                       },
//                       child: Text('Button'),
//                     )
//                   : SizedBox(), // Hidden button
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MultipleHiddenButtonContainers extends StatefulWidget {
//   @override
//   _MultipleHiddenButtonContainersState createState() =>
//       _MultipleHiddenButtonContainersState();
// }

// class _MultipleHiddenButtonContainersState
//     extends State<MultipleHiddenButtonContainers> {
//   late List<bool> areButtonsVisible;

//   @override
//   void initState() {
//     super.initState();
//     areButtonsVisible = [false, false, false]; // Initial visibility states
//   }

//   void toggleButtonVisibility(int index) {
//     setState(() {
//       for (int i = 0; i < areButtonsVisible.length; i++) {
//         if (i == index) {
//           areButtonsVisible[i] = !areButtonsVisible[i];
//         } else {
//           areButtonsVisible[i] = false; // Hide other buttons
//         }
//       }
//     });
//   }

//   void hideButtons(BuildContext context) {
//     setState(() {
//       areButtonsVisible = List.filled(areButtonsVisible.length, false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => hideButtons(context), // Pass the context to hideButtons
//       child: Column(
//         children: List.generate(
//           areButtonsVisible.length,
//           (index) => HiddenButtonContainer(
//             isButtonVisible: areButtonsVisible[index],
//             onTap: () {
//               toggleButtonVisibility(index);
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: FirstPage(),
//   ));
// }

// class FirstPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('First Page'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => MultipleHiddenButtonContainers()),
//             );
//           },
//           child: Text('Go to Multiple Hidden Button Containers'),
//         ),
//       ),
//     );
//   }
// }
