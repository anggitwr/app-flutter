import 'package:assignment/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 late final LocalAuthentication auth;
 bool _supportState = false;

 @override
 void initState(){
   super.initState();
   auth = LocalAuthentication();
   auth.isDeviceSupported().then(
       (bool isSupported) => setState((){
         _supportState = isSupported;
       })
   );
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_supportState )
                const Text('This device is supported')
              else
                const Text("This device is not supported"),
              
              const Divider(height: 100),
              
              ElevatedButton(
                  onPressed: _getAvailableBiomerics,
                  child: const Text('Get avilabel')
              ),
              
              const Divider(height: 100),
              
              ElevatedButton(onPressed:  _authenticate, child: Text('Authenticate'))

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async{
   try{
     bool authenticate = await auth.authenticate(
         localizedReason:
         'localizedReason',
     options: const AuthenticationOptions(
       stickyAuth: true,
       biometricOnly: true,
     )
     );
     
     if(authenticate){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => MainScreen()));
     }

     print("Authenticated : $authenticate");
   } on PlatformException catch (e){
     print(e);
   }
  }

  Future<void> _getAvailableBiomerics() async{
   List<BiometricType> availableBiometrics =
       await auth.getAvailableBiometrics();
   print("List of availabelBiometrics : $availableBiometrics");

   if (!mounted){
     return;
   }
  }
}