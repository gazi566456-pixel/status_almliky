import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/core/functions/http_override/http_override_fun_core.dart';

import 'package:statusgetter/services/ads_service.dart';
import 'package:statusgetter/views/initial/initial_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 ملاحظة مهندس: تم إزالة MobileAds.instance.initialize المباشر 
  // لأن AdsService().init() تقوم بالتهيئة داخلياً بشكل أكثر تنظيماً.
  
  // تهيئة نظام الإعلانات الاحترافي
  await AdsService().init();

  // تهيئة التخزين المؤقت للـ Bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  // تثبيت اتجاه الشاشة
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // تعيين تجاوزات HTTP (لحل مشاكل الشهادات في الإصدارات القديمة)
  HttpOverrides.global = MyHttpOverrides();

  // تهيئة حقن التبعيات (Dependency Injection)
  unawaited(initializeGetIt());

  // تهيئة Firebase
  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Status Saver',
      home: InitialView(),
    );
  }
}
