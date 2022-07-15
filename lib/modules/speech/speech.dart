import 'dart:developer';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechCustom {
  SpeechCustom();

  Future<String> getText() async {
    String text = '';
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize(
      onStatus: (status) {
        log('onStatus: $status');
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
    int seconds = 15;
    while (seconds > 0) {
      if (text != '') {
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
      seconds--;
    }
    speech.stop();
    return text;
  }
}
