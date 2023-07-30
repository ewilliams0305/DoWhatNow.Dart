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

  group('Intigration Tests', () {

    test('Verify Create can Ensure and Map to Result', () {
      final doWhat = create<String>('http://getusers')                              
        .ensure(
          (url) => url.startsWith('http://'),                     
          (url) => message('$url does not start with http://'))    
        .tryMap<HttpResponse>((url) => getRequest(url))                           
        .ensure(
          (httpResponse) => httpResponse.statusCode == 200,       
          (httpResponse) => message('Status Code ${httpResponse.statusCode}'))
        .ensure(
          (httpResponse) => httpResponse.body != null,                     
          (httpResponse) => message('Http response contains no data'))
        .tryMap<User>((httpResponse) => User.fromMap(httpResponse.body!));  
      expect(doWhat.isSuccess, isTrue);
      expect(doWhat.value != null, isTrue);
      expect(doWhat.value!.name == 'some thing', isTrue);
    });
    
    test('Verify Create can Ensure and Map to Error', () {
      final doWhat = create<String>('http://getusers')                              
      .ensure(
        (url) => url.startsWith('http://'),                     
        (url) => message('$url does not start with http://'))  
      .tryMap<HttpResponse>((url) => getRequest(''))                      
      .ensure(
        (httpResponse) => httpResponse.statusCode == 200,       
        (httpResponse) => message('Status Code ${httpResponse.statusCode}'))
      .ensure(
        (httpResponse) => httpResponse.body != null,                      
        (httpResponse) => message('Http response contains no data'))
      .tryMap<User>((httpResponse) => User.fromMap(httpResponse.body!)); 

      expect(doWhat.isFailure, isTrue);
      expect(doWhat.value == null, isTrue);
      expect(doWhat.errors.isNotEmpty, isTrue);
    });
   
    test('Verify Create can Ensure and Map to Exception', () {
      final doWhat = create<String>('http://getusers')                              
      .ensure(
        (url) => url.startsWith('http://'),                     // Validate
        (url) => message('$url does not start with http://'))   // Provide Error  
      .tryMap<HttpResponse>((url) => throwGetRequest(''))       // throws exception            
      .ensure(
        (httpResponse) => httpResponse.statusCode == 200,       // Validate
        (httpResponse) => message('Status Code ${httpResponse.statusCode}'))
      .ensure(
        (httpResponse) => httpResponse.body != null,                      // Validate
        (httpResponse) => message('Http response contains no data'))
      .tryMap<User>((httpResponse) => User.fromMap(httpResponse.body!));

      expect(doWhat.isFailure, isTrue);
      expect(doWhat.value == null, isTrue);
      expect(doWhat.errors.isNotEmpty, isTrue);
      expect(doWhat.errors[0] is WhatException, isTrue);
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


HttpResponse getRequest(String url, {String? name}) =>
  url.isNotEmpty 
  ? HttpResponse(200, {'email':'something@something.com', 'name': name?? 'some thing'})
  : HttpResponse(400, null);

HttpResponse throwGetRequest(String url) =>
  url.isNotEmpty 
  ? HttpResponse(200, {'email':'something@something.com', 'name': 'some thing'})
  : throw Exception(ArgumentError(url));

HttpResponse postRequest(String url) =>
  url.isNotEmpty 
  ? HttpResponse(200, {})
  : HttpResponse(400, null);


class HttpResponse {
  final int statusCode;
  final Map<String, dynamic>? body;
  
  const HttpResponse(this.statusCode, this.body);
}

class User {
  final String name;
  final String email;

  bool eaten;

  User(this.email, this.name): eaten = false;

  factory User.fromMap(Map<String, dynamic> map) =>
    User(
      map['email'] as String, 
      map['name'] as String);

  @override
  String toString() {
    return 'name: $name, email: $email';
  }
}

class Villian {
  
  final User user1;
  final User user2;

  final String ominousMessage;

  factory Villian.eatUsers(User user1, User user2) {
    user1.eaten = true;
    user2.eaten = true;

    return Villian._create(user1, user2);
  }

    Villian._create(this.user1, this.user2):ominousMessage = 'I have eaten ${user1.name} and ${user2.name}!';

    @override
    String toString() => ominousMessage;
    
  }