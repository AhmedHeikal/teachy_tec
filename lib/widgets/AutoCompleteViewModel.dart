class AutoCompleteViewModel {
  int id;
  String name;
  String? image;
  bool? isAllergen;
  bool? isDish;
  // AutoCompleteType autoCompleteType;

  AutoCompleteViewModel({
    required this.id,
    required this.name,
    this.image,
    this.isAllergen,
    this.isDish,
  });
}

// enum AutoCompleteType {
//   GoesGreatWith,
//   MaterialLinkViewModel,
//   IngredientViewModel,
//   AdditionalIngredientViewModel,
//   MenuItemViewModel,
//   AlcoholicItemViewModel,
//   MenuItemLiteViewModel,
//   WineItemLiteViewModel,
//   AlcoholicItemIngredientViewModel,
//   // This type is added to add empty element to the AutoComplete TextField
//   None,
// }
