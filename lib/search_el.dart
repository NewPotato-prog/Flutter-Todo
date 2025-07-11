import 'package:flutter/material.dart';

class SearchEl extends StatefulWidget {
  final TextEditingController controller;
  final Function handleChange;
  const SearchEl({
    super.key,
    required this.controller,
    required this.handleChange,
  });

  @override
  createState() => _SearchElState();
}

class _SearchElState extends State<SearchEl> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.search_outlined),
        hintText: 'Search',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2, color: Colors.orange),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 2, color: Colors.green),
        ),
      ),
      onChanged: (value) => widget.handleChange(value),
    );
  }
}
