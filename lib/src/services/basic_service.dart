import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum RequestType{
  GET,
  POST,
  PUT,
  DELETE
}
abstract class BasicService{
  static final String apiUrl = 'https://codecloud.xyz/api/';
  /** 
   * Variable usada en todas las sub-funciones en los que se está haciendo una petición al servidor, 
   * para guardar la respuesta del servidor, momentaneamente, para luego ser retornada desde la
   * función principal.
   */
  Map<String, dynamic> currentResponseBody;
//for testing
  http.Response currentResponse;
  String executedServiceFunction;
//
  http.MultipartRequest crearMultiPartPostRequest(){
    return http.MultipartRequest('POST', Uri.parse('$apiUrl/tiendas'));
  }

  Map<String, Map<String, dynamic>> createHeadersAndBodyForARequest({Map<String, String> headers, Map<String, dynamic> body}){
    return {
      'headers':headers??{},
      'body':body??{}
    };
  }

  Future<void> executeGeneralRequestWithoutHeaders(Map<String, dynamic> bodyData, String route)async{
    final Map<String, Map<String, dynamic>> headersAndBody = {
      'headers': {
      },
      'body': bodyData
    };
    await executeGeneralEndOfRequest(requestType: RequestType.POST, requestUrl: route, headersAndBody: headersAndBody);
  }

  /**
   * Ejecuta la parte final de un request
   * (Es igual para casi todos los requests)
   */
  Future<void> executeGeneralEndOfRequest({@required RequestType requestType, @required String requestUrl, @required Map<String, dynamic> headersAndBody})async{    
    switch(requestType){
      case RequestType.GET:
        await executeGeneralEndOfGETRequest(requestUrl: requestUrl, headersAndBody: headersAndBody);
      break;
      case RequestType.POST:
        await executeGeneralEndOfPOSTRequest(requestUrl: requestUrl, headersAndBody: headersAndBody);
      break;
      case RequestType.PUT:
        await executeGeneralEndOfPUTRequest(requestUrl: requestUrl, headersAndBody: headersAndBody);
      break;
      case RequestType.DELETE:
        await executeGeneralEndOfDELETERequest(requestUrl: requestUrl, headersAndBody: headersAndBody);
      break;
    };    
  }

  Future<void> executeGeneralEndOfGETRequest({@required String requestUrl, @required Map<String, Map<String, dynamic>> headersAndBody})async{
    this.executedServiceFunction = 'get';//for testing
    final http.Response serverResponse = await http.get(
      requestUrl,
      headers: ((headersAndBody['headers']).cast<String, String>())??{},
    );
    //for testing:
    _doTestInstantiations('get', serverResponse);
    //
    evaluateServerResponse(serverResponse);
  }

  Future<void> executeGeneralEndOfPOSTRequest({@required String requestUrl, @required Map<String, Map<String, dynamic>> headersAndBody})async{
    this.executedServiceFunction = 'post';//for testing
    headersAndBody['headers']['Content-Type'] = 'application/json';
    final http.Response serverResponse = await http.post(
      requestUrl,
      headers: ((headersAndBody['headers']).cast<String, String>())??{},
      body:json.encode( headersAndBody['body'] )
    );
    //for testing:
    _doTestInstantiations('post', serverResponse);
    //
    evaluateServerResponse(serverResponse);
  }
  
  Future<void> executeGeneralEndOfPUTRequest({@required String requestUrl, @required Map<String, dynamic> headersAndBody})async{
    this.executedServiceFunction = 'put';//for testing
    final http.Response serverResponse = await http.put(
      requestUrl,
      headers: ((headersAndBody['headers']).cast<String, String>())??{},
      body:headersAndBody['body']
    );
    //for testing:
    _doTestInstantiations('put', serverResponse);
    //
    evaluateServerResponse(serverResponse);
  }
  
  Future<void> executeGeneralEndOfDELETERequest({@required String requestUrl, @required Map<String, dynamic> headersAndBody})async{
    this.executedServiceFunction = 'delete';//for testing
    final http.Response serverResponse = await http.delete(
      requestUrl,
      headers: ((headersAndBody['headers']).cast<String, String>())??{},
    );
    //for testing:
    _doTestInstantiations('delete', serverResponse);
    //
    evaluateServerResponse(serverResponse);
  }

  void _doTestInstantiations(String tipoDeServicio, http.Response serverResponse){
    this.executedServiceFunction = tipoDeServicio;
    this.currentResponse = serverResponse;
  }
  
  @protected
  void evaluateServerResponse(http.Response serverResponse){
    _readServerResopnseBody(serverResponse);
    _evaluateServerResponseBody(serverResponse);
  }

  void _readServerResopnseBody(http.Response serverResponse){
    try{
      currentResponseBody = json.decode(serverResponse.body);
    }catch(err){
      throw ServiceStatusErr(status: serverResponse.statusCode, extraInformation: serverResponse.reasonPhrase);
    }
  }

  void _evaluateServerResponseBody(http.Response serverResponse){
    if(currentResponseBody['error'] != null)
      throw ServiceStatusErr(status: currentResponseBody['code'], extraInformation: currentResponseBody['error']); 
    if( ['invalid_validation', 'invalid_credentials'].contains(currentResponseBody['status']) )
      throw ServiceStatusErr(status: currentResponseBody['code']??serverResponse.statusCode, extraInformation: currentResponseBody['messages']);
  }

  /**
   * generic function for copy and paste. 
   * Only useful while develope phase
   */
  Future<void> _executeRequest(String authorizationToken, Map<String, dynamic> bodyData)async{
    final String requestUrl = '';
    final Map<String, dynamic> headersAndBody = {
      'headers': {

      },
      'body': bodyData
    };
    await executeGeneralEndOfRequest(requestType: RequestType.GET, requestUrl: requestUrl, headersAndBody: headersAndBody);
  }
}