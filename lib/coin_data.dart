import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const apiUrl = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey1 = 'AD556545-CC80-4A0A-9933-BD616B2244B5';
const apiKey2 = 'EFBC7481-DF59-4704-BE76-24485122D150';

class CryptoResponse {
  final String btc;
  final String eth;
  final String ltc;

  const CryptoResponse({required this.btc, required this.eth, required this.ltc});

  factory CryptoResponse.fromJson(Map<String, dynamic> json) {
    return CryptoResponse(
      btc: json['BTC'],
      eth: json['ETH'],
      ltc: json['LTC'],
    );
  }
}

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      String requestURL = '$apiUrl/$crypto/$selectedCurrency?apikey=$apiKey2';
      http.Response response = await http.get(Uri.parse(requestURL));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return CryptoResponse.fromJson(cryptoPrices);
  }
}
