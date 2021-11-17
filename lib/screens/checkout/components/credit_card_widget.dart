import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:sim_chefe_2021/models/credit_card.dart';

import 'card_back.dart';
import 'card_front.dart';

class CreditCardWidget extends StatefulWidget {

  CreditCardWidget(this.creditCard);

  final CreditCard creditCard;


  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final FocusNode numberFocus = FocusNode();
  final FocusNode dateFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode cvvFocus = FocusNode();



  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      actions: [
        KeyboardActionsItem(focusNode: numberFocus, displayDoneButton: false),
        KeyboardActionsItem(focusNode: dateFocus, displayDoneButton: false),
        KeyboardActionsItem(
          focusNode: nameFocus,
          toolbarButtons: [
            (_) {
              return GestureDetector(
                onTap: () {
                  cardKey.currentState!.toggleCard();
                  cvvFocus.requestFocus();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text('Continuar'),
                ),
              );
            }
          ]
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      autoScroll: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16,16,16,8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FlipCard(
              key: cardKey,
              direction: FlipDirection.HORIZONTAL,
              speed: 700,
              flipOnTouch: false,
              front: CardFront(
                creditCard: widget.creditCard,
                numberFocus: numberFocus,
                dateFocus: dateFocus,
                nameFocus: nameFocus,
                finished: (){
                  cardKey.currentState!.toggleCard();
                  cvvFocus.requestFocus();
                },
              ),
              back: CardBack(
                creditCard: widget.creditCard,
                cvvFocus: cvvFocus
              ),
            ),
            TextButton(
              onPressed: () {
                cardKey.currentState!.toggleCard();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                primary: Colors.white,

              ),
              child: Text('Virar cartão',),

            )
          ],
        )
      ),
    );
  }
}
