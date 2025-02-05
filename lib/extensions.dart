// import 'package:bloc_tutorial/bloc/bloc_action.dart' show PersonUrl;
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

// extension UrlString on PersonUrl {
//   String get urlString {
//     switch (this) {
//       case PersonUrl.persons1:
//         return 'http://10.0.2.2:5500/api/person1.json';
//       case PersonUrl.persons2:
//         return 'http://10.0.2.2:5500/api/person2.json';
//     }
//   }
// }

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}
