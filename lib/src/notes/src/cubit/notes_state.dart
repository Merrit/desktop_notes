part of 'notes_cubit.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    /// Whether the notes are loading.
    required bool loading,

    /// The list of notes.
    required List<Note> notes,

    /// The currently selected note.
    required Note selectedNote,
  }) = _NotesState;

  /// The initial state.
  factory NotesState.initial() {
    final selectedNote = Note.newNote().copyWith(id: 'loading');

    return NotesState(
      loading: true,
      notes: [],
      selectedNote: selectedNote,
    );
  }
}
