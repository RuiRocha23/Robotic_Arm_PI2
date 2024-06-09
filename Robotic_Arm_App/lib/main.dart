import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:Zebrot/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connection.dart';
import 'home.dart';

StreamController<BluetoothConnection> streamController =
    StreamController<BluetoothConnection>();

FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
List<BluetoothDevice> devicesList = [];
BluetoothDevice? connectedDevice;
BluetoothConnection? connection;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Zebrot App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFEEF1F8),
      ),
      home: const HomePage(),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////////////
/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;
  BluetoothConnection? connection;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  void requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothAdvertise.request();
    await Permission.bluetoothConnect.request();
    //await Permission.location.request();

    scanForDevices();
    print(devicesList);
  }

  void scanForDevices() async {
    devicesList = await bluetooth.getBondedDevices();
    setState(() {});
  }

  void connectToDevice(BluetoothDevice device) async {
    connection = await BluetoothConnection.toAddress(device.address.toString());
    setState(() {
      connectedDevice = device;
    });
    print('Connected to the device');
  }

  void connectToRasp() async {
    connection = await BluetoothConnection.toAddress("DC:A6:32:85:B1:A4");
    setState(() {
      //connectedDevice = device;
    });
    print('Connected to the device');
  }

  void disconnectFromDevice() async {
    await connection?.close();
    setState(() {
      connectedDevice = null;
    });
    print('Disconnected from the device');
  }

  void printd() {
    print(connectedDevice);
  }

  void _sendData() async {
    if (connection != null && connection!.isConnected) {
      connection!.output.add(ascii.encode('Hello, Bluetooth!\r\n'));
      await connection!.output.allSent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Devices"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _sendData,
              child: Text("print"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devicesList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devicesList[index].name ?? "Unknown Device"),
                  subtitle: Text(devicesList[index].address),
                  onTap: () {
                    connectToDevice(devicesList[index]);
                  },
                );
              },
            ),
          ),
          if (connectedDevice != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Connected to ${connectedDevice!.name}"),
                  ElevatedButton(
                    onPressed: disconnectFromDevice,
                    child: Text("Disconnect"),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}*/
///////////////////////////////////////////////////////////////////////////////////////
/*import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  bool connected = false;

  @override
  void initState() {
    super.initState();
    print("ola");
    connectToDevice();
  }

  void connectToDevice() async {
    List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    if (devices.isEmpty) {
      print('No paired devices found');
      return;
    } else
      print(
          "..........................................................${devices}........................");
    BluetoothDevice device = devices.first;

    // Append the port number to the device address
    String deviceAddress = '${device.address}:1';

    try {
      BluetoothConnection _connection =
          await BluetoothConnection.toAddress(deviceAddress);

      setState(() {
        connection = _connection;
        connected = true;
      });

      print('Connected to the device');
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Connection'),
      ),
      body: Center(
        child: connected
            ? Text('Connected to the Raspberry Pi Bluetooth server')
            : CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    connection?.close();
    super.dispose();
  }
}*/
