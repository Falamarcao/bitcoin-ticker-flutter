import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency = 'BRL';
  List<Widget> _listCryptoCoins;

  static List<Widget> initialState() {
    return [
      Container(
        child: CircularProgressIndicator(),
      ),
    ];
  }

//TODO: Refactor code - components
  DropdownButton<String> androidDropDown() {
    Iterable<DropdownMenuItem<String>> getDropdownItems() sync* {
      for (String currency in currenciesList) {
        yield DropdownMenuItem(
          child: Text(currency),
          value: currency,
        );
      }
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: getDropdownItems().toList(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          _listCryptoCoins = initialState();
        });
        _cryptoCoins().toList().then((val) async {
          setState(() {
            _listCryptoCoins = val;
          });
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    Iterable<Text> getPickerItems() sync* {
      for (String currency in currenciesList) {
        yield Text(currency);
      }
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          _listCryptoCoins = initialState();
        });
        _cryptoCoins().toList().then((val) async {
          setState(() {
            _listCryptoCoins = val;
          });
        });
      },
      children: getPickerItems().toList(),
    );
  }

  Stream<Card> _cryptoCoins() async* {
    var exchangeRate;

    for (String cryptoCoin in cryptoList) {
      exchangeRate = await coinData.getExchangeRates(
          assetIdBase: cryptoCoin, assetIdQuote: selectedCurrency);
      yield Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCoin = ${exchangeRate.toString()} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _listCryptoCoins = initialState();
    _cryptoCoins().toList().then((val) async {
      setState(() {
        _listCryptoCoins = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _listCryptoCoins)),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
