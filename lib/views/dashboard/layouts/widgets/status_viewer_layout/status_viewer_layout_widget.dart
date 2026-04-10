import 'package:flutter/material.dart';
import 'package:statusgetter/core/model/status_item/status_item_model.dart';
import 'package:statusgetter/views/widgets/banner_ad_widget.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/item_card/item_card_widget.dart';

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
    // 🔥 إعلان كل 6 عناصر
    const int adInterval = 6;
    
    // تقسيم الملفات إلى مجموعات كل مجموعة 6 عناصر
    List<Widget> slivers = [];
    
    // إعلان في البداية (اختياري، حسب رغبتك)
    slivers.add(
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: AdBannerWidget(),
        ),
      ),
    );

    for (var i = 0; i < files.length; i += adInterval) {
      // إضافة مجموعة من الصور
      int end = (i + adInterval < files.length) ? i + adInterval : files.length;
      List currentGroup = files.sublist(i, end);

      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8, // 🔥 تحسين الطول لضمان ظهور الأزرار بوضوح
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = currentGroup[index] as StatusItemModel;
                return WhatsAppItemCard(item: item);
              },
              childCount: currentGroup.length,
            ),
          ),
        ),
      );

      // إضافة إعلان بعد كل مجموعة (إلا إذا كانت آخر مجموعة)
      if (end < files.length) {
        slivers.add(
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: AdBannerWidget(),
            ),
          ),
        );
      }
    }

    return CustomScrollView(
      key: PageStorageKey<String>(pageStorageKey),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: slivers,
    );
  }
}
