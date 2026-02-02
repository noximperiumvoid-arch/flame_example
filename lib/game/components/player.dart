import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../space_shooter_game.dart';
import 'projectile.dart';
import 'enemy.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Player extends PositionComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  static const double _speed = 300;
  Vector2? _targetPosition;
  double _shootTimer = 0;
  static const double _shootInterval = 0.5;

  Player() : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    print('Loading player sprite...');
    try {
      // sprite = await gameRef.loadSprite('player_ship.jpg');
      // For testing visibility:
      final paint = Paint()..color = Colors.red;
      size = Vector2.all(100);
      // Add a simple rectangle component to see if it renders
      add(RectangleComponent(size: size, paint: paint));
      size = Vector2.all(
        512,
      ); // This line was already there and sets the size after the RectangleComponent
      // print(
      //   'Player sprite loaded: ${sprite?.image.width}x${sprite?.image.height}',
      // );
    } catch (e) {
      print('Error loading player sprite: $e');
    }
    // size = Vector2.all(512); // This line is now after the RectangleComponent setup
    add(RectangleHitbox());
    print('Player internal position: $position');
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.size.x == 0 || gameRef.size.y == 0) return;

    // Initial position if at (0,0) and gameRef has size
    if (position == Vector2.zero() && gameRef.size.length > 0) {
      position = gameRef.size / 2;
    }

    // Mouse follow
    if (_targetPosition != null) {
      final direction = _targetPosition! - position;
      if (direction.length > 5) {
        position += direction.normalized() * min(direction.length, _speed * dt);
      }
    }

    // Automatic shooting
    _shootTimer += dt;
    if (_shootTimer >= _shootInterval) {
      _shootTimer = 0;
      _shootAtNearestEnemy();
    }
  }

  void setTargetPosition(Vector2 position) {
    _targetPosition = position;
  }

  void _shootAtNearestEnemy() {
    final enemies = gameRef.children.whereType<Enemy>();
    if (enemies.isEmpty) return;

    Enemy? nearestEnemy;
    double minDistance = double.infinity;

    for (final enemy in enemies) {
      final distance = position.distanceTo(enemy.position);
      if (distance < minDistance) {
        minDistance = distance;
        nearestEnemy = enemy;
      }
    }

    if (nearestEnemy != null && minDistance < 400) {
      final direction = (nearestEnemy.position - position).normalized();
      _fireProjectile(direction);
    }
  }

  Future<void> _fireProjectile(Vector2 direction) async {
    final projectile = Projectile(
      direction: direction,
      speed: 400,
      source: ProjectileSource.player,
      position: position.clone(),
      size: Vector2.all(16),
    )..priority = 15;
    gameRef.add(projectile);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy ||
        (other is Projectile && other.source == ProjectileSource.enemy)) {
      // Handle player hit
      print("Player hit!");
    }
  }
}
