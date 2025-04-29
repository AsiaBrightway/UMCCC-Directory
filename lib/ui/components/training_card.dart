
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:pahg_group/data/vos/request_body/add_training_request.dart';
import 'package:pahg_group/data/vos/training_vo.dart';
import 'package:pahg_group/dialog/training_dialog.dart';
import 'package:pahg_group/utils/utils.dart';

import '../../utils/size_config.dart';
import '../pages/image_details_page.dart';

class TrainingCard extends StatefulWidget {
  final TrainingVo training;
  final String token;
  final int userRole;
  final Function(AddTrainingRequest training) onUpdate;
  final Function(int trainingId) updateImage;
  final Function(String name,int trainingId) onDelete;
  const TrainingCard({super.key,required this.token, required this.userRole, required this.onDelete, required this.onUpdate, required this.training, required this.updateImage});

  @override
  State<TrainingCard> createState() => _TrainingCardState();
}

class _TrainingCardState extends State<TrainingCard> {
  bool _isExpanded = true;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _updateTraining(AddTrainingRequest updatedTraining){
    widget.onUpdate(updatedTraining);
  }

  String _trainingTypeName(int type){
    switch(type){
      case 1:
        return "Internal";
      case 2:
        return "External";
      default:
        return "_";
    }
  }

  String _trainingResult(int result){
    switch(result){
      case 1:
        return "Pass";
      case 2:
        return "Not Pass";
      default:
        return "_";
    }
  }

  String _certificateName(bool isHave){
    switch(isHave){
      case true:
        return "ရှိ";
      case false:
        return "မရှိ";
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
                  ///course title
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text("${widget.training.courseName}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),)),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text("Type: ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey,fontFamily: 'DMSans')),
                            ),
                            Expanded(
                                child: Text(_trainingTypeName(widget.training.trainingType ?? 0),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),)
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Provided By: ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey)),
                            Expanded(
                                child: Text("${widget.training.trainingProvidedBy}",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15))
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(Utils.getFormattedDate(widget.training.startDate),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: Text("To",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                            ),
                            Text(Utils.getFormattedDate(widget.training.endDate),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Place: ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey,fontFamily: 'DMSans'),),
                            Expanded(
                                child: Text("${widget.training.place}",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15))
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Time : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey,fontFamily: 'DMSans'),),
                            Text(widget.training.totalTrainingTime ?? '',style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Result : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey,fontFamily: 'DMSans'),),
                            Text(_trainingResult(widget.training.trainingResult ?? 0),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Note: ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey,fontFamily: 'DMSans')),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("${widget.training.note}",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Certificate: ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey,fontFamily: 'DMSans'),),

                            Text(_certificateName(widget.training.certificate ?? false),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
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
                                  imageUrl: widget.training.getImageWithBaseUrl(),
                                  height: SizeConfig.blockSizeVertical * 12,
                                  width: SizeConfig.blockSizeHorizontal * 30,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, error, stackTrace) {
                                    return Container(
                                        color: Colors.grey.shade900,
                                        child: const Center(child: Text(
                                          "Add Image", style: TextStyle(fontFamily: 'DMSans',
                                            color: Colors.white),)));
                                  },
                                ),
                            closedColor: Colors.black12,
                            openBuilder: (context, action) =>
                                ImageDetailsPage(
                                imageUrl: widget.training.getImageWithBaseUrl()),
                          ),
                          if(widget.userRole == 1)
                            GestureDetector(
                                onTap: () {
                                  widget.updateImage(widget.training.id!);
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
                            Card(
                              child: TextButton.icon(
                                  onPressed: () {
                                    showTrainingDialog(context,training: widget.training,onUpdate: _updateTraining);
                                  },
                                  icon: const Icon(Icons.edit,color: Colors.orange,),
                                  label: const Text('Edit')),
                            ),
                            Card(
                              child: TextButton.icon(
                                  onPressed: () {
                                    widget.onDelete(widget.training.courseName!,widget.training.id!);
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
