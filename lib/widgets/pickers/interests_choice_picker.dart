import 'package:flutter/material.dart';

class InterestChoicePicker extends StatefulWidget {
  final void Function(List<String> selectedChoices) interestChoicePickerFn;
  InterestChoicePicker(this.interestChoicePickerFn);

  @override
  State<InterestChoicePicker> createState() => _ChoicePickerState();
}

class _ChoicePickerState extends State<InterestChoicePicker> {
  final List<String> _selectedChoices = [];
  final List<String> interestList = [
    'Programming',
    'Business',
    'Teaching',
    'Communication',
    'Positivity',
    'Networking',
    'Inspiring',
    'Creative Thinking',
    'Science',
  ];
  @override
  Widget build(BuildContext context) {
    if (_selectedChoices.length == 5) {
      setState(() {
        widget.interestChoicePickerFn(_selectedChoices);
      });
    }
    return Wrap(
      children: interestList.map(
        (hobby) {
          bool isSelected = false;
          if (_selectedChoices.contains(hobby)) {
            isSelected = true;
          }
          return GestureDetector(
            onTap: () {
              if (!_selectedChoices.contains(hobby)) {
                if (_selectedChoices.length < 5) {
                  _selectedChoices.add(hobby);
                  setState(() {});
                  print(_selectedChoices);
                }
              } else {
                _selectedChoices.removeWhere((element) => element == hobby);
                setState(() {});
                print(_selectedChoices);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 2)),
                child: Text(
                  hobby,
                  style: TextStyle(
                      color: isSelected ? Colors.blue : Colors.grey,
                      fontSize: 14),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
