// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notes_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotesState {
  /// Whether the notes are loading.
  bool get loading => throw _privateConstructorUsedError;

  /// The list of notes.
  List<Note> get notes => throw _privateConstructorUsedError;

  /// The currently selected note.
  Note get selectedNote => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotesStateCopyWith<NotesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotesStateCopyWith<$Res> {
  factory $NotesStateCopyWith(
          NotesState value, $Res Function(NotesState) then) =
      _$NotesStateCopyWithImpl<$Res, NotesState>;
  @useResult
  $Res call({bool loading, List<Note> notes, Note selectedNote});

  $NoteCopyWith<$Res> get selectedNote;
}

/// @nodoc
class _$NotesStateCopyWithImpl<$Res, $Val extends NotesState>
    implements $NotesStateCopyWith<$Res> {
  _$NotesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? notes = null,
    Object? selectedNote = null,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<Note>,
      selectedNote: null == selectedNote
          ? _value.selectedNote
          : selectedNote // ignore: cast_nullable_to_non_nullable
              as Note,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NoteCopyWith<$Res> get selectedNote {
    return $NoteCopyWith<$Res>(_value.selectedNote, (value) {
      return _then(_value.copyWith(selectedNote: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_NotesStateCopyWith<$Res>
    implements $NotesStateCopyWith<$Res> {
  factory _$$_NotesStateCopyWith(
          _$_NotesState value, $Res Function(_$_NotesState) then) =
      __$$_NotesStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool loading, List<Note> notes, Note selectedNote});

  @override
  $NoteCopyWith<$Res> get selectedNote;
}

/// @nodoc
class __$$_NotesStateCopyWithImpl<$Res>
    extends _$NotesStateCopyWithImpl<$Res, _$_NotesState>
    implements _$$_NotesStateCopyWith<$Res> {
  __$$_NotesStateCopyWithImpl(
      _$_NotesState _value, $Res Function(_$_NotesState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? notes = null,
    Object? selectedNote = null,
  }) {
    return _then(_$_NotesState(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<Note>,
      selectedNote: null == selectedNote
          ? _value.selectedNote
          : selectedNote // ignore: cast_nullable_to_non_nullable
              as Note,
    ));
  }
}

/// @nodoc

class _$_NotesState implements _NotesState {
  const _$_NotesState(
      {required this.loading,
      required final List<Note> notes,
      required this.selectedNote})
      : _notes = notes;

  /// Whether the notes are loading.
  @override
  final bool loading;

  /// The list of notes.
  final List<Note> _notes;

  /// The list of notes.
  @override
  List<Note> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  /// The currently selected note.
  @override
  final Note selectedNote;

  @override
  String toString() {
    return 'NotesState(loading: $loading, notes: $notes, selectedNote: $selectedNote)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotesState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            (identical(other.selectedNote, selectedNote) ||
                other.selectedNote == selectedNote));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading,
      const DeepCollectionEquality().hash(_notes), selectedNote);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NotesStateCopyWith<_$_NotesState> get copyWith =>
      __$$_NotesStateCopyWithImpl<_$_NotesState>(this, _$identity);
}

abstract class _NotesState implements NotesState {
  const factory _NotesState(
      {required final bool loading,
      required final List<Note> notes,
      required final Note selectedNote}) = _$_NotesState;

  @override

  /// Whether the notes are loading.
  bool get loading;
  @override

  /// The list of notes.
  List<Note> get notes;
  @override

  /// The currently selected note.
  Note get selectedNote;
  @override
  @JsonKey(ignore: true)
  _$$_NotesStateCopyWith<_$_NotesState> get copyWith =>
      throw _privateConstructorUsedError;
}
