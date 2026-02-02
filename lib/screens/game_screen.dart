import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/space_shooter_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final SpaceShooterGame _game;

  @override
  void initState() {
    super.initState();
    _game = SpaceShooterGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: _game),
          // HUD (Heads Up Display) overlay can be added here
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.pause, color: Colors.white, size: 30),
              onPressed: () {
                // Handle pause logic
              },
            ),
          ),
        ],
      ),
    );
  }
}
