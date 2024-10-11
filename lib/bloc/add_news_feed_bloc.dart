
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pahg_group/data/vos/request_body/add_post_request.dart';
import 'package:pahg_group/utils/helper_functions.dart';
import 'package:pahg_group/utils/utils.dart';

import '../data/models/pahg_model.dart';

class AddNewsFeedBloc extends ChangeNotifier{

  final PahgModel _model = PahgModel();
  String _token = "";
  String _postTitle = "";
  String _postContent = "";
  String? _featureImage;
  File? _image;
  String? _errorTitle;
  String? _errorContent;

  String? get errorTitle => _errorTitle;
  String? get errorContent => _errorContent;
  String? get featureImage => _featureImage;
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

  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  void updatePostTitle(String value) {
    _postTitle = value;
  }

  AddNewsFeedBloc(String apiKey){
    _token = apiKey;
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
          }).catchError((onError) {
            // Show error message if adding post fails
            showScaffoldMessage(context, onError.toString());
            Navigator.of(context).pop();
          });
        }).catchError((error) {
          // Show error message if image upload fails
          showScaffoldMessage(context, error.toString());
        });
      }
      // If no image was selected, just create the post
      else {
        AddPostRequest request = AddPostRequest(0, _postTitle, _postTitle, null,_postContent,categoryId,Utils.getCurrentDateTime(),false, null, null, null, null,);

        _model.addPost(_token, request).then((value) {
          // Show success message
          showSuccessScaffold(context, value?.message ?? 'Post added successfully');
          Navigator.of(context).pop();
        }).catchError((onError) {
          // Show error message if adding post fails
          showScaffoldMessage(context, onError.toString());
        });
      }
    }
}