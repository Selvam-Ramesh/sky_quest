import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:sky_quest/components/pipe.dart';
import 'package:sky_quest/game/assets.dart';
import 'package:sky_quest/game/config.dart';
import 'package:sky_quest/game/flappy_game.dart';
import 'package:sky_quest/game/pipe_position.dart';

class PipeGroup extends PositionComponent with HasGameReference<FlappyBirdGame> {
  PipeGroup();

  final random = Random();

  @override
  FutureOr<void> onLoad() {
    position.x = game.size.x;

    final heightMinusGround = game.size.y - Config.groundHeight;
    final spacing = 100 + random.nextDouble() * (heightMinusGround / 4);
    final centerY =
        spacing + random.nextDouble() * (heightMinusGround - spacing);
    addAll([
      Pipe(pipePostion: PipePostion.top, height: centerY - spacing / 2),
      Pipe(
        pipePostion: PipePostion.bottom,
        height: heightMinusGround - (centerY + spacing / 2),
      ),
    ]);
  }

  void updateScore() {
    game.bird.score += 1;
    FlameAudio.play(Assets.point);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= Config.gameSpeed * dt;

    if (position.x < -10) {
      removeFromParent();
      updateScore();
    }

    if (game.isCollided) {
      removeFromParent();
      game.isCollided = false;
    }
  }
}
