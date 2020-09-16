import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MyHomePage(
        chennal: IOWebSocketChannel.connect("wss://echo.websocket.org"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel chennal;
  MyHomePage({
    @required this.chennal,
  });
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Scoket'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Send My Message'),
                controller: controller,
              ),
            ),
            StreamBuilder(
              stream: widget.chennal.stream,
              builder: (context, snapshot) => Padding(
                padding: EdgeInsets.all(20),
                child: Text(snapshot.hasData ? '${snapshot.data}' : 'no data'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: senddata,
        child: Icon(Icons.send),
      ),
    );
  }

  void senddata() {
    if (controller.text.isNotEmpty) {
      widget.chennal.sink.add(controller.text);
      controller.text = '';
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.chennal.sink.close();
    super.dispose();
  }
}
