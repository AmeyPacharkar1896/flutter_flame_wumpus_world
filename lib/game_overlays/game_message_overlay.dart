import 'package:flutter/material.dart';

class GameMessageOverlay extends StatelessWidget {
  final String resultMessage;
  final int moves;
  final int arrowsLeft;
  final bool hasGold;
  final bool isDead;
  final int finalScore;
  final VoidCallback onRestartSame;
  final VoidCallback onRestartNew;

  const GameMessageOverlay({
    super.key,
    required this.resultMessage,
    required this.moves,
    required this.arrowsLeft,
    required this.hasGold,
    required this.isDead,
    required this.finalScore,
    required this.onRestartSame,
    required this.onRestartNew,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = const TextStyle(
      color: Colors.white,
      fontSize: 18,
    );

    final TextStyle valueStyle = const TextStyle(
      color: Colors.orangeAccent,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    return SafeArea(
      child: Center(
        child: Card(
          color: Colors.black87,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  resultMessage,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                _buildRow(
                  "🎯 Moves Made",
                  moves.toString(),
                  "-${moves * 2}",
                  labelStyle,
                  valueStyle,
                ),
                _buildRow(
                  "🏹 Arrows Left",
                  arrowsLeft.toString(),
                  "+${arrowsLeft * 50}",
                  labelStyle,
                  valueStyle,
                ),
                _buildRow(
                  "💰 Gold Collected",
                  hasGold ? "✔" : "✘",
                  hasGold ? "+100" : "+0",
                  labelStyle,
                  valueStyle,
                ),
                _buildRow(
                  "🧍 Player Status",
                  isDead ? "Dead" : "Alive",
                  isDead ? "-200" : "+200",
                  labelStyle,
                  valueStyle,
                ),
                const Divider(color: Colors.white70, height: 32),
                _buildRow(
                  "🏁 Final Score",
                  "",
                  "$finalScore pts",
                  labelStyle.copyWith(fontSize: 20),
                  valueStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onRestartSame,
                        icon: const Icon(Icons.replay),
                        label: const Text("Same Map"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onRestartNew,
                        icon: const Icon(Icons.refresh),
                        label: const Text("New Map"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    String pts,
    TextStyle labelStyle,
    TextStyle valueStyle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: labelStyle)),
          Text(value, style: valueStyle),
          const SizedBox(width: 12),
          Text(pts, style: valueStyle),
        ],
      ),
    );
  }
}
