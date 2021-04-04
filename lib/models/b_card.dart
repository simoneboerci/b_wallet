class BCard{
  final String _name;
  final double _amount;

  BCard(this._name, this._amount);

  String get name => _name;
  double get amount => _amount;

  Map<String, dynamic> toJson() => {
    "name": _name,
    "amount": _amount
  };
}