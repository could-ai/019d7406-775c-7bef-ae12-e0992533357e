import 'package:flutter/material.dart';

void main() {
  runApp(const MyGameApp());
}

class MyGameApp extends StatelessWidget {
  const MyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TicTacToeScreen(),
      },
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  // تمثيل لوحة اللعب (9 مربعات)
  List<String> _board = List.filled(9, '');
  
  // تحديد دور اللاعب (X يبدأ أولاً)
  bool _isXTurn = true;
  
  // حالة اللعبة (فائز أو تعادل)
  String _winner = '';
  bool _isDraw = false;

  // دالة للتعامل مع الضغط على المربعات
  void _handleTap(int index) {
    if (_board[index] != '' || _winner != '') {
      return; // المربع ممتلئ أو اللعبة انتهت
    }

    setState(() {
      _board[index] = _isXTurn ? 'X' : 'O';
      _isXTurn = !_isXTurn;
      _checkWinner();
    });
  }

  // دالة للتحقق من الفائز
  void _checkWinner() {
    // احتمالات الفوز (الصفوف، الأعمدة، الأقطار)
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // الصفوف
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // الأعمدة
      [0, 4, 8], [2, 4, 6]             // الأقطار
    ];

    for (var pattern in winPatterns) {
      String a = _board[pattern[0]];
      String b = _board[pattern[1]];
      String c = _board[pattern[2]];

      if (a != '' && a == b && a == c) {
        setState(() {
          _winner = a;
        });
        return;
      }
    }

    // التحقق من التعادل
    if (!_board.contains('')) {
      setState(() {
        _isDraw = true;
      });
    }
  }

  // دالة لإعادة تشغيل اللعبة
  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _isXTurn = true;
      _winner = '';
      _isDraw = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لعبة إكس أو (Tic Tac Toe)', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // عرض حالة اللعبة (دور من، أو من الفائز)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              _winner != '' 
                  ? 'الفائز هو: $_winner 🎉' 
                  : _isDraw 
                      ? 'تعادل! 🤝' 
                      : 'دور اللاعب: ${_isXTurn ? 'X' : 'O'}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          
          // لوحة اللعب
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _handleTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _board[index],
                            style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              color: _board[index] == 'X' 
                                  ? Colors.blueAccent 
                                  : Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // زر إعادة اللعب
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: ElevatedButton.icon(
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh),
              label: const Text('إلعب مرة أخرى', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
