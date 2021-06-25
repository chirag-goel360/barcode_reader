import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    MyHomePage(),
  );
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String result = '';
  ImagePicker imagePicker;
  File _file;
  BarcodeScanner barcodeScanner;

  doBarcodeScanning() async {
    final inputImage = InputImage.fromFile(
      _file,
    );
    result = '';
    final List<Barcode> barcodes = await barcodeScanner.processImage(
      inputImage,
    );
    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;
      switch (type) {
        case BarcodeType.wifi:
          BarcodeWifi barcodeWifi = barcode.value;
          setState(() {
            result += "Wifi: " + barcodeWifi.ssid + "\n";
            result += "Password: " + barcodeWifi.password + "\n";
            result += "Type: " + barcodeWifi.encryptionType.toString();
          });
          break;
        case BarcodeType.url:
          BarcodeUrl barcodeUrl = barcode.value;
          setState(() {
            result += "Title: " + barcodeUrl.title + "\n";
            result += "URL: " + barcodeUrl.url;
          });
          break;
        case BarcodeType.contactInfo:
          BarcodeContactInfo barcodeContactInfo;
          barcodeContactInfo = barcode.value;
          setState(() {
            result += "First Name: " + barcodeContactInfo.firstName + "\n";
            result += "Last Name: " + barcodeContactInfo.lastName;
          });
          break;
        case BarcodeType.email:
          BarcodeEmail barcodeEmail = barcode.value;
          setState(() {
            result += "Address: " + barcodeEmail.address;
          });
          break;
        case BarcodeType.phone:
          BarcodePhone barcodePhone = barcode.value;
          setState(() {
            result += "PhoneType: " + barcodePhone.phoneType.toString() + "\n";
            result += "Number: " + barcodePhone.number;
          });
          break;
        case BarcodeType.sms:
          BarcodeSMS barcodeSMS = barcode.value;
          setState(() {
            result += "Phone No: " + barcodeSMS.phoneNumber + "\n";
            result += "Message: " + barcodeSMS.message;
          });
          break;
        case BarcodeType.geographicCoordinates:
          BarcodeGeo barcodeGeo = barcode.value;
          setState(() {
            result += "Latitude: " + barcodeGeo.latitude.toString() + "\n";
            result += "Longitude: " + barcodeGeo.longitude.toString();
          });
          break;
        case BarcodeType.driverLicense:
          BarcodeDriverLicense barcodeDriverLicense;
          barcodeDriverLicense = barcode.value;
          setState(() {
            result +=
                "License No: " + barcodeDriverLicense.licenseNumber + "\n";
            result += "First Name: " + barcodeDriverLicense.firstName + "\n";
            result += "Last Name: " + barcodeDriverLicense.lastName + "\n";
            result += "DOB: " + barcodeDriverLicense.birthDate;
          });
          break;
        case BarcodeType.unknown:
          setState(() {
            result += BarcodeType.unknown.index.toString();
          });
          break;
        case BarcodeType.isbn:
          setState(() {
            result += BarcodeType.isbn.index.toString();
          });
          break;
        case BarcodeType.product:
          setState(() {
            result += BarcodeType.product.index.toString();
          });
          break;
        case BarcodeType.text:
          setState(() {
            result += BarcodeType.text.index.toString();
          });
          break;
        case BarcodeType.calendarEvent:
          BarcodeCalenderEvent barcodeCalenderEvent;
          barcodeCalenderEvent = barcode.value;
          setState(() {
            result += "Organiser: " + barcodeCalenderEvent.organiser + "\n";
            result += "Description: " + barcodeCalenderEvent.description;
          });
          break;
      }
    }
  }

  _imgFromGallery() async {
    PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.gallery,
    );
    _file = File(
      pickedFile.path,
    );
    setState(() {});
    doBarcodeScanning();
  }

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    barcodeScanner = GoogleMlKit.vision.barcodeScanner();
  }

  @override
  void dispose() {
    super.dispose();
    barcodeScanner.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/image.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                width: 100,
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 100,
                ),
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            'images/frame.jpg',
                            height: 220,
                            width: 220,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: TextButton(
                        onPressed: _imgFromGallery,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 15,
                          ),
                          child: _file != null
                              ? Image.file(
                                  _file,
                                  width: 140,
                                  height: 150,
                                  fit: BoxFit.fill,
                                )
                              : Container(
                                  width: 140,
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                      ),
                                      Text(
                                        'Press for Gallery',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    top: 20,
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      '$result',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
