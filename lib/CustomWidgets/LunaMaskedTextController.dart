import 'package:flutter/material.dart';

class LunaMaskedTextController extends TextEditingController {
  LunaMaskedTextController({String text, this.mask, Map<String, RegExp> translator})
      : super(text: text) {
    this.translator = translator ?? LunaMaskedTextController.getDefaultTranslator();

    this.addListener(() {
      this.updateText(this.text);
    });

    this.updateText(this.text);
  }

  String mask;

  Map<String, RegExp> translator;

  void updateText(String text) {
    this.text = this._applyMask(this.mask, text);
  }

  void updateMask(String mask) {
    this.mask = mask;
    this.updateText(this.text);
  }

  @override
   set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      this.selection = new TextSelection.fromPosition(
          new TextPosition(offset: (newText ?? '').length));
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return {
      'A': new RegExp(r'[A-Za-z]'),
      '0': new RegExp(r'[0-9]'),
      '@': new RegExp(r'[A-Za-z0-9]'),
      '*': new RegExp(r'.*')
    };
  }

  String _applyMask(String mask, String value) {
    String result = '';

    var maskCharIndex = 0;
    var valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      var maskChar = mask[maskCharIndex];
      var valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (this.translator.containsKey(maskChar)) {
        if (this.translator[maskChar].hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}

///
/// Mask for monetary values.
 ///
