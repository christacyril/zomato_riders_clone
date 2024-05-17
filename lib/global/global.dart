import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Color? zomatocolor= Color(0xFFEF5350);

Position? position;
List<Placemark>? placeMarks;
String completeAddress = "";

String perParcelDeliverChargeAmount = "60.0";
String previousSellerEarnings = "";
String previousRiderEarnings = "";
