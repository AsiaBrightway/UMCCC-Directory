
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pahg_group/bloc/add_news_feed_bloc.dart';
import 'package:pahg_group/data/vos/post_vo.dart';
import 'package:provider/provider.dart';

import '../../utils/helper_functions.dart';
import '../../utils/image_compress.dart';

class AddNewsFeedPage extends StatefulWidget {
  final String token;
  final int categoryId;
  final PostVo? post;
  const AddNewsFeedPage({super.key,this.post, required this.categoryId, required this.token});

  @override
  State<AddNewsFeedPage> createState() => _AddNewsFeedPageState();
}

class _AddNewsFeedPageState extends State<AddNewsFeedPage> {

  void _onBackPressed() {
    Navigator.pop(context,false);
  }

  Future<void> selectImage(ImageSource source,AddNewsFeedBloc bloc) async{
    //Create an instance of ImagePicker
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      compressAndGetFile(File(file.path), file.path,48)
          .then((onValue){
        File? compressFile = onValue;
        if(compressFile != null){
          bloc.image = compressFile;
        }
      }).catchError((onError){
        showScaffoldMessage(context, onError.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewsFeedBloc(widget.token,widget.post),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              (widget.post != null)
                  ? 'Update Post'
                  : 'Create Post',
              style: const TextStyle(fontFamily: 'Ubuntu')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _onBackPressed,
          ),
          actions: [
            Selector<AddNewsFeedBloc,bool>(
              selector: (context,bloc) => bloc.addLoading,
              builder: (context, addLoading, _) {
                  var bloc = context.read<AddNewsFeedBloc>();
                  if(addLoading){
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: Colors.orangeAccent),
                    );
                  }
                  if(widget.post == null ){
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 6),
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6), // Adjust corner radius here
                            ),
                          ),
                          onPressed: () {
                            bloc.addPost(context, widget.categoryId);
                          },
                          child: const Text('POST',style: TextStyle(color: Colors.white))),
                    );
                  }
                  else{
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 6),
                            backgroundColor: Colors.orangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6), // Adjust corner radius here
                            ),
                          ),
                          onPressed: () {
                            bloc.updatePost(context, widget.categoryId);
                          },
                          child: const Text('UPDATE',style: TextStyle(color: Colors.white))),
                    );
                  }
            },)
          ],
        ),
        body: SingleChildScrollView(
          child: Consumer<AddNewsFeedBloc>(
            builder: (context,bloc,child){
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                    child: TextField(
                      controller: TextEditingController(text: bloc.postTitle),
                      onChanged: (value) => bloc.updatePostTitle(value),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          errorText: bloc.errorTitle,
                          border: InputBorder.none,
                          hintText: 'Please enter post title',
                          labelStyle: const TextStyle(fontWeight: FontWeight.w300),
                          floatingLabelBehavior: FloatingLabelBehavior.always
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: TextEditingController(text: bloc.postContent),
                      onChanged: (value) => bloc.postContent = value,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          errorText: bloc.errorContent,
                          hintText: 'What\'s on your mind?',
                          labelStyle: const TextStyle(fontWeight: FontWeight.w300),
                          floatingLabelBehavior: FloatingLabelBehavior.always
                      ),
                    ),
                  ),
                  (bloc.featureImageIsForUpdate == null)
                      ? Selector<AddNewsFeedBloc,File?>(
                          selector: (context,bloc) => bloc.image,
                          builder: (context,image,_){
                            if(image != null){
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 6,vertical: 8),
                                    child: ClipRRect(
                                      child: Image.file(
                                        image,
                                        width: MediaQuery.of(context).size.width * 0.96,
                                        height: MediaQuery.of(context).size.height * 0.3,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: (){
                                        bloc.deleteImage();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.cancel,size: 30,color: Colors.grey),
                                      )
                                  )
                                ],
                              );
                            }else{
                              return const SizedBox(height: 1);
                            }
                          }
                      )
                      : Selector<AddNewsFeedBloc,String?>(
                          selector: (context,bloc) => bloc.featureImageIsForUpdate,
                          builder: (context,featureUpdateImage,_){
                            if(featureUpdateImage != null){
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 6,vertical: 8),
                                    child: ClipRRect(
                                      child: Image.network(widget.post!.getImageWithBaseUrl()),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: (){
                                        bloc.deleteUpdateImage();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.cancel,size: 30,color: Colors.grey),
                                      )
                                  )
                                ],
                              );
                            }else{
                              return const SizedBox(height: 1);
                            }
                          })
                ],
              );
            },
          ),
        ),

        bottomNavigationBar: Consumer<AddNewsFeedBloc>(
          builder: (context,bloc,child){
            return BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0, // Add margin around FloatingActionButton
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // Space the icons equally
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: () {
                      selectImage(ImageSource.gallery, bloc);
                    },
                  ),
                  const SizedBox(width: 40), //
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      selectImage(ImageSource.camera, bloc);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
