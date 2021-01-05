import 'package:flutter/material.dart';
/**
 * Un widget creado para poder tener un context que tenga agregados los blocs en sus formatos anteriores y nuevos.
 */
// ignore: must_be_immutable
class CurrentTestingWidget extends StatefulWidget {
  _CurrentTestingWidgetState _myCurrentState;

  @override
  _CurrentTestingWidgetState createState(){
    _myCurrentState = _CurrentTestingWidgetState();
    return _myCurrentState;
  }
  BuildContext get appContext => _myCurrentState.context;
}

class _CurrentTestingWidgetState extends State<CurrentTestingWidget> {
  final Key _multiBlocProviderKey = Key('multi_bloc_provider');
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}