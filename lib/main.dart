import 'package:bill_creator/Pages/Invoice.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Invoice(),
  ));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Padding(padding: EdgeInsets.only(bottom: 9.0),
              child: Image(image: AssetImage('assets/images/logo.png'),width: 50,height: 50,),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 9.0),
              child: Text("दख्खन सप्लायर्स अपशिंगे",
                style: TextStyle(fontSize: 34),
                textAlign: TextAlign.center,
              ),
            ),
            Text("Address - At Post Apshinge tal koregoan Dist Satara.",
              style: TextStyle(fontSize: 14,color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            Text("Phone No - 8208553219",
              style: TextStyle(fontSize: 14,color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            Text("Email - vaibhavtate002@gmail.com",
              style: TextStyle(fontSize: 14,color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top:8.0),
              child: ElevatedButton(
                onPressed: sampleFunction,
                child: Text('Create Bill'),
              ),
            )
          ],
        ),
      )
    ));
  }
}


sampleFunction(){

  print('Function on Click Event Called.');
  // Put your code here, which you want to execute on onPress event.
}