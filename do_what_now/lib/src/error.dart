import 'result.dart';
import 'error_reason.dart';

/// Defines an error or issue that cause a [Result] to return a failure.
/// The error class can be implemented or extended to provide custom error type or <T>.
/// 
/// Several default [Error] types have been implmented for you
/// - [ErrorEmpty] provides a default error to handle NULL refernces.
/// - [ErrorMessage] stores a custom string provided to the [Result]
/// - [ErrorObject] stores a custom object provided to the [Result]
/// - [ErrorException] stores an exception provided to the [Result]
abstract class Error<TError> {

  /// Default constuctor provides an instance of the [TError] type and the [ErrorReason] that created this instance.
  const Error(this.reason, this.error);

  /// The reason the [Error] instance was created.
  final ErrorReason reason;
  /// The [TError] instance stored my this instance of the [Error] type.
  final TError? error;
  
  /// Is true when this [Error] is NULL or Empty
  bool get isEmpty => reason == ErrorReason.empty;

  /// Is true when this [Error] is NULL or Empty
  bool get isMessage => reason == ErrorReason.message;

  /// Is true when this [Error] is storing an [Object] of [TError]
  bool get isObject => reason == ErrorReason.object;

  /// Is true when this [Error] was the result or an [Exception]
  bool get isException => reason == ErrorReason.exception;

  /// Returns a message describing the [Error]
  String _getMessage();

  @override 
  String toString() => _getMessage();
}


/// [ErrorEmpty] provides a default error to handle NULL refernces.
class ErrorEmpty<TValue> extends Error<String> {

  ErrorEmpty():super(ErrorReason.empty, '${TValue.toString()} is NULL');
  
  @override
  String _getMessage() => error!;
}

/// [ErrorMessage] stores a custom string provided to the [Result]
class ErrorMessage extends Error<String> {

  ErrorMessage(String message):super(ErrorReason.message, message);
  
  @override
  String _getMessage() => error!;
}

/// [ErrorObject] stores a custom object provided to the [Result]
class ErrorObject extends Error<Object> {

  ErrorObject(Object error):super(ErrorReason.object, error);
  
  @override
  String _getMessage() => error.toString();
}

/// [ErrorException] stores an exception provided to the [Result]
class ErrorException extends Error<Exception> {

  ErrorException(Exception error):super(ErrorReason.exception, error);
  
  @override

  String _getMessage() => error.toString();
}

/// Creates a new [ErrorEmpty] extending [Error] of the Type [T]
/// Returns a formmatted message describing the instance of [T]
ErrorEmpty empty<T>() => ErrorEmpty<T>();

/// Creates a new [ErrorMessage] extending [Error]
/// Returns a formmatted message describing the error
ErrorMessage message(String message) => ErrorMessage(message);

/// Creates a new [ErrorObject] extending [Error]
/// Returns a formmatted message describing the instance of the Object
ErrorObject objectError(Object obj) => ErrorObject(obj);

/// Creates a new [ErrorEmpty] extending [Error] of the Type [Exception]
/// Returns a formmatted message describing the instance of [Exception]
ErrorException exception(Exception ex) => ErrorException(ex);

/// Extension methods used to work with collections of [Error] objects.
extension ErrorsListExtension on List<Error> {

  /// Creates a line seperated string containing each [Error] message.
  /// Useful when displaying a list of validation errors is desirable.
  String displayErrors() => isEmpty
      ? ''
      : map((error) => error.toString()).join('\n');
  
  /// Creates a map of errors containing the ordered index of each [Error] as it was created.
  /// usefull when serializing [Error] messages.
  Map<int, String> displayErrorsList() => isEmpty
    ? {}
    : asMap().map((index, error) => MapEntry(index, error.toString()));
}