import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_mobile_sales_mini/data/repositories/data_repository.dart';

import '../../data/models/app_data_state.dart';

final dataRepositoryProvider = Provider((ref) => DataRepository());

final appDataAsyncProvider = AsyncNotifierProvider<AppDataNotifier, AppDataState>(
    () => AppDataNotifier()
);

class AppDataNotifier extends AsyncNotifier<AppDataState> {
  @override
  Future<AppDataState> build() async {
    final repo = ref.read(dataRepositoryProvider);
    await repo.loadData();

    return AppDataState(
      users: repo.users,
      products: repo.products,
      customers: repo.customers
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(dataRepositoryProvider);
      await repo.refresh();

      state = AsyncData(
        state.asData?.value.copyWith(
          users: repo.users,
          products: repo.products,
          customers: repo.customers,
        ) ?? AppDataState.initial(),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (state.asData != null) {
          state = AsyncData(state.asData!.value.copyWith(isRefreshing: false));
        }
      });
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}