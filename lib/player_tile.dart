import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main.dart';
import 'player_detail.dart';

class PlayerTile extends StatelessWidget {
  PlayerTile({super.key, required this.index, required this.startTimer});
  final int index;
  final Function startTimer;
  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: TextButton(
        child: Text(
          '${c.playerList[index].name}',
          textAlign: TextAlign.center,
          softWrap: false,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () => Get.to(() => PlayerDetail(
              index: index,
            )),
      )),
      SizedBox(
        width: 70,
        child: Obx(() {
          return Text(
            '${c.playerList[index].score}',
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          );
        }),
      ),
      SizedBox(
        width: 75,
        child: Obx(() {
          if (c.playerList[index].adjustment == 0) return const Text('');
          if (c.playerList[index].adjustment > 0) {
            return Text(
              '+${c.playerList[index].adjustment}',
              softWrap: false,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            );
          } else {
            return Text(
              '${c.playerList[index].adjustment}',
              softWrap: false,
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            );
          }
        }),
      ),
      IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            //c.playerList[index].score++;
            c.playerList[index].adjustment += 100;
            c.playerList.refresh();
            startTimer();
          }),
      IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            //c.playerList[index].score--;
            c.playerList[index].adjustment--;
            c.playerList.refresh();
            startTimer();
          }),
    ]);
  }
}