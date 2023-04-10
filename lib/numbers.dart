import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "list.dart";
import 'dart:math';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({Key? key}) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  final TextEditingController _costController = TextEditingController();
  List<ListNum> writtenNumbers = [];
  int chosenNumber = 0;
  bool isButtonDisabled = true;
  bool _guessed = false;

  void chooseNumber() {
    setState(() {
      chosenNumber = Random().nextInt(99) + 1;
      print('Starting again - refresh');
      setState(() {
        writtenNumbers = [];
      });
      isButtonDisabled = false;
      print('Chosen number: ${chosenNumber} ');
    });
  }

  void assign(String input) {
    id:
    writtenNumbers.length + 1;
    value:
    int.tryParse(input) ?? 0;
    if (int.tryParse(input)! > chosenNumber) {
      writtenNumbers.add(ListNum(
        id: writtenNumbers.length + 1,
        value: int.tryParse(_costController.text) ?? 0,
        comment: 'Lower',
      ));
    } else if (int.tryParse(input)! < chosenNumber) {
      writtenNumbers.add(ListNum(
        id: writtenNumbers.length + 1,
        value: int.tryParse(_costController.text) ?? 0,
        comment: 'Higher',
      ));
    } else if (int.tryParse(input) == chosenNumber) {
      writtenNumbers.add(ListNum(
        id: writtenNumbers.length + 1,
        value: int.tryParse(_costController.text) ?? 0,
        comment: 'You found the number!',
        isGoodNumber: true,
      ));
      chosenNumber = 0;
      isButtonDisabled = true;
      _guessed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
          ),
          width: double.infinity,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextButton(
                child: Icon(
                  Icons.refresh,
                  size: 30,
                ),
                onPressed: () => chooseNumber(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green,
                  minimumSize: Size(60, 60),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _costController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Write the number"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.deny(
                      RegExp(r'^[1-9][1-9]{2}|^10[1-9]')),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: isButtonDisabled
                    ? null
                    : () {
                        print('Added number');
                        print(_costController.text);
                        setState(() {
                          assign(_costController.text);
                        });
                        _costController.clear();
                      },
                child: Text(
                  'Add',
                  style: TextStyle(fontSize: 17),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(60, 60),
                ),
              ),
            ),
          ],
        ),
        ...writtenNumbers.map((e) {
          return Card(
            child: Row(
              children: [
                Container(
                    constraints: BoxConstraints(
                      minHeight: 60,
                      minWidth: 60,
                    ),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: e.isGoodNumber ? Colors.green : Colors.red,
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        '${e.value}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: e.isGoodNumber ? Colors.green : Colors.red,
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: e.comment == 'Higher'
                      ? Icon(
                          Icons.arrow_upward,
                          size: 40,
                          color: Color.fromARGB(255, 164, 11, 0),
                        )
                      : e.comment == 'Lower'
                          ? Icon(
                              Icons.arrow_downward,
                              size: 40,
                              color: Color.fromARGB(255, 164, 11, 0),
                            )
                          : Icon(
                              Icons.check,
                              size: 40,
                              color: Color.fromARGB(255, 1, 141, 6),
                            ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      '${e.comment}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        })
      ],
    );
  }
}
