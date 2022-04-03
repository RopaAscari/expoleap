import 'dart:io';

import 'package:expoleap/models/device.dart';
import 'package:expoleap/resources/network_exceptions/network_exceptions.dart';
import 'package:expoleap/resources/providers/api/device_api_provider.dart';
import 'package:expoleap/utils/utils.dart';

class DeviceRepository {
  final DeviceApiProvider _provider = new DeviceApiProvider();
  Future<void> registerDeviceToEvent(String eventId) async {
    final String token = await FirebaseServices().getFcmToken();
    final Device device = Device(
      registrationId: token,
      event: eventId,
      type: (Platform.isIOS) ? 'ios' : 'android',
      active: true,
    );

    print('DEVICE $device');

    final response = await _provider.registerDevice(device);

    response.maybeWhen(
      failure: (NetworkExceptions ex) =>
          throw NetworkExceptions.getErrorMessage(ex),
      orElse: () => 'Error occured while registering device',
    );
  }

  Future<void> unRegisterDeviceFromEvent(String eventId) async {}
}
