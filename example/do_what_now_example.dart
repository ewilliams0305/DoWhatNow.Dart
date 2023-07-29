
import 'package:do_what_now/do_what_now.dart';

void main() {
  
  // Don't forget to define the generic Type to avoid usage of dynamic
  final doWhat = create<String>('value');

  if(doWhat.isSuccess){
    // this is now true as the 'value' string was a valid String
  }
  
}

