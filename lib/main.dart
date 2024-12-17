import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CurrencyCalculator(),
    );
  }
}

class CurrencyCalculator extends StatefulWidget {
  const CurrencyCalculator({Key? key}) : super(key: key);

  @override
  _CurrencyCalculatorState createState() => _CurrencyCalculatorState();
}

class _CurrencyCalculatorState extends State<CurrencyCalculator> {
  String? fromCurrency;
  String? toCurrency;
  String result = "";
  double inputAmount = 0.0;

  final currencies = [
    {"code": "USD", "name": "United States Dollar"},
    {"code": "CAD", "name": "Canadian Dollar"},
    {"code": "EURO", "name": "Euro"},
    {"code": "LBP", "name": "Lebanese Pound"},
  ];

  final baseRates = {
    "USD": 1.0,
    "CAD": 1.35,
    "EURO": 0.90,
    "LBP": 89000.0,
  };

  double getRate(String from, String to) {
    if (from == to) return 1.0;
    return (1 / baseRates[from]!) * baseRates[to]!;
  }

  void calculateResult() {
    if (fromCurrency != null && toCurrency != null) {
      double rate = getRate(fromCurrency!, toCurrency!);
      setState(() {
        result =
            "${inputAmount.toStringAsFixed(2)} $fromCurrency = ${(inputAmount * rate).toStringAsFixed(2)} $toCurrency";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Currency Calculator'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CurrencyColumn(
                    title: "From",
                    selectedCurrency: fromCurrency,
                    onCurrencySelected: (currency) {
                      setState(() {
                        fromCurrency = currency;
                        if (currency == toCurrency) toCurrency = null;
                      });
                    },
                    disabledCurrency: toCurrency,
                    currencies: currencies,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CurrencyColumn(
                    title: "To",
                    selectedCurrency: toCurrency,
                    onCurrencySelected: (currency) {
                      setState(() {
                        toCurrency = currency;
                        if (currency == fromCurrency) fromCurrency = null;
                      });
                    },
                    disabledCurrency: fromCurrency,
                    currencies: currencies,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Enter amount"),
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    inputAmount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateResult,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent),
              child: const Text("Calculate",
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  result,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CurrencyColumn extends StatelessWidget {
  final String title;
  final String? selectedCurrency;
  final String? disabledCurrency;
  final List<Map<String, String>> currencies;
  final Function(String) onCurrencySelected;

  const CurrencyColumn({
    Key? key,
    required this.title,
    required this.selectedCurrency,
    required this.disabledCurrency,
    required this.currencies,
    required this.onCurrencySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        for (var currency in currencies)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: disabledCurrency == currency['code']
                      ? null
                      : () => onCurrencySelected(currency['code']!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCurrency == currency['code']
                        ? Colors.blue
                        : Colors.lightBlueAccent.shade100,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: Text(currency['code']!,
                      style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 5),
                Text(currency['name']!,
                    style: const TextStyle(color: Color(0xff7f8f9c))),
              ],
            ),
          ),
      ],
    );
  }
}
