import 'package:do_what_now/do_what_now.dart';
import 'package:test/test.dart';

void main() {
  group('create() result tests', () {
    test('Create Function Returns Failure When Instance Is Null', () {
      final result = create(null);
      expect(result.isFailure, isTrue);
      expect(result.toString() == 'Null is NULL', isTrue);
    });

    test('Create Function Returns Success When Instance Is Valid', () {
      final result = create(Object());
      expect(result.isSuccess, isTrue);
      expect(result.value != null, isTrue);
    });
  });

  group('from() result tests', () {
    test('from Function Returns Failure When Predicate is false', () {
      final result = from<int>(0, (value) => value == 2);
      expect(result.isFailure, isTrue);
    });

    test('Create Function Returns Success When Predicate is True', () {
      final result = from<int>(2, (value) => value == 2);
      expect(result.isSuccess, isTrue);
      expect(result.value, 2);
    });
  });

  group('Result<TValue> Tests', () {
    test('Test isSuccess for successful result', () {
      final result = success(42);
      expect(result.isSuccess, isTrue);
    });

    test('Test isSuccess for failed result', () {
      final result = failure(message('Failed'));
      expect(result.isSuccess, isFalse);
    });

    test('Test isFailure for successful result', () {
      final result = success('Success');
      expect(result.isFailure, isFalse);
    });

    test('Test isFailure for failed result', () {
      final result = failure(message('Failed'));
      expect(result.isFailure, isTrue);
    });

    test('Test value for successful result', () {
      final result = success(true);
      expect(result.value, equals(true));
    });

    test('Test value for failed result', () {
      final result = failure(message('Failed'));
      expect(result.value, equals(null));
    });

    test('Test toString() for successful result', () {
      final result = success(3.14);
      expect(result.toString(), equals('3.14'));
    });

    test('Test toString() for failed result', () {
      final error1 = message('Error 1');
      final error2 = message('Error 2');
      final result = failures([error1, error2]);
      expect(result.toString(), equals('Error 1 | Error 2'));
    });

    test('Test create() for non-null value', () {
      final result = create(100);
      expect(result.isSuccess, isTrue);
      expect(result.value, equals(100));
    });

    test('Test create() for null value', () {
      final result = create(null);
      expect(result.isFailure, isTrue);
      expect(result.errors.length, equals(1));
      expect(result.errors.first.toString(), equals('Null is NULL'));
    });
  });

  group('create result tests', () {
    setUp(() {});

    test('Create Function Returns Failure When Instance Is Null', () {
      Object? obj;
      final result = create(obj);
      expect(result.isFailure, isTrue);
    });

    test('Create Function Returns Success When Instance Is Valid', () {
      Object obj = Object();
      final result = create(obj);
      expect(result.isSuccess, isTrue);
    });
  });

  group('ensure() result tests', () {
    setUp(() {});

    test('Ensure does not process Error', () {
      final result =
          create<String?>(null).ensure((value) => false, (err) => WhatEmpty());

      print(result.toString());

      expect(result.isFailure, isTrue);
      expect(result.errors.length == 1, isTrue);
    });

    test('Ensure adds Error', () {
      final result = create<String>('hello').ensure(
          (value) => value == 'hello!', (err) => message('Hello Does Not Equate'));

      print(result.toString());

      expect(result.isFailure, isTrue);
      expect(result.errors.length == 1, isTrue);
    });

    test('Ensure adds Mulitple Errors', () {
      final result = create<String>('hello')
          .ensure((value) => value == 'hello', (err) => message('Hello Does Not Equate'))
          .ensure(
              (value) => value == 'hello!', (err) => message('Hello Does Not Equate'));

      print(result.toString());

      expect(result.isFailure, isTrue);
      expect(result.errors.length == 1, isTrue);
    });

    test('Ensure creates successfull result from String', () {
      final result =
          create('hello').ensure((value) => value == 'hello', (err) => WhatEmpty());

      expect(result.isSuccess, isTrue);
      expect(result.value == 'hello', isTrue);
    });
  });

  group('map() result tests', () {
    test('Map does not process errors', () {
      final result = create<String>('1')
          .ensure((value) => value == '2', (err) => message('Value not equal 2'))
          .map<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isFailure, isTrue);
    });

    test('Map does not processor errors', () {
      final result = create<String>('1')
          .ensure((value) => value == '2', (err) => message('Value not equal 2'))
          .map<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isFailure, isTrue);
    });

    test('Map converts String to Int', () {
      final result = create<String>('1')
          .ensure((value) => value == '1', (err) => message('Value not equal 1'))
          .map<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isSuccess, isTrue);
    });
  });
  
  group('mapster() result tests', () {
    test('Mapster return exception as Error Result', () {
      final result = create<String>('A')
          .tryMap<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isFailure, isTrue);
    });
    
    test('Mapster return success Result', () {
      final result = create<String>('1')
          .tryMap<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isSuccess, isTrue);
    });

  });
  
  group('tap() result tests', () {
    test('tap adds to value of result', () {

      final result = create<int>(10)
          .tap((original) => from(original + 10, (tapped) => tapped == 20))
          .ensure((value) => value == 20, (err) => message('Value is NOT equal to 20'));

      print(result.toString());
      expect(result.isSuccess, isTrue);
      expect(result.value == 20, isTrue);
    });
    
    test('Mapster return success Result', () {
      final result = create<String>('1')
          .tryMap<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isSuccess, isTrue);
    });

  });

  group('ErrorEmpty Tests', () {
    test('Test ErrorEmpty for String', () {
      final errorString = WhatEmpty<String>();
      expect(errorString.toString(), 'String is NULL');
    });

    test('Test ErrorEmpty for int', () {
      final errorInt = WhatEmpty<int>();
      expect(errorInt.toString(), 'int is NULL');
    });

    test('Test ErrorEmpty for custom class', () {
      final errorCustom = WhatEmpty<CustomClass>();
      expect(errorCustom.toString(), 'CustomClass is NULL');
    });

    test('Test ErrorEmpty isEmpty property', () {
      final emptyError = WhatEmpty<int>();
      final messageError = WhatMessage('');
      final exceptionError = WhatException(Exception());
      final objectError = WhatObject('');

      expect(emptyError.isEmpty, isTrue);
      expect(messageError.isEmpty, isFalse);
      expect(exceptionError.isEmpty, isFalse);
      expect(objectError.isEmpty, isFalse);
    });

    test('Test ErrorEmpty isMessage property', () {
      final emptyError = WhatEmpty<int>();
      expect(emptyError.isMessage, isFalse);
    });

    test('Test ErrorEmpty isObject property', () {
      final emptyError = WhatEmpty<int>();
      expect(emptyError.isObject, isFalse);
    });

    test('Test ErrorEmpty isException property', () {
      final emptyError = WhatEmpty<int>();
      expect(emptyError.isException, isFalse);
    });
  });

  group('MessageError Tests', () {
    test('Test MessageError for String', () {
      final errorMessage = WhatMessage('message');
      expect(errorMessage.toString(), 'message');
    });

    test('Test MessageError isMessage property', () {
      final messageError = WhatMessage('');
      final emptyError = WhatEmpty<int>();
      final exceptionError = WhatException(Exception());
      final objectError = WhatObject('');

      expect(messageError.isMessage, isTrue);
      expect(emptyError.isMessage, isFalse);
      expect(exceptionError.isMessage, isFalse);
      expect(objectError.isMessage, isFalse);
    });

    test('Test MessageError isMessage property', () {
      final messageError = WhatMessage('');
      expect(messageError.isEmpty, isFalse);
    });

    test('Test MessageError isObject property', () {
      final messageError = WhatMessage('');
      expect(messageError.isObject, isFalse);
    });

    test('Test MessageError isException property', () {
      final messageError = WhatMessage('');
      expect(messageError.isException, isFalse);
    });
  });

  group('ErrorObject Tests', () {
    test('Test ErrorObject for String', () {
      final objectError = WhatObject(Exception('message'));
      expect(objectError.toString(), 'Exception: message');
    });

    test('Test ErrorObject for CustomerType', () {
      final objectError = WhatObject(CustomerErrorMessage());
      expect(objectError.toString(), 'Custom');
    });

    test('Test ErrorObject isObject property', () {
      final objectError = WhatObject(Exception());
      final messageError = WhatMessage('');
      final emptyError = WhatEmpty<int>();
      final exceptionError = WhatException(Exception());

      expect(objectError.isObject, isTrue);
      expect(messageError.isObject, isFalse);
      expect(emptyError.isObject, isFalse);
      expect(exceptionError.isObject, isFalse);
    });

    test('Test ErrorObject isMessage property', () {
      final objectError = WhatObject(Exception());
      expect(objectError.isEmpty, isFalse);
    });

    test('Test ErrorObject isObject property', () {
      final objectError = WhatObject(Exception());
      expect(objectError.isMessage, isFalse);
    });

    test('Test ErrorObject isException property', () {
      final objectError = WhatObject(Exception());
      expect(objectError.isException, isFalse);
    });
  });

  group('ErrorException Tests', () {
    test('Test ErrorException for String', () {
      final exceptionError = WhatException(Exception('message'));
      expect(exceptionError.toString(), 'Exception: message');
    });

    test('Test ErrorException isObject property', () {
      final exceptionError = WhatException(Exception());
      final messageError = WhatMessage('');
      final emptyError = WhatEmpty<int>();
      final objectError = WhatObject(Exception());

      expect(exceptionError.isException, isTrue);
      expect(messageError.isException, isFalse);
      expect(emptyError.isException, isFalse);
      expect(objectError.isException, isFalse);
    });

    test('Test ErrorException isEmpty property', () {
      final exceptionError = WhatException(Exception());
      expect(exceptionError.isEmpty, isFalse);
    });

    test('Test ErrorException isMessage property', () {
      final exceptionError = WhatException(Exception());
      expect(exceptionError.isMessage, isFalse);
    });

    test('Test ErrorException isObject property', () {
      final exceptionError = WhatException(Exception());
      expect(exceptionError.isObject, isFalse);
    });
  });
}

class CustomClass {}

class CustomerErrorMessage {
  @override
  String toString() {
    return 'Custom';
  }
}
