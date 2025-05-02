import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:sky_quest/game/assets.dart';
import 'package:sky_quest/game/config.dart';
import 'package:sky_quest/game/flappy_game.dart';
import 'package:sky_quest/game/pipe_position.dart';

class Pipe extends SpriteComponent with HasGameReference<FlappyBirdGame> {
  Pipe({required this.height, required this.pipePostion});

  final PipePostion pipePostion; 

  @override
  double height; // height of the pipe

  @override
  FutureOr<void> onLoad() async {
    final pipe = await Flame.images.load(Assets.pipe);
    final pipeRotated = await Flame.images.load(Assets.pipeRotated);
    size = Vector2(50, height);

    switch (pipePostion) {
      case PipePostion.top:
        position.y = 0;
        sprite = Sprite(pipeRotated);
        break;
      case PipePostion.bottom:
        position.y = game.size.y - size.y - Config.groundHeight;
        sprite = Sprite(pipe);
        break;
    }

    add(RectangleHitbox()); 
  }
}
