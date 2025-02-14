// lib/presentation/blocs/saving/saving_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/saving/get_saving_list.dart';
import '../../../domain/usecases/saving/add_saving.dart';
import '../../../domain/usecases/saving/update_saving.dart';
import 'saving_event.dart';
import 'saving_state.dart';

class SavingBloc extends Bloc<SavingEvent, SavingState> {
  final GetSavingList getSavingList;
  final AddSaving addSaving;
  final UpdateSaving updateSaving;

  SavingBloc({
    required this.getSavingList,
    required this.addSaving,
    required this.updateSaving,
  }) : super(SavingInitial()) {
    on<GetSavingListEvent>(_onGetSavingList);
    on<AddSavingEvent>(_onAddSaving);
    on<UpdateSavingEvent>(_onUpdateSaving);
  }

  Future<void> _onGetSavingList(GetSavingListEvent event,
      Emitter<SavingState> emit,) async {
    emit(SavingLoading());
    final result = await getSavingList();
    result.fold(
          (failure) => emit(SavingError(failure.message)),
          (savings) => emit(SavingListLoaded(savings)),
    );
  }

  Future<void> _onAddSaving(AddSavingEvent event,
      Emitter<SavingState> emit,) async {
    emit(SavingLoading());
    final result = await addSaving(
      categoryId: event.categoryId,
      amount: event.amount,
      date: event.date,
      note: event.note,
    );
    result.fold(
          (failure) => emit(SavingError(failure.message)),
          (saving) => emit(SavingAdded(saving)),
    );
  }

  Future<void> _onUpdateSaving(UpdateSavingEvent event,
      Emitter<SavingState> emit,) async {
    emit(SavingLoading());
    final result = await updateSaving(
      id: event.id,
      categoryId: event.categoryId,
      amount: event.amount,
      date: event.date,
      note: event.note,
    );
    result.fold(
          (failure) => emit(SavingError(failure.message)),
          (saving) => emit(SavingUpdated(saving)),
    );
  }
}
