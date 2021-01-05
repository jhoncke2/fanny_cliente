import 'package:flutter_test/flutter_test.dart';
import 'package:fanny_cliente/src/bloc/user/user_services_manager.dart';

import 'current_testing_widget.dart';

final String _testingGroupDescription = 'Se testearán métodos de userServicesManager';
final String _initUserServicesManagerDescription = 'Se inicializará UserServicesManager';


CurrentTestingWidget _mCWidget;
UserServicesManager _userServicesManager;

void main(){
  //_initInitialVariables();
  
  group(_testingGroupDescription, (){
    _initUserServicesManager();
  });
}

void _initUserServicesManager(){
  testWidgets(_initUserServicesManagerDescription, (WidgetTester tester)async{
    _mCWidget = CurrentTestingWidget();
    tester.pumpWidget(_mCWidget);
    final UserServicesManager uSManager = UserServicesManager.forTesting(appContext: _mCWidget.appContext);
  });
}


void _func1(){

}



