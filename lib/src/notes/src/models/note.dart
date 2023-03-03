import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'note.freezed.dart';
part 'note.g.dart';

const kDefaultNoteColor = 0xFF2196F3;

@freezed
class Note with _$Note {
  factory Note({
    /// The color associated with the note.
    required int color,

    /// The note's unique identifier.
    required String id,

    /// The note's index in the list of notes.
    required int index,

    /// The note's text.
    required String text,

    /// The note's title.
    required String title,
  }) = _Note;

  /// Create a new note.
  factory Note.newNote() => Note(
        color: kDefaultNoteColor,
        id: const Uuid().v4(),
        index: 0,
        text: '',
        title: '',
      );

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}

extension NotesListHelper on List<Note> {
  /// Sort the list of notes by index.
  List<Note> sortNotes() => sorted((a, b) => a.index.compareTo(b.index));
}
