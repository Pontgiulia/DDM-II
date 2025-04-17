import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flores Aleatórias',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.from(alpha: 1, red: 1, green: 0.702, blue: 0.961)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final List<String> flowerNames = [
    'Rosa', 'Girassol', 'Tulipa', 'Orquídea', 'Lírio', 'Violeta', 'Dália', 'Jasmim', 'Cravo', 'Camélia', 'Hortênsia', 'Amarílis', 'Azaleia', 'Begônia', 'Copo-de-leite', 'Magnólia', 'Íris', 'Lavanda', 'Flor-de-lótus', 'Alstroeméria', 'Petúnia', 'Gerânio', 'Margarida', 'Dente-de-leão', 'Papoula', 'Flor-de-maio', 'Flor-de-maracujá', 'Calêndula', 'Peônia', 'Anêmona', 'Zínia', 'Celósia', 'Cosmos', 'Estrelítzia', 'Helicônia', 'Verônica', 'Torênia', 'Ipomeia', 'Flor-de-cera', 'Gladiolo', 'Malva', 'Capuchinha', 'Nigela', 'Lisianthus', 'Ranúnculo', 'Angélica', 'Boca-de-leão', 'Ciclame', 'Flor-de-seda', 'Sempre-viva'
  ];

  final random = Random();
  String current = '*Flores*';

  void getNext() {
    current = flowerNames[random.nextInt(flowerNames.length)];
    notifyListeners();
  }

  var favorites = <String>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Inicio'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Curtidas'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var flower = appState.current;

    IconData icon = appState.favorites.contains(flower)
        ? Icons.favorite
        : Icons.favorite_border;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/Flor.png', // esse caminho deve bater com o pubspec.yaml
          fit: BoxFit.cover,
        ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BigCard(flower: flower),
              SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      appState.toggleFavorite();
                    },
                    icon: Icon(icon),
                    label: Text('Curtir'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      appState.getNext();
                    },
                    child: Text('Próxima!'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key, required this.flower});

  final String flower;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          flower,
          style: style,
          semanticsLabel: flower,
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(child: Text('Nenhuma flor favoritada ainda.'));
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Você favoritou ${appState.favorites.length} flores:',
          ),
        ),
        for (var flower in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(flower),
          ),
      ],
    );
  }
}
