import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
class Note with _$Note {
  factory Note({
    /// The note's unique identifier.
    required String id,

    /// The note's text.
    required String text,

    /// The note's title.
    required String title,
  }) = _Note;

  /// Create a new note.
  factory Note.newNote() => Note(
        id: const Uuid().v4(),
        text: '',
        title: '',
      );

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
