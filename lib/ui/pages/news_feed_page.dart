import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/news_feed_bloc.dart';
import 'package:pahg_group/data/vos/post_vo.dart';
import 'package:pahg_group/ui/pages/add_news_feed_page.dart';
import 'package:pahg_group/ui/shimmer/news_feed_shimmer.dart';
import 'package:pahg_group/utils/utils.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'image_details_page.dart';

class NewsFeedPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  const NewsFeedPage({super.key, required this.categoryId, required this.categoryName});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {

  String _token = "";
  int _userRole = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  Future<void> _initializeData() async {
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _userRole = authModel.role;
  }

  Future<void> callPostsAfterAdd(NewsFeedBloc bloc) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewsFeedPage(categoryId:widget.categoryId,token: _token)));
    if (result == true) {
      // Data has been updated, refresh the data
      bloc.getNewsFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewsFeedBloc>(
      create: (context) => NewsFeedBloc(_token, widget.categoryId),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          centerTitle: true,
          title: Text(widget.categoryName,style: const TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed: _onBackPressed,
          ),
          actions: [
            if(_userRole == 1)
              Selector<NewsFeedBloc,NewsFeedState>(
                selector: (context,bloc) => bloc.newsFeedState,
                builder: (context,newsFeedState,_){
                  var bloc = context.read<NewsFeedBloc>();
                  return TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.green.shade200
                      ),
                      onPressed: (){
                        callPostsAfterAdd(bloc);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle),
                          SizedBox(width: 2),
                          Text('NEW')
                        ],
                      )
                  );
                },
              )
          ],
        ),
        body: Selector<NewsFeedBloc,List<PostVo>?>(
          selector: (context,bloc) => bloc.postList,
          builder: (context,postList,_){
            if(postList == null){
              return const NewsFeedShimmer();
            }
            else if(postList.isEmpty){
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('lib/icons/no_data_empty.png',width: 200,height: 200,fit: BoxFit.cover,),
                      const Text('Empty')
                    ],
                  ),
              );
            }
            else {
              var bloc = context.read<NewsFeedBloc>();
              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification &&
                      scrollNotification.metrics.extentAfter == 0) {
                    // When the user scrolls to the bottom, load more posts
                    bloc.moreNewsFeed(widget.categoryId);
                  }
                  return false;
                },
                child: ListView. builder(
                  itemCount: postList.length,
                  itemBuilder: (context, index) {
                    return NewsFeedCard(postVo: postList[index],categoryId: widget.categoryId,token: _token,role: _userRole,);
                  },
                )
              );
            }
          },
        ),
      ),
    );
  }
}

class NewsFeedCard extends StatefulWidget {
  final PostVo postVo;
  final String token;
  final int role;
  final int categoryId;
  const NewsFeedCard({super.key, required this.postVo, required this.token, required this.categoryId, required this.role});

  @override
  State<NewsFeedCard> createState() => _NewsFeedCardState();
}

class _NewsFeedCardState extends State<NewsFeedCard> {

  Future<void> onTapEdit(PostVo post) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewsFeedPage(categoryId:widget.categoryId,token: widget.token,post: post)));
    if (result == true) {
      // Data has been updated, refresh the data
      var bloc = context.read<NewsFeedBloc>();
      bloc.getNewsFeed();
    }
  }

  Future<void> onTapDelete() async{
    var bloc = context.read<NewsFeedBloc>();
    bloc.deletePost(context, widget.postVo);
    Navigator.pop(context);
  }

  void _onDeleteDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          icon: const Text("Delete post",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          content: const Text('Are you sure to delete?',style: TextStyle(fontSize: 16),),
          actions: [
            TextButton(
              child: const Text("cancel"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () async{
                onTapDelete();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showPickerDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit,color: Colors.orangeAccent,),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context,false);
                  onTapEdit(widget.postVo);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete,color: Colors.redAccent,),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context,false);
                  _onDeleteDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/umcccumccc_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),  // Add spacing between image and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'P A H G',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        Utils.timeAgo(widget.postVo.createdDate ?? ''),
                        style: const TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if(widget.role == 1)
                IconButton(
                    onPressed: (){
                      showPickerDialog(context);
                    },
                    icon: const Icon(Icons.more_horiz_outlined)
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        /// title text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            widget.postVo.postTitle ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
          ),
        ),
        /// feature image
        if(widget.postVo.featureImageUrl != null)
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OpenContainer(
                  closedBuilder:(context,action) => CachedNetworkImage(
                    imageUrl: widget.postVo.getImageWithBaseUrl(),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.96,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width:  MediaQuery.of(context).size.width * 0.96,
                          color: Colors.black12,
                          child: const Center(child: Text("Front Image")));
                    },
                  ),
                  closedColor: Colors.black12,
                  openBuilder: (context,action) =>
                      ImageDetailsPage(imageUrl: widget.postVo.getImageWithBaseUrl()),
                ),
              )
          ),
        /// content text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ExpandableText(
            text: widget.postVo.postContent ?? '',
            trimLines: 2,
          ),
        ),
        const SizedBox(height: 8),
        /// this is grey line
        Container(
            color: Colors.grey,
            height: 4
        )
      ],
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;

  const ExpandableText({super.key, required this.text, this.trimLines = 2});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        // Create a text span for calculating text height
        final span = TextSpan(text: widget.text);
        final tp = TextPainter(
          text: span,
          maxLines: widget.trimLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: size.maxWidth);

        // Check if the text overflows
        final isOverflowing = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display text with conditions for overflow or full text
            Text(
              widget.text,
              maxLines: _isExpanded ? null : widget.trimLines,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),

            // Show 'See More' or 'See Less' based on the state
            if (isOverflowing)
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'See Less' : 'See More',
                  style: const TextStyle(color: Colors.blue,fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        );
      },
    );
  }
}



