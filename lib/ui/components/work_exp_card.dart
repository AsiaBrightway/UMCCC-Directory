import 'package:flutter/material.dart';
import 'package:pahg_group/utils/utils.dart';


import '../../data/vos/request_body/add_work_request.dart';
import '../../data/vos/work_vo.dart';
import '../../dialog/work_dialog.dart';

class WorkExpCard extends StatefulWidget {
  const WorkExpCard({super.key, required this.work, required this.token, required this.userRole, required this.onUpdate, required this.onDelete});
  final WorkVo work;
  final String token;
  final int userRole;
  final Function(AddWorkRequest training) onUpdate;
  final Function(String name,int trainingId) onDelete;
  @override
  State<WorkExpCard> createState() => _WorkExpCardState();
}

class _WorkExpCardState extends State<WorkExpCard> {
  bool _isExpanded = false;
  String? fromDate;
  String? toDate;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _updateWork(AddWorkRequest updatedWork){
    widget.onUpdate(updatedWork);
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
                      Expanded(child: Text("${widget.work.companyName}",style: const TextStyle(fontSize: 16,fontFamily: 'Ubuntu'),)),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Rank : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey,fontFamily: 'DMSans')),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${widget.work.rank}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu')),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Salary : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey,fontFamily: 'DMSans'),),

                            Text("${widget.work.salaryAndAllowance}",style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Responsibilities : ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13,color: Colors.blueGrey,fontFamily: 'DMSans'),),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${widget.work.detailResponsibilities}",style: const TextStyle(fontSize: 14)),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(Utils.getFormattedDate(widget.work.fromDate),style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                              child: Text("To",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                            ),
                            Expanded(child: Text(Utils.getFormattedDate(widget.work.toDate),style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 14))),
                          ],
                        ),
                      ),
                      (widget.userRole == 1)
                          ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ///edit graduate
                            Card(
                              child: TextButton.icon(
                                  onPressed: () {
                                    showWorkDialog(context,work: widget.work, onUpdate: _updateWork);
                                  },
                                  icon: const Icon(Icons.edit,color: Colors.orange,),
                                  label: const Text('Edit')),
                            ),
                            ///delete graduate
                            Card(
                              child: TextButton.icon(
                                  onPressed: () {
                                    widget.onDelete(widget.work.companyName!,widget.work.id!);
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
