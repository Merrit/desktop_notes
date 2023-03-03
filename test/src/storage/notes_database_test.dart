/// Unit tests for the [NotesDatabase] class.

import 'dart:io';

import 'package:desktop_notes/src/src.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../common/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotesDatabase:', () {
    late NotesDatabase database;

    setUpAll(() async {
      setMockPathProviderPlatform();
      await LoggingManager.initialize(verbose: false);
    });

    setUp(() async {
      database = await NotesDatabase.init();
    });

    tearDown(() async {
      await NotesDatabase.instance.close();
      await _deleteTestDatabase();
    });

    test('getAll() returns an empty list when the database is empty', () async {
      final notes = await database.getAll();
      expect(notes, isEmpty);
    });

    test('getAll() returns a list of notes', () async {
      final note1 = Note.newNote();
      final note2 = Note.newNote();
      final note3 = Note.newNote();

      await database.save(note1);
      await database.save(note2);
      await database.save(note3);

      final notes = [note1, note2, note3] //
        ..sort((a, b) => b.id.compareTo(a.id));

      final notesFromDb = await database.getAll()
        ..sort((a, b) => b.id.compareTo(a.id));

      expect(notesFromDb, notes);
    });

    test('save() saves a note to the database', () async {
      final note = Note.newNote();
      await database.save(note);
      final notesFromDb = await database.getAll();
      expect(notesFromDb, [note]);
    });

    test('save() updates a note in the database', () async {
      final note = Note.newNote();
      await database.save(note);

      final updatedNote = note.copyWith(title: 'Updated title');
      await database.save(updatedNote);

      final notesFromDb = await database.getAll();
      expect(notesFromDb, [updatedNote]);
    });

    test('saveAll() saves a list of notes to the database', () async {
      final note1 = Note.newNote();
      final note2 = Note.newNote();
      final note3 = Note.newNote();

      await database.saveAll([note1, note2, note3]);

      final notes = [note1, note2, note3] //
        ..sort((a, b) => b.id.compareTo(a.id));

      final notesFromDb = await database.getAll()
        ..sort((a, b) => b.id.compareTo(a.id));

      expect(notesFromDb, notes);
    });

    test('saveAll() updates a list of notes in the database', () async {
      final note1 = Note.newNote();
      final note2 = Note.newNote();
      final note3 = Note.newNote();

      await database.saveAll([note1, note2, note3]);

      final updatedNote1 = note1.copyWith(title: 'Updated title');
      final updatedNote2 = note2.copyWith(title: 'Updated title');
      final updatedNote3 = note3.copyWith(title: 'Updated title');

      await database.saveAll([updatedNote1, updatedNote2, updatedNote3]);

      final notes = [updatedNote1, updatedNote2, updatedNote3] //
        ..sort((a, b) => b.id.compareTo(a.id));

      final notesFromDb = await database.getAll()
        ..sort((a, b) => b.id.compareTo(a.id));

      expect(notesFromDb, notes);
    });

    test('delete() deletes a note from the database', () async {
      final note = Note.newNote();
      await database.save(note);
      await database.delete(note);
      final notesFromDb = await database.getAll();
      expect(notesFromDb, isEmpty);
    });

    test('delete() does nothing if the note does not exist', () async {
      final note = Note.newNote();
      await database.delete(note);
      final notesFromDb = await database.getAll();
      expect(notesFromDb, isEmpty);
    });

    test('deleteAll() deletes all notes from the database', () async {
      final note1 = Note.newNote();
      final note2 = Note.newNote();
      final note3 = Note.newNote();

      await database.save(note1);
      await database.save(note2);
      await database.save(note3);

      await database.deleteAll();

      final notesFromDb = await database.getAll();
      expect(notesFromDb, isEmpty);
    });

    test('deleteAll() does nothing if the database is empty', () async {
      await database.deleteAll();
      final notesFromDb = await database.getAll();
      expect(notesFromDb, isEmpty);
    });
  });
}

/// Delete the test database file.
///
/// This is called after each test to ensure that the database is empty.
Future<void> _deleteTestDatabase() async {
  final databasePath = NotesDatabase.instance.databasePath;
  final databaseFile = File(databasePath);
  if (await databaseFile.exists()) {
    await databaseFile.delete();
  }
}
