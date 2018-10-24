import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/services.dart'
    show TextInputFormatter, WhitelistingTextInputFormatter;
// import './lunamaskedtextcontroller.dart';
import '../globals/functions.dart';

/// A [FormField<DateTime>] that uses a [TextField] to manage input.
/// If it gains focus while empty, the date and/or time pickers will be shown
/// to the user.
class LunaDateFormFieldDropDown extends FormField<String> {
  /// Whether to show the time picker after a date has been chosen.
  /// To show the time picker only, use [TimePickerFormField].
  final bool dateOnly;

  /// For representing the date as a string e.g.
  /// `DateFormat("EEEE, MMMM d, yyyy 'at' h:mma")`
  /// (Sunday, June 3, 2018 at 9:24pm)
  // final DateFormat format;

  /// Where the calendar will start when shown. Defaults to the current date.
  final DateTime initialDate;

  /// The earliest choosable date. Defaults to 1900.
  final DateTime firstDate;

  /// The latest choosable date. Defaults to 2100.
  final DateTime lastDate;

  /// The initial time prefilled in the picker dialog when it is shown.
  final TimeOfDay initialTime;

  /// If defined the TextField [decoration]'s [suffixIcon] will be
  /// overridden to reset the input using the icon defined here.
  /// Set this to `null` to stop that behavior. Defaults to [Icons.close].
  // final IconData resetIcon;

  /// For validating the [DateTime]. The value passed will be `null` if
  /// [format] fails to parse the text.
  final FormFieldValidator<String> validator;

  /// Called when an enclosing form is saved. The value passed will be `null`
  /// if [format] fails to parse the text.
  final FormFieldSetter<String> onSaved;

  /// Corresponds to the [showDatePicker()] parameter. Defaults to
  /// [DatePickerMode.day].
  final DatePickerMode initialDatePickerMode;

  /// Corresponds to the [showDatePicker()] parameter.
  final Locale locale;

  /// Corresponds to the [showDatePicker()] parameter.
  final bool Function(DateTime) selectableDayPredicate;

  /// Corresponds to the [showDatePicker()] parameter.
  final TextDirection textDirection;

  /// Called when an enclosing form is submitted. The value passed will be
  /// `null` if [format] fails to parse the text.
  final ValueChanged<String> onFieldSubmitted;
  final TextEditingController controller;
  final FocusNode focusNode;
  final InputDecoration decoration;

  final TextInputType keyboardType;
  final TextStyle style;
  final TextAlign textAlign;
  final String initialValue;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final bool maxLengthEnforced;
  final int maxLines;
  final int maxLength;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final bool showDay;
  final bool showMonth;
  final bool showYear;
  final bool showPickButton;

  /// Called whenever the state's value changes, e.g. after picker value(s)
  /// have been selected or when the field loses focus. To listen for all text
  /// changes, use the [controller] and [focusNode].
  final ValueChanged<String> onChanged;

  LunaDateFormFieldDropDown(
      {Key key,
      //this.format,
      this.dateOnly: false,
      this.onChanged,
      //this.resetIcon: Icons.close,
      DateTime initialDate,
      DateTime firstDate,
      DateTime lastDate,
      this.initialTime: const TimeOfDay(hour: 12, minute: 0),
      this.validator,
      this.onSaved,
      this.onFieldSubmitted,
      bool autovalidate: false,
      DatePickerMode initialDatePickerMode,
      this.locale,
      this.selectableDayPredicate,
      this.textDirection,

      // TextField properties
      TextEditingController controller,
      FocusNode focusNode,
      this.initialValue,
      @required this.decoration,
      this.keyboardType: TextInputType.text,
      this.style,
      this.textAlign: TextAlign.start,
      this.autofocus: false,
      this.obscureText: false,
      this.autocorrect: true,
      this.maxLengthEnforced: true,
      this.enabled = true,
      this.maxLines: 1,
      this.maxLength,
      this.inputFormatters,
      this.showDay = true,
      this.showMonth = true,
      this.showYear = true,
      this.showPickButton = true})
      : controller = controller ?? TextEditingController(text: initialValue),
        focusNode = focusNode ?? FocusNode(),
        initialDate = initialDate ?? DateTime.now(),
        firstDate = firstDate ?? DateTime(1900),
        lastDate = lastDate ?? DateTime(2100),
        initialDatePickerMode = initialDatePickerMode ?? DatePickerMode.day,
        super(
            key: key,
            autovalidate: autovalidate,
            validator: validator,
            onSaved: onSaved,
            builder: (FormFieldState<String> state) {});

  @override
  _LunaDateFormFieldState createState() => _LunaDateFormFieldState(this);
}

// String _toString(DateTime date, DateFormat formatter) {
//   if (date != null) {
//     try {
//       return formatter.format(date);
//     } catch (e) {
//       debugPrint('Error formatting date: $e');
//     }
//   }
//   return '';
// }

class _LunaDateFormFieldState extends FormFieldState<String> {
  final LunaDateFormFieldDropDown parent;
  // bool showResetIcon = false;
  //String _previousValue = '';

  _LunaDateFormFieldState(this.parent);

  List<String> _monthNames = [
    "",
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "Mei",
    "Jun",
    "Jul",
    "Ags",
    "Sep",
    "Okt",
    "Nov",
    "Des"
  ];
  String _monthName = "Jan";
  String _day = "";
  String _year = "";
  // String _fullDateText = "";
  int _monthNum = 1;

  TextEditingController controllerYear = new TextEditingController();
  TextEditingController controllerDay = new TextEditingController();

  @override
  void initState() {
    super.initState();
    parent.focusNode.addListener(focusChanged);
    _dayFocusNode.addListener(focusChanged);
    _yearFocusNode.addListener(focusChanged);
    parent.controller.addListener(inputChanged);

    if (parent.controller != null && parent.controller.text != null) {
      DateTime dt = Functions.convertStringToDate(parent.controller.text);
      if (dt != null) {
        controllerYear.text = dt.year.toString();
        controllerDay.text = dt.day.toString();
    
        _monthName =  this._monthNames.elementAt(dt.month);
        _monthNum = dt.month;
        _day = dt.day.toString();
        _year = dt.year.toString();
        return;
      }
    }
    controllerYear.text = "";
    controllerDay.text = "";
    String selmonth = "";
    _monthName = selmonth;
    _monthNum = 0;
    _day = "";
    _year = "";
  }

  @override
  void dispose() {
    parent.controller.removeListener(inputChanged);
    parent.focusNode.removeListener(focusChanged);
    _dayFocusNode.removeListener(focusChanged);
    _yearFocusNode.removeListener(focusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return fieldContainer;
  }

  Widget get fieldContainer {
    return dateRowStacked;

    // Container( child: Column( children: <Widget>[
    //   Text("Label Text")
    //   ,Expanded(child: dateRow),
    //   Text("Error Text")
    // ], ))
    // ;
    //Container(width: MediaQuery.of(context).size.width ,child: InputDecorator(child: TextField(controller: controllerYear), decoration: InputDecoration( errorText: "error", labelText: "Isi sesuatu , ok ?", helperText: "help"),) );
  }

  Widget get dateRowStacked {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Padding(
            child: labelTextWidget,
            padding: EdgeInsets.only(left: _calculateLabelPos()),
          ),
          Padding(
            child: dateRow,
            padding: EdgeInsets.only(top: 5.0),
          ),
          errorTextWidget,
        ],
      ),
    );
  }

  Widget get labelTextWidget {
    return (parent.decoration != null && parent.decoration.labelText != null)
        ? Text(parent.decoration.labelText,
            textAlign: parent.textAlign,
            // style: (parent.decoration.labelStyle != null)
            //     ? parent.decoration.labelStyle.copyWith( color: _labelColor)
            //     : TextStyle(fontSize: 12.0, color: Colors.grey,   )
            style: TextStyle(color: _labelColor, fontSize: 12.0))
        : Text("");
  }

  Widget get errorTextWidget {
    return (parent.decoration != null && parent.decoration.errorText != null)
        ? Text(parent.decoration.errorText,
            style: (parent.decoration.errorStyle != null)
                ? parent.decoration.errorStyle
                : TextStyle(fontSize: 8.0, color: Colors.grey))
        : Text("");
  }

  Widget get dateRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        parent.showDay
            ? SizedBox(
                width: _calculateDayPos(),
                child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: dayField()))
            : new Container(),
        parent.showMonth
            ? SizedBox(
                width: (this.parent.enabled) ? 70.0 : 30.0,
                // height: 20.0,
                child: (parent.enabled)
                    ? monthDropDown
                    : Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(_monthName),
                      ),
              )
            : Container(),
        parent.showYear
            ? new SizedBox(
                width: 50.0,
                child: yearField(),
              )
            : Container(),
        new SizedBox(
          width: 50.0,
          child: (parent.showPickButton)
              ? new IconButton(
                  icon: new Icon(Icons.date_range),
                  onPressed: _openDateDialog,
                )
              : Container(),
        ),
      ],
    );
  }

  Widget get monthDropDown {
    return new DropdownButton(
      onChanged: (String value) {
        _chooseMonth(value);
        setValue(getFullDateText());
      },
      style: parent.style,
      hint: new Text("Month"),
      value: _monthName,
      items: _monthNames.map((String value) {
        return new DropdownMenuItem(
          value: value,
          child: new Text(
            value,
            style: parent.style,
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  FocusNode _yearFocusNode = new FocusNode();
  TextField yearField() {
    return new TextField(
      enabled: parent.enabled,
      focusNode: _yearFocusNode,
      style: parent.style,
      controller: controllerYear,
      keyboardType: TextInputType.number,
      //decoration: parent.decoration,
      // decoration: new InputDecoration(
      //     // labelText: "Year",
      //     counterStyle: TextStyle(color: Colors.transparent)),
      textAlign: TextAlign.left,
      // maxLength: 4,
      // maxLengthEnforced: true,
      maxLines: 1,
      onChanged: (String val) {
        _setYearValue(val);
      },
      onEditingComplete: () => setValue( getFullDateText()),
    );
  }

  FocusNode _dayFocusNode = new FocusNode();

  TextField dayField() {
    return new TextField(
      enabled: parent.enabled,
      //autofocus: true,
      focusNode: _dayFocusNode,
      // textAlign: TextAlign.center,
      decoration: InputDecoration(icon: parent.decoration.icon),
      style: parent.style,
      controller: controllerDay,
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp(r"^([1-9]|[12][0-9]|3[01])$"))
      ],
      //  inputFormatters: [
      //         new WhitelistingTextInputFormatter(
      //             new RegExp(r'^[()\d -]{1,15}$')),
      //       ],
      //keyboardType: TextInputType.number,
      // decoration: new InputDecoration(
      //     //labelText: "Day",
      //     counterStyle: TextStyle(color: Colors.transparent)),
      // maxLength: 2,
      // maxLengthEnforced: true,
      maxLines: 1,
      onChanged: (String val) {
        _setDayValue(val);
      },
      onEditingComplete: () {
        setValue( getFullDateText());
      },
    );
  }

  Color _labelColor = Colors.grey;
  void focusChanged() {
    setState(() {
      if (_dayFocusNode.hasFocus || _yearFocusNode.hasFocus) {
        try {
          _labelColor = Theme.of(context).textSelectionColor;
           
        } catch (err) {
          _labelColor = Colors.teal;
        } finally {
          // _labelColor = Colors.teal;
        }
        //Theme.of(context).inputDecorationTheme.labelStyle.color;
      } else {
        try {
          _labelColor = Theme.of(context).textTheme.caption.color;
           
        } catch (err) {
          _labelColor = Colors.grey;
        } finally {
          // _labelColor = Colors.teal;
        }
      }
    });
  }

  void inputChanged() {
    // if (parent.controller.text.isEmpty &&
    //     _previousValue.isEmpty &&
    //     parent.focusNode.hasFocus) {
    //   getDateTimeInput(context).then((date) {
    //     parent.focusNode.unfocus();
    //     setState(() {
    //       parent.controller.text = _toString(date, parent.format);
    //       // setValue(_toString(date, parent.format);
    //       setValue(Functions.getDateStringYYYYMMDD(date));
    //     });
    //   });
    // }
    // else if (parent.resetIcon != null &&
    //     parent.controller.text.isEmpty == showResetIcon) {
    //   setState(() => showResetIcon = !showResetIcon);
    //   // parent.focusNode.unfocus();
    // }
    // _previousValue = parent.controller.text;
    //if (!parent.focusNode.hasFocus) {
    setValue(getFullDateText());
    //}
  }

  bool _dateIsValid(String val) {
    print(val);
    try {
      DateTime.parse(val);

      // print(_dt.toIso8601String());
      print("$val is a valid date !!!");
      return true;
    } catch (e) {
      print('$val is not a valid date !!!');
      return false;
    }
  }

  void _chooseMonth(String value) {
    setState(() {
      _monthName = value;
      _monthNum = this._monthNames.indexOf(value);
    });
    setValue(getFullDateText());
  }

  

  void _setDayValue(String val) {
    setState(() {
      _day = val;
    });
    setValue(getFullDateText());
  }

  void _setYearValue(String val) {
    setState(() {
      _year = val;
    });
    setValue(getFullDateText());
  }

  // String _validateDay(String val) {
  //   var _tday = int.tryParse(val);
  //   if (_tday == null) {
  //     return 'Day must not be blank and must be numeric';
  //   }
  //   if (_tday < 1 || _tday > 31) {
  //     return 'Day must be between 1 to 31';
  //   }
  //   return null;
  // }

  _openDateDialog() {
    print("open");
    getDateTimeInput(context).then((date) {
      parent.focusNode.unfocus();
      print(date);
      if (date != null) {
        setState(() {
          _year = date.year.toString();
          _monthNum = date.month;

          _day = date.day.toString();
           _monthName=this._monthNames.elementAt(date.month);
        });
      
        controllerDay.text= _day;
        controllerYear.text= _year;
        
   parent.controller.text =
        getFullDateText(); // this triggers inputChanged listener
        // setValue(parent.controller.text );
      }

      //setValue(Functions.getDateStringYYYYMMDD(date));
    });
  }

  String getFullDateText() {
    String _date;
    _date = this._year +
        "-" +
        Functions.getIntPadLeft(this._monthNum, 2) +
        "-" +
        Functions.getStrPadLeft(this._day, 2);
    print(_date);
    if (_dateIsValid(_date)) {
      print(_date);
      return _date;
    }
    return DateTime.now().year.toString() +
        "-" +
        Functions.getIntPadLeft(DateTime.now().month, 2) +
        "-" +
        Functions.getIntPadLeft(DateTime.now().day, 2);
  }

  DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);
  Future<DateTime> getDateTimeInput(BuildContext context) async {
    var _fullDateText = getFullDateText();
    print(_fullDateText);
    var date = await showDatePicker(
        context: context,
        // firstDate: DateTime.parse("1900-01-01"),
        // lastDate: DateTime.parse("2100-12-31"),
        // initialDate: DateTime.parse(_getThisDate()),
        // initialDatePickerMode: DatePickerMode.day,

        firstDate: parent.firstDate,
        lastDate: parent.lastDate,
        initialDate: (Functions.convertStringToDate(_fullDateText) != null)
            ? Functions.convertStringToDate(_fullDateText)
            : DateTime.now(),
        initialDatePickerMode: parent.initialDatePickerMode,
        locale: parent.locale,
        selectableDayPredicate: parent.selectableDayPredicate,
        textDirection: parent.textDirection);
    if (date != null) {
      date = startOfDay(date);
    }

    return date;
  }

  // String _toString(DateTime date, DateFormat formatter) {
  //   if (date != null) {
  //     try {
  //       return formatter.format(date);
  //     } catch (e) {
  //       debugPrint('Error formatting date: $e');
  //     }
  //   }
  //   return '';
  // }

  // DateTime _toDate(String string, DateFormat formatter) {
  //   if (string != null && string.isNotEmpty) {
  //     try {
  //       return formatter.parse(string);
  //     } catch (e) {
  //       debugPrint('Error parsing date: $e');
  //     }
  //   }
  //   return null;
  // }

  @override
  void setValue(String value) {
    super.setValue(value);
    if (parent.onChanged != null) parent.onChanged(value);
  }

  double _calculateDayPos() {
    double iconWidth =
        (parent.decoration != null && parent.decoration.icon != null)
            ? 40.0
            : 0.0;
    if (this.parent.enabled) {
      return iconWidth + 40.0;
    } else {
      return iconWidth + 30.0;
    }
  }

  double _calculateLabelPos() {
    double iconWidth =
        (parent.decoration != null && parent.decoration.icon != null)
            ? 40.0
            : 0.0;

    return iconWidth;
  }
}

/// END OF CODE

// Future<DateTime> getDateTimeInput(BuildContext context) async {
//   var date = await showDatePicker(
//       context: context,
//       firstDate: parent.firstDate,
//       lastDate: parent.lastDate,
//       initialDate: parent.initialDate,
//       initialDatePickerMode: parent.initialDatePickerMode,
//       locale: parent.locale,
//       selectableDayPredicate: parent.selectableDayPredicate,
//       textDirection: parent.textDirection);
//   if (date != null) {
//     date = startOfDay(date);
//     if (!parent.dateOnly) {
//       final time = await showTimePicker(
//         context: context,
//         initialTime: parent.initialTime,
//       );
//       if (time != null) {
//         date = date.add(Duration(hours: time.hour, minutes: time.minute));
//       }
//     }
//   }

//   return date;
// }
