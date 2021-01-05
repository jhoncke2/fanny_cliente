import 'package:flutter/material.dart';
class DataSearchWidget extends SearchDelegate<String>{

  List<String> _suggestionListTest = [
    'Celular redmi note 8',
    'teclado inhalámbrico',
    'mouse inhalámbrico negro',
    'mouse gamer',
    'mouse genius',
    'mouse genius verde',
    'computador gigabyte 8',
    'xbox one',
    'teclado gamer',
    'cargador de mac',
    'cargador xiaomi redmi note 8',
    'cargador de xiaomi redmi note 9',
    'cargador de huawei',
    'cargador iphone',
    'cargador de portátil lenovo 8'
  ];
  
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(
          Icons.clear
        ),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<String> suggestion;
    if(query.length < 4)
      suggestion = _suggestionListTest;
    else{
      suggestion = _suggestionListTest.where(
        (String word) => word.contains(query)
      ).toList();
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          leading: Icon(
            Icons.search
          ),
          title: Text(
            suggestion[index]
          ),
        );
      },
      itemCount: suggestion.length,
    );
  }

}