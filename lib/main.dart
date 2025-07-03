import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class PageViewPage extends StatelessWidget {
  final Color color;
  final String text;

  const PageViewPage({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coração Animal',
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    },
                    children: [
                    // Card 1: About the App
                    Container(
                      color: Color(0xFFFFA726),
                      child: Center(
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(80.0),
                                      topRight: const Radius.circular(80.0),
                                      bottomLeft: const Radius.circular(80.0),
                                      bottomRight: const Radius.circular(80.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  clipBehavior: Clip.hardEdge, // ESSENCIAL para cortar a imagem!

                                  child: SizedBox(
                                    width: 300,
                                    height: 200, // Metade da altura original
                                    child: ClipRect(
                                      child: OverflowBox(
                                        maxHeight: double.infinity,
                                        alignment: Alignment.topCenter,
                                        child: Transform.scale(
                                          scale: 1.0, // Aumenta o "zoom" da imagem (2x)
                                          alignment: Alignment.topCenter, // foca no topo
                                          child: Image.asset(
                                            'assets/images/adocao.png',
                                            width: 300,
                                            height: 350, // Tamanho real da imagem
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Center(
                                  child: Text(
                                    'Bem-vindo ao Coração Animal', 
                                    style: TextStyle(
                                      fontSize: 22, 
                                      fontWeight: FontWeight.bold,
                                      ),
                                    textAlign: TextAlign.center,

                                    )
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Este aplicativo ajuda você a encontrar animais para adoção, aprender sobre diferentes espécies e se envolver com a comunidade de amantes de animais.',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Card 2: How It Works
                    Container(
                      color: Color(0xFFFFA726),
                      child: Center(
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Como Funciona', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                SizedBox(height: 12),
                                Icon(Icons.explore, size: 48, color: Colors.orange),
                                SizedBox(height: 12),
                                Text(
                                  'Escolha um pet, leia sua história e veja se vocês combinam.',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Card 3: Get Started
                    Container(
                      color: Color(0xFFFFA726),
                      child: Center(
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Comece Agora!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                SizedBox(height: 12),
                                Icon(Icons.favorite, size: 48, color: Color(0xFFA5D6A7)),
                                SizedBox(height: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Como funciona a adoção?',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.green[100],
                                        child: Text('1'),
                                      ),
                                      title: Text('Explore os pets disponíveis por localização ou perfil.'),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.green[100],
                                        child: Text('2'),
                                      ),
                                      title: Text('Toque no pet que te encantou para ver mais detalhes.'),
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.green[100],
                                        child: Text('3'),
                                      ),
                                      title: Text('Envie uma solicitação de adoção e aguarde o retorno do abrigo ou tutor.'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.pets, color: Color(0xFFA5D6A7), size: 24),
                                          SizedBox(width: 4),
                                          Text(
                                            'Simples, seguro e cheio de amor!',
                                            style: TextStyle(fontSize: 16, color: Colors.black87),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),
                                Builder(
                                  builder: (context) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator: true).pushReplacement(
                                          MaterialPageRoute(builder: (context) => HomePage()),
                                        );
                                      },
                                      child: Text('Adote agora!', style: TextStyle(fontSize: 18)),
                                    );
                                  }
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  ),
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Icon(Icons.star, color: Colors.white, size: 32),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      final bool isSelected = _currentPage == index;
                      return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () => _goToPage(index),
                        child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: isSelected ? 36 : 24,
                        height: isSelected ? 18 : 12,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        ),
                      ),
                      );
                    }),
                    ),
                  ),
                ],
              ),  
            ),
          ),
        ),
      );
    }
}