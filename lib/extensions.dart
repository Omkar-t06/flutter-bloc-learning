import 'package:bloc_tutorial/main.dart' show PersonUrl;

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.persons1:
        return 'http://10.0.2.2:5500/api/person1.json';
      case PersonUrl.persons2:
        return 'http://10.0.2.2:5500/api/person2.json';
    }
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}
