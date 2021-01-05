import 'package:fanny_cliente/src/errors/custom_error.dart';
import 'package:fanny_cliente/src/errors/error_types.dart';
class ServiceStatusErr extends CustomError{
  final status;
  final statusAndMessagesCouples = <Map<String, dynamic>>[
    {
      'status':500,
      'message':'Ha ocurrido un problema en el servidor'
    },
    {
      'status':401,
      'message':'Sin autorización para ejecutar la acción demandada'
    },
    {
      'status':422,
      'message':'Hay un problema en el contenido del cuerpo de la petición.'
    },
    {
      'status':401,
      'message':'El correo o la contraseña son incorrectos'
    }
  ];  

  ServiceStatusErr({this.status, String message, dynamic extraInformation}) 
  :super(
    type: ErrorTypes.SERVICE, 
    message: message,
    extraInformation: extraInformation
  ){
    if(message == null)
      this.message = _getMessageByStatus(this.status);
  }

  String _getMessageByStatus(int searchedStatus){
    for(int i = 0; i < statusAndMessagesCouples.length; i++){
      Map<String, dynamic> actualStatusAndMessageCouple = statusAndMessagesCouples[i];
      if(actualStatusAndMessageCouple['status'] == searchedStatus)
        return actualStatusAndMessageCouple['message'];
    }
    return 'ha ocurrido un error';
  }
}