import 'package:feature_chat_api/feature_chat_api.dart';
import 'package:feature_chats_list_api/feature_chats_list_api.dart';
import 'package:feature_dev/feature_dev.dart';
import 'package:feature_global_search_api/feature_global_search_api.dart';
import 'package:feature_main_screen_api/feature_main_screen_api.dart';
import 'package:feature_notifications_settings_api/feature_notifications_settings_api.dart';
import 'package:feature_privacy_settings_api/feature_privacy_settings_api.dart';
import 'package:feature_settings_api/feature_settings_api.dart';
import 'package:feature_settings_search_api/feature_settings_search_api.dart';
import 'package:presentation/src/di/component/feature_component.dart';

class FeatureFactory {
  FeatureFactory({required FeatureComponent featureComponent})
      : _featureComponent = featureComponent;

  final FeatureComponent _featureComponent;

  IMainScreenFeatureApi createMainScreenFeature() =>
      _featureComponent.getMainScreenFeatureApi();

  IChatsListFeatureApi createChatsListFeatureApi() =>
      _featureComponent.getChatsListFeatureApi();

  IGlobalSearchFeatureApi createGlobalSearchFeatureApi() =>
      _featureComponent.getGlobalSearchFeatureApi();

  IChatFeatureApi createChatFeatureApi() =>
      _featureComponent.getChatListFeatureApi();

  ISettingsFeatureApi createSettingsFeatureApi() =>
      _featureComponent.getSettingsFeatureApi();

  ISettingsSearchFeatureApi createSettingsSearchFeatureApi() =>
      _featureComponent.getSettingsSearchFeatureApi();

  IPrivacySettingsFeatureApi createPrivacySettingsFeatureApi() =>
      _featureComponent.getPrivacySettingsFeatureApi();

  INotificationsSettingsFeatureApi createNotificationsSettingsFeatureApi() =>
      _featureComponent.getNotificationsSettingsFeatureApi();

  DevFeature createDevFeature() => _featureComponent.getDevFeature();
}