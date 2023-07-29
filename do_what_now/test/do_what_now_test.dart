import 'package:do_what_now/do_what_now.dart';
import 'package:do_what_now/src/extensions.dart';
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
          create<String?>(null).ensure((value) => false, ErrorEmpty());

      print(result.toString());

      expect(result.isFailure, isTrue);
      expect(result.errors.length == 1, isTrue);
    });

    test('Ensure adds Error', () {
      final result = create<String>('hello').ensure(
          (value) => value == 'hello!', message('Hello Does Not Equate'));

      print(result.toString());

      expect(result.isFailure, isTrue);
      expect(result.errors.length == 1, isTrue);
    });

    test('Ensure adds Mulitple Errors', () {
      final result = create<String>('hello')
          .ensure((value) => value == 'hello', message('Hello Does Not Equate'))
          .ensure(
              (value) => value == 'hello!', message('Hello Does Not Equate'));

      print(result.toString());

      expect(result.isFailure, isTrue);
      expect(result.errors.length == 1, isTrue);
    });

    test('Ensure creates successfull result from String', () {
      final result =
          create('hello').ensure((value) => value == 'hello', ErrorEmpty());

      expect(result.isSuccess, isTrue);
      expect(result.value == 'hello', isTrue);
    });
  });

  group('map() result tests', () {
    test('Map does not process errors', () {
      final result = create<String>('1')
          .ensure((value) => value == '2', message('Value not equal 2'))
          .map<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isFailure, isTrue);
    });

    test('Map does not processor errors', () {
      final result = create<String>('1')
          .ensure((value) => value == '2', message('Value not equal 2'))
          .map<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isFailure, isTrue);
    });

    test('Map converts String to Int', () {
      final result = create<String>('1')
          .ensure((value) => value == '1', message('Value not equal 1'))
          .map<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isSuccess, isTrue);
      expect(result.runtimeType.toString() == 'Result<int>', isTrue);
    });
  });
  
  group('mapster() result tests', () {
    test('Mapster return exception as Error Result', () {
      final result = create<String>('A')
          .mapster<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isFailure, isTrue);
    });
    
    test('Mapster return success Result', () {
      final result = create<String>('1')
          .mapster<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isSuccess, isTrue);
    });

  });
  
  group('tap() result tests', () {
    test('tap adds to value of result', () {

      final result = create<int>(10)
          .tap((original) => from(original + 10, (tapped) => tapped == 20))
          .ensure((value) => value == 20, message('Value is NOT equal to 20'));

      print(result.toString());
      expect(result.isSuccess, isTrue);
      expect(result.value == 20, isTrue);
    });
    
    test('Mapster return success Result', () {
      final result = create<String>('1')
          .mapster<int>((input) => int.parse(input));

      print(result.toString());
      expect(result.isSuccess, isTrue);
    });

  });

  group('ErrorEmpty Tests', () {
    test('Test ErrorEmpty for String', () {
      final errorString = ErrorEmpty<String>();
      expect(errorString.toString(), 'String is NULL');
    });

    test('Test ErrorEmpty for int', () {
      final errorInt = ErrorEmpty<int>();
      expect(errorInt.toString(), 'int is NULL');
    });

    test('Test ErrorEmpty for custom class', () {
      final errorCustom = ErrorEmpty<CustomClass>();
      expect(errorCustom.toString(), 'CustomClass is NULL');
    });

    test('Test ErrorEmpty isEmpty property', () {
      final emptyError = ErrorEmpty<int>();
      final messageError = ErrorMessage('');
      final exceptionError = ErrorException(Exception());
      final objectError = ErrorObject('');

      expect(emptyError.isEmpty, isTrue);
      expect(messageError.isEmpty, isFalse);
      expect(exceptionError.isEmpty, isFalse);
      expect(objectError.isEmpty, isFalse);
    });

    test('Test ErrorEmpty isMessage property', () {
      final emptyError = ErrorEmpty<int>();
      expect(emptyError.isMessage, isFalse);
    });

    test('Test ErrorEmpty isObject property', () {
      final emptyError = ErrorEmpty<int>();
      expect(emptyError.isObject, isFalse);
    });

    test('Test ErrorEmpty isException property', () {
      final emptyError = ErrorEmpty<int>();
      expect(emptyError.isException, isFalse);
    });
  });

  group('MessageError Tests', () {
    test('Test MessageError for String', () {
      final errorMessage = ErrorMessage('message');
      expect(errorMessage.toString(), 'message');
    });

    test('Test MessageError isMessage property', () {
      final messageError = ErrorMessage('');
      final emptyError = ErrorEmpty<int>();
      final exceptionError = ErrorException(Exception());
      final objectError = ErrorObject('');

      expect(messageError.isMessage, isTrue);
      expect(emptyError.isMessage, isFalse);
      expect(exceptionError.isMessage, isFalse);
      expect(objectError.isMessage, isFalse);
    });

    test('Test MessageError isMessage property', () {
      final messageError = ErrorMessage('');
      expect(messageError.isEmpty, isFalse);
    });

    test('Test MessageError isObject property', () {
      final messageError = ErrorMessage('');
      expect(messageError.isObject, isFalse);
    });

    test('Test MessageError isException property', () {
      final messageError = ErrorMessage('');
      expect(messageError.isException, isFalse);
    });
  });

  group('ErrorObject Tests', () {
    test('Test ErrorObject for String', () {
      final objectError = ErrorObject(Exception('message'));
      expect(objectError.toString(), 'Exception: message');
    });

    test('Test ErrorObject for CustomerType', () {
      final objectError = ErrorObject(CustomerErrorMessage());
      expect(objectError.toString(), 'Custom');
    });

    test('Test ErrorObject isObject property', () {
      final objectError = ErrorObject(Exception());
      final messageError = ErrorMessage('');
      final emptyError = ErrorEmpty<int>();
      final exceptionError = ErrorException(Exception());

      expect(objectError.isObject, isTrue);
      expect(messageError.isObject, isFalse);
      expect(emptyError.isObject, isFalse);
      expect(exceptionError.isObject, isFalse);
    });

    test('Test ErrorObject isMessage property', () {
      final objectError = ErrorObject(Exception());
      expect(objectError.isEmpty, isFalse);
    });

    test('Test ErrorObject isObject property', () {
      final objectError = ErrorObject(Exception());
      expect(objectError.isMessage, isFalse);
    });

    test('Test ErrorObject isException property', () {
      final objectError = ErrorObject(Exception());
      expect(objectError.isException, isFalse);
    });
  });

  group('ErrorException Tests', () {
    test('Test ErrorException for String', () {
      final exceptionError = ErrorException(Exception('message'));
      expect(exceptionError.toString(), 'Exception: message');
    });

    test('Test ErrorException isObject property', () {
      final exceptionError = ErrorException(Exception());
      final messageError = ErrorMessage('');
      final emptyError = ErrorEmpty<int>();
      final objectError = ErrorObject(Exception());

      expect(exceptionError.isException, isTrue);
      expect(messageError.isException, isFalse);
      expect(emptyError.isException, isFalse);
      expect(objectError.isException, isFalse);
    });

    test('Test ErrorException isEmpty property', () {
      final exceptionError = ErrorException(Exception());
      expect(exceptionError.isEmpty, isFalse);
    });

    test('Test ErrorException isMessage property', () {
      final exceptionError = ErrorException(Exception());
      expect(exceptionError.isMessage, isFalse);
    });

    test('Test ErrorException isObject property', () {
      final exceptionError = ErrorException(Exception());
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
