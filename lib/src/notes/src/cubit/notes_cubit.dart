import 'package:collection/collection.dart';
import 'package:desktop_notes/src/src.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_state.dart';
part 'notes_cubit.freezed.dart';

class NotesCubit extends Cubit<NotesState> {
  static late NotesCubit instance;

  NotesCubit() : super(NotesState.initial()) {
    instance = this;
    _init();
  }

  /// Initialize the cubit.
  Future<void> _init() async {
    await _loadNotes();
  }

  /// Load notes from storage.
  ///
  /// If no notes exist, create a new note.
  Future<void> _loadNotes() async {
    final List<Note> notes = await NotesDatabase.instance.getAll();

    String? selectedNoteId = await StorageRepository.instance.get(
      'selectedNoteId',
    );

    if (notes.isEmpty) {
      final note = Note.newNote();
      await NotesDatabase.instance.save(note);
      notes.add(note);
      selectedNoteId = note.id;
    }

    Note? selectedNote = notes.firstWhereOrNull(
      (note) => note.id == selectedNoteId,
    );

    selectedNote ??= notes.first;

    emit(state.copyWith(
      loading: false,
      notes: notes.sortNotes(),
      selectedNote: selectedNote,
    ));
  }

  /// Create a new note.
  Future<void> create() async {
    final note = Note.newNote();

    emit(state.copyWith(
      notes: [note, ...state.notes],
      selectedNote: note,
    ));

    await NotesDatabase.instance.save(note);
  }

  /// Delete a note from storage.
  Future<void> delete(Note note) async {
    final notes = state.notes.where((n) => n.id != note.id).toList();
    select(notes.first);
    emit(state.copyWith(notes: notes));
    await NotesDatabase.instance.delete(note);
  }

  /// Delete all notes from storage.
  Future<void> deleteAll() async {
    await NotesDatabase.instance.deleteAll();
  }

  /// Reorder the notes.
  ///
  /// Updates the index for each note, emits the new state, and saves the notes.
  Future<void> reorder(int oldIndex, int newIndex) async {
    final notes = [...state.notes];
    final note = notes.removeAt(oldIndex);
    notes.insert(newIndex, note);

    for (var i = 0; i < notes.length; i++) {
      notes[i] = notes[i].copyWith(index: i);
    }

    emit(state.copyWith(notes: notes));
    await NotesDatabase.instance.saveAll(notes);
  }

  /// Save a note to storage.
  Future<void> save(Note note) async {
    await NotesDatabase.instance.save(note);
  }

  /// Select a note.
  void select(Note note) {
    emit(state.copyWith(selectedNote: note));
    StorageRepository.instance.save(key: 'selectedNoteId', value: note.id);
  }

  /// Update a note.
  Future<void> update(Note note) async {
    final notes = [...state.notes];
    final index = notes.indexWhere((e) => e.id == note.id);
    notes[index] = note;

    emit(state.copyWith(
      notes: notes,
      selectedNote: note,
    ));

    await save(note);
  }
}
