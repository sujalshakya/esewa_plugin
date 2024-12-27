import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:esewa_plugin/esewa_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _paymentStatus = 'Not Started';
  final _esewaPlugin = EsewaPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Initialize platform state
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _esewaPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  // Trigger eSewa payment
  Future<void> startPayment() async {
    try {
      final result = await _esewaPlugin.startEsewa(
          // clientId: 'your_client_id',
          // secretKey: 'your_secret_key',
          // environment: 0,
          // productPrice: '100',
          // productName: 'Test Product',
          // productId: '12345',
          // callbackUrl: 'www.google.com',
          );
      setState(() {
        _paymentStatus = 'Payment Successful: $result';
      });
    } on PlatformException catch (e) {
      setState(() {
        _paymentStatus = 'Payment Failed: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('eSewa Plugin Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              ElevatedButton(
                onPressed: startPayment,
                child: const Text('Start Payment'),
              ),
              const SizedBox(height: 20),
              Text('Payment Status: $_paymentStatus'),
            ],
          ),
        ),
      ),
    );
  }
}
