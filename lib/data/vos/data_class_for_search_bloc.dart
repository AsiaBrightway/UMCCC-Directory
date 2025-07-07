class DataClassForSearchBloc{
  String token = "";
  int searchType = 0;
  int companyId = 0;
  int searchBy = 0;
  String searchName = "";
  String? lang;
  final EntityType entity; // new!

  DataClassForSearchBloc(
      this.token,
      this.searchType,
      this.companyId,
      this.searchName,
      {this.lang,required this.entity}
      );
}

enum EntityType { business, person }