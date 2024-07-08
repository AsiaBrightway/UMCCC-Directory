import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/family_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_family_request.dart';
import 'package:pahg_group/dialog/family_dialog.dart';

import '../themes/colors.dart';

class FamilyCard extends StatefulWidget {
  const FamilyCard({super.key, required this.token, required this.userRole, required this.onUpdate, required this.onDelete, required this.family});
  final FamilyVo family;
  final String token;
  final int userRole;
  final Function(AddFamilyRequest training) onUpdate;
  final Function(String name,int familyId) onDelete;
  @override
  State<FamilyCard> createState() => _FamilyCardState();
}

class _FamilyCardState extends State<FamilyCard> {
  bool _isExpanded = true;
  String? fromDate;
  String? toDate;
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _updateFamily(AddFamilyRequest updatedFamily){
    widget.onUpdate(updatedFamily);
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
                      Text("${widget.family.name}",style: const TextStyle(fontSize: 16,fontFamily: 'Ubuntu'),),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Relationship : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),
                            Text("${widget.family.relationship}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Identity Number : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),
                            Text("${widget.family.identityNumber}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Rank : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),
                            Text("${widget.family.rank}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Date of Birth : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),

                            Text("${widget.family.dateOfBirth}",style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Employment : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),
                            Text("${widget.family.employment}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Race : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),

                            Text("${widget.family.race}",style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      (widget.userRole == 1)
                          ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ///edit graduate
                            IconButton(onPressed: (){
                              showFamilyDialog(context,family: widget.family, onUpdate: _updateFamily);
                            }, icon: const Icon(Icons.edit,color: colorAccent)
                            ),
                            IconButton(onPressed: (){
                              widget.onDelete(widget.family.name!,widget.family.id!);
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
