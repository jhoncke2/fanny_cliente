import 'package:fanny_cliente/src/services/basic_service.dart';

class LugaresService extends BasicService{ 

  Future<Map<String, dynamic>> cargarLugares(Map<String, String> headers)async{
    final String requestUrl = BasicService.apiUrl + 'direcciones';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers, body: {});
    await executeGeneralEndOfRequest(requestType: RequestType.GET, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }

  Future<Map<String, dynamic>> crearLugar(Map<String, String> headers, Map<String, dynamic> body)async{
    final String requestUrl = BasicService.apiUrl + 'direcciones';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers, body: body);
    await executeGeneralEndOfRequest(requestType: RequestType.POST, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }

  Future<Map<String, dynamic>> elegirLugar(int elegidoId, Map<String, String> headers)async{
    final String requestUrl = BasicService.apiUrl + 'direccion/elegido/$elegidoId';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers, body: {});
    await executeGeneralEndOfRequest(requestType: RequestType.GET, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }

  Future<Map<String, dynamic>> changeLatLongOfLugar(int lugarId, Map<String, String> headers, Map<String, dynamic> body)async{
    final requestUrl = BasicService.apiUrl + 'direccion/latlon/$lugarId';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers, body: body);
    await executeGeneralEndOfRequest(requestType: RequestType.POST, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }
}

final LugaresService lugaresService = LugaresService();