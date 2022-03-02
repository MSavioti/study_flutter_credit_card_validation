import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_flutter_credit_card_validation/app/shared/input_formatters/date_input_formatter.dart';
import 'package:study_flutter_credit_card_validation/app/shared/models/credit_card.dart';
import 'package:study_flutter_credit_card_validation/app/shared/utils/card_utils.dart';
import 'package:study_flutter_credit_card_validation/app/shared/utils/string_utils.dart';

class CreditCardForm extends StatefulWidget {
  const CreditCardForm({Key? key}) : super(key: key);

  @override
  State<CreditCardForm> createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  final GlobalKey<FormState> _paymentFormKey = GlobalKey<FormState>();
  final int _creditCardNumbersLimit = 19;
  final int _dateMonthDigitsLimit = 4;
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final SizedBox _divider = const SizedBox(height: 24.0);

  int _month = 0;
  int _year = 0;
  bool _isCardValid = false;
  bool _hasAttemptedValidation = false;
  MaterialStateProperty<Color>? _submitButtonColor;

  void _submitForm() {
    setState(() {
      _hasAttemptedValidation = true;
    });

    if (_paymentFormKey.currentState!.validate()) {
      final CreditCard _card = CreditCard(
        number: _numberController.text,
        holderName: _nameController.text,
        expirationMonth: _month,
        expirationYear: _year,
      );

      setState(() {
        _isCardValid = true;
      });

      print('Valid card! $_card');
    } else {
      setState(() {
        _isCardValid = false;
      });
    }

    _updateSubmitButtonColor();
  }

  void _updateSubmitButtonColor() {
    MaterialStateProperty<Color>? color = MaterialStateProperty.all(Colors.orange);

    if (!_hasAttemptedValidation) {
      color = MaterialStateProperty.all(Colors.blue);
    }

    if (_isCardValid) {
      color = MaterialStateProperty.all(Colors.green);
    }

    setState(() {
      _submitButtonColor = color;
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    _cvvController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _paymentFormKey,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            // Card number
            TextFormField(
              controller: _numberController,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(Icons.credit_card),
                hintText: 'Card number',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(_creditCardNumbersLimit),
              ],
              onSaved: (String? value) {
                if (value != null && value.isNotEmpty) {
                  _numberController.text = CardUtils.normalizeCardNumber(value);
                }
              },
              validator: CardUtils.validateCardNumber,
            ),
            _divider,
            // Card holder's name
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Card holder\'s name',
              ),
              onSaved: (String? value) {
                if (value != null && value.isNotEmpty) {
                  _nameController.text = value;
                }
              },
              validator: StringUtils.validateString,
            ),
            // _divider,
            // // CVV
            // TextFormField(
            //   controller: _cvvController,
            //   keyboardType: TextInputType.text,
            //   decoration: const InputDecoration(
            //     icon: Icon(Icons.lock),
            //     hintText: 'Security code',
            //   ),
            //   inputFormatters: [
            //     FilteringTextInputFormatter.digitsOnly,
            //     LengthLimitingTextInputFormatter(_cvvLength),
            //   ],
            //   onSaved: (String? value) {
            //     final String _value = value ?? '';
            //     final int _parsedCVV = int.tryParse(_value) ?? 0;

            //     if (_parsedCVV != 0) {
            //       _cvvController.text = '$_parsedCVV';
            //     }
            //   },
            //   validator: CardUtils.validateCVV,
            // ),
            _divider,
            // Expiration date
            TextFormField(
              controller: _dateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Expiration date (MM/YY)',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(_dateMonthDigitsLimit),
                CardMonthInputFormatter(),
              ],
              onSaved: (String? value) {
                final List<int> _expirationDate =
                    CardUtils.extractMonthYearFromDate(value);

                if (_expirationDate.isNotEmpty) {
                  _month = _expirationDate[0];
                  _year = _expirationDate[1];
                }
              },
              validator: CardUtils.validateMonthYearDate,
            ),
            const Spacer(),
            // Submit button
            // if (_isCardValid)
            ElevatedButton(
              onPressed: _submitForm,
              child: _isCardValid
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Validated!',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(Icons.check_circle_outline),
                      ],
                    )
                  : const Text(
                      'Validate card',
                      style: TextStyle(color: Colors.white),
                    ),
              style: ButtonStyle(
                backgroundColor: _submitButtonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
