import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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

const kCoinApiKey = '313B0C2E-2E1F-4067-8687-FF5565902A71';

class CoinData {
  String baseURL = 'https://rest.coinapi.io';

  Future<dynamic> _get(String url) async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Map jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> getExchangeRates(
      {String assetIdBase, String assetIdQuote}) async {
    Map response = await _get(
        '$baseURL/v1/exchangerate/$assetIdBase/$assetIdQuote?apikey=$kCoinApiKey');
    if (response != null) {
      return response['rate'];
    }
    return '?';
  }
}
