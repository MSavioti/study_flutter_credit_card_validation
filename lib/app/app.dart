import 'package:flutter/material.dart';
import 'package:study_flutter_credit_card_validation/app/pages/credit_card_validation/credit_card_validation_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreditCardValidationPage(),
    );
  }
}
