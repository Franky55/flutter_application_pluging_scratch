
//build with dll files:
//https://stackoverflow.com/questions/69511109/how-to-include-dlls-in-flutter-build-windows

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io' show Platform, Directory;
import "dart:async";
import 'package:path/path.dart' as path;


typedef INIT = ffi.Void Function();
// ignore: camel_case_types
typedef INIT_F = void Function();

typedef CPUFunc = ffi.Int32 Function();
// ignore: camel_case_types
typedef CPU_F = int Function();

CPU_F ?cpu;

INIT_F ?init_f;

void main() {

  String ?libraryPath;
      

  

  if (kReleaseMode) {
    // I'm on release mode, absolute linking
    if (Platform.isWindows) {
    libraryPath = path.join(
        //Directory.current.path, 'libraries', 'window_monitor', 'hardware_monitor_windows', 'Release', 'Lib.dll');
        Directory.current.path, 'Lib.dll');
  }
  } else {
    // I'm on debug mode, local linking
    if (Platform.isWindows) {
    libraryPath = path.join(
        Directory.current.path, 'libraries', 'window_monitor', 'hardware_monitor_windows', 'Release', 'Lib.dll');
       
  }
  }
  
  final dylib = ffi.DynamicLibrary.open(libraryPath!);

  // Look up the C++ function 'getAverage_CPU'
  init_f = dylib
      .lookup<ffi.NativeFunction<INIT>>('initialize')
      .asFunction();
  // Call the function
  init_f!();


  // Look up the C++ function 'getAverage_CPU'
  cpu = dylib
      .lookup<ffi.NativeFunction<CPUFunc>>('getAverage')
      .asFunction();
  // Call the function
  cpu!();

  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frank',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Frank\'s CPU plugin windows'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int cpu_value = 0;

  @override
  void initState()
  {
    Timer mytimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      cpu_value = cpu!();
      setState((){});
    });

    super.initState();
  }
   

  

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is your CPU %:',
            ),
            Text(
              '$cpu_value',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      
    );
  }
}
