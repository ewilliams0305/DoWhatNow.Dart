# DoWhatNow.Dart
![GitHub](https://img.shields.io/github/license/ewilliams0305/DoWhatNow.Dart) 
![GitHub all releases](https://img.shields.io/github/downloads/ewilliams0305/DoWhatNow.Dart/total)
![GitHub issues](https://img.shields.io/github/issues/ewilliams0305/DoWhatNow.Dart)
![GitHub Repo stars](https://img.shields.io/github/stars/ewilliams0305/DoWhatNow.Dart?style=social)
![GitHub forks](https://img.shields.io/github/forks/ewilliams0305/DoWhatNow.Dart?style=social)
![Pub Points](https://img.shields.io/pub/points/DoWhatNow)


A Result package for Dart (and Flutter of course) designed around fluent APIs and a functional approach to error handling, because things go wrong!
This package will help you process the `DO` without verbosity while forgetting all about the `WHAT`.  
The `DO` being the happy path an application may take, and the `WHAT` being short for `WTF`.  Complete your process OR find out what went wrong.

![Do What Now?](DoWhat.PNG)

## Table of Contents
1. [Files](#The-Files)
2. [DoWhat](#The-DoWhat-Object)
3. [What](#The-What-Object)
4. [Extension Methods](#Extension-Methods)
5. [Usage](#DoWhat-Usage)
6. [Errors](Handling-Errors)

## The Files
located in the lib/src directory you will find a few files exported by this library.

`/lib/src/do_what.dart` contains the main type defined by this library as well as various factory methods.
`/lib/src/do_state.dart` contains an enum used internally by the DoWhat class.
`/lib/src/what.dart` contains error definitions, that `WTF`
`/lib/src/why.dart` contains an enum used internally by the `What` error types.
`/lib/src/extensions.dart` contains all `DoWhat` extension methods required to create a fluent API.

## The DoWhat Object
The [DoWhat](lib/src/do_what.dart) type is an immutable class that stores a collection of [What](lib/src/do_what.dart)s or a valid `<TValue>` object.  The `DoWhat` class can only ever be a success or failure.  Each `DoWhat` instance holds a propery `value` of <T?>, `List<What>` `errors` storing any errors, `isSuccess` boolean, and `isFalure` boolean.  The `value` property will never be null if the `isSuccessfull` property is true, whilst the `errors` property will be populated with at least one `What` what the `isSuccessfull` property is false.  The `isFailure` property is only every be true when the `isSuccess` property is false.  And guess what, the collection of `What`s `errors` property will have one or more errors.  Bottom line, A `DoWhat` can only be 'Doing' or 'Whating'.

To begin using the `DoWhat` class create an instance with one of the factories provided.

#### Factories

`create<TValue>` can be used to evaluate an instance of the defined type.  If the `TValue` instance is not not the `create` method will return a successfull result.

Create a valid `DoWhat`, note the `String` 'valid' is NOT NULL
```dart 
// Don't forget to define the generic Type to avoid usage of dynamic
final doWhat = create<String>('value');

if(doWhat.isSuccess){
// this is now true as the 'value' string was a valid String
}
```
Create an invalid `DoWhat` with a null value.
```dart
// Don't forget to define the generic Type to avoid usage of dynamic
final doWhat = create<String>(_oppsReturnedNull());

if(doWhat.isFailure){
// this is now true as the bogus method returned a null string
}

...
String? _oppsReturnedNull(){
    //... some error returned null;
    return null;
}
```

`from<TValue>` can be used to evaluate a predicate to return a `DoWhat` based on the result.
```dart
final result = from<int>(2, (value) => value == 2);
result.isSuccess // this is true as the value passed into the from method is '2' and predicate evaluates to true.
```
In contrast the below example produces a failed `DoWhat` as the predicate returns false.
```dart
final result = from<int>(22, (value) => value == 2);
result.isFailure // this is true as the value passed into the from method is '12' and predicate evaluates to false.
```
Should you need to create a successfull `DoWhat` you can use the `success<TValue>` factory.
Pass any instance of `<TValue>` into the method and begin chaining you validations.
```dart 
final Thing thing = Thing();
final doWhat = success(thing); //this is now a successfull dowhat and can be processed.
```
Should you need to create a failed `DoWhat` you can use the `failure<TValue>` or `failures` factory.
Pass any instance of `What` or `List<What>` into the method.
```dart 
final doWhat = failure(message('This is a Failed thing')); 
```

## The What Object
Stores the failures.  Failures can be as complex as required.  A What is an abstract class, several concrete `What`s have been provided for you that store.  

## Extension Methods


## DoWhat Usage
So whats the point.  Well now you have a `DoWhat` and you can use this as a return type on potentially destructive methods.  The `DoWhat` will allow you to gracfully handle these errors, process the results, return messages to UI, while manintaining readability. Below are some complex use cases.

## Handling Errors


