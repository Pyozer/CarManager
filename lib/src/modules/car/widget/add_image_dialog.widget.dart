import 'package:flutter/material.dart';

import '../../../utils/validators.utils.dart';

class AddImageDialog extends StatefulWidget {
  const AddImageDialog({Key? key}) : super(key: key);

  @override
  State<AddImageDialog> createState() => _AddImageDialogState();
}

class _AddImageDialogState extends State<AddImageDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController(text: '');
  late final Validator _validator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _validator = Validator(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Image URL'),
      actions: [
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(_controller.text);
            }
          },
        ),
      ],
      content: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          maxLines: 4,
          validator: _validator.noEmpty,
        ),
      ),
    );
  }
}
