import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'components/player.dart';
import 'components/enemy.dart';
import 'dart:math';

class SpaceShooterGame extends FlameGame
    with HasCollisionDetection, DragCallbacks, TapCallbacks {
  late final SpriteComponent background;
  late final Player player;
  late final TextComponent scoreText;
  int score = 0;
  double _enemySpawnTimer = 0;
  static const double _enemySpawnInterval = 2.0;

  @override
  bool get debugMode => true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      final bgSprite = await loadSprite('background.jpg');
      print(
        'Background sprite loaded: ${bgSprite.image.width}x${bgSprite.image.height}',
      );
      background = SpriteComponent()
        ..sprite = bgSprite
        ..size = size
        ..priority = -1;
      add(background);
    } catch (e) {
      print('Error loading background: $e');
    }

    print('Adding player...');
    // Player
    player = Player()..priority = 10;
    await add(player);
    print('Player added to game');

    // Score Text
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 20),
      priority: 100,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    add(scoreText);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) {
      background.size = size;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (size.x == 0 || size.y == 0) return;

    // Enemy spawning
    _enemySpawnTimer += dt;
    if (_enemySpawnTimer >= _enemySpawnInterval) {
      _enemySpawnTimer = 0;
      _spawnEnemy();
    }

    scoreText.text = 'Score: $score';
  }

  void _spawnEnemy() {
    final x = (Random().nextDouble() * (size.x - 100)) + 50;
    final enemy = Enemy(position: Vector2(x, -50))..priority = 5;
    add(enemy);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    player.setTargetPosition(event.localEndPosition);
  }

  @override
  void onTapDown(TapDownEvent event) {
    player.setTargetPosition(event.localPosition);
  }

  void addScore(int points) {
    score += points;
  }
}
