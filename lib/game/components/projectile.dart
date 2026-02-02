import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import '../space_shooter_game.dart';

enum ProjectileSource { player, enemy }

class Projectile extends PositionComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  final Vector2 direction;
  final double speed;
  final ProjectileSource source;

  Projectile({
    required this.direction,
    required this.speed,
    required this.source,
    required super.position,
    required super.size,
  }) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final paint = Paint()..color = Colors.green;
    add(RectangleComponent(size: size, paint: paint));
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction * speed * dt;

    if (position.y < 0 ||
        position.y > gameRef.size.y ||
        position.x < 0 ||
        position.x > gameRef.size.x) {
      removeFromParent();
    }
  }
}
