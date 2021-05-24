import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './app_data.dart';

void main() {
  runApp(const MaterialApp(
    home: GuessMyNumber(),
    debugShowCheckedModeBanner: false,
  ));
}

class GuessMyNumber extends StatelessWidget {
  const GuessMyNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textFieldController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void restartGame() {
    setState(() {
      AppData.userSelectedNumber = -2;
      AppData.randomGeneratedNumber =
          AppData.generateRandomNumberBetween(AppData.minRandomNumber, AppData.maxRandomNumber);
      AppData.cardText = AppData.tryNumberText;
      AppData.buttonText = AppData.guessButtonText;
      textFieldController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppData.primaryColor,
        title: const Text(AppData.appTitle),
        centerTitle: true,
        actions: const <Widget>[
          IconButton(
            icon: Icon(
              Icons.clear,
              color: AppData.whiteColor,
            ),
            onPressed: AppData.closeApp,
          ),
        ],
      ),
      body: Container(
        color: AppData.secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FractionallySizedBox(
                widthFactor: .8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: data.size.longestSide * 0.025, horizontal: 0),
                      child: Text(
                        AppData.iAmThinkingText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppData.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: data.size.longestSide * 0.033,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: data.size.longestSide * 0.025,
                        horizontal: 0,
                      ),
                      child: Text(
                        AppData.yourTurnText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppData.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: data.size.longestSide * 0.025,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: data.size.longestSide * 0.025,
                        horizontal: 0,
                      ),
                      child: Card(
                        color: AppData.whiteColor,
                        elevation: data.size.shortestSide * 0.025,
                        shadowColor: AppData.silverColor,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: data.size.longestSide * 0.025,
                                horizontal: 0,
                              ),
                              child: Text(
                                AppData.cardText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppData.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: data.size.longestSide * 0.025,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: data.size.longestSide * 0.025,
                              ),
                              child: TextField(
                                controller: textFieldController,
                                cursorColor: AppData.primaryColor,
                                cursorHeight: data.size.longestSide * 0.025,
                                onChanged: (String text) {
                                  if (text.length > 1 && text[0] == '0') {
                                    textFieldController.text =
                                        AppData.handleZeroFirstCharacter(textFieldController.text);
                                    textFieldController.selection = TextSelection.fromPosition(
                                        TextPosition(offset: textFieldController.text.length));
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: AppData.textFieldHintText,
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppData.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppData.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  hintStyle: TextStyle(
                                    color: AppData.primaryColor,
                                    fontSize: data.size.longestSide * 0.025,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: TextStyle(
                                  color: AppData.primaryColor,
                                  fontSize: data.size.longestSide * 0.025,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: data.size.longestSide * 0.025, horizontal: 0),
                              child: OutlinedButton(
                                onPressed: () {
                                  if (AppData.buttonText == AppData.restartText)
                                    restartGame();
                                  else {
                                    setState(() {
                                      if (textFieldController.text.isNotEmpty)
                                        AppData.userSelectedNumber = int.parse(textFieldController.text);
                                      else
                                        AppData.userSelectedNumber = -2;
                                    });

                                    final int inputNumberIsEqualToTheRandomNumber =
                                        AppData.checkIfTheInputNumberIsEqualToTheRandomGeneratedNumber(
                                            AppData.userSelectedNumber);

                                    if (inputNumberIsEqualToTheRandomNumber == -1) {
                                      Fluttertoast.showToast(msg: AppData.tryHigher);
                                    } else if (inputNumberIsEqualToTheRandomNumber == 0) {
                                      Fluttertoast.showToast(msg: AppData.congratulationsText);

                                      setState(() {
                                        AppData.cardText = AppData.congratulationsText;
                                        AppData.buttonText = AppData.restartText;
                                      });
                                    } else if (inputNumberIsEqualToTheRandomNumber == 1) {
                                      Fluttertoast.showToast(msg: AppData.tryLower);
                                    }
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 2,
                                    color: AppData.primaryColor,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(data.size.shortestSide * 0.01),
                                  child: Text(
                                    AppData.buttonText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppData.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: data.size.longestSide * 0.025,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
