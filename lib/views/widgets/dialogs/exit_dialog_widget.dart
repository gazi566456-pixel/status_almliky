import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/meta/settings/settings_meta.dart';
import 'package:statusgetter/views/widgets/banner_ad_widget.dart';

Future<void> showExitDialog(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierLabel: AppSettings.empty,
    barrierColor: AppColors.kBlack.withOpacity(0.5),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (_, Animation<double> a1, Animation<double> a2, __) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: const _ExitDialog(),
        ),
      );
    },
  );
}

class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: context.bgColor,
      surfaceTintColor: context.bgColor,
      insetPadding: EdgeInsets.symmetric(horizontal: (context.width * 0.08)),
      child: Container(
        width: context.width,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(
              'تأكيد الخروج',
              maxLines: 1,
              style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            AutoSizeText(
              maxLines: 3,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
              'هل أنت متأكد أنك تريد الخروج من التطبيق؟',
            ),
            const SizedBox(height: 20.0),
            
            // 🔥 إعلان بنر داخل النافذة
            const SizedBox(
              height: 60,
              child: AdBannerWidget(),
            ),
            
            const SizedBox(height: 24.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const AutoSizeText('إلغاء', maxLines: 1),
                    onPressed: () => Navigator.pop(context), // 🔥 إغلاق النافذة فقط
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => SystemNavigator.pop(), // 🔥 إنهاء التطبيق
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.theme.colorScheme.primary,
                      foregroundColor: AppColors.kWhite,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const AutoSizeText('تأكيد الخروج', maxLines: 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
