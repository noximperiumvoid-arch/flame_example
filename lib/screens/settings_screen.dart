import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'SETTINGS',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SOUND EFFECTS',
                        style: TextStyle(fontSize: 20),
                      ),
                      Switch(
                        value: _soundEnabled,
                        onChanged: (value) {
                          setState(() {
                            _soundEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('BACK'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
