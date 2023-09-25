import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/theme_helper.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  String _device = "";
  String _userId = "";

  final platform = const MethodChannel('unique_id');

  Future<String> getAndroidId() async {
    try {
      final String androidId = await platform.invokeMethod('getAndroidId');
      return androidId;
    } catch (e) {
      print("Error: $e");
      return "";
    }
  }

  void fetchDeviceId() async {
    String id = await getAndroidId();
    setState(() {
      _device = id;
    });
  }

  void fetchUserId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString('userId') ?? '';
    setState(() {
      _userId = userId;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDeviceId();
    fetchUserId();
    getAndroidId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF3F4F8),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/splash.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text(
                      'App navn',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.buttonPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Sjekk',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Versjon',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.buttonPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '1.7.1 beta',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Bruker-ID',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.buttonPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _userId,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(),
                    Text(
                      'Enhets-ID',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.buttonPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _device,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _device))
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Enhets-ID kopiert')));
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue
                          ),
                          child: Text('Kopiere',style: TextStyle(
                            color: Colors.white
                          ),),
                        )
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 120.0),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '© 2023 en del av Gensolv.no',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
