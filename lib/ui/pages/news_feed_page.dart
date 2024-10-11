import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/add_news_feed_bloc.dart';
import 'package:pahg_group/bloc/news_feed_bloc.dart';
import 'package:pahg_group/data/vos/post_vo.dart';
import 'package:pahg_group/ui/pages/add_news_feed_page.dart';
import 'package:pahg_group/ui/shimmer/home_shimmer.dart';
import 'package:pahg_group/utils/utils.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewsFeedBloc>(
      create: (context) => NewsFeedBloc(_token, widget.categoryId),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          centerTitle: true,
          title: Text(widget.categoryName,style: TextStyle(color: Colors.white),),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed: _onBackPressed,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.green.shade200
              ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewsFeedPage(categoryId: widget.categoryId,token: _token,)));
                },
                child: const Row(
                  children: [
                    Icon(Icons.add_circle),
                    Text('Post')
                  ],
                ))
          ],
        ),
        body: Selector<NewsFeedBloc,List<PostVo>?>(
          selector: (context,bloc) => bloc.postList,
          builder: (context,postList,_){
            if(postList == null || postList.isEmpty){
              return const HomeShimmer();
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
                child: ListView.builder(
                  itemCount: postList.length,
                  itemBuilder: (context, index) {
                    return NewsFeedCard(postVo: postList[index]);
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

class NewsFeedCard extends StatelessWidget {
  final PostVo postVo;

  const NewsFeedCard({super.key, required this.postVo});

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
                        'assets/pahg_logo.png',
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
                        Utils.timeAgo(postVo.createdDate ?? ''),
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
              const Icon(Icons.more_horiz_outlined),
            ],
          ),
        ),
        const SizedBox(height: 4),
        /// title text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            postVo.postTitle ?? '',
            style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
          ),
        ),
        /// feature image
        if(postVo.featureImageUrl != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6,vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                postVo.featureImageUrl ?? '',
                width: MediaQuery.of(context).size.width * 0.96,
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.cover,
              ),
            ),
          ),
        /// content text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ExpandableText(
            text: postVo.postContent ?? 'To implement expandable and collapsible text in your news feed, you can use a custom widget that manages the expanded and collapsed states. Here’s how you can achieve this:',
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



