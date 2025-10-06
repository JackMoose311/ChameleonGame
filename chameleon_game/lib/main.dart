import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// Sound Service for playing UI sounds
class SoundService {
  static Future<void> playButtonSound() async {
    try {
      // Play a subtle button click sound using haptic feedback
      await HapticFeedback.lightImpact();
      // Add a small delay to make the sound more noticeable
      await Future.delayed(const Duration(milliseconds: 50));
    } catch (e) {
      // Fallback to haptic feedback if audio fails
      await HapticFeedback.lightImpact();
    }
  }
  
  static Future<void> playSliderSound() async {
    try {
      // Play a subtle slider sound using haptic feedback
      await HapticFeedback.selectionClick();
      // Add a small delay to make the sound more noticeable
      await Future.delayed(const Duration(milliseconds: 30));
    } catch (e) {
      // Fallback to haptic feedback if audio fails
      await HapticFeedback.selectionClick();
    }
  }
  
  static Future<void> playNavigationSound() async {
    try {
      // Play a different sound for navigation actions
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 40));
    } catch (e) {
      await HapticFeedback.mediumImpact();
    }
  }
}

// Dynamic Text Widget with subtle animation
class DynamicText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const DynamicText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  State<DynamicText> createState() => _DynamicTextState();
}

class _DynamicTextState extends State<DynamicText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 2 * _animation.value - 1), // Subtle vertical movement
          child: Opacity(
            opacity: 0.8 + (0.2 * _animation.value), // Subtle opacity change
            child: Text(
              widget.text,
              style: widget.style,
              textAlign: widget.textAlign,
              maxLines: widget.maxLines,
              overflow: widget.overflow,
            ),
          ),
        );
      },
    );
  }
}

// Hover-based Wiggling Text Widget
class HoverWiggleText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const HoverWiggleText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  State<HoverWiggleText> createState() => _HoverWiggleTextState();
}

class _HoverWiggleTextState extends State<HoverWiggleText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wiggleAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _wiggleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHoverEnter() {
    setState(() {
      _isHovering = true;
    });
    _controller.forward();
  }

  void _onHoverExit() {
    setState(() {
      _isHovering = false;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverEnter(),
      onExit: (_) => _onHoverExit(),
      child: AnimatedBuilder(
        animation: _wiggleAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _isHovering ? 0.05 * _wiggleAnimation.value * (1 - _wiggleAnimation.value) : 0.0,
            child: Transform.scale(
              scale: _isHovering ? 1.0 + (0.1 * _wiggleAnimation.value) : 1.0,
              child: Text(
                widget.text,
                style: widget.style,
                textAlign: widget.textAlign,
                maxLines: widget.maxLines,
                overflow: widget.overflow,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Word Manager to prevent repetition
class WordManager {
  static final Map<String, List<String>> _usedWords = {};
  
  static String getRandomWord(String category) {
    final wordList = WordCategories.categories[category] ?? WordCategories.categories['Movies']!;
    final usedWords = _usedWords[category] ?? [];
    
    // If all words have been used, reset the used words list
    if (usedWords.length >= wordList.length) {
      _usedWords[category] = [];
    }
    
    String selectedWord;
    do {
      selectedWord = wordList[Random().nextInt(wordList.length)];
    } while (_usedWords[category]?.contains(selectedWord) == true);
    
    _usedWords[category] = [...(usedWords), selectedWord];
    return selectedWord;
  }
  
  static void resetUsedWords() {
    _usedWords.clear();
  }
}

// Word Categories
class WordCategories {
  static const Map<String, List<String>> categories = {
    'Clash Royale': [
      'Archer Queen', 'Barbarian King', 'Mega Knight', 'P.E.K.K.A', 'Wizard',
      'Archer', 'Knight', 'Giant', 'Dragon', 'Skeleton', 'Bomber', 'Musketeer',
      'Prince', 'Baby Dragon', 'Witch', 'Skeleton Army', 'Goblin Gang', 'Minions'
    ],
    'Countries': [
      'France', 'Japan', 'Brazil', 'Australia', 'Canada', 'Germany', 'Italy',
      'Spain', 'Mexico', 'India', 'China', 'Russia', 'United Kingdom', 'South Korea',
      'Argentina', 'Egypt', 'Thailand', 'Netherlands', 'Sweden', 'Norway'
    ],
    'Video Games': [
      'Minecraft', 'Fortnite', 'Call of Duty', 'Grand Theft Auto', 'FIFA',
      'Among Us', 'Roblox', 'Pokemon', 'Super Mario', 'Zelda', 'Halo',
      'Counter-Strike', 'World of Warcraft', 'League of Legends', 'Valorant',
      'Apex Legends', 'Overwatch', 'Rocket League', 'Fall Guys'
    ],
    'Movies': [
      'Inception', 'Titanic', 'Avatar', 'Avengers', 'Star Wars', 'Harry Potter',
      'The Godfather', 'Forrest Gump', 'The Dark Knight', 'Pulp Fiction',
      'The Lion King', 'Toy Story', 'Jurassic Park', 'Spider-Man', 'Iron Man',
      'Frozen', 'Finding Nemo', 'Shrek', 'The Matrix', 'Back to the Future'
    ]
  };
}

// Custom Animated Button with Slam Effect
class RainforestButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  const RainforestButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
  });

  @override
  State<RainforestButton> createState() => _RainforestButtonState();
}

class _RainforestButtonState extends State<RainforestButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    SoundService.playButtonSound();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: widget.width ?? 200,
                height: widget.height ?? 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4A7C59), // Medium green
                      Color(0xFF2D5016), // Deep forest green
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A3D0A).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom Animated Slider with Rainforest Styling
class RainforestSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final ValueChanged<double>? onChanged;

  const RainforestSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.label,
    this.onChanged,
  });

  @override
  State<RainforestSlider> createState() => _RainforestSliderState();
}

class _RainforestSliderState extends State<RainforestSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _colorAnimation = ColorTween(
      begin: const Color(0xFF6B9B6B),
      end: const Color(0xFF4A7C59),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: _glowAnimation.value > 0 ? [
              BoxShadow(
                color: const Color(0xFF4A7C59).withOpacity(_glowAnimation.value * 0.3),
                blurRadius: 8 * _glowAnimation.value,
                spreadRadius: 2 * _glowAnimation.value,
              ),
            ] : null,
          ),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF4A7C59),
              inactiveTrackColor: const Color(0xFF2D5016).withOpacity(0.3),
              thumbColor: _colorAnimation.value,
              overlayColor: const Color(0xFF4A7C59).withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 12 + (2 * _glowAnimation.value),
              ),
              trackHeight: 6,
            ),
            child: Slider(
              value: widget.value,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              label: widget.label,
              onChanged: (value) {
                _controller.forward().then((_) {
                  _controller.reverse();
                });
                SoundService.playSliderSound();
                widget.onChanged?.call(value);
              },
            ),
          ),
        );
      },
    );
  }
}

void main() => runApp(const ChameleonApp());

class ChameleonApp extends StatelessWidget {
  const ChameleonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chameleon Game',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF2D5016), // Deep forest green
        scaffoldBackgroundColor: const Color(0xFF1A3D0A), // Dark rainforest green
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2D5016),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE8F5E8)), // Light green text
          bodyMedium: TextStyle(color: Color(0xFFE8F5E8)),
          titleLarge: TextStyle(color: Color(0xFFE8F5E8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A7C59), // Medium green
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: const Color(0xFF1A3D0A),
          ),
        ),
      ),
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
      appBar: AppBar(
        title: const Text("🦎 Chameleon Game"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A3D0A), // Dark rainforest green
              Color(0xFF2D5016), // Deep forest green
              Color(0xFF1A3D0A), // Back to dark
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Chameleon emoji and title
              const Text(
                "🦎",
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              DynamicText(
                text: "Chameleon Game",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE8F5E8),
                ),
              ),
              const SizedBox(height: 10),
              DynamicText(
                text: "Can you blend in or will you be caught?",
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFB8D4B8),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              RainforestButton(
                text: "Start Game",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameSettingsPage()),
                  );
                },
                width: 250,
                height: 60,
              ),
              const SizedBox(height: 20),
              RainforestButton(
                text: "About the Creator",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
                width: 250,
                height: 60,
              ),
            ],
          ),
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
  String selectedCategory = 'Movies';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game Settings"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A3D0A), // Dark rainforest green
              Color(0xFF2D5016), // Deep forest green
              Color(0xFF1A3D0A), // Back to dark
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Players section - More compact
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D5016).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4A7C59).withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Players",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE8F5E8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$players",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A7C59),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RainforestSlider(
                      value: players.toDouble(),
                      min: 3,
                      max: 10,
                      divisions: 7,
                      label: "$players",
                      onChanged: (val) => setState(() => players = val.round()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Rounds section - More compact
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D5016).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4A7C59).withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Rounds",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE8F5E8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$rounds",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A7C59),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RainforestSlider(
                      value: rounds.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: "$rounds",
                      onChanged: (val) => setState(() => rounds = val.round()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Category section - Compact with arrow navigation
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D5016).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF4A7C59).withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE8F5E8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left arrow
                        GestureDetector(
                          onTap: () async {
                            final categories = WordCategories.categories.keys.toList();
                            final currentIndex = categories.indexOf(selectedCategory);
                            final newIndex = currentIndex > 0 ? currentIndex - 1 : categories.length - 1;
                            setState(() {
                              selectedCategory = categories[newIndex];
                            });
                            await SoundService.playButtonSound();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A7C59).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFFE8F5E8),
                              size: 16,
                            ),
                          ),
                        ),
                        // Category name
                        Expanded(
                          child: Text(
                            selectedCategory,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFE8F5E8),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Right arrow
                        GestureDetector(
                          onTap: () async {
                            final categories = WordCategories.categories.keys.toList();
                            final currentIndex = categories.indexOf(selectedCategory);
                            final newIndex = currentIndex < categories.length - 1 ? currentIndex + 1 : 0;
                            setState(() {
                              selectedCategory = categories[newIndex];
                            });
                            await SoundService.playButtonSound();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A7C59).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFFE8F5E8),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              RainforestButton(
                text: "Start Game",
                onPressed: () {
                  WordManager.resetUsedWords(); // Reset used words for new game
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoundPage(
                        totalPlayers: players,
                        totalRounds: rounds,
                        currentRound: 1,
                        scores: List.filled(players, 0),
                        selectedCategory: selectedCategory,
                      ),
                    ),
                  );
                },
                width: 250,
                height: 50,
              ),
              const SizedBox(height: 16),
            ],
          ),
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
  final String selectedCategory;

  const RoundPage({
    super.key,
    required this.totalPlayers,
    required this.totalRounds,
    required this.currentRound,
    required this.scores,
    required this.selectedCategory,
  });

  @override
  State<RoundPage> createState() => _RoundPageState();
}

class _RoundPageState extends State<RoundPage> {
  int currentPlayer = 1;
  late int chameleon;
  late String word;
  bool wordShown = false;

  @override
  void initState() {
    super.initState();
    chameleon = Random().nextInt(widget.totalPlayers) + 1;
    word = WordManager.getRandomWord(widget.selectedCategory);
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
            selectedCategory: widget.selectedCategory,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isChameleon = currentPlayer == chameleon;

    return Scaffold(
      appBar: AppBar(
        title: Text("Round ${widget.currentRound}"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A3D0A), // Dark rainforest green
              Color(0xFF2D5016), // Deep forest green
              Color(0xFF1A3D0A), // Back to dark
            ],
          ),
        ),
        child: Center(
          child: !wordShown
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "🦎",
                      style: TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: 20),
                    DynamicText(
                      text: "Give phone to Player $currentPlayer",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE8F5E8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    DynamicText(
                      text: "Make sure no one else can see!",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB8D4B8),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    RainforestButton(
                      text: "Show Word",
                      onPressed: () {
                        setState(() => wordShown = true);
                      },
                      width: 200,
                      height: 60,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(30),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isChameleon 
                            ? const Color(0xFF8B4513).withOpacity(0.3) // Brown for chameleon
                            : const Color(0xFF2D5016).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isChameleon 
                              ? const Color(0xFFCD853F).withOpacity(0.8)
                              : const Color(0xFF4A7C59).withOpacity(0.8),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isChameleon ? "🦎" : "🦎",
                            style: const TextStyle(fontSize: 50),
                          ),
                          const SizedBox(height: 15),
                          DynamicText(
                            text: isChameleon ? "You are the CHAMELEON!" : "Word: $word",
                            style: TextStyle(
                              fontSize: isChameleon ? 28 : 24,
                              fontWeight: FontWeight.bold,
                              color: isChameleon 
                                  ? const Color(0xFFCD853F)
                                  : const Color(0xFFE8F5E8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (isChameleon) ...[
                            const SizedBox(height: 10),
                            const Text(
                              "Blend in and don't get caught!",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFB8D4B8),
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    RainforestButton(
                      text: "I have read the word",
                      onPressed: nextPlayer,
                      width: 250,
                      height: 60,
                    ),
                  ],
                ),
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
  final String selectedCategory;

  const SpinWheelPage({
    super.key,
    required this.totalPlayers,
    required this.totalRounds,
    required this.currentRound,
    required this.scores,
    required this.chameleon,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final int starter = Random().nextInt(totalPlayers) + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Who Starts?"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A3D0A), // Dark rainforest green
              Color(0xFF2D5016), // Deep forest green
              Color(0xFF1A3D0A), // Back to dark
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🦎",
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D5016).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF4A7C59).withOpacity(0.8),
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    DynamicText(
                      text: "Player $starter will start the round!",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE8F5E8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    DynamicText(
                      text: "Time to discuss and find the chameleon!",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB8D4B8),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              RainforestButton(
                text: "End Round",
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
                        selectedCategory: selectedCategory,
                      ),
                    ),
                  );
                },
                width: 200,
                height: 60,
              ),
            ],
          ),
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
  final String selectedCategory;

  const ResultsPage({
    super.key,
    required this.totalPlayers,
    required this.totalRounds,
    required this.currentRound,
    required this.scores,
    required this.chameleon,
    required this.selectedCategory,
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
            selectedCategory: widget.selectedCategory,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinalPage(
            scores: scores,
            selectedCategory: widget.selectedCategory,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Round Results"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A3D0A), // Dark rainforest green
              Color(0xFF2D5016), // Deep forest green
              Color(0xFF1A3D0A), // Back to dark
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DynamicText(
                text: "Leaderboard",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE8F5E8),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D5016).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF4A7C59).withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < scores.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Player ${i + 1}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFFE8F5E8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${scores[i]} pts",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF4A7C59),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              DynamicText(
                text: "Who won this round?",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE8F5E8),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RainforestButton(
                    text: "Players Win",
                    onPressed: () => nextRound(false),
                    width: 150,
                    height: 60,
                  ),
                    RainforestButton(
                      text: "Chameleon Wins",
                      onPressed: () => nextRound(true),
                      width: 150,
                      height: 60,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FinalPage extends StatelessWidget {
  final List<int> scores;
  final String selectedCategory;
  const FinalPage({super.key, required this.scores, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    int winner = scores.indexOf(scores.reduce(max)) + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Final Results"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A3D0A), // Dark rainforest green
              Color(0xFF2D5016), // Deep forest green
              Color(0xFF1A3D0A), // Back to dark
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "🦎",
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4A7C59),
                        Color(0xFF2D5016),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1A3D0A).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      DynamicText(
                        text: "WINNER!",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE8F5E8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DynamicText(
                        text: "Player $winner won!",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE8F5E8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                DynamicText(
                  text: "Final Leaderboard",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE8F5E8),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D5016).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xFF4A7C59).withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < scores.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (i + 1 == winner) const Text("★ ", style: TextStyle(fontSize: 18, color: Color(0xFF4A7C59))),
                                      Text(
                                        "Player ${i + 1}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: i + 1 == winner 
                                              ? const Color(0xFF4A7C59)
                                              : const Color(0xFFE8F5E8),
                                          fontWeight: i + 1 == winner 
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${scores[i]} pts",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: i + 1 == winner 
                                          ? const Color(0xFF4A7C59)
                                          : const Color(0xFF4A7C59),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RainforestButton(
                      text: "Restart Game",
                      onPressed: () {
                        WordManager.resetUsedWords(); // Reset used words for restart
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoundPage(
                              totalPlayers: scores.length,
                              totalRounds: 3, // Default to 3 rounds
                              currentRound: 1,
                              scores: List.filled(scores.length, 0),
                              selectedCategory: selectedCategory,
                            ),
                          ),
                        );
                      },
                      width: 140,
                      height: 50,
                    ),
                    RainforestButton(
                      text: "Home",
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomePage()),
                          (route) => false,
                        );
                      },
                      width: 140,
                      height: 50,
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
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About the Creator"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A3D0A), // Dark rainforest green
              Color(0xFF2D5016), // Deep forest green
              Color(0xFF1A3D0A), // Back to dark
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(40.0),
            decoration: BoxDecoration(
              color: const Color(0xFF2D5016).withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF4A7C59).withOpacity(0.8),
                width: 4,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "🦎",
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Hi, I'm Jack Mussoline!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE8F5E8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "I built this game so that I can enjoy the game anywhere with my friends!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFB8D4B8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                const Text(
                  "🦎 Can you blend in or will you be caught? 🦎",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A7C59),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                RainforestButton(
                  text: "LinkedIn",
                  onPressed: () async {
                    await SoundService.playButtonSound();
                    final Uri url = Uri.parse('https://www.linkedin.com/in/jack-mussoline-199060381/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  width: 200,
                  height: 50,
                ),
                const SizedBox(height: 15),
                RainforestButton(
                  text: "Email Me",
                  onPressed: () async {
                    await SoundService.playButtonSound();
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'jackmussoline@gmail.com',
                      query: 'subject=Chameleon Game Inquiry',
                    );
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    }
                  },
                  width: 200,
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
