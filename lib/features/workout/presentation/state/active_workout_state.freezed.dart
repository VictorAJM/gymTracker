// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_workout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ActiveWorkoutState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ExerciseEntry> exercises,
            String? expandedExerciseId, String sessionId)
        loaded,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExerciseEntry> exercises, String? expandedExerciseId,
            String sessionId)?
        loaded,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExerciseEntry> exercises, String? expandedExerciseId,
            String sessionId)?
        loaded,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActiveWorkoutLoaded value) loaded,
    required TResult Function(ActiveWorkoutLoading value) loading,
    required TResult Function(ActiveWorkoutError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActiveWorkoutLoaded value)? loaded,
    TResult? Function(ActiveWorkoutLoading value)? loading,
    TResult? Function(ActiveWorkoutError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActiveWorkoutLoaded value)? loaded,
    TResult Function(ActiveWorkoutLoading value)? loading,
    TResult Function(ActiveWorkoutError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveWorkoutStateCopyWith<$Res> {
  factory $ActiveWorkoutStateCopyWith(
          ActiveWorkoutState value, $Res Function(ActiveWorkoutState) then) =
      _$ActiveWorkoutStateCopyWithImpl<$Res, ActiveWorkoutState>;
}

/// @nodoc
class _$ActiveWorkoutStateCopyWithImpl<$Res, $Val extends ActiveWorkoutState>
    implements $ActiveWorkoutStateCopyWith<$Res> {
  _$ActiveWorkoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveWorkoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ActiveWorkoutLoadedImplCopyWith<$Res> {
  factory _$$ActiveWorkoutLoadedImplCopyWith(_$ActiveWorkoutLoadedImpl value,
          $Res Function(_$ActiveWorkoutLoadedImpl) then) =
      __$$ActiveWorkoutLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<ExerciseEntry> exercises,
      String? expandedExerciseId,
      String sessionId});
}

/// @nodoc
class __$$ActiveWorkoutLoadedImplCopyWithImpl<$Res>
    extends _$ActiveWorkoutStateCopyWithImpl<$Res, _$ActiveWorkoutLoadedImpl>
    implements _$$ActiveWorkoutLoadedImplCopyWith<$Res> {
  __$$ActiveWorkoutLoadedImplCopyWithImpl(_$ActiveWorkoutLoadedImpl _value,
      $Res Function(_$ActiveWorkoutLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveWorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercises = null,
    Object? expandedExerciseId = freezed,
    Object? sessionId = null,
  }) {
    return _then(_$ActiveWorkoutLoadedImpl(
      exercises: null == exercises
          ? _value._exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<ExerciseEntry>,
      expandedExerciseId: freezed == expandedExerciseId
          ? _value.expandedExerciseId
          : expandedExerciseId // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ActiveWorkoutLoadedImpl implements ActiveWorkoutLoaded {
  const _$ActiveWorkoutLoadedImpl(
      {required final List<ExerciseEntry> exercises,
      required this.expandedExerciseId,
      required this.sessionId})
      : _exercises = exercises;

  final List<ExerciseEntry> _exercises;
  @override
  List<ExerciseEntry> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  /// The exercise card currently expanded. Null = all collapsed.
  @override
  final String? expandedExerciseId;

  /// UUID of the workout session created when the screen opened.
  @override
  final String sessionId;

  @override
  String toString() {
    return 'ActiveWorkoutState.loaded(exercises: $exercises, expandedExerciseId: $expandedExerciseId, sessionId: $sessionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveWorkoutLoadedImpl &&
            const DeepCollectionEquality()
                .equals(other._exercises, _exercises) &&
            (identical(other.expandedExerciseId, expandedExerciseId) ||
                other.expandedExerciseId == expandedExerciseId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_exercises),
      expandedExerciseId,
      sessionId);

  /// Create a copy of ActiveWorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveWorkoutLoadedImplCopyWith<_$ActiveWorkoutLoadedImpl> get copyWith =>
      __$$ActiveWorkoutLoadedImplCopyWithImpl<_$ActiveWorkoutLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ExerciseEntry> exercises,
            String? expandedExerciseId, String sessionId)
        loaded,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) {
    return loaded(exercises, expandedExerciseId, sessionId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExerciseEntry> exercises, String? expandedExerciseId,
            String sessionId)?
        loaded,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(exercises, expandedExerciseId, sessionId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExerciseEntry> exercises, String? expandedExerciseId,
            String sessionId)?
        loaded,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(exercises, expandedExerciseId, sessionId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActiveWorkoutLoaded value) loaded,
    required TResult Function(ActiveWorkoutLoading value) loading,
    required TResult Function(ActiveWorkoutError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActiveWorkoutLoaded value)? loaded,
    TResult? Function(ActiveWorkoutLoading value)? loading,
    TResult? Function(ActiveWorkoutError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActiveWorkoutLoaded value)? loaded,
    TResult Function(ActiveWorkoutLoading value)? loading,
    TResult Function(ActiveWorkoutError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ActiveWorkoutLoaded implements ActiveWorkoutState {
  const factory ActiveWorkoutLoaded(
      {required final List<ExerciseEntry> exercises,
      required final String? expandedExerciseId,
      required final String sessionId}) = _$ActiveWorkoutLoadedImpl;

  List<ExerciseEntry> get exercises;

  /// The exercise card currently expanded. Null = all collapsed.
  String? get expandedExerciseId;

  /// UUID of the workout session created when the screen opened.
  String get sessionId;

  /// Create a copy of ActiveWorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveWorkoutLoadedImplCopyWith<_$ActiveWorkoutLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ActiveWorkoutLoadingImplCopyWith<$Res> {
  factory _$$ActiveWorkoutLoadingImplCopyWith(_$ActiveWorkoutLoadingImpl value,
          $Res Function(_$ActiveWorkoutLoadingImpl) then) =
      __$$ActiveWorkoutLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActiveWorkoutLoadingImplCopyWithImpl<$Res>
    extends _$ActiveWorkoutStateCopyWithImpl<$Res, _$ActiveWorkoutLoadingImpl>
    implements _$$ActiveWorkoutLoadingImplCopyWith<$Res> {
  __$$ActiveWorkoutLoadingImplCopyWithImpl(_$ActiveWorkoutLoadingImpl _value,
      $Res Function(_$ActiveWorkoutLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveWorkoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ActiveWorkoutLoadingImpl implements ActiveWorkoutLoading {
  const _$ActiveWorkoutLoadingImpl();

  @override
  String toString() {
    return 'ActiveWorkoutState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveWorkoutLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ExerciseEntry> exercises,
            String? expandedExerciseId, String sessionId)
        loaded,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExerciseEntry> exercises, String? expandedExerciseId,
            String sessionId)?
        loaded,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExerciseEntry> exercises, String? expandedExerciseId,
            String sessionId)?
        loaded,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActiveWorkoutLoaded value) loaded,
    required TResult Function(ActiveWorkoutLoading value) loading,
    required TResult Function(ActiveWorkoutError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActiveWorkoutLoaded value)? loaded,
    TResult? Function(ActiveWorkoutLoading value)? loading,
    TResult? Function(ActiveWorkoutError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActiveWorkoutLoaded value)? loaded,
    TResult Function(ActiveWorkoutLoading value)? loading,
    TResult Function(ActiveWorkoutError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ActiveWorkoutLoading implements ActiveWorkoutState {
  const factory ActiveWorkoutLoading() = _$ActiveWorkoutLoadingImpl;
}

/// @nodoc
abstract class _$$ActiveWorkoutErrorImplCopyWith<$Res> {
  factory _$$ActiveWorkoutErrorImplCopyWith(_$ActiveWorkoutErrorImpl value,
          $Res Function(_$ActiveWorkoutErrorImpl) then) =
      __$$ActiveWorkoutErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ActiveWorkoutErrorImplCopyWithImpl<$Res>
    extends _$ActiveWorkoutStateCopyWithImpl<$Res, _$ActiveWorkoutErrorImpl>
    implements _$$ActiveWorkoutErrorImplCopyWith<$Res> {
  __$$ActiveWorkoutErrorImplCopyWithImpl(_$ActiveWorkoutErrorImpl _value,
      $Res Function(_$ActiveWorkoutErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActiveWorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ActiveWorkoutErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ActiveWorkoutErrorImpl implements ActiveWorkoutError {
  const _$ActiveWorkoutErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ActiveWorkoutState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveWorkoutErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ActiveWorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveWorkoutErrorImplCopyWith<_$ActiveWorkoutErrorImpl> get copyWith =>
      __$$ActiveWorkoutErrorImplCopyWithImpl<_$ActiveWorkoutErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<ExerciseEntry> exercises,
            String? expandedExerciseId, String sessionId)
        loaded,
    required TResult Function() loading,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<ExerciseEntry> exercises, String? expandedExerciseId,
            String sessionId)?
        loaded,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<ExerciseEntry> exercises, String? expandedExerciseId,
            String sessionId)?
        loaded,
    TResult Function()? loading,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ActiveWorkoutLoaded value) loaded,
    required TResult Function(ActiveWorkoutLoading value) loading,
    required TResult Function(ActiveWorkoutError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ActiveWorkoutLoaded value)? loaded,
    TResult? Function(ActiveWorkoutLoading value)? loading,
    TResult? Function(ActiveWorkoutError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ActiveWorkoutLoaded value)? loaded,
    TResult Function(ActiveWorkoutLoading value)? loading,
    TResult Function(ActiveWorkoutError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ActiveWorkoutError implements ActiveWorkoutState {
  const factory ActiveWorkoutError(final String message) =
      _$ActiveWorkoutErrorImpl;

  String get message;

  /// Create a copy of ActiveWorkoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveWorkoutErrorImplCopyWith<_$ActiveWorkoutErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
