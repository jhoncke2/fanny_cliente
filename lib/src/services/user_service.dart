import 'package:fanny_cliente/src/errors/services/service_status_err.dart';
import 'package:fanny_cliente/src/services/basic_service.dart';

class UserService extends BasicService{

  Future<Map<String, dynamic>> login(Map<String, dynamic> body)async{
    final String requestUrl = BasicService.apiUrl + 'login';
    await executeGeneralRequestWithoutHeaders(body, requestUrl);
    return currentResponseBody;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> body)async{
    try{
      final String requestUrl = BasicService.apiUrl + 'register';
      await executeGeneralRequestWithoutHeaders(body, requestUrl);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }

  Future<Map<String, dynamic>> validarEmail(Map<String, dynamic> body)async{
    try{
      final String requestUrl = BasicService.apiUrl + 'validar/email';
      await executeGeneralRequestWithoutHeaders(body, requestUrl);
      return currentResponseBody;
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> updateMobileToken(Map<String, dynamic> headers, Map<String, dynamic> body)async{
    try{
      final String requestUrl = BasicService.apiUrl + 'mobile_token';
      final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: {}, body: body);
      await executeGeneralEndOfRequest(requestType: RequestType.POST, requestUrl: requestUrl, headersAndBody: headersAndBody);
      return currentResponseBody;
    }catch(err){
      return {
        'status':'err',
        'message':err
      };
    }
  }

  Future<Map<String, dynamic>> getUserInformation(Map<String, String> headers)async{
    try{
      final String requestUrl = BasicService.apiUrl + 'seeUserAuth';
      final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers, body: {});
      await executeGeneralEndOfRequest(requestType: RequestType.GET, requestUrl: requestUrl, headersAndBody: headersAndBody);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }

  Future<Map<String, dynamic>> logout(Map<String, dynamic> bodyData)async{
    try{
      final String requestUrl = BasicService.apiUrl + 'logout';
      await executeGeneralRequestWithoutHeaders(bodyData, requestUrl);
      return currentResponseBody;
    }catch(err){
      throw err;
    }
  }
}

final UserService userService = UserService();