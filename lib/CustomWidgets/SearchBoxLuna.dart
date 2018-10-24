import 'package:flutter/material.dart';

class SearchBoxLuna extends StatelessWidget {
  final TextEditingController editingControllerSearch ;
  SearchBoxLuna(
      {Key key,
      this.label,
      this.hintText,
      this.editingControllerSearch,
      this.onChanged,
      this.onSubmitted,
      this.onEditingCompleted,
      this.onRefreshButtonClick})
      : super(key: key);
  // final Key key = new GlobalKey();
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final ValueChanged onEditingCompleted;
  final ValueChanged<String> onRefreshButtonClick;
  final String label;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              decoration: BoxDecoration(
                  // color: const Color(0x0),
                  border: Border.all(
                    color: Colors.teal,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: TextField(
                controller: editingControllerSearch,
                onChanged: (String value) => this.onChanged(value),
                decoration: new InputDecoration.collapsed(
                  hintText: this.hintText,
                  hintStyle: TextStyle(fontSize: 12.0),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: new Icon(Icons.refresh),
          alignment: Alignment.centerRight,
          onPressed: () {
            this.onRefreshButtonClick(this.editingControllerSearch.text);
          },
        ),
      ],
    );
  }
}
