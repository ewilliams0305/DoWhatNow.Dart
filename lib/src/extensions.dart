import 'do_what.dart';
import 'what.dart';
import 'dart:async';
import 'do_state.dart';

/// Extension methods designed to provide a fluent API
/// These methods allow users to safely chain together [DoWhat]s and safely continue on either the happy path or the sad path.
extension ResultExtensions<TValue> on DoWhat<TValue> {
  /// Provides a handler for each case of the Result instance.
  /// When the result is a failure the [What]s list will be passed to the [errors] function.
  /// When the result is a success the [TValue] instance will be passed to the success function.
  ///
  /// Each use case is expected to return a new [DoWhat]
  DoWhat<TValue> or(DoWhat<TValue> Function(TValue? value) success,
          DoWhat<TValue> Function(List<What> errors) error) =>
      isSuccess ? success(value) : error(errors);

  /// The [ensure] method validates a state of the [Result] [TValue] instance.
  /// Ensure will call you predicate if and only if the result is successfully.
  /// When the prdicate returns true the result is considered successfull.
  ///
  /// This functional is primarily used for validation.
  DoWhat<TValue> ensure(bool Function(TValue value) predicate,
          What Function(TValue value) error) =>
      isSuccess && value != null
          ? predicate(value as TValue)
              ? success(value as TValue)
              : failure(error(value as TValue))
          : failures(errors);

  /// Provides an inline function to access the value of the [TValue] instance.
  /// Process whatever logic you need to and return a result.
  /// [tap] will only invoke you function if the [DoWhat] is successfull.
  /// When the result is a failure it will simply return the current state back to the invocation.
  ///
  /// Should the [tap] process callback return an error, the [What] will be added to the [DoWhat] errors and returned.
  DoWhat<TValue> tap(DoWhat<TValue> Function(TValue value) process) {
    if (isFailure) {
      return failures(errors);
    }

    final result = process(value as TValue);

    if (result.isFailure) {
      return failures([...errors, ...result.errors]);
    }

    return result;
  }

  /// Provides an inline function to access the value of the [TValue] instance and wraps it in a try catch.
  /// Process whatever logic you need to and return a result.
  /// [tap] will only invoke you function if the [DoWhat] is successfull.
  /// When the result is a failure it will simply return the current state back to the invocation.
  ///
  /// Should the [tap] process callback return an error, the [What] will be added to the [DoWhat] errors and returned.
  DoWhat<TValue> tryTap(DoWhat<TValue> Function(TValue value) process) {
    if (isFailure) {
      return failures(errors);
    }

    try {
      final result = process(value as TValue);

      if (result.isFailure) {
        return failures([...errors, ...result.errors]);
      }
      return result;
    } on Exception catch (exception) {
      return failures([...errors, WhatException(exception)]);
    } catch (object) {
      return failures([...errors, WhatObject(object)]);
    }
  }

  /// The [async] [Future] compatible version of the [tap] function.
  Future<DoWhat<TValue>> tapFuture(
      FutureOr<DoWhat<TValue>> Function(TValue value) process) async {
    if (isFailure) {
      return failures(errors);
    }

    final result = await process(value as TValue);

    if (result.isFailure) {
      return failures([...errors, ...result.errors]);
    }

    return result;
  }

  /// The [map] method is inteded to convert the stored [TValue]
  /// Provide a function to receive the current state of the result, process the data and return a new [DoWhat] or differnt [TValue]
  ///
  /// ```
  /// final result = create(1).map<String>((value) => vlaue == 1 ? 'one' : 'none');
  /// ```
  DoWhat<TOut> map<TOut>(TOut Function(TValue input) mapping) =>
      isSuccess ? success(mapping(value as TValue)) : failures(errors);

  /// The [tryMap] method is identicle to the [map] method however it wrap your conversion method in a [try] [catch]
  DoWhat<TOut> tryMap<TOut>(TOut Function(TValue input) mapping) {
    try {
      return isSuccess ? success(mapping(value as TValue)) : failures(errors);
    } on Exception catch (exception) {
      return failures([...errors, WhatException(exception)]);
    } catch (object) {
      return failures([...errors, WhatObject(object)]);
    }
  }

  /// The [async] [Future] compatible version of the [map] function.
  Future<DoWhat<TOut>> mapFuture<TOut>(
          FutureOr<TOut> Function(TValue value) mappingFunction) async =>
      isSuccess
          ? success(await mappingFunction(value as TValue))
          : failures(errors);

  /// Combines two [DoWhat] instances as a Single [DoWhat]
  /// When both results are [DoState.success] the [DoWhat] will become a Successful result.
  DoWhat<(TValue, TCombinedValue)> augment<TCombinedValue>(
          DoWhat<TCombinedValue> doWhat) =>
      combine(this, doWhat);
}
