import 'package:flutter/material.dart';
import 'winning_line.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Cat extends StatefulWidget {
  const Cat({super.key});

  @override
  CatState createState() => CatState();
}

class CatState extends State<Cat> {
  late List<String> table;
  late String jugadorActual;
  late bool isOver;
  late List<int> lineaGanadora;
  String winner = '';

  @override
  void initState() {
    super.initState();
    restart();
  }

  TextStyle styleText() {
    return const TextStyle(color: Colors.white, fontSize: 20);
  }

  void restart() {
    setState(() {
      table = List.filled(9, '');
      jugadorActual = '👻';
      isOver = false;
      lineaGanadora = [];
      winner = '';
    });
  }

  void _handleTap(int index) {
    if (!isOver && table[index] == '') {
      setState(() {
        table[index] = jugadorActual;
        isOver = verificarGanador(jugadorActual, index) || !table.contains('');
        if (!isOver) {
          jugadorActual = jugadorActual == '👻' ? '⭕' : '👻';
        } else {
          setState(() {
            winner = lineaGanadora.isNotEmpty ? jugadorActual : 'Empate';
          });
        }
      });
    }
  }

  bool verificarGanador(String jugador, int index) {
    final List<List<int>> lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];

    for (var line in lines) {
      if (line.contains(index) && line.every((i) => table[i] == jugador)) {
        lineaGanadora = line;
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JUEGO DEL GATO'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(color: Color(0xFF0E1C1F)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Jugador 1: 👻',
                    style: styleText(),
                  ),
                  Text(
                    'Jugador 2: ⭕',
                    style: styleText(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          tablero(),
          const SizedBox(height: 20),
          isOver
              ? ElevatedButton(
                  onPressed: restart,
                  child: const Text('REINICIAR'),
                )
              : Container(),
          const SizedBox(height: 20),
          winner.isNotEmpty
              ? Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Alert(
                        context: context,
                        title: winner == 'Empate' ? 'EMPATE' : 'GANADOR',
                        desc: winner == 'Empate' ? 'Es un empate' : (winner == '👻' ? 'JUGADOR 1 $winner' : 'JUGADOR 2 $winner'),
                        buttons: [
                          DialogButton(child: const Text('OK'), onPressed: () => Navigator.pop(context))
                        ]
                      ).show();
                    });
                    return Container();
                  },
                )
              : Text(
                  'Turno de: $jugadorActual',
                  style: styleText(),
                ),
        ],
      ),
    );
  }

  Widget tablero() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _handleTap(index),
                  child: GridTile(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: Center(
                        child: Text(
                          table[index],
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: table[index] == '👻'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          generarLinea(),
        ],
      ),
    );
  }

  Widget generarLinea() {
    if (lineaGanadora.isEmpty) return Container();

    Offset start, end;
    switch (lineaGanadora) {
      case [0, 1, 2]:
        start = const Offset(0, 1 / 6);
        end = const Offset(1, 1 / 6);
        break;
      case [3, 4, 5]:
        start = const Offset(0, 1 / 2);
        end = const Offset(1, 1 / 2);
        break;
      case [6, 7, 8]:
        start = const Offset(0, 5 / 6);
        end = const Offset(1, 5 / 6);
        break;
      case [0, 3, 6]:
        start = const Offset(1 / 6, 0);
        end = const Offset(1 / 6, 1);
        break;
      case [1, 4, 7]:
        start = const Offset(1 / 2, 0);
        end = const Offset(1 / 2, 1);
        break;
      case [2, 5, 8]:
        start = const Offset(5 / 6, 0);
        end = const Offset(5 / 6, 1);
        break;
      case [0, 4, 8]:
        start = const Offset(0, 0);
        end = const Offset(1, 1);
        break;
      case [2, 4, 6]:
        start = const Offset(1, 0);
        end = const Offset(0, 1);
        break;
      default:
        return Container();
    }

    return CustomPaint(
      painter: WinningLinePainter(start, end),
      size: Size.infinite,
    );
  }
}
