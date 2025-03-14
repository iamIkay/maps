//Location search with drop down suggestions
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function() onTap;

  const AddressInputField(this.controller, {required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: SizedBox(
        height: 40.0,
        child: TextField(
          decoration: _addressInputDecoration(hint: "Search"),
          cursorColor: Theme.of(context).primaryColor,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
    );
  }
}

InputDecoration _addressInputDecoration({required String hint}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 16.0),
    prefixIcon: Icon(CupertinoIcons.search, color: Colors.grey, size: 20.0),
    prefixIconConstraints: const BoxConstraints(minWidth: 40.0),
    // suffixIconColor: Palette.fontColor,
    fillColor: Colors.black87,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
      borderRadius: BorderRadius.circular(24.0),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 18.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1.0, color: Colors.grey),
      borderRadius: BorderRadius.circular(24.0),
    ),
  );
}
