import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List<WordPair> _randomWordPairs = <WordPair>[];
  final Set<WordPair> _savedWordPairs = <WordPair>{};

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedWordPairs.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: TextStyle(fontSize: 18, color: Colors.indigo.shade400),
                ),
                trailing: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              );
            },
          );
          final List<Widget> divided =
              ListTile.divideTiles(context: context, tiles: tiles).toList();
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Saved'),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
              ),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WordPair Generator'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _pushSaved,
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        // Every other item should be a divider
        if (item.isOdd) return const Divider();

        // The index should be every 2 items to ignore the dividers
        final int index = item ~/ 2;

        // If the number of items in the list (index) is less than or equal to the number of WordPairs in the list, generate 10 more WordPairs
        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }

        return _buildListTile(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildListTile(WordPair wordPair) {
    final bool saved = _savedWordPairs.contains(wordPair);

    final IconData icon = saved ? Icons.favorite : Icons.favorite_border;

    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: TextStyle(fontSize: 18, color: Colors.indigo.shade400),
      ),
      trailing: IconButton(
        color: Colors.red,
        icon: Icon(icon),
        onPressed: () {
          setState(() {
            saved
                ? _savedWordPairs.remove(wordPair)
                : _savedWordPairs.add(wordPair);
          });
        },
      ),
    );
  }
}
