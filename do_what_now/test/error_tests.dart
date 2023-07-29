import 'package:do_what_now/do_what_now.dart';
import 'package:test/test.dart';

void main() {
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
