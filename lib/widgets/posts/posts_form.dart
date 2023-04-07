import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nodelink/widgets/pickers/posts_image_picker.dart';

import '/widgets/pickers/user_image_picker.dart';

class PostsForm extends StatefulWidget {
  const PostsForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  final bool isLoading;
  final void Function(
    String title,
    String content,
    File image,
    BuildContext ctx,
  ) submitFn;

  @override
  State<PostsForm> createState() => _PostsFormState();
}

class _PostsFormState extends State<PostsForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String? _postsTitle = '';
  String? _postsContent = '';
  File? _postImageFile;

  void _pickedImage(File image) {
    _postImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_postImageFile == null && !_isLogin) {
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
        _postsTitle.toString().trim(),
        _postsContent.toString().trim(),
        _postImageFile as File,
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
                    margin: const EdgeInsets.only(right: 100, top: 10),
                    child: const Text(
                      'Your Contribution:',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  PostsImagePicker(_pickedImage),
                  TextFormField(
                    key: const ValueKey('title'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Please Enter atleast 7 characters';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Title:',
                    ),
                    onSaved: (value) {
                      _postsTitle = value;
                    },
                  ),
                  TextFormField(
                    key: const ValueKey('content'),
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
                      labelText: 'Describe your Contribution :',
                    ),
                    maxLength: 500,
                    maxLines: 6,
                    onSaved: (value) {
                      _postsContent = value;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: const Text(
                        'Share',
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
