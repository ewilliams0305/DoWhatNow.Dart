import 'result.dart';
import 'error.dart';
import 'dart:async';


extension ResultExtensions<T> on Result<T> {

  List<Result> combine(Result result) {
    final List<Result> results = [result, this];
    return results;
  }

  Result<T> or(Result<T> Function(T? value) success,
               Result<T> Function(List<Error> errors) error) =>
          isSuccess 
          ? success(value) 
          : error(errors);

  Result<T> ensure(bool Function(T? value) predicate, Error error) =>
    isSuccess 
      ? predicate(value) 
        ? success(value as T)
        : failure(error)
      :failures(errors);

  Result<T> tap(void Function(T value) process){
    process(value as T);
    return this;
  } 
}

extension ResultMapsExtensions on Result {
  
  Result<TOut> map<TIn, TOut>(TOut Function(TIn input) mapping) {
    return isSuccess 
    ? success(mapping(value)) 
    : failure(exception(Exception('')));
  }
}

extension ResultMapperExtensions<TIn> on Result<TIn> {

  Result<TOut> mapper<TOut>(TOut Function(TIn input) mapping) =>
    isSuccess 
    ? success(mapping(value as TIn))
    : failures(errors);

  Future<Result<TOut>> mapFuture<TOut>(FutureOr<TOut> Function(TIn? value) mappingFunction) async =>
    isSuccess 
    ? success(await mappingFunction(value))
    : failures(errors);
}