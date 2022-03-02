import 'package:flutter/material.dart';
import 'package:study_flutter_credit_card_validation/app/pages/credit_card_validation/widgets/credit_card_form.dart';

class CreditCardValidationPage extends StatelessWidget {
  const CreditCardValidationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Credit Card'),
      ),
      body: const CreditCardForm(),
    );
  }
}
