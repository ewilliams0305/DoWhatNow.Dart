import 'result.dart';
import 'error.dart';
import 'dart:async';
import 'result_state.dart';

/// Extension methods designed to provide a fluent API
/// These methods allow users to safely chain together [Result]s and safely continue on either the happy path or the sad path.
extension ResultExtensions<TValue> on Result<TValue> {

  /// Combines two [Result] instances as a Single [Result]
  /// When both results are [ResultState.success] the [Result] will become a Successful result.
  List<Result> combine(Result result) {
    final List<Result> results = [result, this];
    return results;
  }

  /// Provides a handler for each case of the Result instance.
  /// When the result is a failure the [Error]s list will be passed to the [errors] function.
  /// When the result is a success the [TValue] instance will be passed to the success function.
  /// 
  /// Each use case is expected to return a new [Result]
  Result<TValue> or(
    Result<TValue> Function(TValue? value) success,
    Result<TValue> Function(List<Error> errors) error) =>
          isSuccess 
          ? success(value) 
          : error(errors);

  /// The [ensure] method validates a state of the [Result] [TValue] instance.
  /// Ensure will call you predicate if and only if the result is successfully.
  /// When the prdicate returns true the result is considered successfull.
  /// 
  /// This functional is primarily used for validation. 
  Result<TValue> ensure(bool Function(TValue? value) predicate, Error error) =>
    isSuccess 
      ? predicate(value) 
        ? success(value as TValue)
        : failure(error)
      :failures(errors);

  /// Provides an inline function to access the value of the [TValue] instance.
  /// Process whatever logic you need to and return a result.  
  /// [tap] will only invoke you function if the [Result] is successfull.
  /// When the result is a failure it will simply return the current state back to the invocation.
  /// 
  /// Should the [tap] process callback return an error, the [Error] will be added to the [Result] errors and returned.
  Result<TValue> tap(Result<TValue> Function(TValue value) process){
    if(isFailure){
      return failures(errors);
    }
    
    final result = process(value as TValue);

    if(result.isFailure){
      return failures([...errors, ...result.errors]);
    }

    return result;
  } 
  
  /// The [async] [Future] compatible version of the [tap] function.
  Future<Result<TValue>> tapFuture(FutureOr<Result<TValue>> Function(TValue value) process) async {
    if(isFailure){
      return failures(errors);
    }
    
    final result = await process(value as TValue);

    if(result.isFailure){
      return failures([...errors, ...result.errors]);
    }

    return result;
  } 

  /// The [map] method is inteded to convert the stored [TValue]
  /// Provide a function to receive the current state of the result, process the data and return a new [Result] or differnt [TValue]
  /// 
  /// ```
  /// final result = create(1).map<String>((value) => vlaue == 1 ? 'one' : 'none');
  /// ```
  Result<TOut> map<TOut>(TOut Function(TValue input) mapping) =>
    isSuccess 
    ? success(mapping(value as TValue))
    : failures(errors);
  
  /// The [async] [Future] compatible version of the [map] function.
  Future<Result<TOut>> mapFuture<TOut>(FutureOr<TOut> Function(TValue value) mappingFunction) async =>
    isSuccess 
    ? success(await mappingFunction(value as TValue))
    : failures(errors);
}