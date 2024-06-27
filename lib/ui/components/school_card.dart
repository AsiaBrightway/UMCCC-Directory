import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/education_school_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_school_request.dart';
import 'package:pahg_group/exception/helper_functions.dart';
import 'package:pahg_group/ui/components/update_school_dialog.dart';
import 'package:pahg_group/ui/themes/colors.dart';

import '../../data/models/pahg_model.dart';

class SchoolCard extends StatefulWidget {
  final EducationSchoolVo school;
  final String token;
  final int userRole;
  final Function(String name,int schoolId) onDelete;
  const SchoolCard({super.key, required this.school, required this.token, required this.userRole, required this.onDelete});

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> {
  bool _isExpanded = true;
  bool editMode = true;
  final PahgModel _model = PahgModel();

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _updateSchool(AddSchoolRequest updateSchool){
    _model.updateSchool(widget.token,updateSchool.id!, updateSchool).then((response){
      //showSuccessDialog(context, response!.message.toString());
    }).catchError((error){
      showErrorDialog(context, error.toString());
    });
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
                  padding: const EdgeInsets.only(top: 4.0,bottom: 10,right: 6),
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
                            Text("${widget.school.fromDate}",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: Text("To",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                            ),
                            Text("${widget.school.toDate}",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Secondary: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),

                            Text("${widget.school.secondary}",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Maximum Achievements: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),

                            Expanded(child: Text("${widget.school.maximumAchievement}",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13))),
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
