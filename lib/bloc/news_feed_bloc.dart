import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pahg_group/utils/helper_functions.dart';
import '../data/models/pahg_model.dart';
import '../data/vos/post_vo.dart';
import '../data/vos/request_body/get_request.dart';

enum NewsFeedState { initial, loading, success, error }
class NewsFeedBloc extends ChangeNotifier{

  final PahgModel _model = PahgModel();
  String _token = "";
  NewsFeedState _newsFeedState = NewsFeedState.initial;
  List<PostVo>? _postList;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  int? _categoryId;

  List<PostVo>? get postList => _postList;
  NewsFeedState get newsFeedState => _newsFeedState;
  String? get errorMessage => _errorMessage;

  ///Constructor
  NewsFeedBloc(String token,int categoryId){
    _token = token;
    _categoryId = categoryId;
    getNewsFeed();
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  Future<void> getNewsFeed() async{
    _currentPage = 1;
    _hasMore = true;
    _newsFeedState = NewsFeedState.loading;
    notifyListeners();
    GetRequest request = GetRequest(columnName: "CategoryId", columnCondition: 1, columnValue: _categoryId.toString());
    //order by id descending
    _model.getPosts(_token, request,_currentPage,10).then((onValue){
      _postList = onValue;
      _newsFeedState = NewsFeedState.success;
      notifyListeners();
    }).catchError((onError){
      _errorMessage = onError.toString();
      _newsFeedState = NewsFeedState.error;
      notifyListeners();
    });

    _currentPage ++;
  }

  ///when you use methods like remove(),
  ///it doesn't create a new list.
  ///Flutter's ChangeNotifier might not detect this in-place change.
  Future<void> deletePost(BuildContext context,PostVo post) async{
    _model.deletePostById(_token, post.id!).then((onValue){
      showSuccessScaffold(context, onValue?.message ?? '');
      _postList = List.from(_postList!);
      _postList?.remove(post);
      notifyListeners();
    }).catchError((onError){
      showScaffoldMessage(context, onError.toString());
    });
  }

  Future<void> moreNewsFeed(int categoryId) async{
    if (_isLoadingMore || !_hasMore) return; // Prevents duplicate calls

    _isLoadingMore = true;

    GetRequest request = GetRequest(columnName: "CategoryId", columnCondition: 1, columnValue: categoryId.toString());
    //order by id descending
    _model.getPosts(_token, request,_currentPage,10).then((onValue){

      _postList = List.from(_postList!)..addAll(onValue);
      notifyListeners();
      _currentPage++;
      if (onValue.length < 3) {
        _hasMore = false;
      }
    }).catchError((onError){
      notifyListeners();
    });

    _isLoadingMore = false;
  }
}