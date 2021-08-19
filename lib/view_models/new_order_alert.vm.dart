import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/models/new_order.dart';
import 'package:fuodz/requests/order.request.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class NewOrderAlertViewModel extends MyBaseViewModel {
  //
  OrderRequest orderRequest = OrderRequest();
  NewOrder newOrder;
  bool canDismiss = false;
  CountDownController countDownTimerController = CountDownController();
  NewOrderAlertViewModel(this.newOrder, BuildContext context) {
    this.viewContext = context;
  }

  final assetsAudioPlayer = AssetsAudioPlayer();

  initialise() {
    //
    assetsAudioPlayer.open(
      Audio("assets/audio/alert.mp3"),
      loopMode: LoopMode.single,
    );
    //
    countDownTimerController.start();
    assetsAudioPlayer.play();
  }

  void processOrderAcceptance() async {
    setBusy(true);
    try {
      await orderRequest.acceptNewOrder(newOrder.id);
      assetsAudioPlayer.stop();
      viewContext.pop(true);
      return;
    } catch (error) {
      
      viewContext.showToast(
        msg: "$error",
        bgColor: Colors.red,
        textColor: Colors.white,
        textSize: 20,
      );

      //
      canDismiss = true;
    }
    setBusy(false);
    //
    if (canDismiss) {
      assetsAudioPlayer.stop();
      viewContext.pop();
    }
  }
}
