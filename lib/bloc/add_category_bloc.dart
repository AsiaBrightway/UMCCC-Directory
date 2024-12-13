
import 'package:flutter/cupertino.dart';
import '../data/models/pahg_model.dart';
import '../data/vos/category_vo.dart';
import '../data/vos/request_body/add_category_vo.dart';
import '../data/vos/request_body/get_request.dart';
import '../utils/helper_functions.dart';
import '../utils/utils.dart';

class AddCategoryBloc extends ChangeNotifier{

  List<CategoryVo>? _categoryList;
  List<CategoryVo>? _parentCategoryList;
  String _token = '';
  int? _selectedParent;
  int? _updateParentId;
  final PahgModel _model = PahgModel();
  String? _categoryName;
  bool _isActive = true;
  String? _failedMessage;
  int? updateId;

  int? get updateParentId => _updateParentId;
  String? get failedMessage => _failedMessage;
  String get token => _token;
  int? get selectedParentId => _selectedParent;
  List<CategoryVo>? get parentCategoryList => _parentCategoryList;
  List<CategoryVo>? get categoryList => _categoryList;
  String? get categoryName => _categoryName;
  bool get isActive => _isActive;

  void updateCategoryName(String? value) {
    _categoryName = value;
    notifyListeners();
  }

  set isActive(bool value) {
    _isActive = value;
    notifyListeners();
  }

  set updateParentId(int? value) {
    _updateParentId = value;
    notifyListeners();
  }

  set selectedParentId(int? value) {
    _selectedParent = value;
    notifyListeners();
  }

  AddCategoryBloc(String token,bool isAdd){
    _token = token;
    getCategoryList(isAdd);
  }

  Future<void> getCategoryList(bool isAdd)async {
    ///column condition 5 is all
    GetRequest request = GetRequest(columnName: "ParentId", columnCondition: 5, columnValue: "0");
    _model.getCategories(_token, request).then((onValue){
      if(isAdd){
        _categoryList = [CategoryVo(0, "No Parent", 0, isActive,null, null),...onValue];
      }else{
        _categoryList = onValue;
        var tempList = _categoryList?.where((category) => category.parentId == 0).toList();
        _parentCategoryList = [CategoryVo(0, "No Parent", 0, isActive, null, null),...?tempList];
      }
      notifyListeners();
    }).catchError((onError){

    });
  }

  Future<void> addCategory(BuildContext context) async{
    if(_categoryName != null && _selectedParent != null){
      AddCategoryVo requestBody = AddCategoryVo(0, _categoryName, _selectedParent, _isActive, null, Utils.getCurrentDate());
      _model.addCategory(_token, requestBody).then((onValue){
        showSuccessScaffold(context, onValue?.message ?? '');
      }).catchError((onError){
        showErrorDialog(context, onError.toString());
      });
    }
    else if(_selectedParent == null){
      showScaffoldMessage(context, "Please select Parent Id");
    }
    else{
      showScaffoldMessage(context, "Please fill the blank Category!");
    }
  }

  Future<void> updateCategory(BuildContext context) async{
    if(_categoryName != null && updateId != null && _updateParentId != null){
      AddCategoryVo requestBody = AddCategoryVo(updateId, _categoryName, _updateParentId, _isActive, null, null);
      _model.updateCategory(_token,updateId!, requestBody).then((onValue){
        showSuccessScaffold(context, onValue?.message ?? '');
      }).catchError((onError){
        showErrorDialog(context, onError.toString());
      });
    }
    else if(_updateParentId == null){
      showScaffoldMessage(context, "Please select parent.");
    }
    else if(updateId == null){
      showScaffoldMessage(context, "Your update id is null");
    }
    else{
      showScaffoldMessage(context, "Please fill the blank Category!");
    }
  }
}