import 'error.dart';

/// The result type is the result of a method call.
/// Results can contain either an exception or value of the specified type <T>
/// Results use a status enum reporting either pass/fail and can never be both.
class Result<T> {
  /// The status of the result.
  final ResultStatus status;

  /// This is not yet implemented and will need to aggregate the errors together.
  final List<Error> errors;

  /// The value returned from the result.  Will be null unless the result is pass.
  final T? value;

  /// The result of the operation was successful
  bool get isSuccess => status == ResultStatus.pass && errors.isEmpty;

  /// The result of the operation failed and contains errors.
  bool get isFailure => status == ResultStatus.fail || errors.isNotEmpty;

  /// Creates a new passing result.
  Result.pass(this.value)
      : status = ResultStatus.pass,
        errors = List.empty();

  /// Creates a new failed result.
  Result.fail(Error error)
      : status = ResultStatus.fail,
        value = null,
        errors = [error];

  /// Creates a new failed result.
  const Result.failures(this.errors)
      : status = ResultStatus.fail,
        value = null;
}

Result<TValue> failure<TValue>(Error error) => Result.fail(error);

Result<TValue> failures<TValue>(List<Error> errors) => Result.failures(errors);

Result<TValue> create<TValue>(TValue value) =>
    value != null ? success<TValue>(value) : failure<TValue>(Error.empty());
Result<TValue> success<TValue>(TValue value) => Result.pass(value);

Result<TValue> from<TValue>(
        TValue value, bool Function(TValue value) predicate) =>
    predicate(value)
        ? success(value)
        : failure(Error.message('The resulting predicate failed'));

Result<TValue> ensure<TValue>(
        TValue value, bool Function(TValue v) predicate, Error error) =>
    predicate(value) ? success(value) : failure(error);

Result<(T1, T2)> combine<T1, T2>(Result<T1> result1, Result<T2> result2) {
  if (result1.isFailure) {
    return failures<(T1, T2)>(result1.errors);
  }
  if (result2.isFailure) {
    return failures<(T1, T2)>(result2.errors);
  }

  return success((result1.value!, result2.value!));
}

/// The resuting state of a [Result]
/// A result can only ever be pass or fail.
enum ResultStatus {
  /// The result was successful and passed.
  pass,

  /// The result failed and stores an exception.
  fail
}
