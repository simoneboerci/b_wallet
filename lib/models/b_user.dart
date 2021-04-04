import 'b_card.dart';

class BUser{
  final BCard _main;
  final List<BCard> _cards;

  BUser(this._main, this._cards);

  BCard get getMain => _main;
  List<BCard> get getCards => _cards;

  BCard getCard(int index) => _cards[index];

  Map<String, dynamic> toJson() => {
    "main_card": _main.toJson(),
    "cards": _cards.asMap()
  };
}