import 'package:do_what_now/do_what_now.dart';
import 'package:test/test.dart';

void main() {
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
}
