class ItemPreparation {

  ItemPreparation({this.name});


  ItemPreparation.fromMap(Map<String, dynamic> map) {
    name = map['name'] as String;
  }

  String? name;


  @override
  String toString() {
    return 'ItemPreparation{name: $name}';
  }

  ItemPreparation clone() {
    return ItemPreparation(
        name: name,
    );
  }

  Map<String,dynamic> toMap() {
    return {
      'name' : name
    };
  }

}