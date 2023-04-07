import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nodelink/widgets/pickers/interests_choice_picker.dart';
import 'package:nodelink/widgets/pickers/skills_choice_picker.dart';
import 'package:nodelink/widgets/pickers/posts_image_picker.dart';

import '/widgets/pickers/user_image_picker.dart';

class CompleteUserForm extends StatefulWidget {
  const CompleteUserForm(this.submitFn, this.isLoading, {Key? key})
      : super(key: key);

  final bool isLoading;
  final void Function(
    String about,
    List<String> skills,
    List<String> interests,
    BuildContext ctx,
  ) submitFn;

  @override
  State<CompleteUserForm> createState() => _PostsFormState();
}

class _PostsFormState extends State<CompleteUserForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String? _about = '';
  List<String>? _skills;
  List<String>? _interests;

  void _pickedSkills(List<String> skills) {
    _skills = skills;
  }

  void _pickedInterests(List<String> interests) {
    _interests = interests;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_skills == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _about.toString().trim(),
        _skills as List<String>,
        _interests as List<String>,
        context,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 150, top: 10),
                    child: const Text(
                      'Complete Your Profile:',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    key: const ValueKey('about'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 20) {
                        return 'Please Enter atleast 20 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Describe your Productive Self (About):',
                    ),
                    maxLength: 500,
                    maxLines: 6,
                    onSaved: (value) {
                      _about = value;
                    },
                  ),
                  Container(
                    width: double.infinity,
                    child: const Text(
                      'Skills:',
                      style: TextStyle(
                        color: Color.fromARGB(255, 146, 145, 145),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SkillsChoicePicker(_pickedSkills),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: double.infinity,
                    child: const Text(
                      'Interests:',
                      style: TextStyle(
                        color: Color.fromARGB(255, 146, 145, 145),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InterestChoicePicker(_pickedInterests),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
