import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:sky_quest/game/assets.dart';
import 'package:sky_quest/game/flappy_game.dart';

class Background extends SpriteComponent with HasGameReference<FlappyBirdGame> {
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load(Assets.background);
    size = game.size;
    sprite = Sprite(background);
  }
}
