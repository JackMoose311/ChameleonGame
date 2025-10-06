import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const ChameleonApp());

class ChameleonApp extends StatelessWidget {
  const ChameleonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chameleon Game',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chameleon Game")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Start Game"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameSettingsPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("About the Creator"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GameSettingsPage extends StatefulWidget {
  const GameSettingsPage({super.key});

  @override
  State<GameSettingsPage> createState() => _GameSettingsPageState();
}

class _GameSettingsPageState extends State<GameSettingsPage> {
  int players = 3;
  int rounds = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Game Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Number of Players: $players"),
            Slider(
              value: players.toDouble(),
              min: 3,
              max: 10,
              divisions: 7,
              label: "$players",
              onChanged: (val) => setState(() => players = val.round()),
            ),
            Text("Number of Rounds: $rounds"),
            Slider(
              value: rounds.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: "$rounds",
              onChanged: (val) => setState(() => rounds = val.round()),
            ),
            const Spacer(),
            ElevatedButton(
              child: const Text("Start Game"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoundPage(
                      totalPlayers: players,
                      totalRounds: rounds,
                      currentRound: 1,
                      scores: List.filled(players, 0),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RoundPage extends StatefulWidget {
  final int totalPlayers;
  final int totalRounds;
  final int currentRound;
  final List<int> scores;

  const RoundPage({
    super.key,
    required this.totalPlayers,
    required this.totalRounds,
    required this.currentRound,
    required this.scores,
  });

  @override
  State<RoundPage> createState() => _RoundPageState();
}

class _RoundPageState extends State<RoundPage> {
  int currentPlayer = 1;
  late int chameleon;
  late String word;
  bool wordShown = false;
  final List<String> wordList = [
    "Inception",
    "Titanic",
    "Paris",
    "New York",
    "Albert Einstein",
    "Taylor Swift",
    "Mount Everest",
    "Iron Man",
    "Harry Potter",
    "The Godfather"
  ];

  @override
  void initState() {
    super.initState();
    chameleon = Random().nextInt(widget.totalPlayers) + 1;
    word = wordList[Random().nextInt(wordList.length)];
  }

  void nextPlayer() {
    if (currentPlayer < widget.totalPlayers) {
      setState(() {
        currentPlayer++;
        wordShown = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SpinWheelPage(
            totalPlayers: widget.totalPlayers,
            totalRounds: widget.totalRounds,
            currentRound: widget.currentRound,
            scores: widget.scores,
            chameleon: chameleon,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isChameleon = currentPlayer == chameleon;

    return Scaffold(
      appBar: AppBar(title: Text("Round ${widget.currentRound}")),
      body: Center(
        child: !wordShown
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Give phone to Player $currentPlayer"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => wordShown = true);
                    },
                    child: const Text("Show Word"),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isChameleon ? "You are the CHAMELEON!" : "Word: $word",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: nextPlayer,
                    child: const Text("I have read the word"),
                  ),
                ],
              ),
      ),
    );
  }
}

class SpinWheelPage extends StatelessWidget {
  final int totalPlayers;
  final int totalRounds;
  final int currentRound;
  final List<int> scores;
  final int chameleon;

  const SpinWheelPage({
    super.key,
    required this.totalPlayers,
    required this.totalRounds,
    required this.currentRound,
    required this.scores,
    required this.chameleon,
  });

  @override
  Widget build(BuildContext context) {
    final int starter = Random().nextInt(totalPlayers) + 1;

    return Scaffold(
      appBar: AppBar(title: const Text("Who Starts?")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Player $starter will start the round!",
                style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsPage(
                      totalPlayers: totalPlayers,
                      totalRounds: totalRounds,
                      currentRound: currentRound,
                      scores: scores,
                      chameleon: chameleon,
                    ),
                  ),
                );
              },
              child: const Text("End Round"),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsPage extends StatefulWidget {
  final int totalPlayers;
  final int totalRounds;
  final int currentRound;
  final List<int> scores;
  final int chameleon;

  const ResultsPage({
    super.key,
    required this.totalPlayers,
    required this.totalRounds,
    required this.currentRound,
    required this.scores,
    required this.chameleon,
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  late List<int> scores;

  @override
  void initState() {
    super.initState();
    scores = List.from(widget.scores);
  }

  void nextRound(bool chameleonWins) {
    if (chameleonWins) {
      scores[widget.chameleon - 1]++;
    } else {
      for (int i = 0; i < scores.length; i++) {
        if (i != widget.chameleon - 1) scores[i]++;
      }
    }

    if (widget.currentRound < widget.totalRounds) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoundPage(
            totalPlayers: widget.totalPlayers,
            totalRounds: widget.totalRounds,
            currentRound: widget.currentRound + 1,
            scores: scores,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinalPage(scores: scores),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Round Results")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Leaderboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          for (int i = 0; i < scores.length; i++)
            Text("Player ${i + 1}: ${scores[i]} pts"),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => nextRound(false),
            child: const Text("Players Win"),
          ),
          ElevatedButton(
            onPressed: () => nextRound(true),
            child: const Text("Chameleon Wins"),
          ),
        ],
      ),
    );
  }
}

class FinalPage extends StatelessWidget {
  final List<int> scores;
  const FinalPage({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    int winner = scores.indexOf(scores.reduce(max)) + 1;

    return Scaffold(
      appBar: AppBar(title: const Text("Final Results")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Player $winner won!", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            for (int i = 0; i < scores.length; i++)
              Text("Player ${i + 1}: ${scores[i]} pts"),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About the Creator")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/creator.jpg'), // Add image to assets folder
            ),
            const SizedBox(height: 20),
            const Text(
              "Hi, I'm [Your Name]! I built this game for fun to bring people together and test how sneaky you can be as the Chameleon!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {}, // add LinkedIn URL
              child: const Text("LinkedIn"),
            ),
            TextButton(
              onPressed: () {}, // add email link
              child: const Text("Email Me"),
            ),
          ],
        ),
      ),
    );
  }
}
