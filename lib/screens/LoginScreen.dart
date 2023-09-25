import 'package:car_app/screens/MainScreen.dart';
import 'package:car_app/screens/machine_issue.dart';
import 'package:car_app/screens/notifications_screen.dart';
import 'package:car_app/services/user_service.dart';
import 'package:flutter/material.dart';

import '../helpers/theme_helper.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(

      body: Container(
        color: Colors.white60,
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Badge(
                    child: IconButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => NotificationsScreen())
                        );
                      },
                      icon: Icon(Icons.notifications,size: 40,color: ThemeHelper.buttonPrimaryColor,),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.1,),
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/splash.png',
                        ), // Replace this with your logo SVG file
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Pn ID',
                      prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Passord',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      validateLogin(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeHelper.buttonPrimaryColor,
                      minimumSize: Size(double.infinity, 40)
                    ),
                    child: Text('Logg Inn'.toUpperCase(), style: TextStyle(
                        fontSize: 18,
                      color: Colors.white
                    )),
                  ),
                  SizedBox(height: 12,),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 3,
                        ),
                      ),
                      SizedBox(width: 4,),
                      Text('Eller',style: TextStyle(
                        fontSize: 18
                      ),),
                      SizedBox(width: 4,),
                      Expanded(
                        child: Divider(
                          thickness: 3,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12,),
                  Container(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MachineIssue())
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.purple,
                        minimumSize: Size(double.infinity,40)
                      ),
                      child: Text('P-Automat',style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),),
                    ),
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateLogin(BuildContext context) async{
    bool isLogged = await UserServices.login(email: _emailController.text, password: _passwordController.text);
    if(isLogged){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen())
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kunne ikke logge på'))
      );
    }
  }
}
