import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Future<Map<String, String>> getDeviceInfo() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      return {
        "board": androidDeviceInfo.board,
        "bootloader": androidDeviceInfo.bootloader,
        "brand": androidDeviceInfo.brand,
        "device": androidDeviceInfo.device,
        "display": androidDeviceInfo.display,
        "fingerprint": androidDeviceInfo.fingerprint,
        "hardware": androidDeviceInfo.hardware,
        "host": androidDeviceInfo.host,
        "id": androidDeviceInfo.id,
        "manufacturer": androidDeviceInfo.manufacturer,
        "model": androidDeviceInfo.model,
        "product": androidDeviceInfo.product,
        "tags": androidDeviceInfo.tags,
        "type": androidDeviceInfo.type,
        "androidId": androidDeviceInfo.androidId
      };
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      return {
        "name": iosDeviceInfo.name,
        "systemName": iosDeviceInfo.systemName,
        "systemVersion": iosDeviceInfo.systemVersion,
        "model": iosDeviceInfo.model,
        "localizedModel": iosDeviceInfo.localizedModel,
        "identifierForVendor": iosDeviceInfo.identifierForVendor
      };
    } else
      return Future.error("Unsupported platform");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getDeviceInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.data);
          } else if (snapshot.hasData) {
            Map<String, String> data = snapshot.data as Map<String, String>;
            List<String> keys = data.keys.toList();
            List<String> values = data.values.toList();
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 30),
              child: ListView(
                children: [
                  for (int i = 0; i < keys.length; i++) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                            flex: 5,
                            child: Text(
                              keys[i],
                              style: Theme.of(context).textTheme.headline,
                            )),
                        SizedBox(width: 15),
                        Flexible(
                            flex: 8,
                            child: Text(
                              values[i],
                              style: Theme.of(context).textTheme.subhead,
                            )),
                      ],
                    ),
                    SizedBox(height: 10)
                  ]
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
