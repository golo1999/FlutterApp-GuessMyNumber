import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart';

// ignore: avoid_classes_with_only_static_members
class AppData {
  static const String appTitle = 'Guess my number';
  static const int minRandomNumber = 1;
  static const int maxRandomNumber = 100;
  static const String iAmThinkingText = "I'm thinking of a number between $minRandomNumber and $maxRandomNumber.";
  static const String yourTurnText = "It's your turn to guess my number!";
  static const String tryNumberText = 'Try a number!';
  static const String guessButtonText = 'Guess';
  static const String restartText = 'Restart';
  static const String textFieldHintText = 'Enter a number';
  static const String tryHigher = 'Try higher';
  static const String tryLower = 'Try lower';
  static const String congratulationsText = 'Congratulations!';
  static const Color primaryColor = Color(0xff8ABAD3);
  static const Color secondaryColor = Color(0xffEDC2D8);
  static const Color silverColor = Color(0xffAAA9AD);
  static const Color whiteColor = Color(0xffFCF6F5);
  static int randomGeneratedNumber = generateRandomNumberBetween(minRandomNumber, maxRandomNumber);
  static int userSelectedNumber = -2;
  static String cardText = tryNumberText;
  static String buttonText = guessButtonText;

  // method for removing 0 if it's the first character and the input has more than one character
  static String handleZeroFirstCharacter(String input) {

    return input.substring(1);
  }

  // method for generating a random integer between min and max
  static int generateRandomNumberBetween(int min, int max) {
    return Random().nextInt(max) + min;
  }

  // method for verifying if the user's number is equal to the random generated number
  static int checkIfTheInputNumberIsEqualToTheRandomGeneratedNumber(int number) {
    int outputNumber = 0;

    if (number != AppData.randomGeneratedNumber) {
      outputNumber = number < AppData.randomGeneratedNumber ? -1 : 1;
    }

    return outputNumber;
  }

  // method for closing the app
  static void closeApp() {
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }
}
