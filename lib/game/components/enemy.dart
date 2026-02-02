import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../space_shooter_game.dart';
import 'projectile.dart';
import 'player.dart';
import 'dart:math';

class Enemy extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  static const double _speed = 50;
  double _shootTimer = 0;
  final double _shootInterval = 2.0 + Random().nextDouble() * 2.0;

  Enemy({required super.position}) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('enemy_ship.png');
    size = Vector2.all(64);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Random simple movement downwards
    position.y += _speed * dt;
    position.x += sin(gameRef.elapsedSeconds * 2) * 20 * dt;

    if (position.y > gameRef.size.y + 50) {
      removeFromParent();
    }

    // Shoot slow projectiles
    _shootTimer += dt;
    if (_shootTimer >= _shootInterval) {
      _shootTimer = 0;
      _shootAtPlayer();
    }
  }

  void _shootAtPlayer() {
    final player = gameRef.children.whereType<Player>().firstOrNull;
    if (player == null) return;

    final direction = (player.position - position).normalized();
    _fireProjectile(direction);
  }

  Future<void> _fireProjectile(Vector2 direction) async {
    final projectile = Projectile(
      direction: direction,
      speed: 150,
      source: ProjectileSource.enemy,
      position: position.clone(),
      sprite: await gameRef.loadSprite('projectile.png'),
      size: Vector2.all(16),
    );
    gameRef.add(projectile);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Projectile && other.source == ProjectileSource.player) {
      gameRef.addScore(100);
      other.removeFromParent();
      removeFromParent();
    }
  }
}
