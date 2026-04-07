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
    int totalCount = files.length + (files.length ~/ adInterval) + 1;

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
        childAspectRatio: 0.85,
      ),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        // 🔥 إعلان في البداية وكل adInterval عناصر
        if (index == 0 || (index > 0 && index % (adInterval + 1) == 0)) {
          return const AdBannerWidget();
        }

        // 🔥 حساب index الحقيقي
        int adCountBefore = (index ~/ (adInterval + 1)) + 1;
        int realIndex = index - adCountBefore;

        if (realIndex >= 0 && realIndex < files.length) {
          final item = files[realIndex] as StatusItemModel;
          return WhatsAppItemCard(item: item);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
