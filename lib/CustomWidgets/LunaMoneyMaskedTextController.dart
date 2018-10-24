import 'package:flutter/material.dart';

class MyMoneyMaskedTextController extends TextEditingController {
  MyMoneyMaskedTextController(
      {double initialValue = 0.0,
        this.decimalSeparator = ',',
        this.thousandSeparator = '.',
        this.rightSymbol = '',
        this.leftSymbol = ''}) {
    _validateConfig();

    this.addListener(() {
      this.updateValue(this.numberValue);
    });

    this.updateValue(initialValue);
  }

  final String decimalSeparator;
  final String thousandSeparator;
  final String rightSymbol;
  final String leftSymbol;

  // this is the maximum supported for double values.
  final int _maxLength = 19;

  void updateValue(double value) {
    String masked = this._applyMask(value);

    if (masked.length > _maxLength) {
      masked = masked.substring(0, _maxLength);
    }

    if (rightSymbol.length > 0) {
      masked += rightSymbol;
    }

    if (leftSymbol.length > 0) {
      masked = leftSymbol + masked;
    }

    if (masked != this.text) {
      this.text = masked;

      var cursorPosition = super.text.length - this.rightSymbol.length;
      this.selection = new TextSelection.fromPosition(
          new TextPosition(offset: cursorPosition));
    }
  }

  double get numberValue => double.parse(_getSanitizedText(this.text)) / 100.0;

//  @override
//  set text(String newText) {
//    String formattedText = "";
//
//    if (newText.length <= _maxLengthForNumbers) {
//      formattedText = newText;
//    } else {
//      formattedText = newText.substring(0, _maxLengthForNumbers);
//    }
//
//    super.text = formattedText + "${this.rightSymbol}";
//
//    var cursorPosition = super.text.length - this.rightSymbol.length;
//
//    this.selection = new TextSelection.fromPosition(
//        new TextPosition(offset: cursorPosition));
//  }

  _validateConfig() {
    bool rightSymbolHasNumbers = _getOnlyNumbers(this.rightSymbol).length > 0;

    if (rightSymbolHasNumbers) {
      throw new ArgumentError("rightSymbol must not have numbers.");
    }
  }

  String _getSanitizedText(String text) {
    String cleanedText = text;

    var valuesToSanitize = [this.thousandSeparator, this.decimalSeparator];

    valuesToSanitize.forEach((val) {
      cleanedText = cleanedText.replaceAll(val, '');
    });

    cleanedText = _getOnlyNumbers(cleanedText);

    return cleanedText;
  }

  String _getOnlyNumbers(String text) {
    String cleanedText = text;

    var onlyNumbersRegex = new RegExp(r'[^\d]');

    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');

    return cleanedText;
  }

  String _applyMask(double value) {
    String textRepresentation =
    value.toStringAsFixed(2).replaceAll('.', this.decimalSeparator);

    List<String> numberParts = [];

    for (var i = 0; i < textRepresentation.length; i++) {
      numberParts.add(textRepresentation[i]);
    }

    const lengthsWithThousandSeparators = [6, 10, 14, 18];

    for (var i = 0; i < lengthsWithThousandSeparators.length; i++) {
      var l = lengthsWithThousandSeparators[i];

      if (numberParts.length > l) {
        numberParts.insert(numberParts.length - l, this.thousandSeparator);
      } else {
        break;
      }
    }

    String numberText = numberParts.join('');

    return numberText;
  }
}