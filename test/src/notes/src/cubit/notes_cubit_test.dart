import 'package:bloc_test/bloc_test.dart';
import 'package:desktop_notes/src/src.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../common/path_provider.dart';

class MockNotesDatabase extends Mock implements NotesDatabase {}

class MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotesCubit:', () {
    late NotesCubit cubit;
    late MockNotesDatabase mockNotesDatabase;
    late MockStorageRepository mockStorageRepository;

    setUpAll(() async {
      setMockPathProviderPlatform();
      registerFallbackValue(Note.newNote());
      await LoggingManager.initialize(verbose: false);
    });

    setUp(() async {
      // Mock the database
      mockNotesDatabase = MockNotesDatabase();
      NotesDatabase.instance = mockNotesDatabase;
      when(() => mockNotesDatabase.getAll()).thenAnswer((_) async => []);
      when(() => mockNotesDatabase.save(any())).thenAnswer((_) async {});
      when(() => mockNotesDatabase.saveAll(any())).thenAnswer((_) async {});

      // Mock the storage repository
      mockStorageRepository = MockStorageRepository();
      StorageRepository.instance = mockStorageRepository;
      when(() => mockStorageRepository.get('selectedNoteId'))
          .thenAnswer((_) async => null);

      // Create the cubit
      cubit = NotesCubit();
    });

    test('initial state is NotesState.initial()', () {
      expect(cubit.state, NotesState.initial());
    });

    group('reorder:', () {
      final note1 = Note.newNote().copyWith(id: '1', title: 'Note 1', index: 0);
      final note2 = Note.newNote().copyWith(id: '2', title: 'Note 2', index: 1);
      final note3 = Note.newNote().copyWith(id: '3', title: 'Note 3', index: 2);

      blocTest<NotesCubit, NotesState>(
        'reorder() emits a new state with the notes in the new order',
        build: () => cubit,
        seed: () => NotesState(
          loading: false,
          notes: [note1, note2, note3],
          selectedNote: note1,
        ),
        act: (cubit) => cubit.reorder(0, 2),
        expect: () {
          final reorderedNote1 = note1.copyWith(index: 2);
          final reorderedNote2 = note2.copyWith(index: 0);
          final reorderedNote3 = note3.copyWith(index: 1);

          return [
            NotesState(
              loading: false,
              notes: [reorderedNote2, reorderedNote3, reorderedNote1],
              selectedNote: note1,
            ),
          ];
        },
      );

      blocTest<NotesCubit, NotesState>(
        'reorder() saves the notes to the database',
        build: () => cubit,
        seed: () => NotesState(
          loading: false,
          notes: [note1, note2, note3],
          selectedNote: note1,
        ),
        act: (cubit) => cubit.reorder(0, 2),
        verify: (_) {
          final reorderedNote1 = note1.copyWith(index: 2);
          final reorderedNote2 = note2.copyWith(index: 0);
          final reorderedNote3 = note3.copyWith(index: 1);

          verify(() => mockNotesDatabase.saveAll([
                reorderedNote2,
                reorderedNote3,
                reorderedNote1,
              ])).called(1);
        },
      );
    });
  });
}
