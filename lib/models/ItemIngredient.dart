class ItemIngredient {

  ItemIngredient({this.name});

  ItemIngredient.fromMap(Map<String, dynamic> map) {
    name = map['name'] as String;
  }

  String? name;


  @override
  String toString() {
    return 'ItemIngredient{name: $name}';
  }

  ItemIngredient clone() {
    return ItemIngredient(
      name: name
    );
  }
  
  Map<String,dynamic> toMap() {
    return {
      'name' : name
    };
  }

}