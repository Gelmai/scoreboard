import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main.dart';

class PlayerDetail extends StatelessWidget {
  PlayerDetail({super.key, required this.index});
  final Controller c = Get.put(Controller());
  final nameFieldController = TextEditingController();
  final int index;

  @override
  Widget build(context) {
    nameFieldController.text = c.playerList[index].name;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Player Detail"),
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
                        c.playerList[index].name =
                            nameFieldController.text.toUpperCase();
                        //nameFieldController.dispose();
                        Get.offAll(() => Home());
                      }),
                ],
              ),
            ],
          ),
        ));
  }
}
