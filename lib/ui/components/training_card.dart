
import 'package:flutter/material.dart';

import 'package:pahg_group/data/vos/request_body/add_training_request.dart';
import 'package:pahg_group/data/vos/training_vo.dart';
import 'package:pahg_group/dialog/training_dialog.dart';
import 'package:pahg_group/ui/themes/colors.dart';

class TrainingCard extends StatefulWidget {
  final TrainingVo training;
  final String token;
  final int userRole;
  final Function(AddTrainingRequest training) onUpdate;
  final Function(String name,int trainingId) onDelete;
  const TrainingCard({super.key,required this.token, required this.userRole, required this.onDelete, required this.onUpdate, required this.training});

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
                      Text("${widget.training.courseName}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),),
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
                            const Text("Type : ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),
                            Text(_trainingTypeName(widget.training.trainingType ?? 0),style: const TextStyle(fontWeight: FontWeight.w300),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Provided by: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13)),

                            Text("${widget.training.trainingProvidedBy}",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text("${widget.training.startDate}",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: Text("To",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                            ),
                            Text("${widget.training.endDate}",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Place: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),

                            Text("${widget.training.place}",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Result : ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),
                            Text(_trainingResult(widget.training.trainingResult ?? 0),style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Note: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),

                            Text("${widget.training.note}",style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Certificate: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),

                            Text(_certificateName(widget.training.certificate ?? false),style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      (widget.userRole == 1)
                          ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){
                              showTrainingDialog(context,training: widget.training,onUpdate: _updateTraining);
                            }, icon: const Icon(Icons.edit,color: colorAccent)
                            ),
                            IconButton(onPressed: (){
                              widget.onDelete(widget.training.courseName!,widget.training.id!);
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
