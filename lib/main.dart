import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './app_data.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(
      MaterialApp(
        home: GuessMyNumber(),
        debugShowCheckedModeBanner: false,
      )
  );
}

class GuessMyNumber extends StatelessWidget {
  const GuessMyNumber({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textFieldController = TextEditingController();
  final focusNode = FocusNode();

  void restartGame() {
    setState(() {
      AppData.userSelectedNumber = -2;
      AppData.randomGeneratedNumber = AppData.generateRandomNumberBetween(AppData.minRandomNumber, AppData.maxRandomNumber);
      AppData.cardText = AppData.tryNumberText;
      AppData.buttonText = AppData.guessButtonText;
      textFieldController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppData.primaryColor,
        title: Text(AppData.appTitle),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.clear,
                color: AppData.whiteColor,
              ),
              onPressed: AppData.closeApp)
        ],
      ),
      body: Container(
        color: AppData.secondaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FractionallySizedBox(
                widthFactor: .8,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: data.size.longestSide * 0.025,
                            horizontal: 0),
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
                            horizontal: 0),
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
                            horizontal: 0),
                        child: Card(
                          color: AppData.whiteColor,
                          elevation: data.size.shortestSide * 0.025,
                          shadowColor: AppData.silverColor,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: data.size.longestSide * 0.025,
                                    horizontal: 0),
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
                                    horizontal: data.size.longestSide * 0.025),
                                child: TextField(
                                  controller: textFieldController,
                                  cursorColor: AppData.primaryColor,
                                  cursorHeight: data.size.longestSide * 0.025,
                                  onChanged: (text) {
                                    if (text.length > 1 && text[0] == '0') {
                                      textFieldController.text = AppData.handleZeroFirstCharacter(textFieldController.text);
                                      textFieldController.selection = TextSelection.fromPosition(TextPosition(offset: textFieldController.text.length));
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: AppData.textFieldHintText,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: AppData.primaryColor,
                                        width: 2,
                                      )),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                        color: AppData.primaryColor,
                                        width: 2,
                                      )),
                                      hintStyle: TextStyle(
                                        color: AppData.primaryColor,
                                        fontSize: data.size.longestSide * 0.025,
                                      ),
                                      contentPadding: EdgeInsets.zero),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  style: TextStyle(
                                    color: AppData.primaryColor,
                                    fontSize: data.size.longestSide * 0.025,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: data.size.longestSide * 0.025,
                                    horizontal: 0),
                                child: OutlinedButton(
                                    onPressed: () {
                                      if (AppData.buttonText == AppData.restartText)
                                        restartGame();
                                      else {
                                        setState(() {
                                          if (textFieldController.text.isNotEmpty)
                                            AppData.userSelectedNumber = int.tryParse(textFieldController.text);
                                          else AppData.userSelectedNumber = -2;
                                        });

                                        int inputNumberIsEqualToTheRandomNumber = AppData.checkIfTheInputNumberIsEqualToTheRandomGeneratedNumber(AppData.userSelectedNumber);

                                        if (inputNumberIsEqualToTheRandomNumber == -1)
                                          Fluttertoast.showToast(msg: AppData.tryHigher);
                                        else if (inputNumberIsEqualToTheRandomNumber == 0) {
                                          Fluttertoast.showToast(msg: AppData.congratulationsText);

                                          setState(() {
                                            AppData.cardText = AppData.congratulationsText;
                                            AppData.buttonText = AppData.restartText;
                                          });
                                        }
                                        else if (inputNumberIsEqualToTheRandomNumber == 1)
                                          Fluttertoast.showToast(msg: AppData.tryLower);
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                      width: 2,
                                      color: AppData.primaryColor,
                                    )),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          data.size.shortestSide * 0.01),
                                      child: Text(
                                        AppData.buttonText,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppData.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              data.size.longestSide * 0.025,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
