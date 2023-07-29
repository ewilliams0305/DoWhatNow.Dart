
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

    // test('Test ErrorEmpty isEmpty property', () {
    //   final emptyError = ErrorEmpty<int>();
    //   final nonEmptyError = ErrorEmpty<String>()..error = 'Error message';

    //   expect(emptyError.isEmpty, isTrue);
    //   expect(nonEmptyError.isEmpty, isFalse);
    // });

    // test('Test ErrorEmpty isMessage property', () {
    //   final messageError = ErrorEmpty<String>()..error = 'Error message';
    //   final nonMessageError = ErrorEmpty<int>();

    //   expect(messageError.isMessage, isTrue);
    //   expect(nonMessageError.isMessage, isFalse);
    // });

    // test('Test ErrorEmpty isObject property', () {
    //   final objectError = ErrorEmpty<CustomClass>()..error = CustomClass();
    //   final nonObjectError = ErrorEmpty<int>();

    //   expect(objectError.isObject, isTrue);
    //   expect(nonObjectError.isObject, isFalse);
    // });

    // test('Test ErrorEmpty isException property', () {
    //   final exceptionError = ErrorEmpty<int>()..error = 'Exception';
    //   final nonExceptionError = ErrorEmpty<CustomClass>();

    //   expect(exceptionError.isException, isTrue);
    //   expect(nonExceptionError.isException, isFalse);
    // });
  });
}

class CustomClass {}