import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'crypto_mod.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Widget getPicker() {
    if (!kIsWeb && Platform.isAndroid) {
      return androidPicker();
    } else if (!kIsWeb && Platform.isIOS) {
      return iosPicker();
    } else {
      return iosPicker();
    }
  }

  CryptoResponse cryptoResponse = CryptoResponse(btc: '0', eth: '0', ltc: '0');

  void getData() async {
    try {
      CryptoResponse data = await CoinData().getCoinData(selectedCurrency);
      setState(() {
        cryptoResponse = data;
      });
    } catch (e) {
      print('getData(): $e');
    }
  }

  DropdownButton<String> androidPicker() {
    return DropdownButton<String>(
        value: selectedCurrency,
        items: currenciesList
            .map((map) => DropdownMenuItem(
                  child: Text(map),
                  value: map,
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCurrency = value ?? 'USD';
            getData();
          });
        });
  }

  CupertinoPicker iosPicker() {
    return CupertinoPicker(
      diameterRatio: 0.98,
      useMagnifier: true,
      magnification: 1.23,
      itemExtent: 32.0,
      onSelectedItemChanged: (selected) {
        setState(() {
          selectedCurrency = currenciesList[selected];
          getData();
        });
      },
      children: currenciesList.map((map) => Text(map)).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoMod(
            name: 'BTC',
            value: cryptoResponse.btc,
            currency: selectedCurrency,
          ).card(),
          CryptoMod(
            name: 'ETH',
            value: cryptoResponse.eth,
            currency: selectedCurrency,
          ).card(),
          CryptoMod(
            name: 'LTC',
            value: cryptoResponse.ltc,
            currency: selectedCurrency,
          ).card(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
