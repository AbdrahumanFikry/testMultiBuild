import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = await readJsonFile("assets/config.json");
  if (kDebugMode) log("config : $config");
  final color = HexColor.fromHex(config["color"]);

  runApp(MyApp(color: color));
}

Future<Map> readJsonFile(String filePath) async {
  var input = await rootBundle.loadString(filePath);
  var map = jsonDecode(input) as Map<String, dynamic>;
  return map;
}

class MyApp extends StatelessWidget {
  final Color color;

  const MyApp({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fawater Demo',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        // id - logo - theme - colorPalette
        colorScheme: ColorScheme.fromSeed(seedColor: color),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        // id - logo - theme - colorPalette
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF59C09E),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Fawater Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _switchVal = true;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() => _counter = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton.filled(
            onPressed: _resetCounter,
            icon: Icon(
              Icons.local_print_shop_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          IconButton.filledTonal(
            onPressed: _resetCounter,
            color: Theme.of(context).colorScheme.tertiaryContainer,
            icon: Icon(
              Icons.notifications_on_outlined,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          children: <Widget>[
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Theming & Multi Build configurations",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondaryContainer,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(style: BorderStyle.solid),
                ),
              ),
            ),
            Switch.adaptive(
              value: _switchVal,
              onChanged: (value) => setState(() => _switchVal = value),
            ),
            const FilledButton(
              onPressed: null,
              child: Text("Disabled"),
            ),
            FilledButton.icon(
              label: const Text("RESET COUNTER"),
              icon: const Icon(Icons.restart_alt),
              onPressed: _resetCounter,
            ),
            FilledButton.tonal(
              onPressed: () async => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("This is a demo alert dialog."),
                  content:
                      const Text("Would you like to approve of this message?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Okay"),
                    ),
                    FilledButton.tonal(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text("Dismiss"),
                    ),
                  ],
                ),
              ),
              child: const Text("PRESS ME"),
            ),
            OutlinedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Yay! A SnackBar!'),
                  behavior: SnackBarBehavior.floating,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  action: SnackBarAction(
                    label: 'Close',
                    onPressed: () =>
                        ScaffoldMessenger.of(context).clearSnackBars(),
                  ),
                ),
              ),
              child: const Text("PRESS ME"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
