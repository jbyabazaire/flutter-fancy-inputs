import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class FancySwitchInput extends StatefulWidget {
  String? hintText;
  String? labelText;

  ValueChanged<dynamic>? onChanged;
  String? errorText;
  String textOn = "Yes";
  String textOff = "No";
  bool initialValue = false;

  FancySwitchInput({
    Key? key,
    this.hintText,
    @required this.labelText,
    this.onChanged,
    this.errorText,
    this.textOn: "Yes",
    this.textOff = "No",
    this.initialValue = false,
  }) : super(key: key) {}

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _FancySwitchInputState(value: this.initialValue);
  }
}

class _FancySwitchInputState extends State<FancySwitchInput> {
  bool value = false;
  _FancySwitchInputState({required this.value});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.labelText!,
            style: TextStyle(),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlutterSwitch(
              showOnOff: true,
              activeText: widget.textOn,
              inactiveText: widget.textOff,
              activeTextColor: Colors.white,
              // inactiveTextColor: Cc.BG_APP_BAR,
              // inactiveToggleColor: Cc.BG_APP_BAR,
              width: 150,

              // inactiveColor: Cc.BG_FRONT,
              // activeColor: Cc.BG_APP_BAR,
              value: value,
              onToggle: (b) {
                value = b;
                if (widget.onChanged != null) {
                  widget.onChanged!(b);
                }
                setState(() {});
              },
            ),
          ],
        ),
      ],
    );
  }
}
