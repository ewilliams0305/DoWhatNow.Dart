import 'result.dart';

/// The error class is used to store the result error from a fail [Result].
/// Errors can be either none, null, objects, or exceptions.
class Error {

  final Object? _object;
  final Exception? _exception;
  final ErrorType _type;

  ErrorType get type => _type;
  Object get object => _object?? Object();
  Exception get exception => _exception?? Exception();

  bool get isNone => _type == ErrorType.none;
  bool get isEmpty => _type == ErrorType.empty;
  bool get isException => _type == ErrorType.exception;
  bool get isObject => _type == ErrorType.object;

  /// The default state of an error is none, 
  /// The Error.none constuctor should only be used to satify a [Result]
  Error.none():_type = ErrorType.none, _object = null, _exception = null;
  /// The [Error.empty()] constructor is used when a null object is return.
  Error.empty():_type = ErrorType.empty, _object = null, _exception = null;
  /// The exception constructor is used to provide an exception to the [Result]
  Error.exception(Exception exception):_type = ErrorType.exception, _object = null, _exception = exception;
  /// The exception constructor is used to provide an exception to the [Result]
  Error.message(String message):_type = ErrorType.exception, _object = null, _exception = Exception(message);
  /// The object consuctor stores an object insdie the Error object.
  Error.object(Object object):_type = ErrorType.object, _exception = null, _object = object;
}

/// Describes the type of error stored in the instance of the [Error] class.
enum ErrorType { 
  /// The error is none and holds no valid error.
  none, 
  /// The error was the result of a null object response from a [Result]
  empty, 
  /// The error was the result of an exception retured from a [Result]
  exception, 
  /// The error stores an object, possible caught by a customer exception.
  object 
}
