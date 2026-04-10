import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:statusgetter/core/extensions/file_system_entity/file_system_entity_extension_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';
import 'package:statusgetter/core/model/status_item/status_item_model.dart';

part 'whatsapp_state.dart';

class WhatsappBloc extends Cubit<WhatsappState> {
  WhatsappBloc() : super(const WhatsappState(isLoading: true));

  /// Emit new state if the bloc is not closed.
  void emitState(WhatsappState state) {
    if (!isClosed) {
      return emit(state);
    }
  }

  /// Requests permission from the user to access device storage and then fetches the status.
  Future<void> askStoragePermission() {
    // Asks the user for storage permission using a utility function.
    return waUtils.askStoragePermission.then<void>((_) {
      // After permission is granted, fetches the storage status.
      return fetchStatus();
    });
  }

  /// Create an Instance of `WaUtils`
  final WaUtils waUtils = WaUtils()..getDeviceInfo();

  /// Fetches the status from device storage and updates the application state accordingly.
  Future<void> fetchStatus() async {
    /// Emit a loading state to indicate that the process has started.
    emitState(const WhatsappState(isLoading: true));

    // تحقق من حالة الإذن أولاً (تم طلبها في main.dart)
    PermissionStatus status;
    if (waUtils.shouldAskManageExternalPermission) {
      status = await Permission.manageExternalStorage.status;
    } else {
      status = await Permission.storage.status;
    }

    /// إذا لم يكن الإذن ممنوحاً، اطلبه الآن
    if (!status.isGranted) {
      status = await waUtils.askStoragePermission;
    }

    if (!status.isGranted) {
      "Storage permission not granted".print("Permission");
      return emitState(const WhatsappState(permissionDenied: true));
    }

    /// Try to get the WhatsApp status directory path from the user's device.
    final Directory directory = Directory(await waUtils.whatsAppPath);

    /// Check if the directory exists.
    if (await directory.exists()) {
      /// If the directory exists, list its contents and emit a status available state with the list of statuses.
      return emitState(WhatsappState(
        status: await directory.listSync().waStatusList,
      ));
    } else {
      /// If the directory does not exist, emit an app not installed state, indicating WhatsApp is not installed on the user's device.
      return emitState(const WhatsappState(appNotInstalled: true));
    }
  }
}
