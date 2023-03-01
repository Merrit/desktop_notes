part of 'wrapper_cubit.dart';

class WrapperState {
  final bool isHovered;
  final bool isLocked;

  const WrapperState({
    required this.isHovered,
    required this.isLocked,
  });

  WrapperState copyWith({
    bool? isHovered,
    bool? isLocked,
  }) {
    return WrapperState(
      isHovered: isHovered ?? this.isHovered,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isHovered': isHovered,
      'isLocked': isLocked,
    };
  }

  factory WrapperState.fromMap(Map<String, dynamic> map) {
    return WrapperState(
      isHovered: map['isHovered'] ?? false,
      isLocked: map['isLocked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory WrapperState.fromJson(String source) =>
      WrapperState.fromMap(json.decode(source));

  @override
  String toString() =>
      'WrapperState(isHovered: $isHovered, isLocked: $isLocked)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WrapperState &&
        other.isHovered == isHovered &&
        other.isLocked == isLocked;
  }

  @override
  int get hashCode => isHovered.hashCode ^ isLocked.hashCode;
}
