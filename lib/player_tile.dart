import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'player_detail.dart';
import 'controllers.dart';

class PlayerTile extends StatelessWidget {
  PlayerTile(
      {super.key,
      required this.index,
      required this.startTimer,
      this.nameToBeRemoved});
  final int index;
  final Function startTimer;
  final RxString? nameToBeRemoved;
  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    if (c.playerList.isEmpty) return const Column();

    return Column(
      children: [
        if (index == 0) const Divider(height: 2),
        if (index <= c.playerList.length - 1)
          Row(children: [
            Expanded(
                child: TextButton(
              child: Obx(() => Text(
                    nameToBeRemoved?.value ?? c.playerList[index].name.value,
                    textAlign: TextAlign.center,
                    softWrap: false,
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  )),
              onPressed: () => Get.to(() => PlayerDetail(
                    index: index,
                  )),
            )),
            SizedBox(
              width: 70,
              child: Obx(() {
                return Text(
                  '${c.playerList[index].score}',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
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
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  );
                } else {
                  return Text(
                    '${c.playerList[index].adjustment}',
                    softWrap: false,
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  );
                }
              }),
            ),
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  //c.playerList[index].score++;
                  c.playerList[index].adjustment += 10;
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
          ]),
        const Divider(),
      ],
    );
  }
}
