import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import './mymaskedtext.dart';
import './lunamaskedtextcontroller.dart';

import '../globals/functions.dart';
// import 'package:intl/intl.dart' show DateFormat;
// import 'package:flutter/services.dart' show TextInputFormatter;

// import 'package:masked_text/masked_text.dart';
// LunaTextDateFieldState _globalState = new LunaTextDateFieldState();

class LunaTextDateField extends StatefulWidget {
  LunaTextDateField(
      {Key key,
      this.label,
      this.initialDate,
      this.enabled = true,
      this.showPickButton = true,
      this.showDay = true,
      this.showMonth = true,
      this.showYear = true,
      this.editingControllerYear,
      this.editingControllerDay,
      this.textStyleAll,
      this.onChanged})
      : super(key: key);
  // final Key key = new GlobalKey();
  final ValueChanged<String> onChanged;
  final DateTime initialDate;
  final String label;
  final bool showDay;
  final bool showMonth;
  final bool showYear;
  final bool enabled;
  final bool showPickButton;
  // String generatedDateText;
  final TextEditingController editingControllerYear;
  final TextEditingController editingControllerDay;
  final TextStyle textStyleAll;

  @override
  LunaTextDateFieldState createState() => new LunaTextDateFieldState();
  //_MyAppBarButtonState createState() => new _MyAppBarButtonState();

  //_LunaTextDateFieldState createState() => _LunaTextDateFieldState();
  // GlobalKey<_LunaTextDateFieldState> myWidgetStateKey = new GlobalKey<_LunaTextDateFieldState>();

}

class LunaTextDateFieldState extends State<LunaTextDateField> {
  String yyyysmmsdd;
  final _dayKey = new GlobalKey();
  final _yearKey = new GlobalKey();

  // final _monthNameKey = new GlobalKey();

  TextEditingController controllerDay;
  TextEditingController controllerYear;
  TextStyle textStyleAll;

  @override
  void initState() {
    super.initState();
    _setEditingControllers();
    textStyleAll = this.widget.textStyleAll;
    if (textStyleAll == null) {
      textStyleAll = new TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          textBaseline: TextBaseline.alphabetic);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Additional code
  }

  @override
  void dispose() {
    // Additional disposal code

    super.dispose();
  }

  void _setEditingControllers() {
    if (widget.editingControllerDay == null) {
      // final translator = {'#': new RegExp(r"^([1-9]|[12][0-9]|3[01])$")};
      setState(() {
        this.controllerDay =
            new LunaMaskedTextController(mask: "00", text: "01");
        this.controllerYear =
            new LunaMaskedTextController(mask: "0000", text: "1900");
        // _labelDate = widget.label;
        if (widget.initialDate != null) {
          setText(widget.initialDate);
        } else {}
      });
    }
  }

  List<String> _monthNames = [
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
  String _fullDateText = "";
  int _monthNum = 1;
  // String _dateErrorMsg = "";
  // String _labelDate;
  // List<String> _passedDateText = [];

  // TextEditingController editingControllerDay = new TextEditingController();
  // TextEditingController editingControllerYear = new TextEditingController();
  // TextEditingController editingControllerYear = widget.editingControllerYear;

  // String get fullDateText => _fullDateText;
  // set fullDateText(String value) => _passedDateText = value.split("-").toList();()

  void setText(val) {
    if (_dateIsValid(val)) {
      DateTime dt = DateTime.parse(val);
      print('date : ' + dt.toString());
      // widget.editingControllerYear.text = dt.year.toString();
      // widget.editingControllerDay.text = dt.day.toString();
      controllerYear.text = dt.year.toString();
      controllerDay.text = dt.day.toString();
      String selmonth = this._monthNames.elementAt(dt.month - 1);

      setState(() {
        _monthName = selmonth;
        _monthNum = dt.month;
        _day = dt.day.toString();
        _year = dt.year.toString();
      });
      // setState(() {
      //   _day = dt.day.toString();
      //  // _monthName = dt.month.toString();S
      //   _year = dt.year.toString();
      // });

      // controllerDay.text=_day;SS
      // print(_day);
      // print(_monthName);
      // print(_year);
      // this.editingControllerDay.text=_day.toString();
      // this.editingControllerYear.text=_year.toString();

    }
  }

  bool _dateIsValid(String val) {
    print(val);
    try {
      // DateTime.tryParse(formattedString)

      DateTime.parse(val);

      // print(_dt.toIso8601String());
      print("$val is a valid date !!!");
      return true;
    } catch (e) {
      print('$val is not a valid date !!!');
      return false;
    }
  }

  void _handleOnChanged() {
    _setDateValue();
    widget.onChanged(_fullDateText);
    // widget.generatedDateText = _fullDateText;
    // print(_passedDateText);
  }

  void _chooseMonth(String value) {
    setState(() {
      _monthName = value;
      _monthNum = this._monthNames.indexOf(value) + 1;
      _handleOnChanged();
    });
  }

  void _setDateValue() {
    setState(() {
      _fullDateText = _year +
          "-" +
          Functions.getStrPadLeft(_monthNum.toString(), 2) +
          "-" +
          Functions.getStrPadLeft(_day, 2);
      // if (!_dateIsValid(_fullDateText)) {
      //   _dateErrorMsg = "Enter a valid date";
      // } else {
      //   _dateErrorMsg = "Date is valid " + _fullDateText;
      // }
    });
  }

  void _setDayValue(String val) {
    setState(() {
      _day = val;
      _handleOnChanged();
    });
  }

  void _setYearValue(String val) {
    setState(() {
      _year = val;
      _handleOnChanged();
    });
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
      //parent.focusNode.unfocus();
      print(date);
      if (date != null) {
        setText(date.toIso8601String());
      }
    });
  }

  String _getThisDate() {
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
    print(DateTime.parse(_getThisDate()));
    var date = await showDatePicker(
        context: context,
        firstDate: DateTime.parse("1900-01-01"),
        lastDate: DateTime.parse("2100-12-31"),
        initialDate: DateTime.parse(_getThisDate()),
        initialDatePickerMode: DatePickerMode.day,
        //locale: Locale("id"),
        //selectableDayPredicate: SelectableDayPredicate.(),
        textDirection: TextDirection.ltr);
    if (date != null) {
      date = startOfDay(date);
      // if (!parent.dateOnly) {
      //   final time = await showTimePicker(
      //     context: context,
      //     initialTime: parent.initialTime,
      //   );
      //   if (time != null) {
      //     date = date.add(Duration(hours: time.hour, minutes: time.minute));
      //   }
      // }
    }

    return date;
  }

  // setErrorText(String val) {
  //   setState(() {
  //     _dateErrorMsg = val;
  //   });
  // }

  // clearErrorText() {
  //   setState(() {
  //     _dateErrorMsg = null;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return dateRow();
    // Row(children: <Widget>[
    //   Stack(
    //     alignment: const Alignment(0.0, -1.9),
    //     children: [
    //       Container(
    //         decoration: BoxDecoration(
    //             // color: const Color(0x0),
    //             border: Border.all(
    //               color: Colors.teal,
    //               width: 1.0,
    //             ),
    //             borderRadius: BorderRadius.all(Radius.circular(20.0))),
    //         child: dateRow(),
    //       ),
    //       // Container(
    //       //   padding: const EdgeInsets.all(3.0),
    //       //   decoration: BoxDecoration(
    //       //       color: Colors.white,
    //       //       border: Border.all(
    //       //         color: Colors.teal,
    //       //         width: 1.0,
    //       //       ),
    //       //       borderRadius: BorderRadius.all(Radius.circular(10.0))),
    //       //   child: Text(
    //       //     _labelDate,
    //       //     style: TextStyle(
    //       //       color: Colors.blue,
    //       //     ),
    //       //   ),
    //       // ),
    //     ],
    //   ),
    //   // Column(
    //   //   children: <Widget>[
    //   //     Text(
    //   //       _dateErrorMsg,
    //   //       style: TextStyle(color: Colors.red),
    //   //     ),
    //   //   ],
    //   // )
    // ]);
  }

  Row dateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.showDay
            ? SizedBox(
                width: (this.widget.enabled) ? 40.0 : 30.0,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: dayField()))
            : new Container(),

        widget.showMonth
            ? SizedBox(
                width: (this.widget.enabled) ? 70.0 : 30.0, //70.0,
                // height: 20.0,
                child: (widget.enabled)
                    ? monthDropDown
                    : Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(_monthName),
                      ),
              )
            : Container(),

        widget.showYear
            ? new SizedBox(
                width: 50.0,
                child: yearField(),
                // child: new FittedBox(
                //   fit: BoxFit.contain, // otherwise the logo will be tiny
                //   child: const FlutterLogo(),
                // ),
              )
            : Container(),
        new SizedBox(
          width: 50.0,
          child: (widget.showPickButton)
              ? new IconButton(
                  icon: new Icon(Icons.date_range),
                  onPressed: _openDateDialog,
                )
              : Container(),
          // child: new FittedBox(
          //   fit: BoxFit.contain, // otherwise the logo will be tiny
          //   child: const FlutterLogo(),
          // ),
        ),
        //  new SizedBox(
        //   width: 75.0,
        //   child: new TextField(

        //     // controller: widget.editingControllerYear,
        //   // inputFormatters: [WhitelistingTextInputFormatter(RegExp("[a-zA-Z]"))],
        //     inputFormatters: [WhitelistingTextInputFormatter(RegExp(r"^([1-9]|[12][0-9]|3[01])$"))],

        //     keyboardType: TextInputType.numberWithOptions( decimal: false),
        //     decoration: new InputDecoration(labelText: "Day"),

        //     maxLength: 2,
        //     maxLengthEnforced: true,
        //     maxLines: 1,
        //     onChanged: (String val) {
        //       _setYearValue(val);
        //     },
        //     onEditingComplete: () => _setDateValue(),
        //   ),
        // child: new FittedBox(
        //   fit: BoxFit.contain, // otherwise the logo will be tiny
        //   child: const FlutterLogo(),
        // ),
        // ),
      ],
    );
  }

  Widget get monthDropDown {
    return new DropdownButton(
      onChanged: (String value) {
        _chooseMonth(value);
        _setDateValue();
      },
      style: textStyleAll,
      hint: new Text("Month"),
      value: _monthName,
      items: _monthNames.map((String value) {
        return new DropdownMenuItem(
          value: value,
          child: new Text(
            value,
            style: textStyleAll,
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  TextField yearField() {
    return new TextField(
      enabled: widget.enabled,
      key: _yearKey,
      style: textStyleAll,
      controller: controllerYear,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      decoration: new InputDecoration(
          // labelText: "Year",
          counterStyle: TextStyle(color: Colors.transparent)),
      textAlign: TextAlign.center,
      // maxLength: 4,
      // maxLengthEnforced: true,
      maxLines: 1,
      onChanged: (String val) {
        _setYearValue(val);
      },
      onEditingComplete: () => _setDateValue(),
    );
  }

  TextField dayField() {
    return new TextField(
      enabled: widget.enabled,
      key: _dayKey,
      // textAlign: TextAlign.center,
      style: textStyleAll,
      controller: controllerDay,
      inputFormatters: [
        WhitelistingTextInputFormatter(RegExp(r"^([1-9]|[12][0-9]|3[01])$"))
      ],
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      decoration: new InputDecoration(
          //labelText: "Day",
          counterStyle: TextStyle(color: Colors.transparent)),
      // maxLength: 2,
      // maxLengthEnforced: true,
      maxLines: 1,
      onChanged: (String val) {
        _setDayValue(val);
      },
      onEditingComplete: () {
        _setDateValue();
      },
    );
  }
}
