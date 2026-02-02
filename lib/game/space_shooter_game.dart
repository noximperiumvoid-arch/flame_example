import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'components/player.dart';
import 'components/enemy.dart';
import 'dart:math';

class SpaceShooterGame extends FlameGame
    with HasCollisionDetection, TapCallbacks, PanDetector {
  late final SpriteComponent background;
  late final Player player;
  late final TextComponent scoreText;
  int score = 0;
  double _enemySpawnTimer = 0;
  static const double _enemySpawnInterval = 2.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Background
    background = SpriteComponent()
      ..sprite = await loadSprite('background.png')
      ..size = size;
    add(background);

    // Player
    player = Player();
    add(player);

    // Score Text
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 20),
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
  void update(double dt) {
    super.update(dt);

    // Enemy spawning
    _enemySpawnTimer += dt;
    if (_enemySpawnTimer >= _enemySpawnInterval) {
      _enemySpawnTimer = 0;
      _spawnEnemy();
    }

    scoreText.text = 'Score: $score';
  }

  void _spawnEnemy() {
    final x = Random().nextDouble() * size.x;
    final enemy = Enemy(position: Vector2(x, -50));
    add(enemy);
  }

  @override
  void onPanUpdate(PanUpdateInfo info) {
    player.setTargetPosition(info.eventPosition.global);
  }

  @override
  void onPanDown(TapDownInfo info) {
    player.setTargetPosition(info.eventPosition.global);
  }

  void addScore(int points) {
    score += points;
  }
}
