import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

// StatelessWidgetを継承して作成
class AdBanner extends StatelessWidget {


Widget build(BuildContext context) {
  // バナー広告をインスタンス化
  BannerAd myBanner = BannerAd(
      // FOR TEST
      adUnitId: getTestAdBannerUnitId(),
    //   // FOR 本番
    // adUnitId: getAdBannerUnitId(),

      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
  );
  // バナー広告の読み込み
  myBanner.load();

  return Container(
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
      child: AdWidget(ad: myBanner),
  );

}
// プラットフォーム（iOS / Android）に合わせてデモ用広告IDを返す
  String getTestAdBannerUnitId() {
    String testBannerUnitId = "";
    if (Platform.isAndroid) {
      // Android のとき
      testBannerUnitId = "ca-app-pub-3940256099942544/6300978111"; // Androidのデモ用バナー広告ID
      //本番用ANDROIDバナーID
    //  ca-app-pub-6321551480201249/5592261891

    } else if (Platform.isIOS) {
      // iOSのとき
      testBannerUnitId = "ca-app-pub-3940256099942544/2934735716"; // iOSのデモ用バナー広告ID
      //本番用IOSバナーID
    //  ca-app-pub-6321551480201249/1514497656
    }
    return testBannerUnitId;
  }

  // // ''''' 本番用  ''''  プラットフォーム（iOS / Android）に合わせて本番用広告IDを返す
  // String getAdBannerUnitId() {
  //   String bannerUnitId = "";
  //   if (Platform.isAndroid) {
  //     // Android のとき
  //     bannerUnitId = "ca-app-pub-6321551480201249/5592261891"; // Androidの本番用バナー広告ID
  //   } else if (Platform.isIOS) {
  //     // iOSのとき
  //     bannerUnitId = "ca-app-pub-6321551480201249/1514497656"; // iOSの本番用バナー広告ID
  //   }
  //   return bannerUnitId;
  // }

}