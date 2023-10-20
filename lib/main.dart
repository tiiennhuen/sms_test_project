import 'package:flutter/material.dart';
import 'package:sms_test_project/repository/user_repository.dart';
import 'dart:async';
import 'package:telephony/telephony.dart';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserRepository userRepository = UserRepository();
  String _message = "";
  final telephony = Telephony.instance;
  int seconds = 0;
  Timer? myTimer;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }

  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Kys SMS App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                startTimer();
              },
              child: const Text('Start'),
            ),
          ),
          Text(
            'Seconds: $seconds',
            style: const TextStyle(fontSize: 24),
          ),
          ElevatedButton(
            onPressed: () async {
              cancelTimer();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    ));
  }

  Future sendRequest() async {
    await userRepository.fetchUsers().then((users) async {
      for (var user in users) {
        await Future.delayed(const Duration(seconds: 2));
        await telephony.sendSms(
          isMultipart: true,
          to: user.phoneNumber!,
          message: user.message!,
        );
        print('Sent sms to the phoneNumber ${user.phoneNumber}');
        print('Message ${user.message}');
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  void startTimer() {
    const Duration duration = Duration(seconds: 1);

    myTimer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        seconds++;
      });

      if (seconds % 60 == 0) {
        sendRequest();
        seconds = 0;
      }
    });
  }

  void cancelTimer() {
    // Check if the timer is not null and then cancel it
    if (myTimer != null && myTimer!.isActive) {
      myTimer!.cancel();
      print('Timer canceled');
    }
  }
}
