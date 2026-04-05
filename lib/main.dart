import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // 🔥 جديد
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/core/functions/http_override/http_override_fun_core.dart';
import 'package:statusgetter/firebase_options.dart';
import 'package:statusgetter/views/initial/initial_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 تهيئة الإعلانات
  await MobileAds.instance.initialize();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HttpOverrides.global = MyHttpOverrides();

  unawaited(initializeGetIt());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdWrapper(),
    );
  }
}
class AdWrapper extends StatefulWidget {
  const AdWrapper({super.key});

  @override
  State<AdWrapper> createState() => _AdWrapperState();
}

class _AdWrapperState extends State<AdWrapper> {
  BannerAd? bannerAd;

  @override
  void initState() {
    super.initState();

    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // 🔥 إعلان تجريبي
      listener: BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const InitialView(), // 👈 تطبيقك الأساسي

          // 🔥 الإعلان أسفل الشاشة
          if (bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 50,
                child: AdWidget(ad: bannerAd!),
              ),
            ),
        ],
      ),
    );
  }
}
