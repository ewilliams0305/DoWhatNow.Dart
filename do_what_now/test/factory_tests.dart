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
}