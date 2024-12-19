import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/utils/utils.dart';


import '../../data/vos/graduate_vo.dart';
import '../../data/vos/request_body/add_graduate_request.dart';
import '../../dialog/graduate_dialog.dart';
import '../../utils/size_config.dart';
import '../pages/image_details_page.dart';

class GraduateCard extends StatefulWidget {
  final GraduateVo graduate;
  final String token;
  final int userRole;
  final Function(int graduateId) onUpdateImage;
  final Function(AddGraduateRequest school) onUpdate;
  final Function(String name,int graduateId) onDelete;
  const GraduateCard({super.key, required this.token, required this.userRole, required this.onDelete, required this.onUpdate, required this.graduate, required this.onUpdateImage});

  @override
  State<GraduateCard> createState() => _GraduateCardState();
}

class _GraduateCardState extends State<GraduateCard> {
  bool _isExpanded = true;
  bool editMode = true;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _updateGraduate(AddGraduateRequest updatedSchool){
    ///handle network update in fragment
    widget.onUpdate(updatedSchool);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 4,top: 8,bottom: 8),
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
                  padding: const EdgeInsets.only(top: 4.0,bottom: 10,right: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text("${widget.graduate.university}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),)
                      ),
                      (_isExpanded)
                          ? const Icon(Icons.keyboard_arrow_up,size: 20)
                          : const Icon(Icons.keyboard_arrow_down,size: 20)
                    ],
                  ),
                ),
                if(_isExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Type : ",style: TextStyle(fontFamily: 'DMSans',color: Colors.blueGrey,fontWeight: FontWeight.w300,fontSize: 13),),
                          Text("${widget.graduate.degreeType}",style: const TextStyle(fontSize: 14,fontFamily: 'Ubuntu'),),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Year : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey,fontFamily: 'DMSans'),),

                            Text(Utils.getFormattedDate(widget.graduate.receivedYear),style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          OpenContainer(
                            closedBuilder: (context, action) =>
                                CachedNetworkImage(
                                  //todo
                                  imageUrl: widget.graduate.getImageWithBaseUrl(),
                                  height: SizeConfig.blockSizeVertical * 12,
                                  width: SizeConfig.blockSizeHorizontal * 30,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, error, stackTrace) {
                                    return Container(
                                        color: Colors.black12,
                                        child: const Center(child: Text(
                                          "Add Image", style: TextStyle(fontFamily: 'DMSans', color: Colors.white),)));
                                  },
                                ),
                            closedColor: Colors.black12,
                            openBuilder: (context, action) =>
                                ImageDetailsPage(
                                imageUrl: widget.graduate.getImageWithBaseUrl()),
                          ),
                          if(widget.userRole == 1)
                            GestureDetector(
                                onTap: () {
                                  widget.onUpdateImage(widget.graduate.id!);
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
                            ///edit graduate
                            Card(
                              child: TextButton.icon(
                                  onPressed: () {
                                    showGraduateDialog(context, graduate: widget.graduate,onSave: _updateGraduate);
                                  },
                                  icon: const Icon(Icons.edit,color: Colors.orange,),
                                  label: const Text('Edit')),
                            ),
                            Card(
                              child: TextButton.icon(
                                  onPressed: () {
                                    widget.onDelete(widget.graduate.university!,widget.graduate.id!);
                                  },
                                  icon: const Icon(Icons.delete,color: Colors.red,),
                                  label: const Text('Delete')),
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
