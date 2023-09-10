import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'player_tile.dart';
import 'add_player.dart';
import 'controllers.dart';

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

class Home extends StatelessWidget {
  Home({super.key});
  final Controller c = Get.put(Controller());
  final TimerController timerController = Get.put(TimerController());

  @override
  Widget build(BuildContext context) {
    final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
    c.currentListKey = listKey;

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
                        c.resetList();
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
                c.flipList();
              },
            ),
          ]),
      body: Center(
          child: AnimatedList(
              key: listKey,
              initialItemCount: 0,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                    key: UniqueKey(),
                    sizeFactor: animation,
                    child: PlayerTile(
                      index: index,
                      startTimer: timerController.startTimer,
                    ));
              })
          //return buildListItem(playerTiles[index], index);
          ),
/*
      body: Center(
        child: Obx(() => ListView(
                children: List.generate((c.playerList.length), (index) {
              return PlayerTile(
                index: index,
                startTimer: timerController.startTimer,
              );
            }))),
      ),
*/
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

// Widget buildListItem(Widget item, int index) {
//   final Controller c = Get.put(Controller());
//   c.playerList.refresh();
//   return AnimatedBuilder(
//     animation: c.flipX,
//     builder: (BuildContext context, Widget? child) {
//       return Transform(
//         transform: Matrix4.identity()
//           ..setEntry(3, 2, 0.0002)
//           ..rotateX(pi * c.flipX.value),
//         alignment: Alignment.center,
//         child: Container(
//           child: item,
//         ),
//       );
//     },
//   );

//   // Widget for the horizontally flipping animation
// }
