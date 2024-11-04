import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pahg_group/fcm/access_firebase_token.dart';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../ui/pages/news_feed_page.dart';

const localNotificationChannel = "high_importance_channel";
const localNotificationChannelTitle = "High Importance Notifications";
const localNotificationChannelDescription =
    "This channel is used for important notifications.";

class FCMService {
  static final FCMService _singleton = FCMService._internal();

  factory FCMService() {
    return _singleton;
  }

  FCMService._internal();

  /// Firebase Messaging Instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// Android Notification Channel
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    localNotificationChannel,
    localNotificationChannelTitle,
    description: localNotificationChannelDescription,
    importance: Importance.high,
  );

  /// Flutter Notification Plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Android Initialization Settings
  AndroidInitializationSettings initializationSettingsAndroid =
  const AndroidInitializationSettings('ic_launcher');

  void listenForMessages() async {

    await requestNotificationPermissionForIOS();
    await turnOnIOSForegroundNotification();
    await initFlutterLocalNotification();
    await registerChannel();
    messaging.getToken().then((fcmToken) {

    });

    FirebaseMessaging.onMessage.listen((remoteMessage) {
      //debugPrint("Notification Sent From Server while in foreground");
      RemoteNotification? notification = remoteMessage.notification;
      AndroidNotification? android = remoteMessage.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
          payload: remoteMessage.data['post_id'].toString(),
        );
      }
    });

    ///background click
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage){
      handleMessage(remoteMessage.data['post_id']);
    });
  }

  Future<void> setUpInteractMessage({required Function(RemoteMessage) onMessageOpenedApp}) async{

    messaging.getInitialMessage().then((remoteMessage) {
      if(remoteMessage != null){
        onMessageOpenedApp(remoteMessage);
      }
    });
  }

  /// Request Notification Permission For IOS
  Future requestNotificationPermissionForIOS() {
    return messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  /// Turn IoS Foreground Notification
  Future turnOnIOSForegroundNotification() {
    return FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  ///notification click in foreground
  Future initFlutterLocalNotification() {
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );
    return flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
          debugPrint("Local Notification Clicked =====> $payload");
          var categoryId = payload.payload;
          handleMessage(categoryId!);
        });
  }

  Future? registerChannel() async {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> sendTopicNotification(int postId,String topic,String title,String message) async{
    String truncatedBody = truncateMessage(message, maxLength: 80);
    try{
      final body = {
        'message' : {
          'topic' : topic,
          'notification' : {
            'title': title,
            'body': truncatedBody,
          },
          'data': {
            'post_id': postId.toString(),
          },
        }
      };

      String accessToken = await AccessFirebaseToken().getAccessToken();
      String url = 'https://fcm.googleapis.com/v1/projects/pahg-hr/messages:send';
      
      await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(body)
      ).then((value) {

      });
    }catch(e){
      //print(e);
    }
  }


  String truncateMessage(String message, {int maxLength = 80}) {
    return message.length > maxLength ? '${message.substring(0, maxLength)} ...' : message;
  }

  void handleMessage(String categoryId){
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => NewsFeedPage(
          categoryId: int.parse(categoryId),
          categoryName: 'Name',
        ),
      ),
    );
  }
}