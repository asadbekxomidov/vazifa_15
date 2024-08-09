import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:vazifa_15/page/home_page.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isBiometricSupported = false;
  bool _hasFaceID = false;
  bool _hasFingerprint = false;
  String _enteredPin = '';

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    setState(() {
      _isBiometricSupported = canCheckBiometrics;
      _hasFaceID = availableBiometrics.contains(BiometricType.face);
      _hasFingerprint = availableBiometrics.contains(BiometricType.fingerprint);
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Use your biometric credential to access the app',
        options: AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Error using biometrics: $e');
    }

    if (authenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Biometric authentication failed')),
      );
    }
  }

  void _onPinSubmitted(String pin) {
    setState(() {
      _enteredPin = pin;
    });
    if (_enteredPin == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect PIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade200,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade200,
        centerTitle: true,
        title: Text('Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isBiometricSupported)
              ElevatedButton(
                onPressed: _authenticateWithBiometrics,
                child: Text(
                  _hasFaceID
                      ? 'Unlock with Face ID'
                      : _hasFingerprint
                          ? 'Unlock with Fingerprint'
                          : 'Unlock with Biometrics',
                ),
              ),
            Pinput(
              length: 4,
              onCompleted: _onPinSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}
