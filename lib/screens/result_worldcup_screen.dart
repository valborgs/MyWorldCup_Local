import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:my_worldcup_local/screens/play_worldcup_screen.dart';

import '../api/kakaotalk_feed.dart';
import '../models/worldcup_item_model.dart';
import '../models/worldcup_model.dart';

class ResultWorldCupScreen extends StatefulWidget {
  WorldCupModel worldCupModel;
  WorldCupItemModel winnerModel;
  int round;
  ResultWorldCupScreen(this.worldCupModel, this.winnerModel, this.round, {super.key});

  @override
  State<ResultWorldCupScreen> createState() => _ResultWorldCupScreen();
}

class _ResultWorldCupScreen extends State<ResultWorldCupScreen> {

  late ConfettiController _confettiController;

  @override
  void dispose() {
    super.dispose();
    _confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();

    return Scaffold(
      resizeToAvoidBottomInset:false,
      appBar: AppBar(
        title: Text("${widget.worldCupModel.title} 우승자"),
      ),
      // 화면
      body: Container(
        height: double.maxFinite,
        color: Colors.grey.withOpacity(0.1),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: const Row(
                children: [
                  Text(
                    "축하합니다!",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Icon(Icons.auto_awesome, color: Colors.yellow,)
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              width: 150,
              height: 150,
              child: CircleAvatar(
                backgroundImage: Image.file(File(widget.winnerModel.imagePath)).image,
              ) ,
            ),
            Text(
              widget.winnerModel.imageInfo,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            // 버튼 묶음
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 다시하기 버튼
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PlayWorldCupScreen(widget.worldCupModel, widget.round),
                      ),
                    );
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                      shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0))
                          )
                      )
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.replay,
                        color: Colors.white,
                      ),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      Text(
                        '다시 하기',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                // 공유 버튼
                IconButton(
                    onPressed: () => shareGameWithKakao(),
                    icon: Image.network(
                      'https://developers.kakao.com/assets/img/about/logos/kakaotalksharing/kakaotalk_sharing_btn_medium.png',
                      width: 40,
                    )
                ),
              ],
            ),
            // 팡파레 효과
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: -pi / 2 - 0.15,
                    emissionFrequency: 0,
                    numberOfParticles: 20,
                    maxBlastForce: 120,
                    minBlastForce: 60,
                  ),
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: -pi / 2 ,
                    emissionFrequency: 0,
                    numberOfParticles: 20,
                    maxBlastForce: 120,
                    minBlastForce: 60,
                  ),
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: -pi / 2 + 0.15,
                    emissionFrequency: 0,
                    numberOfParticles: 20,
                    maxBlastForce: 120,
                    minBlastForce: 60,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 카카오톡 공유하기 기능
  Future<void> shareGameWithKakao() async {
    var title = widget.worldCupModel.title;
    var image = widget.winnerModel.imagePath;
    var description = '${widget.worldCupModel.title} 우승자 : ${widget.winnerModel.imageInfo}';

    var myTemplate = await makeFeedTemplate(title, description, image, image);
    sendFeed(myTemplate);
  }
}
