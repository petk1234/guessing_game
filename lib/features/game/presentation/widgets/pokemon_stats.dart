import 'package:flutter/material.dart';
import 'package:pokemon_guessing_game/features/game/domain/models/pokemon_model.dart';

class PokemonStats extends StatefulWidget {
  final PokemonModel pokemon;

  const PokemonStats({super.key, required this.pokemon});

  @override
  State<PokemonStats> createState() => _PokemonStatsState();
}

class _PokemonStatsState extends State<PokemonStats> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final pokemon = widget.pokemon;
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            this.isExpanded = isExpanded;
          });
        },
        children: [
          ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Stats',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ]));
              },
              body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: pokemon.stats.entries
                        .map(
                          (stat) => Padding(
                            key: Key(stat.key),
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${stat.key.toUpperCase()}: ${stat.value}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                LinearProgressIndicator(
                                  value: stat.value / 255,
                                  backgroundColor: Colors.grey[200],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    pokemon.types[0].color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  )),
              isExpanded: isExpanded)
        ]);
  }
}
