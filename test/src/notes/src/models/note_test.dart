/// Unit tests for the [Note] class.

import 'package:desktop_notes/src/src.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('Note:', () {
    test('newNote() returns a new note', () {
      final note = Note.newNote();
      expect(note.id, isNotNull);
      expect(note.title, isEmpty);
      expect(note.text, isEmpty);
      expect(note.color, kDefaultNoteColor);
    });

    test('fromJson() returns a note from a JSON map', () {
      final note = Note.newNote();
      final noteFromJson = Note.fromJson(note.toJson());
      expect(noteFromJson, note);
    });

    test('toJson() returns a JSON map from a note', () {
      final note = Note.newNote();
      final noteJson = note.toJson();
      expect(noteJson['id'], note.id);
      expect(noteJson['title'], note.title);
      expect(noteJson['text'], note.text);
      expect(noteJson['color'], note.color);
    });

    test('copyWith() returns a copy of the note', () {
      final note = Note.newNote();
      final noteCopy = note.copyWith();
      expect(noteCopy, note);
    });

    test('copyWith() returns a copy of the note with the given values', () {
      final note = Note.newNote();
      final noteCopy = note.copyWith(
        title: 'title',
        text: 'text',
        color: 0xFF000000,
      );
      expect(noteCopy, isNot(note));
      expect(noteCopy.title, 'title');
      expect(noteCopy.text, 'text');
      expect(noteCopy.color, 0xFF000000);
    });

    group('NotesListHelper:', () {
      test('sortNotes() sorts the list of notes by index', () {
        final note1 = Note(
          id: const Uuid().v4(),
          index: 0,
          title: 'title1',
          text: 'text1',
          color: 0xFF000000,
        );

        final note2 = Note(
          id: const Uuid().v4(),
          index: 1,
          title: 'title2',
          text: 'text2',
          color: 0xFF000000,
        );

        final note3 = Note(
          id: const Uuid().v4(),
          index: 2,
          title: 'title3',
          text: 'text3',
          color: 0xFF000000,
        );

        final unsortedNotes = [note3, note1, note2];
        final sortedNotes = [note1, note2, note3];

        expect(unsortedNotes.sortNotes(), sortedNotes);
      });
    });
  });
}
