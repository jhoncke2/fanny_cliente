import 'package:meta/meta.dart';
class PushNotificationInfo{
  final String receiverMobileToken;
  final String receiverChannel;
  final String notificationType;
  final Map<String, dynamic> bodyData;

  PushNotificationInfo.innerNotification({
    @required this.receiverChannel, 
    @required this.notificationType, 
    @required this.bodyData,    
  })
  :this.receiverMobileToken = null;

  PushNotificationInfo.outerNotification({
    @required this.notificationType, 
    @required this.bodyData,
    @required this.receiverMobileToken
  })
  :this.receiverChannel = null;
}