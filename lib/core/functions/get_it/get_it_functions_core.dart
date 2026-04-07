import 'package:get_it/get_it.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_manager/ad_manager_cubit.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_server/ad_server_cubit.dart';
import 'package:statusgetter/core/domain/repo/social_repo_domain_core.dart';
import 'package:statusgetter/views/dashboard/cubit/dashboard_cubit.dart';
import 'package:statusgetter/views/dashboard/layouts/business_wa/bloc/business_whats_app_bloc.dart';
import 'package:statusgetter/views/dashboard/layouts/tiktok_download/bloc/tiktok_download_bloc.dart';
import 'package:statusgetter/views/dashboard/layouts/whatsapp/bloc/whatsapp_bloc.dart';
import 'package:statusgetter/views/initial/cubit/theme_cubit.dart';

/// Create an Instance of `GetIt`
final GetIt getItInstance = GetIt.I;

/// Initialize Instances using `GetIt`
Future<void> initializeGetIt() async {
  // 🔥 منع التكرار (مهم جداً)
  if (!getItInstance.isRegistered<ThemeCubit>()) {
    getItInstance.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  }

  if (!getItInstance.isRegistered<AdServerCubit>()) {
    getItInstance.registerLazySingleton<AdServerCubit>(
      () => AdServerCubit(),
    );
  }

  if (!getItInstance.isRegistered<DashboardCubit>()) {
    getItInstance.registerLazySingleton<DashboardCubit>(
      () => DashboardCubit(),
    );
  }

  if (!getItInstance.isRegistered<AdManagerCubit>()) {
    getItInstance.registerLazySingleton<AdManagerCubit>(
      () => AdManagerCubit(),
    );
  }

  if (!getItInstance.isRegistered<TiktokDownloadBloc>()) {
    getItInstance.registerLazySingleton<TiktokDownloadBloc>(
      () => TiktokDownloadBloc(const SocialDownloadRepo()),
    );
  }

  if (!getItInstance.isRegistered<WhatsappBloc>()) {
    getItInstance.registerLazySingleton<WhatsappBloc>(
      () => WhatsappBloc(),
    );
  }

  if (!getItInstance.isRegistered<BusinessWhatsAppBloc>()) {
    getItInstance.registerLazySingleton<BusinessWhatsAppBloc>(
      () => BusinessWhatsAppBloc(),
    );
  }
}
