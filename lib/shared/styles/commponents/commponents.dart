import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double width = double.infinity,
  double height = 45.0,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text.toLowerCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
    );

Widget defaultIconButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 0.0,
  required VoidCallback function,
  required String text,
  required Widget imageWidget,
}) =>
    Container(
      width: width,
      height: 45.0,
      child: MaterialButton(
        onPressed: function,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: imageWidget,
              flex: 2,
            ),
            //SizedBox(width: 50,),
            Expanded(
              flex: 4,
              child: Text(
                isUpperCase ? text.toUpperCase() : text.toLowerCase(),
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(
          radius,
        ),
      ),
    );

 elevatedBtn(
        {required IconData iconData,
          required String text,
          required VoidCallback function}) =>
    ElevatedButton.icon(
      onPressed: function,
      icon: Icon(iconData,color: Colors.white,),
      label: Text(text),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.black,),
      ),
    );


 showSnackBarScaffold(context,text)
=>
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${text}')));

/*Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType textInputType,
  Function onSubmit,
  Function onChanged,
  bool isPassword = false,
  @required Function validator,
  @required String label,
  @required IconData prefixIcon,
  IconData suffixIcon,
  Function suffixIconPressed,
  Function onTap,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label, //hintText
          prefixIcon: Icon(
            prefixIcon,
          ),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(
                    suffixIcon,
                  ),
                  onPressed: suffixIcon != null ? suffixIconPressed : null,
                )
              : null,
          border: OutlineInputBorder()),
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      validator: validator,
      keyboardType: textInputType,
      obscureText: isPassword,
      onTap: onTap,
      enabled: isClickable,
    );*/

Widget myDivider() => Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    );

 showToast({required String msg, required state}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastedStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastedStates states) {
  Color color;
  switch (states) {
    case ToastedStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastedStates.ERROR:
      color = Colors.red;
      break;
    case ToastedStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );
