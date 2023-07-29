import 'do_what.dart';
import 'why.dart';

/// Defines an error or issue that cause a [DoWhat] to return a failure.
/// The error class can be implemented or extended to provide custom error type or <T>.
/// 
/// Several default [What] types have been implmented for you
/// - [WhatEmpty] provides a default error to handle NULL refernces.
/// - [WhatMessage] stores a custom string provided to the [DoWhat]
/// - [WhatObject] stores a custom object provided to the [DoWhat]
/// - [WhatException] stores an exception provided to the [DoWhat]
abstract class What<TError> {

  /// Default constuctor provides an instance of the [TError] type and the [Why] that created this instance.
  const What(this.reason, this.error);

  /// The reason the [What] instance was created.
  final Why reason;
  /// The [TError] instance stored my this instance of the [What] type.
  final TError? error;
  
  /// Is true when this [What] is NULL or Empty
  bool get isEmpty => reason == Why.empty;

  /// Is true when this [What] is NULL or Empty
  bool get isMessage => reason == Why.message;

  /// Is true when this [What] is storing an [Object] of [TError]
  bool get isObject => reason == Why.object;

  /// Is true when this [What] was the result or an [Exception]
  bool get isException => reason == Why.exception;

  /// Returns a message describing the [What]
  String _getMessage();

  @override 
  String toString() => _getMessage();
}


/// [WhatEmpty] provides a default error to handle NULL refernces.
class WhatEmpty<TValue> extends What<String> {

  WhatEmpty():super(Why.empty, '${TValue.toString()} is NULL');
  
  @override
  String _getMessage() => error!;
}

/// [WhatMessage] stores a custom string provided to the [DoWhat]
class WhatMessage extends What<String> {

  WhatMessage(String message):super(Why.message, message);
  
  @override
  String _getMessage() => error!;
}

/// [WhatObject] stores a custom object provided to the [DoWhat]
class WhatObject extends What<Object> {

  WhatObject(Object error):super(Why.object, error);
  
  @override
  String _getMessage() => error.toString();
}

/// [WhatException] stores an exception provided to the [DoWhat]
class WhatException extends What<Exception> {

  WhatException(Exception error):super(Why.exception, error);
  
  @override

  String _getMessage() => error.toString();
}

/// Creates a new [WhatEmpty] extending [What] of the Type [T]
/// Returns a formmatted message describing the instance of [T]
WhatEmpty empty<T>() => WhatEmpty<T>();

/// Creates a new [WhatMessage] extending [What]
/// Returns a formmatted message describing the error
WhatMessage message(String message) => WhatMessage(message);

/// Creates a new [WhatObject] extending [What]
/// Returns a formmatted message describing the instance of the Object
WhatObject what(Object obj) => WhatObject(obj);

/// Creates a new [WhatException] extending [What] of the Type [Exception]
/// Returns a formmatted message describing the instance of [Exception]
WhatException exception(Exception ex) => WhatException(ex);

/// Extension methods used to work with collections of [What] objects.
extension WhatErrorsExtension on List<What> {

  /// Creates a line seperated string containing each [What] message.
  /// Useful when displaying a list of validation errors is desirable.
  String displayErrors() => isEmpty
      ? ''
      : map((error) => error.toString()).join(' | ');
  
  /// Creates a map of errors containing the ordered index of each [What] as it was created.
  /// usefull when serializing [What] messages.
  Map<int, String> displayErrorsList() => isEmpty
    ? {}
    : asMap().map((index, error) => MapEntry(index, error.toString()));
}