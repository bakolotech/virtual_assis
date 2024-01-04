import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:untitled/signaling.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentFlateform
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your Application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistant Virtuel',
      theme: ThemeData(
              primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    ); // MaterialApp
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream){
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose(){
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to virtual assistant'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    signaling.openUserMedia(_localRenderer, _remoteRenderer);
                  },
                child: Text('Open camera & microphone'),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                  onPressed: () {
                    signaling.join(textEditingController.text);
                  },
                child: Text('Join room'),
              ),
              SizedBox(
                width: 8,
              ),
              ElevatedButton(
                  onPressed: () {
                    signaling.hangUp(_localRenderer)
                  },
                child: Text('Hangup'),
              )
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(_localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(_remoteRenderer)),
                ],
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Join the following room'),
                    Flexible(
                        child: TextFormField(
                          controller: textEditingController,
                        )
                    )
                  ],
                ),
              ),
          ),
          SizedBox(
            height: 8,
          )
          )
        ],
      ),

    );
  }
}