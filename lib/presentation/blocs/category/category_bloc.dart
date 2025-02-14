import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/category/get_category_list.dart';
import '../../../../domain/usecases/category/add_category.dart';
import '../../../../domain/usecases/category/update_category.dart';
import '../../../../domain/usecases/category/delete_category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoryList getCategoryList;
  final AddCategory addCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;

  CategoryBloc({
    required this.getCategoryList,
    required this.addCategory,
    required this.updateCategory,
    required this.deleteCategory,
  }) : super(CategoryInitial()) {
    on<GetCategoryListEvent>(_onGetCategoryList);
    on<AddCategoryEvent>(_onAddCategory);
    on<UpdateCategoryEvent>(_onUpdateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onGetCategoryList(
      GetCategoryListEvent event,
      Emitter<CategoryState> emit,
      ) async {
    emit(CategoryLoading());
    final result = await getCategoryList();
    result.fold(
          (failure) => emit(CategoryError(failure.message)),
          (categories) => emit(CategoryListLoaded(categories)),
    );
  }

  Future<void> _onAddCategory(
      AddCategoryEvent event,
      Emitter<CategoryState> emit,
      ) async {
    emit(CategoryLoading());
    final result = await addCategory(
      name: event.name,
      type: event.type,
      description: event.description,
    );
    result.fold(
          (failure) => emit(CategoryError(failure.message)),
          (category) => emit(CategoryAdded(category)),
    );
  }

  Future<void> _onUpdateCategory(
      UpdateCategoryEvent event,
      Emitter<CategoryState> emit,
      ) async {
    emit(CategoryLoading());
    final result = await updateCategory(
      id: event.id,
      name: event.name,
      type: event.type,
      description: event.description,
    );
    result.fold(
          (failure) => emit(CategoryError(failure.message)),
          (category) => emit(CategoryUpdated(category)),
    );
  }

  Future<void> _onDeleteCategory(
      DeleteCategoryEvent event,
      Emitter<CategoryState> emit,
      ) async {
    emit(CategoryLoading());
    final result = await deleteCategory(id: event.id);
    result.fold(
          (failure) => emit(CategoryError(failure.message)),
          (_) => emit(CategoryDeleted(event.id)),
    );
  }
}