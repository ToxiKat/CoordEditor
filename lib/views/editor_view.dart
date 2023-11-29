import 'package:coordeditor/values/values.dart';
import 'package:coordeditor/widgets/coord_entry_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditingView extends StatefulWidget {
  const EditingView({super.key});

  @override
  State<EditingView> createState() => _EditingViewState();
}

class _EditingViewState extends State<EditingView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getJsonValues(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Map> outValues = [];
          List editableValues = snapshot.data;
          return Scaffold(
            body: ListView.builder(
              itemCount: editableValues.length,
              itemBuilder: (context, index) {
                outValues.add(editableValues[index]["value"]);
                return CoordEntry(
                  name: editableValues[index]["key"],
                  coords: editableValues[index]["value"],
                  onChanged: (value) {
                    outValues[index] = value;
                  },
                );
              },
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text("Discard"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Map save = {};
                            for (int i = 0; i < outValues.length; i++) {
                              save[editableValues[i]["key"]] = outValues[i];
                            }
                            saveJsonValues(save);
                            setState(() {});
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: () {
                      List<String> keyList = [];
                      for (int i = 0; i < editableValues.length; i++) {
                        keyList.add(editableValues[i]["key"]);
                      }
                      reorderDialog(keyList);
                    },
                    tooltip: "Reorder Keys",
                    icon: const Icon(Icons.reorder),
                  ),
                  IconButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed: addDialog,
                    tooltip: "Add key value pair",
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      List<String> keyList = [];
                      for (int i = 0; i < editableValues.length; i++) {
                        keyList.add(editableValues[i]["key"]);
                      }
                      deleteDialog(keyList);
                    },
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    tooltip: "delete Key entry",
                    icon: const Icon(
                      Icons.delete_rounded,
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void addDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController ncon = TextEditingController();
        final TextEditingController xcon = TextEditingController();
        final TextEditingController ycon = TextEditingController();
        return AlertDialog(
          title: const Text("Add key Value Pair"),
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Key Name"),
                  ),
                  controller: ncon,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("X Value"),
                  ),
                  controller: xcon,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Y Value"),
                  ),
                  controller: ycon,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("cancel"),
            ),
            TextButton(
              onPressed: () {
                int xval, yval;
                if (xcon.text.isEmpty) {
                  xval = 0;
                } else {
                  xval = int.parse(xcon.text);
                }
                if (ycon.text.isEmpty) {
                  yval = 0;
                } else {
                  yval = int.parse(ycon.text);
                }
                Map out = {
                  "x": xval,
                  "y": yval,
                };
                addJsonKeyValues(ncon.text, out);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text("save"),
            ),
          ],
        );
      },
    );
  }

  void deleteDialog(List<String> itemList) {
    Color currentTextColor = Theme.of(context).textTheme.bodyMedium!.color!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> selectedItems = [];
        double setWidth = 500;
        double setHeight = 300;
        return AlertDialog(
          title: const Text('Delete Key Value Pair'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.minPositive > setWidth
                    ? double.minPositive
                    : setWidth,
                height: setHeight,
                child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: currentTextColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text(itemList[index]),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                selectedItems.add(itemList[index]);
                                itemList.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteJsonKeyValues(itemList);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void reorderDialog(List<String> itemList) {
    Color currentTextColor = Theme.of(context).textTheme.bodyMedium!.color!;
    List<String> reorderedList = List.from(itemList);
    ValueNotifier<bool> isUpdated = ValueNotifier<bool>(false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        isUpdated.addListener(() {
          setState(() {});
        });
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    Expanded(
                      child: ReorderableListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (context, index) {
                          return ReorderableDragStartListener(
                            key: ValueKey(reorderedList[index]),
                            index: index,
                            child: Padding(
                              key: ValueKey(reorderedList[index]),
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: currentTextColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(reorderedList[index]),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: reorderedList.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final String item =
                                reorderedList.removeAt(oldIndex);
                            reorderedList.insert(newIndex, item);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("cancel"),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              reorderJsonKeys(reorderedList);
                              Navigator.of(context).pop();
                              isUpdated.value = !isUpdated.value;
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
