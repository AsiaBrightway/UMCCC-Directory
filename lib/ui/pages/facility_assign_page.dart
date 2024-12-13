import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/facility_assign_bloc.dart';
import 'package:pahg_group/data/vos/facility_assign_vo.dart';
import 'package:pahg_group/data/vos/work_vo.dart';
import 'package:pahg_group/ui/pages/add_facility_assign_page.dart';
import 'package:pahg_group/utils/utils.dart';
import 'package:provider/provider.dart';

import '../components/empty_data_widget.dart';
import '../providers/auth_provider.dart';
import '../themes/colors.dart';

class FacilityAssignPage extends StatefulWidget {
  final int userRole;
  final String empId;
  const FacilityAssignPage({super.key, required this.empId, required this.userRole});

  @override
  State<FacilityAssignPage> createState() => _FacilityAssignPageState();
}

class _FacilityAssignPageState extends State<FacilityAssignPage> {

  String _token = '';

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async{
    final authModel = context.read<AuthProvider>();
    _token = authModel.token;
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FacilityAssignBloc(_token,widget.empId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Facility',style: TextStyle(fontFamily: 'Ubuntu',color: Colors.white)),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.blue.shade800,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white),
            onPressed: _onBackPressed
          ),
        ),
        floatingActionButton: (widget.userRole == 1)
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddFacilityAssignPage(empId: widget.empId),));
                },
                backgroundColor: Colors.orangeAccent,
                icon: const Icon(Icons.add),
                label: const Text('Add Facility'),
              )
            : null,
        body: Selector<FacilityAssignBloc,List<FacilityAssignVo>>(
          selector: (context,bloc) => bloc.facilityAssignList ?? [],
          builder: (context,facilityAssignmentList,_){
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (facilityAssignmentList.isNotEmpty)
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                                children: facilityAssignmentList.map((assign) {
                                  return FacilityCard(userRole: widget.userRole,facilityassign: assign);
                                }).toList(),
                              ),
                          ],
                        )
                        : const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: EmptyDataWidget()
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FacilityCard extends StatefulWidget {
  const FacilityCard({super.key, required this.userRole , required this.facilityassign});
  final int userRole;
  final FacilityAssignVo facilityassign;

  @override
  State<FacilityCard> createState() => _FacilityCardState();
}

class _FacilityCardState extends State<FacilityCard> {
  bool _isExpanded = true;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
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
                      Expanded(
                          child: Text(widget.facilityassign.facilityName ?? '',style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'))
                      ),
                      const Icon(Icons.keyboard_arrow_down,size: 20)
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
                            const Text("Assigned Date: ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),

                            Text(Utils.getFormattedDate(widget.facilityassign.assignedDate) ?? '',style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Description: ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),

                            Expanded(child: Text(widget.facilityassign.description ?? '',style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Status: ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),

                            Expanded(child: Text(widget.facilityassign.status ?? '',style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15))),
                          ],
                        ),
                      ),
                      (widget.userRole == 1)
                          ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){
                              //todo
                            }, icon: const Icon(Icons.edit,color: colorAccent)
                            ),
                            IconButton(onPressed: (){
                              //todo
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
