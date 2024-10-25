import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:io';

import 'package:flutter/services.dart';
import 'package:msecfluttersdk/msecfluttersdk.dart';

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
  bool _securityAgent = false;
  bool _isRootedOrJailbroken = false;
  bool _isDebuggable = false;
  bool _isMemoryHooked = false;
  bool _isEmulator = false;
  String _fingerprint = "Unknown";
  final _msecfluttersdkPlugin = Msecfluttersdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initSecurityAgentState();
  }

  Future<void> initSecurityAgentState() async {
    bool securityAgent;
    bool isRootedOrJailbroken;
    bool isMemoryHooked;
    bool isDebuggable;
    bool isEmulator;
    String fingerprint;
    securityAgent = await _msecfluttersdkPlugin.startSecurityAgent("1.0.2") ?? false;
    fingerprint = await _msecfluttersdkPlugin.getFingerprint() ?? _fingerprint;
    isRootedOrJailbroken = await _msecfluttersdkPlugin.isRootedOrJailbroken() ?? _isRootedOrJailbroken;
    isDebuggable = await _msecfluttersdkPlugin.isDebuggable() ?? _isDebuggable;
    isEmulator = await _msecfluttersdkPlugin.isEmulator() ?? _isEmulator;
    isMemoryHooked = await _msecfluttersdkPlugin.isMemoryHooked() ?? _isMemoryHooked;
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _securityAgent = securityAgent;
      _fingerprint = fingerprint;
      _isRootedOrJailbroken = isRootedOrJailbroken;
      _isDebuggable = isDebuggable;
      _isEmulator = isEmulator;
      _isMemoryHooked = isMemoryHooked;
    });
  }


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _msecfluttersdkPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              Text('Security Agent started: $_securityAgent\n'),
              Text('Fingerprint: $_fingerprint \n'),
              Text('Debuggable? : $_isDebuggable \n'),
              Text('Memory hooked? : $_isMemoryHooked \n'),
              Text('Is an emulator? : $_isEmulator \n'),
              Text('Rooted or Jailbroken? : $_isRootedOrJailbroken \n'),
            ]
        ),
      ),
    );
  }
}
