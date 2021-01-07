import 'package:fanny_cliente/src/services/basic_service.dart';

class ProductosService extends BasicService{
  Future<Map<String, dynamic>> loadPublicProducts()async{
    final String requestUrl = BasicService.apiUrl + 'products/public';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: {}, body: {});
    await executeGeneralEndOfRequest(requestType: RequestType.GET, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }

  Future<Map<String, dynamic>> loadCategories()async{
    final String requestUrl = BasicService.apiUrl + 'category/public';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: {}, body:{});
    await executeGeneralEndOfRequest(requestType: RequestType.GET, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }

  Future<Map<String, dynamic>> loadProductsByCategory(int categoryId)async{
    final String requestUrl = BasicService.apiUrl + 'products/category/$categoryId';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: {}, body: {});
    await executeGeneralEndOfRequest(requestType: RequestType.GET, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }

  Future<Map<String, dynamic>> loadProductsBySearch(String searchingWord)async{
    final String requestUrl = BasicService.apiUrl + 'products/search/$searchingWord';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: {}, body: {});
    await executeGeneralEndOfRequest(requestType: RequestType.GET, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }

  Future<Map<String, dynamic>> createFavorito(Map<String, String> headers, Map<String, dynamic> body)async{
    final String requestUrl = BasicService.apiUrl + 'user-products/favorite';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers, body: body);
    await executeGeneralEndOfRequest(requestType: RequestType.POST, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }

  Future<Map<String, dynamic>> deleteFavorito(Map<String, String> headers, int favoriteId)async{
    final String requestUrl = BasicService.apiUrl + 'user-products/favorite/$favoriteId';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers, body: {});
    await executeGeneralEndOfRequest(requestType: RequestType.DELETE, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }

  Future<Map<String, dynamic>> loadFavoritos(Map<String, String> headers)async{
    final String requestUrl = BasicService.apiUrl + 'user-products/favorite';
    final Map<String, Map<String, dynamic>> headersAndBody = createHeadersAndBodyForARequest(headers: headers, body: {});
    await executeGeneralEndOfRequest(requestType: RequestType.GET, requestUrl: requestUrl, headersAndBody: headersAndBody);
    return currentResponseBody;
  }
}

final ProductosService productosService = ProductosService();