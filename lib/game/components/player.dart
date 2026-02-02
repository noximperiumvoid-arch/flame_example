import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../space_shooter_game.dart';
import 'projectile.dart';
import 'enemy.dart';
import 'dart:math';

class Player extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  static const double _speed = 300;
  Vector2? _targetPosition;
  double _shootTimer = 0;
  static const double _shootInterval = 0.5;

  Player() : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('player_ship.png');
    size = Vector2.all(64);
    position = gameRef.size / 2;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

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
      sprite: await gameRef.loadSprite('projectile.png'),
      size: Vector2.all(16),
    );
    gameRef.add(projectile);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Enemy ||
        (other is Projectile && other.source == ProjectileSource.enemy)) {
      // Handle player hit (e.g., game over or lose life)
      // For now, just print
      print("Player hit!");
    }
  }
}
