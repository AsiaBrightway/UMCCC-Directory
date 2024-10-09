
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';

import '../data/models/pahg_model.dart';
import '../data/vos/post_vo.dart';

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

  List<PostVo>? get postList => _postList;
  NewsFeedState get newsFeedState => _newsFeedState;
  String? get errorMessage => _errorMessage;

  ///Constructor
  NewsFeedBloc(String token,int categoryId){
    _token = token;
    getNewsFeed(categoryId);
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  Future<void> getNewsFeed(int categoryId) async{
    _newsFeedState = NewsFeedState.loading;
    notifyListeners();
    GetRequest request = GetRequest(columnName: "CategoryId", columnCondition: 1, columnValue: categoryId.toString());
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

  Future<void> moreNewsFeed(int categoryId) async{
    if (_isLoadingMore || !_hasMore) return; // Prevents duplicate calls

    _isLoadingMore = true;

    GetRequest request = GetRequest(columnName: "CategoryId", columnCondition: 1, columnValue: categoryId.toString());
    //order by id descending
    _model.getPosts(_token, request,_currentPage,2).then((onValue){
      if (_currentPage == 1) {
        // For the first page, replace the list
        _postList = onValue;
      } else {
        // For subsequent pages, append to the list
        _postList?.addAll(onValue);
      }

      if (onValue.length < 2) {
        _hasMore = false;
      }
      notifyListeners();
    }).catchError((onError){

    });

    _isLoadingMore = false;
    notifyListeners();
  }
}