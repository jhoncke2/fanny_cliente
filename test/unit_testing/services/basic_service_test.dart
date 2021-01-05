
import 'package:flutter_test/flutter_test.dart';
import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/services/basic_service.dart';

import 'package:http/http.dart' as http;

class _BasicServiceTest extends BasicService{
  void evaluateServerResponseTest(http.BaseResponse serverResponse){
    evaluateServerResponse(serverResponse);
  }
}

final String _crearHeadersAndBodyMessage = 'crea headers y un body para un request dado.';
final String _executeGeneralEndOfRequestMessage = 'se debe ejecutar el método generalEndOfRequest y elegir el sub método correcto dado el tipo de service';
final String _ejecutarGetMessage = 'se debe ejecutar correctamente la petición tipo get';
final String _ejecutarPostMessage = 'se debe ejecutar correctamente la petición tipo post';
final String _ejecutarPutMessage = 'se debe ejecutar correctamente la petición tipo post';
final String _ejecutarDeleteMessage = 'se debe ejecutar correctamente la petición tipo post';
final String _evaluateResponseMessage = 'Se debe evaluar un http.Response correctamente, instanciando en el currentResponseBody el body del response entrante';

final String _getUrl = '';
final String _postUrl = '';
final String _postWithoutHeadersUrl = 'http://cc.codecloud.xyz/api/auth/login';
final Map<String, dynamic> _postLoginBody = {'email':'email1@gmail.com', 'password':'12345678'};
final String _postErrUrl = '';
final String _putUrl = '';
final String _deleteUrl = '';

final _BasicServiceTest _basicServiceTest = _BasicServiceTest();
void main(){
  _testCreateHeadersAndBodyForARequest();
  _testExecuteGeneralRequestWithoutHeaders();
  _testExecuteGeneralEndOfRequest();
  //_testExecuteGeneralEndOfGETRequest();
  //_testExecuteGeneralEndOfPOSTRequest();
  _testEvaluateServerResponseFailed();
  _testEvaluateServerResponseSuccesful();
}

void _testCreateHeadersAndBodyForARequest(){
  test(_crearHeadersAndBodyMessage, (){
    Map<String, String> headers = {
      'Authorization':'AB23cd89',
      'Content-Type':'Application/json'
    };
    Map<String, dynamic> body = {
      'email':'email1@gmail.com',
      'password':'12345678'
    };
    Map<String, dynamic> headersAndBody = _basicServiceTest.createHeadersAndBodyForARequest(
      headers: headers,
      body: body
    );
    expect(headersAndBody, isNotNull);
    Map<String, String> resultHeaders = headersAndBody['headers'];
    expect(resultHeaders, isNotNull);
    expect(resultHeaders['Authorization'], 'AB23cd89');
    expect(resultHeaders['Content-Type'], 'Application/json');
    Map<String, dynamic> resultBody = headersAndBody['body'];
    expect(resultBody, isNotNull);
    expect(resultBody['email'], 'email1@gmail.com');
    expect(resultBody['password'], '12345678');
  });
}

void _testExecuteGeneralEndOfRequest(){
  test(_executeGeneralEndOfRequestMessage, (){
    try{
      _validateGeneralEndOfRequest();
    }catch(err){
      fail('Ha ocurrido un error inesperado: ${err.toString()}');
    }
  });
}

void _validateGeneralEndOfRequest()async{
  Map<String, dynamic> body = {
    'email':'email1@gmail.com',
    'password':'12345678'
  };
  Map<String, Map<String, dynamic>> headersAndBody = {
    'headers':{},
    'body':body
  };
  await _basicServiceTest.executeGeneralEndOfRequest(requestType: RequestType.POST, requestUrl: _postWithoutHeadersUrl, headersAndBody: headersAndBody);
  expect(_basicServiceTest.executedServiceFunction, 'post', reason: 'el método elegido debería ser post');
  expect(_basicServiceTest.currentResponse, isNotNull, reason: 'el currentResponse no debería ser null');
  expect(_basicServiceTest.currentResponseBody, isNotNull, reason: 'el currentResponseBody no debería ser null');
}

void _testExecuteGeneralEndOfGETRequest(){
  test(_ejecutarGetMessage, ()async{
    await _basicServiceTest.executeGeneralEndOfGETRequest(requestUrl: _getUrl, headersAndBody: {'headers':{}, 'body':{}});
    // @ignore dart(invalid_use_of_protected_member)
    final http.Response response= _basicServiceTest.currentResponse;
    expect(response, isNotNull, reason: 'el response actual no debería ser null');
    expect(response.body, isNotNull, reason: 'el body del response actual no debería ser null');
  });
}

void _testExecuteGeneralRequestWithoutHeaders(){
  test(_ejecutarGetMessage, ()async{
    await _basicServiceTest.executeGeneralRequestWithoutHeaders(_postLoginBody, _postWithoutHeadersUrl);
    // @ignore dart(invalid_use_of_protected_member)
    final http.Response response= _basicServiceTest.currentResponse;
    expect(response, isNotNull, reason: 'el response actual no debería ser null');
    expect(response.body, isNotNull, reason: 'el body del response actual no debería ser null');
  });
}


void _testExecuteGeneralEndOfPOSTRequest(){
  test(_ejecutarPostMessage, ()async{
    Map<String, Map<String, dynamic>> headersAndBody = _crearGeneralEndOfPostRequestHeadersAndBody();
    await _basicServiceTest.executeGeneralEndOfPOSTRequest(requestUrl: _postUrl, headersAndBody: headersAndBody);
    final http.Response response = _basicServiceTest.currentResponse;
    expect(response, isNotNull, reason: 'el response actual no debería ser null');
    expect(response.body, isNotNull, reason: 'el body del response actual no debería ser null');
  });
}

Map<String, Map<String, dynamic>> _crearGeneralEndOfPostRequestHeadersAndBody(){
  return {
    'headers':{},
    'body':{
      'email':'email1@gmail.com',
      'password':'12345678'
    }
  };
}

void _testExecuteGeneralEndOfPUTRequest(){
  //TODO: probar un put request
}

void _testExecuteGeneralEndOfDELETERequest(){
  //TODO: probar un delete request
}

void _testEvaluateServerResponseFailed(){
  test(_evaluateResponseMessage, (){
    final http.BaseResponse currentResponse = http.Response(
      'x"Q@x~~2{}x###x.</>',
      200
    );
    _ejecutarValidacionesDeTestEvaluateServerResponseFailed(currentResponse);
  });
}

void _ejecutarValidacionesDeTestEvaluateServerResponseFailed(http.BaseResponse currentResponse){
  try{
    _basicServiceTest.evaluateServerResponseTest(currentResponse);
    expect(_basicServiceTest.currentResponseBody, isNotNull);
    fail('Se debería haber lanzado una excepción en este punto');
  }on ServiceStatusErr catch(_){
    
  }catch(err){
    fail('Ocurrió un error inesperado: ${err.toString()}');
  }
}

void _testEvaluateServerResponseSuccesful(){
  test(_evaluateResponseMessage, (){
    final http.BaseResponse currentResponse = http.Response(
      '{"status":"ok", "token":"A12b9"}',
      200
    );
    _ejecutarValidacionesDeTestEvaluateServerResponseSuccesful(currentResponse);
  });
}

void _ejecutarValidacionesDeTestEvaluateServerResponseSuccesful(http.BaseResponse currentResponse){
  try{
    _basicServiceTest.evaluateServerResponseTest(currentResponse);
    expect(_basicServiceTest.currentResponseBody, isNotNull);
  }catch(err){
    fail('no se debería generar errores al ejecutar el evaluateServerResponse');
  }
}