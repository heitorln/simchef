import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sim_chefe_2021/models/credit_card.dart';
import 'package:sim_chefe_2021/screens/checkout/components/card_text_field.dart';

class CardFront extends StatelessWidget {

  CardFront({required this.numberFocus, required this.dateFocus, required this.nameFocus, required this.finished, required this.creditCard});

  final dateFormatter = MaskTextInputFormatter(
    mask: '!#/####', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')}
  );

  final VoidCallback finished;

  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;

  final CreditCard creditCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 16,
      child: Container(
        height: 200,
        color: Colors.grey,//const Color(0xFF1B4B52),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CardTextField(
                    initialValue: creditCard.number,
                    title: 'Número',
                    hint: '0000 0000 0000 0000',
                    textInputType: TextInputType.number,
                    bold: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      CartaoBancarioInputFormatter()
                    ],
                    validator: (number) {
                      if(number?.length != 19) return 'Inválido';
                      else if(detectCCType(number!) == CreditCardType.unknown)
                        return 'Inválido';
                      return null;
                    },
                    onSubmitted: (_){
                      dateFocus.requestFocus();
                    },
                    focusNode: numberFocus,
                    onSaved: creditCard.setNumber,
                  ),
                  CardTextField(
                    initialValue: creditCard.expirationDate,
                    title: 'Validade',
                    hint: '11/2025',
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      dateFormatter
                    ],
                    validator: (date){
                      if(date?.length != 7) return 'Inválido';
                      return null;
                    },
                    onSubmitted: (_){
                      nameFocus.requestFocus();
                    },
                    focusNode: dateFocus,
                    onSaved: creditCard.setExpirationDate,
                  ),
                  CardTextField(
                    initialValue: creditCard.holder,
                    title: 'Titular',
                    hint: 'CAIO S CATARINO',
                    textInputType: TextInputType.text,
                    bold: true,
                    validator: (String? name) {
                      if(name == null) return 'Inválido';
                      return null;
                    },
                    inputFormatters: [],
                    onSubmitted: (_){
                      finished();
                    },
                    focusNode: nameFocus,
                    onSaved: creditCard.setholder,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
