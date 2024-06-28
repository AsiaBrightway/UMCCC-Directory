import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/graduate_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_graduate_request.dart';
import 'package:pahg_group/dialog/graduate_dialog.dart';
import 'package:pahg_group/ui/themes/colors.dart';

class GraduateCard extends StatefulWidget {
  final GraduateVo graduate;
  final String token;
  final int userRole;
  final Function(AddGraduateRequest school) onUpdate;
  final Function(String name,int graduateId) onDelete;
  const GraduateCard({super.key, required this.token, required this.userRole, required this.onDelete, required this.onUpdate, required this.graduate});

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
                      Text("${widget.graduate.university}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),),
                      const Icon(Icons.keyboard_arrow_down,size: 20,)
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
                          const Text("Type : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),
                          Text("${widget.graduate.degreeType}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Year : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),

                            Text("${widget.graduate.receivedYear}",style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      (widget.userRole == 1)
                          ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ///edit graduate
                            IconButton(onPressed: (){
                              showGraduateDialog(context, graduate: widget.graduate,onSave: _updateGraduate);
                            }, icon: const Icon(Icons.edit,color: colorAccent)
                            ),
                            IconButton(onPressed: (){
                              widget.onDelete(widget.graduate.university!,widget.graduate.id!);
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
