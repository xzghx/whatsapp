import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:whatsapp/components/MyTextInputFields.dart';

class FormContainer extends StatelessWidget {
  final Key formKey; //is like id
  final onEmailSaved;
  final onPasswordSaved;

  FormContainer(
      {@required this.formKey,
      @required this.onEmailSaved,
      @required this.onPasswordSaved});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          new Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  MyTextInputFields(
                      obscured: false,
                      hint: "ایمیل",
                      iconData: Icons.person,
                      validator: (String value) {
                        if (!isEmail(value)) {
                          return 'ایمیل صحیح نیست';
                        }
                        return null;
                      },
                      onSaved: onEmailSaved),
                  MyTextInputFields(
                      obscured: true,
                      hint: "پسورد",
                      iconData: Icons.lock,
                      validator: (String value) {
                        if (value.length < 8) return "حداقل طول پسورد 8 باشد";
                        return null;
                      },
                      onSaved: onPasswordSaved)
                ],
              ))
        ],
      ),
    );
  }
}
