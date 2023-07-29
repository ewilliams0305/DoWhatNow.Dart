import 'what.dart';
import 'do_state.dart';

/// The [DoWhat] type is the result of a method an object or method.
/// Results can contain either a List<> of [What] or value of the specified type <T>
/// Results use a [DoState] enum internal to ensure the [DoWhat] can only ever be success or fail.
class DoWhat<TValue> {
  /// The value of [TValue] returned from the result.  Will be null unless the result is success.
  final TValue? value;

  /// The captured list of [What] objects.
  /// Each time a [DoWhat] instance is processed, the operation may fail.
  /// When the operation fails the [What] will be captured and added to the collection or errors.
  final List<What> errors;

  /// The state of the result.
  /// When [DoState.success] this result instance stores a valid <T> instance.
  /// When [DoState.fail] this result instance stores a null value with one or more [What]s
  final DoState state;

  /// This result passed and the operation was successful
  bool get isSuccess => state == DoState.success;

  /// The result of the operation failed and contains errors.
  bool get isFailure => state == DoState.fail;

  /// Creates a new successful result.
  DoWhat._success(this.value)
      : state = DoState.success,
        errors = List.empty();

  /// Creates a new failed result.
  DoWhat._failure(What error)
      : state = DoState.fail,
        value = null,
        errors = [error];

  /// Creates a new failed result containing multiple errors.
  DoWhat._failures(this.errors)
      : state = DoState.fail,
        value = null;

  @override
  String toString() => isSuccess
    ? value.toString()
    : errors.displayErrors();
}

/// Factory method to create a new Successful [DoWhat]
DoWhat<TValue> success<TValue>(TValue value) => DoWhat._success(value);

/// Factory method to create a new failed [DoWhat]
DoWhat<TValue> failure<TValue>(What error) => DoWhat._failure(error);

/// Factory method to create a new failed [DoWhat] with several errors
DoWhat<TValue> failures<TValue>(List<What> errors) => DoWhat._failures(errors);

/// Factory method to create a new result [DoWhat] from an instance of an object
/// The [create] method will return a successful result only if the [TValue] is NOT null
DoWhat<TValue> create<TValue>(TValue value) =>
    value != null ? DoWhat._success(value) : DoWhat._failure(empty<TValue>());

/// Factory method to create a new [DoWhat]
/// The [from] method will evaluate the value and execute the predicate.
/// The [DoWhat] will be successfull if the callers predicate returns true.
/// 
/// Example returning valid successfull result.
/// ```
/// final result = from(12, (value) => value == 12));
/// result.isSuccess // true
/// ```
/// 
/// Example returning invald failure result. 
/// ```
/// final result = from(13, (value) => value == 12));
/// result.isSuccess // false
/// ```
DoWhat<TValue> from<TValue>(TValue value, bool Function(TValue value) predicate,
        {String? message}) =>
    predicate(value)
        ? success(value)
        : failure(WhatMessage(message ?? 'The resulting predicate failed'));

/// Returns a tuple result.
DoWhat<(T1, T2)> combine<T1, T2>(DoWhat<T1> result1, DoWhat<T2> result2) {
  if (result1.isFailure) {
    return failures<(T1, T2)>(result1.errors);
  }
  if (result2.isFailure) {
    return failures<(T1, T2)>(result2.errors);
  }

  return success((result1.value!, result2.value!));
}
