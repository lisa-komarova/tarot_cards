import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:taro_cards/ads/ad_helper.dart';

///builds banner ad
class BannerAdvertisment extends StatefulWidget {
  const BannerAdvertisment({Key? key}) : super(key: key);

  @override
  State<BannerAdvertisment> createState() => _BannerAdvertismentState();
}

class _BannerAdvertismentState extends State<BannerAdvertisment> {
  bool isLoading = true;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      width: double.infinity,
      child: isLoading
          ? const SizedBox(
              height: 50,
              width: double.infinity,
            )
          : _buildAd(),
    );
  }

  Widget _buildAd() {
    if (_bannerAd != null) {
      return Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        ),
      );
    } else {
      return Container();
    }
  }
}
