// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import './SharedPrefsHelperStatic.dart';
import './global.dart';

import 'package:flutter/material.dart';

enum EnumServerAddr { virtual, device }
enum EnumPrefKeys { serverAddress }

class Functions {
  // Functions();

  static String getIntPadLeft(int num, int leadingZeroCount) {
    String str = num.toString();
    str = str.padLeft(leadingZeroCount, "0").substring(0, leadingZeroCount);
    return str;
    //  for (int i=1 ; i <=leadingZeroCount;i++){

    //  }
  }

  static String getStrPadLeft(String numstr, int leadingZeroCount) {
    numstr =
        numstr.padLeft(leadingZeroCount, "0").substring(0, leadingZeroCount);
    return numstr;
    //  for (int i=1 ; i <=leadingZeroCount;i++){

    //  }
  }

  static String getDateStringYYYYMMDD(DateTime date) {
    return date.year.toString() +
        "-" +
        getIntPadLeft(date.month, 2) +
        "-" +
        getIntPadLeft(date.day, 2);
  }

  

  static String getMonthStartDateStr(DateTime date) {
    return date.year.toString() +
        "-" +
        getIntPadLeft(date.month, 2) +
        "-" +
        getIntPadLeft(1, 2);
  }

  static String getMonthEndDateStr(DateTime date) {
    int i = 31;
    DateTime endMonth;
    if (date.month == 12) {}

    while (true) {
      endMonth = DateTime.tryParse(date.year.toString() +
          "-" +
          getIntPadLeft(date.month, 2) +
          "-" +
          getIntPadLeft(i, 2));
      if (endMonth != null) {
        if (endMonth.day == 1) {
          DateTime nxMonth = new DateTime(endMonth.year, endMonth.month, 0);
          return getDateStringYYYYMMDD(nxMonth);
        }
        return getDateStringYYYYMMDD(endMonth);
      }
      i = i - 1;
    }
  }

  // static getPref(EnumPrefKeys key) async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   switch (key) {
  //     case EnumPrefKeys.serverAddress:
  //       return sharedPreferences.getString("serverAddress") ??
  //           'http://192.168.96.2/churchapi';
  //   }
  // }

  static getPostMultiPartHeader() {
    var apiToken = SharedPrefsHelperStatic.getString(PREFKEY_TOKEN);
         

// Content-Type': 'application/json

    return {
      'Authorization': 'Bearer ' + apiToken,
      'Content-Type': 'multipart/form-data'
    };
//  return {"Authorization": 'Bearer $apiToken', 'accept': '*/*' ,'cache-control': 'no-cache','accept-encoding': 'gzip, deflate, br',
//   'accept-language': 'en-US,en;q=0.9','content-type': 'multipart/form-data; boundary=dart-http-boundary-c5wNJqGih_JEpr-INqCAj-u3U7YSZc_np0u4bEf_OOPXqI+NUSy'};
  }

  // static String getServerAddr(EnumServerAddr type) {
  //   if (type == EnumServerAddr.device) {
  //     return SERVER_ADDR_DEVICE;
  //   }
  //   if (type == EnumServerAddr.virtual) {
  //     return SERVER_ADDR_VIRTUAL;
  //   } else {
  //     return SERVER_ADDR_VIRTUAL;
  //   }
  // }

  static bool isEmpty(sourceString) {
    if (sourceString==null) {
      return true;
    } 
    return sourceString.isEmpty;
  }
  static DateTime convertStringWithTtoDateTime(String strDateTimeWithT) {
    return DateTime.tryParse(strDateTimeWithT);
  }

  static bool dateStringIsValid(String val, bool emptyIsvalid) {
    if (val.isEmpty || val == null) {
      if (emptyIsvalid) {
        return true;
      } else {
        return false;
      }
    }

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

  static bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }
  static bool isValidPhoneNumber(String input) {
    final RegExp regex = new RegExp(r'^(\+0)?');
    //final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');
    return regex.hasMatch(input);
  }
  static DateTime convertStringToDate(String dateString) {
    try {

      //var d = new DateFormat.yMd().parseStrict(dateString);
      var d=DateTime.tryParse(dateString);
      if (d==null) {
        
      }
      return d;
    } catch (e) {
      return null;
    }
  }

static  int findAge(DateTime birthDate){
    int age;
    Duration dur = DateTime.now().difference(birthDate);
    age=(dur.inDays/365).floor();
    return age ;
  }
  
  static String defValueString(object, {String defaultValue='' }) {
      if (object==null) {
        return (defaultValue!=null) ? defaultValue : null;
      }
      return object;
  }
  static void showAlertDialog(BuildContext context, String title, String body) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future  delay(int durationms) async {
   await  Future.delayed(new Duration(milliseconds: durationms), () {}).then((_) {
     return;
    });
  }

  static void showMyDialog(BuildContext context, String msg) {
     
    var alert = new AlertDialog(
      content: new Stack(
        children: <Widget>[
          new Text(
            'Message',
            style:
                TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          ),
          new Container(
              margin: new EdgeInsets.only(top: 40.0),
              child: new Text(
                '$msg',
                style: TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.bold),
              )),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text(
              'OK',
              style: TextStyle(color: const Color(0xFF860000)),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
  
 static showOKScreen(BuildContext context) async {
  // 1, 2
  bool value = await Navigator.of(context).push(new MaterialPageRoute<bool>(
    builder: (BuildContext context) {
      return new Padding(
        padding: const EdgeInsets.all(32.0),
        // 3
        child: new Column(
        children: [
          new GestureDetector(
            child: new Text('OK'),
            // 4, 5
            onTap: () { Navigator.of(context).pop(true); }
          ),
          new GestureDetector(
            child: new Text('NOT OK'),
            // 4, 5
            onTap: () { Navigator.of(context).pop(false); }
          )
        ])
      );
    }
  ));
  // 6
  AlertDialog alert = new AlertDialog(
    content: new Text((value != null && value) ? "OK was pressed" : "NOT OK or BACK was pressed"),
    actions: <Widget>[
      new FlatButton(
        child: new Text('OK'),
        // 7
        onPressed: () { Navigator.of(context).pop(); }
        )
    ],
  );
  // 8
  //showDialog(context: context, child: alert);
  showDialog(context: context, builder: (BuildContext context) {return alert;});
}
}
