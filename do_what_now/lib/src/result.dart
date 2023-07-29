import 'error.dart';
import 'result_state.dart';

/// The [Result] type is the result of a method an object or method.
/// Results can contain either a List<> of [Error] or value of the specified type <T>
/// Results use a [ResultState] enum internal to ensure the [Result] can only ever be success or fail.
class Result<TValue> {
  /// The value of [TValue] returned from the result.  Will be null unless the result is success.
  final TValue? value;

  /// The captured list of [Error] objects.
  /// Each time a [Result] instance is processed, the operation may fail.
  /// When the operation fails the [Error] will be captured and added to the collection or errors.
  final List<Error> errors;

  /// The state of the result.
  /// When [ResultState.success] this result instance stores a valid <T> instance.
  /// When [ResultState.fail] this result instance stores a null value with one or more [Error]s
  final ResultState state;

  /// This result passed and the operation was successful
  bool get isSuccess => state == ResultState.success;

  /// The result of the operation failed and contains errors.
  bool get isFailure => state == ResultState.fail;

  /// Creates a new successful result.
  Result._success(this.value)
      : state = ResultState.success,
        errors = List.empty();

  /// Creates a new failed result.
  Result._failure(Error error)
      : state = ResultState.fail,
        value = null,
        errors = [error];

  /// Creates a new failed result containing multiple errors.
  Result._failures(this.errors)
      : state = ResultState.fail,
        value = null;

  @override
  String toString() => isSuccess
    ? value.toString()
    : errors.displayErrors();
}

/// Factory method to create a new Successful [Result]
Result<TValue> success<TValue>(TValue value) => Result._success(value);

/// Factory method to create a new failed [Result]
Result<TValue> failure<TValue>(Error error) => Result._failure(error);

/// Factory method to create a new failed [Result] with several errors
Result<TValue> failures<TValue>(List<Error> errors) => Result._failures(errors);

/// Factory method to create a new result [Result] from an instance of an object
/// The [create] method will return a successful result only if the [TValue] is NOT null
Result<TValue> create<TValue>(TValue value) =>
    value != null ? Result._success(value) : Result._failure(empty<TValue>());

/// Factory method to create a new [Result]
/// The [from] method will evaluate the value and execute the predicate.
/// The [Result] will be successfull if the callers predicate returns true.
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
Result<TValue> from<TValue>(TValue value, bool Function(TValue value) predicate,
        {String? message}) =>
    predicate(value)
        ? success(value)
        : failure(ErrorMessage(message ?? 'The resulting predicate failed'));

/// Returns a tuple result.
Result<(T1, T2)> combine<T1, T2>(Result<T1> result1, Result<T2> result2) {
  if (result1.isFailure) {
    return failures<(T1, T2)>(result1.errors);
  }
  if (result2.isFailure) {
    return failures<(T1, T2)>(result2.errors);
  }

  return success((result1.value!, result2.value!));
}
