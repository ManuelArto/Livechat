import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required String text,
    required TextEditingController searchController,
  })  : _text = text,
        _searchController = searchController;

  final TextEditingController _searchController;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: _text,
      shape: MaterialStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(backgroundColor: Colors.transparent),
      ),
      controller: _searchController,
      leading: const Icon(Icons.search_rounded),
      trailing: _searchController.text.isNotEmpty
          ? [
              IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: _searchController.clear),
            ]
          : null,
    );
  }
}