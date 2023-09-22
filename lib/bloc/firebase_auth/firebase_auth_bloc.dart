import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:lansonndehplumbing/Apiutils/app_version.dart';
import 'package:lansonndehplumbing/client/api_requests.dart';
import 'package:lansonndehplumbing/core/utils/keys.dart';
import 'package:lansonndehplumbing/core/utils/strings.dart';
import 'package:lansonndehplumbing/main.dart';
import 'package:lansonndehplumbing/models/env_vars.dart';
import 'package:lansonndehplumbing/models/firebase_auth_user.dart';
import 'package:lansonndehplumbing/repository/firebase/firebase_services.dart';
import 'package:lansonndehplumbing/repository/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

part 'firebase_auth_event.dart';

part 'firebase_auth_state.dart';

final getIt = GetIt.I;

class FirebaseAuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuthBloc() : super(AuthUnknown()) {
    on<AutoLogin>(_onAutoLogin);
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
    on<Refresh>(_onRefresh);
    on<UpdateUser>(_onUpdateUser);
  }

  static final firebaseInstance = getIt<FirebaseService>().firebaseAuthInst;
  final generalBox = getIt<GeneralBox>();
  final Logger logger = Logger('authBlock');

  // Future updateUserPosition(FirebaseAuthUser firebaseAuthUser, Position? position) async {
  //   position ??= await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   firebaseAuthUser.lat = position.latitude;
  //   firebaseAuthUser.lng = position.longitude;
  //   updateDriverLocation(position, firebaseAuthUser.userId);
  //   await sf.write(key: Keys.firebaseAuthUser, value: jsonEncode(firebaseAuthUser.toMap()));
  // }

  Future updateDriverLocation(Position position, num userId) async {
    ApiRequest.genericPost('update_driver_location', params: {
      'lat': position.latitude.toString(),
      'lng': position.longitude.toString(),
      'userId': userId.toString()
    }).then((value) => null);
  }

  Future<void> _onAutoLogin(event, emit) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final firebaseAuthUser = generalBox.get(Keys.firebaseAuthUser);
    if (firebaseAuthUser == null) {
      emit(UnAuthenticated());
      return;
    } else {
      try {
        try {
          await firebaseInstance.signInWithEmailAndPassword(
              email: firebaseAuthUser.email, password: EnvVars.EMAIL_PASSWORD);
          emit(Authenticated(firebaseAuthUser));
          final p = generalBox.get(Keys.authenticatedTime) ?? 0;

          final lastAuthenticatedTime =
              p > 1000 ? p : DateTime.now().millisecondsSinceEpoch;
          if (lastAuthenticatedTime +
                  (const Duration(minutes: 30).inMilliseconds) <
              DateTime.now().millisecondsSinceEpoch) {
            add(Refresh());
          }
        } catch (e, stackTrace) {
          logger.severe(e, stackTrace);
        }
      } catch (e, stackTrace) {
        logger.severe(e, stackTrace);
        emit(UnAuthenticated());
      }
    }
  }

  Future<void> _onLogin(event, emit) async {
    FirebaseAuthUser thisUser = event.firebaseAuthUser;
    generalBox.put(Keys.firebaseAuthUser, thisUser);

    emit(Authenticated(thisUser));
  }

  Future<void> _onLogout(event, emit) async {
    generalBox.delete(Keys.authenticatedTime);
    generalBox.delete(Keys.firebaseAuthUser);
    await firebaseInstance.signOut();
    emit(UnAuthenticated());
  }

  Future<void> _onRefresh(event, emit) async {
    var authState = state;
    if (authState is Authenticated) {
      emit(AuthRefreshing(authState.firebaseAuthUser));
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user?.isAnonymous == false) {
          final idTokenResult = await user!.getIdTokenResult(true);

          final customClaims = idTokenResult.claims;
          final firebaseAuthUser =
              FirebaseAuthUser.fromCurrentUser(user, customClaims);
          generalBox.put(Keys.firebaseAuthUser, firebaseAuthUser);
          emit(Authenticated(firebaseAuthUser));
        }
      } catch (e) {
        emit(UnAuthenticated());
      }
    }
  }

  Future<void> _onUpdateUser(event, emit) async {
    FirebaseAuthUser firebaseAuthUser = event.firebaseAuthUser;
    generalBox.put(Keys.firebaseAuthUser, firebaseAuthUser);
    emit(Authenticated(firebaseAuthUser));
  }

  Future<String?> getApiAppVersion() async {
    String platform = kIsWeb
        ? 'web'
        : Platform.isAndroid
            ? 'android'
            : 'ios';
    final res = await ApiRequest.genericGet('get_app_version/$platform');
    return res?['currentVersion'];
  }

  void checkVersion() async {
    var lastUpdatePromptedTime = generalBox.get(Keys.updatePromptTime) ?? 0;

    if (lastUpdatePromptedTime > 100 &&
        (lastUpdatePromptedTime + const Duration(hours: 24).inMilliseconds) >
            DateTime.now().millisecondsSinceEpoch) {
      return;
    }

    var versions =
        await Future.wait([AppVersion.getAppVersion(), getApiAppVersion()]);

    if (!versions.contains(null) && versions[0] != versions[1]) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      Uri uri = Platform.isAndroid
          ? Uri.https("play.google.com", "/store/apps/details",
              {"id": packageInfo.packageName})
          : Uri.https("itunes.apple.com", "/lookup",
              {"bundleId": packageInfo.packageName});

      showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentState!.context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text(Strings.updateDialogTitle),
              content: Text(Strings.updateAppMessage
                  .replaceAll('100', versions.first!)
                  .replaceAll('200', versions.last!)),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (await canLaunchUrl(Uri.parse(uri.toString()))) {
                      generalBox.put(Keys.updatePromptTime,
                          DateTime.now().millisecondsSinceEpoch);
                      await launchUrl(Uri.parse(uri.toString()));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    Strings.letsUpdate,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    generalBox.put(Keys.updatePromptTime,
                        DateTime.now().millisecondsSinceEpoch);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    Strings.maybeLater,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}

String getUserId(BuildContext context) {
  return (context.read<FirebaseAuthBloc>().state as Authenticated)
      .firebaseAuthUser
      .uid;
}

FirebaseAuthUser getFirebaseAuthUser(BuildContext context) {
  return (context.read<FirebaseAuthBloc>().state as Authenticated)
      .firebaseAuthUser;
}

FirebaseAuthUser? getNullableFirebaseAuthUser(BuildContext context) {
  final state = (context.read<FirebaseAuthBloc>().state);
  if (state is Authenticated) {
    return state.firebaseAuthUser;
  }
  return null;
}
