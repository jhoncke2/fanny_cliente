abstract class CustomError extends Error{
  
  final type;
  String message;
  dynamic extraInformation;

  CustomError({this.type, this.message, this.extraInformation});
}