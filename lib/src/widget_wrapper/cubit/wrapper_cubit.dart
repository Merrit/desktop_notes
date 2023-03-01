import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'wrapper_state.dart';

class WrapperCubit extends Cubit<WrapperState> {
  WrapperCubit()
      : super(const WrapperState(
          isHovered: false,
          isLocked: true,
        ));

  void toggleIsLocked() => emit(state.copyWith(isLocked: !state.isLocked));

  void updateIsHovered(bool value) => emit(state.copyWith(isHovered: value));
}
