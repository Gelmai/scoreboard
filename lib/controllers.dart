import 'player_tile.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:async/async.dart';

class Player {
  var name = "".obs;
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
  late AnimationController flipVerticallyAnimationController;
  late FlipCardController flipCardController;
  late Animation<double> flipX;
  late GlobalKey<AnimatedListState> currentListKey;

  @override
  void refresh() {
    super.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    const flipVerticallyDuration = Duration(milliseconds: 500);

    flipVerticallyAnimationController = AnimationController(
        vsync: this, duration: flipVerticallyDuration, value: 1);

    flipX = Tween<double>(begin: -0.5, end: 0)
        .animate(flipVerticallyAnimationController);

    flipCardController = FlipCardController();
  }

  @override
  void onClose() {
    super.onClose();
    flipVerticallyAnimationController.dispose();
  }

  startAnimation() {
    if (flipVerticallyAnimationController.isAnimating) {
      flipVerticallyAnimationController.stop();
    }
  }

  void addItem(int index, RxString name) {
    playerList.insert(
        index,
        Player(
            index: playerList.length - 1, name: name, score: 0, adjustment: 0));
    playerCount++;
    currentListKey.currentState!
        .insertItem(index, duration: const Duration(milliseconds: 500));
  }

  void removeItem(int index) {
    final RxString nameToBeRemoved = playerList[index].name;

    playerList.removeAt(index);
    playerCount--;
    currentListKey.currentState!.removeItem(index, (_, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: PlayerTile(
            index: index, startTimer: () {}, nameToBeRemoved: nameToBeRemoved),
      );
    }, duration: const Duration(milliseconds: 500));
  }

  void resetList() {
    for (var i = 0; i < playerList.length; i++) {
      playerList[i].score = 0;
      playerList[i].adjustment = 0;
      playerList.refresh();
    }
  }

  void flipList() async {
    final Controller c = Get.put(Controller());

    await c.flipVerticallyAnimationController.reverse();

    int compareScore(dynamic a, dynamic b) {
      if (c.sortListAscending == true) {
        return a.score.compareTo(b.score);
      } else {
        return b.score.compareTo(a.score);
      }
    }

    c.sortListAscending = !c.sortListAscending;

    c.playerList.sort(compareScore);

    await c.flipVerticallyAnimationController.forward();

    //c.playerList.refresh();
  }

  void sortList() async {
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

    playerList.refresh();
    await flipVerticallyAnimationController.reverse();
    playerList.sort(compareScore);
    playerList.refresh();
    await flipVerticallyAnimationController.forward();
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
