
import 'package:do_what_now/do_what_now.dart';

/// This example illustrates handling http requests and responses.  
/// In order to prevent taking on any dependancies this example uses several mocked classes.
/// Again, the purpose is to demonstrate one of many use cases for [DoWhat] and [What]
/// 
/// A mocked http [getRequest] and [postRequest] method have been provided that return a standard [HttpResponse] object.
/// When a [String] is provided to the request method it returns 200 and otherwise 400.
/// The example code provided demonstrates handling the both cases.
void main() {
  
  happyHttpExample();
  sadHttpExample();
  exceptionHttpExample();
  combineExample();
}

/// We will start by sanitizing the input to our method.  Right away the result will be a failure if the URL where NULL.
/// ```
/// final doWhat = create<String>('urlForGetUsers') 
/// ```
/// We can then ensure the URL starts will http://, image for a minute the URL came from some external input and could be invalid.
/// ```
///   .ensure((url) => url!.startsWith('http://'), message('Url is invalid'))  
/// ```
/// We can then map the result to the getRequest method, thus creating a new Result<HttpResponse>, by using the tryMap the invocation of the getRequest is wrapped in exception handling.
/// ```
///   .tryMap<HttpResponse>((url) => getRequest(url))  
/// ```
/// At this point the doWhat instance is still succsefull assuming no exceptions have been thrown, and the url is valid.  
/// This instance started as a Result<String> and is now a Result<HttpResponse>.  We can now validate the [HttpResponse]
/// ```
/// .ensure(
///      (httpResponse) => httpResponse.statusCode == 200,       
///      (httpResponse) => message('Status Code ${httpResponse.statusCode}'))
/// ```
/// We can then confirm the boidy has data
/// .ensure(
///      (httpResponse) => httpResponse.body != null,                      
///      (httpResponse) => message('Http response contains no data'))
/// Lastly we attempt to convert the body to a new [User]
/// ```
/// .tryMap<User>((httpResponse) => User.fromMap(httpResponse.body!));
/// ```
/// Our [DoWhat] instance is NOW a Result<User> containing a valid User Object!
/// Should anything go wrong your can evaluate the [DoWhat] for errors and handle them accordingly.
void happyHttpExample() {
  final doWhat = create<String>('http://getusers')                              
    .ensure(
      (url) => url.startsWith('http://'),                     // Validate
      (url) => message('$url does not start with http://'))   // Provide Error  
    .tryMap<HttpResponse>((url) => getRequest(url))           // Convert                 
    .ensure(
      (httpResponse) => httpResponse.statusCode == 200,       // Validate
      (httpResponse) => message('Status Code ${httpResponse.statusCode}'))
    .ensure(
      (httpResponse) => httpResponse.body != null,                      // Validate
      (httpResponse) => message('Http response contains no data'))
    .tryMap<User>((httpResponse) => User.fromMap(httpResponse.body!));  //When KNOW the body is NOT Null!
  
  if(doWhat.isSuccess){
    print(doWhat);  // Will display the user.toSring()
  }
  
  if(doWhat.isFailure){
    print(doWhat);  // Will display the errors
  }
}

void sadHttpExample() {
  final doWhat = create<String>('http://getusers')                              
    .ensure(
      (url) => url.startsWith('http://'),                     // Validate
      (url) => message('$url does not start with http://'))   // Provide Error  
    .tryMap<HttpResponse>((url) => getRequest(''))            // oops, no URL               
    .ensure(
      (httpResponse) => httpResponse.statusCode == 200,       // Validate
      (httpResponse) => message('Status Code ${httpResponse.statusCode}'))
    .ensure(
      (httpResponse) => httpResponse.body != null,                      // Validate
      (httpResponse) => message('Http response contains no data'))
    .tryMap<User>((httpResponse) => User.fromMap(httpResponse.body!));  //When KNOW the body is NOT Null!
  
  if(doWhat.isSuccess){
    print(doWhat);  // Will display the user.toSring()
  }
  
  if(doWhat.isFailure){
    print(doWhat);  // Will display the errors
  }
}

void exceptionHttpExample() {
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
    .tryMap<User>((httpResponse) => User.fromMap(httpResponse.body!));  //When KNOW the body is NOT Null!
  
  if(doWhat.isSuccess){
    print(doWhat);  // Will display the user.toSring()
  }
  
  if(doWhat.isFailure){
    print(doWhat);  // Will display the errors
  }
}

/// Perhaps we need two valid responses from two differnt APIs that depend on one another.
/// No problem, we can use the [combine] extansion method to check the results of both [DoWhat]s and create a new [DoWhat]
/// The follwoing exmaple using two methods that return a [DoWhat] from an http Request and continues only if both responses are valid.
/// 
/// In the example we will create a new Super villian by eating two users.
void combineExample(){

  final doWhat = combine(
    getUserAccount('apple'), 
    getUserAccount('bannana'))
    .ensure(
      (users) => users.$1.name == 'apple' && users.$2.name == 'bannana', 
      (users) => message('One or More Users are Not Value'))
    .map<Villian>((users) => Villian.eatUsers(users.$1, users.$2))
    .ensure(
      (villian) => villian.user1.eaten && villian.user2.eaten, 
      (villian) => message('The villian didn\'t eat the users'));

    print(doWhat);
}

DoWhat<User> getUserAccount(String name) =>
  create(name)
    .map<String>((name) => 'http://getusers/$name')                              
    .ensure(
      (url) => url.startsWith('http://'),                     
      (url) => message('$url does not start with http://'))    
    .tryMap<HttpResponse>((url) => getRequest(url, name: name))                           
    .ensure(
      (httpResponse) => httpResponse.statusCode == 200,       
      (httpResponse) => message('Status Code ${httpResponse.statusCode}'))
    .ensure(
      (httpResponse) => httpResponse.body != null,                      
      (httpResponse) => message('Http response contains no data'))
    .tryMap<User>((httpResponse) => User.fromMap(httpResponse.body!));  


HttpResponse getRequest(String url, {String? name}) =>
  url.isNotEmpty 
  ? HttpResponse(200, {'email':'something@something.com', 'name': name?? 'some thing'})
  : HttpResponse(400, null);

HttpResponse throwGetRequest(String url) =>
  url.isNotEmpty 
  ? HttpResponse(200, {'email':'something@something.com', 'name': 'some thing'})
  : throw(ArgumentError(url));

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