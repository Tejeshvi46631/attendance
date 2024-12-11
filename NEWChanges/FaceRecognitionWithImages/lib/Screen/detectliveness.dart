
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:selfie_liveness/selfie_liveness.dart';

class ElatechLiveliness extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ElatechLiveliness();
  }
}

class _ElatechLiveliness extends State<ElatechLiveliness> {
  String value = "";
//asset image required
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            value != ""
                ? Image.file(new File(value), key: UniqueKey())
                : const SizedBox(),
            Text("Press The Button To Take Photo"),
            ElevatedButton
            (
                onPressed: () async {
                   value = await SelfieLiveness.detectLiveness(
                    poweredBy: "",
                    assetLogo: "assets/raven_logo_white.png",
                    compressQualityandroid: 88,
                    compressQualityiOS: 88,
                  );
                  setState(() {
                     Navigator.pushNamed(context, '/welcomescreen');
                  });
                },
                child: const Text("Detect Liveness"))
          ]),
        ),
      ),
    );
  }
 
}