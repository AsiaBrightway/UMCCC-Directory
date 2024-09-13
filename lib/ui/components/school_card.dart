
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/vos/education_school_vo.dart';
import '../../data/vos/request_body/add_school_request.dart';
import '../../dialog/update_school_dialog.dart';
import '../../utils/size_config.dart';
import '../pages/image_details_page.dart';
import '../themes/colors.dart';

class SchoolCard extends StatefulWidget {
  final EducationSchoolVo school;
  final String token;
  final int userRole;
  final Function(AddSchoolRequest school) onUpdate;
  final Function(int schoolId) updateImage;
  final Function(String name,int schoolId) onDelete;
  const SchoolCard({super.key, required this.school, required this.token, required this.userRole, required this.onDelete, required this.onUpdate, required this.updateImage});

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> {
  bool _isExpanded = true;
  bool editMode = true;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _updateSchool(AddSchoolRequest updatedSchool){
    widget.onUpdate(updatedSchool);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: _toggleExpanded,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4,top: 4.0,bottom: 10,right: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.school.name}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),),
                      const Icon(Icons.keyboard_arrow_down,size: 20,)
                    ],
                  ),
                ),
                if(_isExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text("${widget.school.fromDate}",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: Text("To",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                            ),
                            Text("${widget.school.toDate}",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Secondary: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13)),

                            Text("${widget.school.secondary}",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Achievements: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),

                            Expanded(child: Text("${widget.school.maximumAchievement}",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Subjects: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),

                            Text("${widget.school.subjects}",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ///crack logic
                          OpenContainer(
                            closedBuilder: (context, action) =>
                                CachedNetworkImage(
                                  //todo
                                  imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWJfFCJV-vv9n31dyGa5SQbK7gYflNb-7ClHI55banTVjaxoxMWhrJmO0uqPFe6Da6wv4&usqp=CAU",
                                  height: SizeConfig.blockSizeVertical * 12,
                                  width: SizeConfig.blockSizeHorizontal * 30,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, error, stackTrace) {
                                    return Container(
                                        color: Colors.black12,
                                        child: const Center(child: Text(
                                          "Add Image", style: TextStyle(
                                            color: Colors.white),)));
                                  },
                                ),
                            closedColor: Colors.black12,
                            openBuilder: (context, action) =>
                            const ImageDetailsPage(
                                imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWJfFCJV-vv9n31dyGa5SQbK7gYflNb-7ClHI55banTVjaxoxMWhrJmO0uqPFe6Da6wv4&usqp=CAU"),
                          ),
                          GestureDetector(
                              onTap: () {
                                widget.updateImage(widget.school.id!);
                              },
                              child: Image.asset(
                                "lib/icons/add_camera.png",
                                width: 30,
                                height: 30,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                      (widget.userRole == 1)
                          ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){
                              showSchoolDialog(context,school:  widget.school,onSave:  _updateSchool);
                              }, icon: const Icon(Icons.edit,color: colorAccent)
                            ),
                            IconButton(onPressed: (){
                              widget.onDelete(widget.school.name!,widget.school.id!);
                            }, icon: const Icon(Icons.delete,color: colorAccent)
                            ),
                          ]
                      )
                          : const SizedBox(height: 1)
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
