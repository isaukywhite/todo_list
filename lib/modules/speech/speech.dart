import 'dart:developer';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechCustom {
  SpeechCustom._();

  static Future<String> getText() async {
    SpeechControl.reset();
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize(
      onStatus: (status) {
        final finished = ['notListening', 'done'].contains(status);
        if (finished) {
          SpeechControl.finish();
        }
        log('onStatus: $status - control: ${SpeechControl.toText()}');
      },
      onError: (error) {
        log('onError: $error');
        SpeechControl.finish();
      },
    );
    if (available) {
      speech.listen(
        onResult: (value) {
          log('onResult: $value');
          SpeechControl.text = value.recognizedWords;
        },
      );
    } else {
      log("Access denied for speech recognition.");
      SpeechControl.finish();
    }
    while (SpeechControl.running) {
      await Future.delayed(const Duration(seconds: 1));
      SpeechControl.decrement();
      log('Control: ${SpeechControl.toText()}');
    }
    speech.stop();
    return SpeechControl.text;
  }
}

class SpeechControl {
  SpeechControl._();

  static int seconds = 15;
  static bool finished = false;
  static String text = '';

  static bool get running => !finished;

  static void finish() {
    finished = true;
    seconds = 0;
  }

  static void decrement() {
    seconds--;
    if (finished || seconds <= 0) {
      finish();
    }
  }

  static void reset() {
    finished = false;
    seconds = 15;
    text = '';
  }

  static String toText() =>
      'SpeechControl - seconds: $seconds - finished: $finished - text: $text';
}
