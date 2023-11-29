import 'package:coordeditor/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoordEntry extends StatefulWidget {
  final String name;
  final Map coords;
  final void Function(Map) onChanged;
  const CoordEntry({
    required this.name,
    required this.coords,
    required this.onChanged,
    super.key,
  });

  @override
  State<CoordEntry> createState() => _CoordEntryState();
}

class _CoordEntryState extends State<CoordEntry> {
  late bool isExpanded;
  late TextEditingController xController, yController;

  @override
  void initState() {
    super.initState();
    isExpanded = defaultExpand.value;
    xController = TextEditingController(text: widget.coords["x"].toString());
    yController = TextEditingController(text: widget.coords["y"].toString());
  }

  @override
  Widget build(BuildContext context) {
    Color currentTextColor = Theme.of(context).textTheme.bodyMedium!.color!;
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 4.0,
        bottom: 4.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: currentTextColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(widget.name),
                trailing: isExpanded
                    ? const Icon(Icons.keyboard_arrow_up)
                    : const Icon(Icons.keyboard_arrow_down),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "X",
                                counter: Container(),
                              ),
                              maxLength: 4,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              controller: xController,
                              onChanged: (value) {
                                widget.onChanged(getValues());
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "Y",
                                counter: Container(),
                              ),
                              maxLength: 4,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                                signed: false,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              controller: yController,
                              onChanged: (value) {
                                widget.onChanged(getValues());
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Map getValues() {
    int xval, yval;
    if (xController.text.isEmpty) {
      xval = 0;
    } else {
      xval = int.parse(xController.text);
    }
    if (yController.text.isEmpty) {
      yval = 0;
    } else {
      yval = int.parse(yController.text);
    }
    return {
      "x": xval,
      "y": yval,
    };
  }
}
