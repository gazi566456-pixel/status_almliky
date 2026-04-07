import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 🔥 Widget الإعلان
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-3940256099942544/6300978111",
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint("✅ Ad Loaded");
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("❌ Ad Failed: $error");
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );

    _bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null) return const SizedBox();

    return Container(
      alignment: Alignment.center,
      height: 50,
      child: AdWidget(ad: _bannerAd!),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}

// 🔥 Widget عرض الحالات
class StatusViewerLayoutWidget extends StatelessWidget {
  final List files;
  final String pageStorageKey;

  const StatusViewerLayoutWidget({
    super.key,
    required this.files,
    required this.pageStorageKey,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: PageStorageKey<String>(pageStorageKey),
      padding: const EdgeInsets.all(8.0),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),

      // ✅ إصلاح العدد (لازم +1)
      itemCount: files.length + (files.length ~/ 4) + 1,

      itemBuilder: (context, index) {

        // ✅ أول عنصر إعلان (مهم جداً)
        if (index == 0) {
          return const BannerAdWidget();
        }

        // ✅ إعلان كل 4 عناصر
        if (index % 4 == 0) {
          return const BannerAdWidget();
        }

        // ✅ الحساب الصحيح (لازم -1)
        final realIndex = index - (index ~/ 4) - 1;

        // حماية
        if (realIndex < 0 || realIndex >= files.length) {
          return const SizedBox();
        }

        final item = files[realIndex];

        // 🔥 عنصر الحالة (كما هو بدون حذف)
        return WhatsAppItemCard(item: item);
      },
    );
  }
}

// ⚠️ هذا كما هو (لم يتم حذفه)
class WhatsAppItemCard extends StatelessWidget {
  final dynamic item;

  const WhatsAppItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: const Center(
        child: Text(
          "Status",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
