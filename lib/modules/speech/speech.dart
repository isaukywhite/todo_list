import 'dart:developer';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechCustom {
  SpeechCustom._();

  static Future<String> getText() async {
    int seconds = 15;
    String text = '';
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize(
      onStatus: (status) {
        log('onStatus: $status');
        if (status == 'notListening') {
          seconds = 0;
        }
      },
      onError: (error) {
        log('onError: $error');
      },
    );
    if (available) {
      speech.listen(
        onResult: (value) {
          log('onResult: $value');
          text = value.recognizedWords;
        },
      );
    } else {
      log("Access denied for speech recognition.");
    }

    while (seconds > 0) {
      await Future.delayed(const Duration(seconds: 1));
      seconds--;
    }
    speech.stop();
    return text;
  }
}
