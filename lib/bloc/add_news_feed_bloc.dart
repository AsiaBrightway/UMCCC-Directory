
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pahg_group/data/vos/post_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_post_request.dart';
import 'package:pahg_group/utils/helper_functions.dart';
import 'package:pahg_group/utils/utils.dart';

import '../data/models/pahg_model.dart';

class AddNewsFeedBloc extends ChangeNotifier{

  final PahgModel _model = PahgModel();
  String _token = "";
  String _postTitle = "";
  String _postContent = "";
  String? _featureImageIsForUpdate;
  File? _image;
  String? _errorTitle;
  String? _errorContent;
  int? _postId;

  String? get errorTitle => _errorTitle;
  String? get errorContent => _errorContent;
  String? get featureImageIsForUpdate => _featureImageIsForUpdate;
  String get postContent => _postContent;
  String get postTitle => _postTitle;
  File? get image => _image;

  set postContent(String value) {
    _postContent = value;
  }

  void deleteImage(){
    _image = null;
    notifyListeners();
  }

  void deleteUpdateImage(){
    _featureImageIsForUpdate = null;
    notifyListeners();
  }

  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  void updatePostTitle(String value) {
    _postTitle = value;
  }

  AddNewsFeedBloc(String apiKey,PostVo? post){
    _token = apiKey;
    if(post != null){
       _postId = post.id!;
      _postTitle = post.postTitle!;
      _postContent = post.postContent ?? '';
      _featureImageIsForUpdate = post.featureImageUrl;
      notifyListeners();
    }
  }

  Future<void> updatePost(BuildContext context,int categoryId) async{
    // Validate title and content first
    if (_postTitle.isEmpty) {
      _errorTitle = "Title is required";
    } else {
      _errorTitle = null;
    }

    if (_postContent.isEmpty) {
      _errorContent = "Content is required";
    } else {
      _errorContent = null;
    }
    notifyListeners();

    // Stop if there are validation errors
    if (_errorTitle != null || _errorContent != null) {
      return; // Prevent further execution if validation fails
    }

    if (_image != null) {
      _model.uploadImage(_token, image!).then((onValue) {
        // Proceed to create post after image upload
        AddPostRequest request = AddPostRequest(_postId, _postTitle, _postTitle, onValue?.file, _postContent, categoryId, Utils.getCurrentDateTime(), false, null, null, null, null,);

        _model.updatePost(_token,_postId!, request).then((value) {
          // Show success message
          showSuccessScaffold(context, value?.message ?? 'Post updated successfully');
          Navigator.pop(context,true);
        }).catchError((onError) {
          // Show error message if adding post fails
          showScaffoldMessage(context, onError.toString());
        });
      }).catchError((error) {
        // Show error message if image upload fails
        showScaffoldMessage(context, error.toString());
      });
    }
    // If no image was selected, just create the post.I use featureImage because it can be already exit in update state
    else {
      AddPostRequest request = AddPostRequest(_postId, _postTitle, _postTitle, _featureImageIsForUpdate,_postContent,categoryId,Utils.getCurrentDateTime(),false, null, null, null, null,);

      _model.updatePost(_token, _postId!,request).then((value) {
        // Show success message
        showSuccessScaffold(context, value?.message ?? 'Post updated successfully');
        Navigator.pop(context,true);
      }).catchError((onError) {
        // Show error message if adding post fails
        showScaffoldMessage(context, onError.toString());
      });
    }
  }

  Future<void> addPost(BuildContext context,int categoryId) async{
      // Validate title and content first
      if (_postTitle.isEmpty) {
        _errorTitle = "Title is required";
      } else {
        _errorTitle = null;
      }

      if (_postContent.isEmpty) {
        _errorContent = "Content is required";
      } else {
        _errorContent = null;
      }
      notifyListeners();

      // Stop if there are validation errors
      if (_errorTitle != null || _errorContent != null) {
        return; // Prevent further execution if validation fails
      }

      // If image is selected, upload the image first
      if (_image != null) {
        _model.uploadImage(_token, image!).then((onValue) {
          // Proceed to create post after image upload
          AddPostRequest request = AddPostRequest(0, _postTitle, _postTitle, onValue?.file, _postContent, categoryId, Utils.getCurrentDateTime(), false, null, null, null, null,);

          _model.addPost(_token, request).then((value) {
            // Show success message
            showSuccessScaffold(context, value?.message ?? 'Post added successfully');
            Navigator.pop(context,true);
          }).catchError((onError) {
            // Show error message if adding post fails
            showScaffoldMessage(context, onError.toString());
          });
        }).catchError((error) {
          // Show error message if image upload fails
          showScaffoldMessage(context, error.toString());
        });
      }
      // If no image was selected, just create the post.I use featureImage because it can be already exit in update state
      else {
        AddPostRequest request = AddPostRequest(0, _postTitle, _postTitle, _featureImageIsForUpdate,_postContent,categoryId,Utils.getCurrentDateTime(),false, null, null, null, null,);

        _model.addPost(_token, request).then((value) {
          // Show success message
          showSuccessScaffold(context, value?.message ?? 'Post added successfully');
          Navigator.pop(context,true);
        }).catchError((onError) {
          // Show error message if adding post fails
          showScaffoldMessage(context, onError.toString());
        });
      }
    }
}