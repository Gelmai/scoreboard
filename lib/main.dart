import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'player_tile.dart';
import 'add_player.dart';
import 'package:async/async.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Scoreboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

class Player {
  var name = "";
  var score = 0;
  var adjustment = 0;
  var index = 0;

  Player(
      {required this.index,
      required this.name,
      required this.score,
      required this.adjustment});
}

class Controller extends GetxController with GetTickerProviderStateMixin {
  var playerCount = 0;
  increment() => playerCount++;
  RxList playerList = <Player>[].obs;
  bool sortListAscending = true;
  late AnimationController animationController;
  late FlipCardController flipCardController;

  @override
  void refresh() {
    super.refresh();
  }

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));

    flipCardController = FlipCardController();
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
  }

  startAnimation() {
    if (animationController.isAnimating) {
      animationController.stop();
    }
  }

  void sortList() {
    for (var i = 0; i < playerList.length; i++) {
      playerList[i].score = playerList[i].score + playerList[i].adjustment;
      playerList[i].adjustment = 0;
    }

    int compareScore(dynamic a, dynamic b) {
      if (sortListAscending == true) {
        return a.score.compareTo(b.score);
      } else {
        return b.score.compareTo(a.score);
      }
    }

    playerList.sort(compareScore);
    playerList.refresh();
  }
}

class TimerController extends GetxController {
  final Controller c = Get.put(Controller());
  final RxInt _seconds = 0.obs;
  final RxBool _isRunning = false.obs;
  RestartableTimer? _timer;

  int get seconds => _seconds.value;
  bool get isRunnings => _isRunning.value;

  void startTimer() {
    if (!_isRunning.value) {
      _isRunning.value = true;
      _timer =
          RestartableTimer(const Duration(seconds: 3), () => {c.sortList()});
    } else {
      _timer?.reset();
    }
  }

  void stopTimer(Function sortList) {
    if (_isRunning.value) {
      _isRunning.value = false;
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class Home extends StatelessWidget {
  Home({super.key});
  final Controller c = Get.put(Controller());
  final TimerController timerController = Get.put(TimerController());

  void resetList() {
    for (var i = 0; i < c.playerList.length; i++) {
      c.playerList[i].score = 0;
      c.playerList[i].adjustment = 0;
      c.playerList.refresh();
    }
  }

  void flipList() {
    final Controller c = Get.put(Controller());

    int compareScore(dynamic a, dynamic b) {
      if (c.sortListAscending == true) {
        return a.score.compareTo(b.score);
      } else {
        return b.score.compareTo(a.score);
      }
    }

    c.sortListAscending = !c.sortListAscending;

    c.playerList.sort(compareScore);

    c.playerList.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Scoreboard"),
          actions: [
            IconButton(
                onPressed: () {
                  Get.defaultDialog(
                      title: "Reset scores?",
                      textConfirm: "Reset",
                      onConfirm: () {
                        resetList();
                        Get.close(1);
                      },
                      textCancel: "Cancel",
                      middleText: "This action cannot be undone!");
                },
                icon: const Icon(
                  Icons.restart_alt,
                  size: 40,
                )),
            FlipCard(
              direction: FlipDirection.VERTICAL,
              controller: c.flipCardController,
              side:
                  c.sortListAscending == true ? CardSide.FRONT : CardSide.BACK,
              front: const Icon(Icons.arrow_upward, size: 40),
              back: const Icon(Icons.arrow_downward, size: 40),
              onFlip: () {
                flipList();
              },
            ),
          ]),
      body: Center(
        child: Obx(() => ListView(
                children: List.generate((c.playerList.length), (index) {
              return PlayerTile(
                index: index,
                startTimer: timerController.startTimer,
              );
            }))),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddPlayer(
              sortList: c.sortList,
              startTimer: timerController.startTimer,
            )),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
