import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/earning/get_earnings.dart';
import '../../../../domain/usecases/earning/get_earnings_by_date_range.dart';
import '../../../../domain/usecases/earning/get_earning.dart';
import '../../../../domain/usecases/earning/add_earning.dart';
import '../../../../domain/usecases/earning/update_earning.dart';
import '../../../../domain/usecases/earning/get_dashboard_summary.dart';
import 'earning_event.dart';
import 'earning_state.dart';

class EarningBloc extends Bloc<EarningEvent, EarningState> {
  final GetEarnings getEarnings;
  final GetEarningsByDateRange getEarningsByDateRange;
  final GetEarning getEarning;
  final AddEarning addEarning;
  final UpdateEarning updateEarning;
  final GetDashboardSummary getDashboardSummary;

  EarningBloc({
    required this.getEarnings,
    required this.getEarningsByDateRange,
    required this.getEarning,
    required this.addEarning,
    required this.updateEarning,
    required this.getDashboardSummary,
  }) : super(EarningInitial()) {
    on<GetEarningsEvent>(_onGetEarnings);
    on<GetEarningsByDateRangeEvent>(_onGetEarningsByDateRange);
    on<GetEarningEvent>(_onGetEarning);
    on<AddEarningEvent>(_onAddEarning);
    on<UpdateEarningEvent>(_onUpdateEarning);
    on<GetDashboardSummaryEvent>(_onGetDashboardSummary);
  }

  Future<void> _onGetEarnings(
      GetEarningsEvent event,
      Emitter<EarningState> emit,
      ) async {
    emit(EarningLoading());
    final result = await getEarnings(
      startDate: event.startDate,
      endDate: event.endDate,
      jobId: event.jobId,
    );
    result.fold(
          (failure) => emit(EarningError(failure.message)),
          (earnings) => emit(EarningListLoaded(earnings)),
    );
  }

  Future<void> _onGetEarningsByDateRange(
      GetEarningsByDateRangeEvent event,
      Emitter<EarningState> emit,
      ) async {
    emit(EarningLoading());
    final result = await getEarningsByDateRange(
      startDate: event.startDate,
      endDate: event.endDate,
    );
    result.fold(
          (failure) => emit(EarningError(failure.message)),
          (earnings) => emit(EarningListLoaded(earnings)),
    );
  }

  Future<void> _onGetEarning(
      GetEarningEvent event,
      Emitter<EarningState> emit,
      ) async {
    emit(EarningLoading());
    final result = await getEarning(id: event.id);
    result.fold(
          (failure) => emit(EarningError(failure.message)),
          (earning) => emit(EarningLoaded(earning)),
    );
  }

  Future<void> _onAddEarning(
      AddEarningEvent event,
      Emitter<EarningState> emit,
      ) async {
    emit(EarningLoading());
    final result = await addEarning(
      jobId: event.jobId,
      amount: event.amount,
      date: event.date,
      note: event.note,
      status: event.status
    );
    result.fold(
          (failure) => emit(EarningError(failure.message)),
          (earning) => emit(EarningAdded(earning)),
    );
  }

  Future<void> _onUpdateEarning(
      UpdateEarningEvent event,
      Emitter<EarningState> emit,
      ) async {
    emit(EarningLoading());
    final result = await updateEarning(
      id: event.id,
      jobId: event.jobId,
      amount: event.amount,
      date: event.date,
      note: event.note,
      status: event.status
    );
    result.fold(
          (failure) => emit(EarningError(failure.message)),
          (earning) => emit(EarningUpdated(earning)),
    );
  }

  Future<void> _onGetDashboardSummary(
      GetDashboardSummaryEvent event,
      Emitter<EarningState> emit,
      ) async {
    emit(EarningLoading());
    final result = await getDashboardSummary();
    result.fold(
          (failure) => emit(EarningError(failure.message)),
          (summary) => emit(DashboardSummaryLoaded(summary)),
    );
  }
}