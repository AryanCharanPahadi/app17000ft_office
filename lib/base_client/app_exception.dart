
class AppException implements Exception{
String? message;
String? prefix;
String? url;


AppException([this.message,this.prefix,this.url]);





}

class BadRequestException extends AppException{
  BadRequestException([String? message,String? url]) : super('Bad Request', url);
}
class FetchDataException extends AppException{
  FetchDataException([String? message,String? url]) : super('Unable to Process', url);
}
class TimeOutException extends AppException{
  TimeOutException([String? message,String? url]) : super('Request Time Out', url);
}
class UnauthorizedException extends AppException{
  UnauthorizedException([String? message,String? url]) : super('Unauthorized Acces', url);
}
class ApiNotResponsdingException extends AppException{
  ApiNotResponsdingException([String? message,String? url]) : super('API not responding', url);
}
class NotFoundException extends AppException{
  NotFoundException([String? message,String? url]) : super('Not Found', url);
}

