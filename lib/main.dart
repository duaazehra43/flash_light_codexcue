import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(FlashlightApp());
}

class FlashlightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashlight App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FlashlightScreen(),
    );
  }
}

class FlashlightScreen extends StatefulWidget {
  @override
  _FlashlightScreenState createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initFlashlight();
  }

  void _initFlashlight() async {
    try {
      final isTorchAvailable = await TorchLight.isTorchAvailable();
      if (isTorchAvailable) {
        // Torch is available, proceed
        _turnFlashlight(false); // Ensure flashlight is initially off
      } else {
        // Torch is not available, handle accordingly
        // For example, show an error message or disable flashlight functionality
      }
    } on Exception catch (e) {
      // Handle error
      print('Error initializing flashlight: $e');
    }
  }

  void _turnFlashlight(bool enable) async {
    try {
      if (enable) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
      setState(() {
        _isFlashOn = enable;
      });
    } on Exception catch (e) {
      // Handle error
      print('Error toggling flashlight: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashlight'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2C5364),
              Color(0xFF0F2027),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                size: 100.0,
                color: _isFlashOn ? Colors.yellow : Colors.white,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _turnFlashlight(!_isFlashOn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFlashOn ? Colors.red : Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  _isFlashOn ? 'Turn Off' : 'Turn On',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
