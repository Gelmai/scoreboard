import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main.dart';

class AddPlayer extends StatelessWidget {
  AddPlayer({super.key, required this.sortList, required this.startTimer});
  final Controller c = Get.put(Controller());
  final nameFieldController = TextEditingController();
  final Function sortList;
  final Function startTimer;

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Add Player"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: nameFieldController,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: const Text("Cancel"), onPressed: () => Get.back()),
                  const SizedBox(width: 20.0),
                  ElevatedButton(
                      child: const Text("Done"),
                      onPressed: () {
                        c.playerList.add(Player(
                            index: c.playerCount,
                            name: nameFieldController.text.toUpperCase(),
                            score: 0,
                            adjustment: 0));
                        //nameFieldController.dispose();
                        c.playerCount++;
                        startTimer();
                        Get.offAll(() => Home());
                      }),
                ],
              ),
            ],
          ),
        ));
  }
}
