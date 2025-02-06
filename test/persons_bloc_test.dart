import 'package:bloc_tutorial/bloc/bloc_action.dart';
import 'package:bloc_tutorial/bloc/person.dart';
import 'package:bloc_tutorial/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPersons1 = [
  Person(name: 'John Doe', age: 20),
  Person(name: 'Jane Doe', age: 30),
];

const mockedPersons2 = [
  Person(name: 'John Doe', age: 20),
  Person(name: 'Jane Doe', age: 30),
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockedPersons1);

Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockedPersons2);

void main() {
  group('Testing bloc', () {
    late PersonsBloc bloc;

    setUp(() {
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      'Test Initial State',
      build: () => bloc,
      verify: (bloc) => bloc.state == null,
    );

    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons from first iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          LoadPersonsAction(
            url: 'test_url_1',
            loader: mockGetPersons1,
          ),
        );
        bloc.add(
          LoadPersonsAction(
            url: 'test_url_1',
            loader: mockGetPersons1,
          ),
        );
      },
      expect: () => [
        FetchResult(
          persons: mockedPersons1,
          isRetrievedFromCache: false,
        ),
        FetchResult(
          persons: mockedPersons1,
          isRetrievedFromCache: true,
        )
      ],
    );
    blocTest<PersonsBloc, FetchResult?>(
      'Mock retrieving persons from second iterable',
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          LoadPersonsAction(
            url: 'test_url_2',
            loader: mockGetPersons2,
          ),
        );
        bloc.add(
          LoadPersonsAction(
            url: 'test_url_2',
            loader: mockGetPersons2,
          ),
        );
      },
      expect: () => [
        FetchResult(
          persons: mockedPersons2,
          isRetrievedFromCache: false,
        ),
        FetchResult(
          persons: mockedPersons2,
          isRetrievedFromCache: true,
        )
      ],
    );
  });
}
