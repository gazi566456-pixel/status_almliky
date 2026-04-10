void showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("هل تريد الخروج؟"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// 🔥 Banner Ad
            Container(
              height: 60,
              child: AdWidget(
                ad: AdsService().bannerAd!, // لازم يكون محمل
              ),
            ),

            SizedBox(height: 10),
            Text("اضغط خروج للخروج من التطبيق"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Future.delayed(Duration(milliseconds: 200), () {
                exit(0); // خروج
              });
            },
            child: Text("خروج"),
          ),
        ],
      );
    },
  );
}