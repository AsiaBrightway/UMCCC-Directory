import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/facility_assign_bloc.dart';
import 'package:pahg_group/data/vos/facility_assign_vo.dart';
import 'package:pahg_group/ui/pages/add_facility_assign_page.dart';
import 'package:pahg_group/ui/shimmer/facility_shimmer.dart';
import 'package:pahg_group/utils/utils.dart';
import 'package:pahg_group/widgets/error_employee_widget.dart';
import 'package:provider/provider.dart';
import '../components/empty_data_widget.dart';
import '../providers/auth_provider.dart';

class FacilityAssignPage extends StatefulWidget {
  final int userRole;
  final String empId;
  const FacilityAssignPage({super.key, required this.empId, required this.userRole});

  @override
  State<FacilityAssignPage> createState() => _FacilityAssignPageState();
}

class _FacilityAssignPageState extends State<FacilityAssignPage> {

  String _token = '';
  String _currentUserId = '';

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _navigateToEditPage(bool isAdd,FacilityAssignBloc bloc) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFacilityAssignPage(empId: widget.empId, isAdd: true)),
    );
    if (result == true) {
      // Data has been updated, refresh the data
      bloc.getFacilityByEmployeeId();
    }
  }

  void _onDelete(int id,FacilityAssignBloc bloc){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: const Text('Are you sure to delete?',style: TextStyle(fontSize: 16),),
          actions: [
            TextButton(
              child: const Text("cancel"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                bloc.deleteFacilityAssign(context, id);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _initializeData() async{
    final authModel = context.read<AuthProvider>();
    _token = authModel.token;
    _currentUserId = authModel.userId;
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FacilityAssignBloc(_token,widget.empId,_currentUserId,false,null),
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
            ? Consumer<FacilityAssignBloc>(
              builder: (BuildContext context, FacilityAssignBloc value, Widget? child) {
                var bloc = context.read<FacilityAssignBloc>();
                return FloatingActionButton.extended(
                  onPressed: () {
                    _navigateToEditPage(true,bloc);
                  },
                  backgroundColor: Colors.orangeAccent,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Facility'),
                );
              },
            )
            : null,
        body: DefaultTabController(
          length: (widget.userRole != 4) ? 3: 2,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.blue.shade900,
                  unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                  indicatorColor: Colors.blue,
                  tabs: [
                     const Tab(
                      text: "Assign",
                    ),
                    const Tab(
                      text: "Pending",
                    ),
                    if(widget.userRole != 4)
                      const Tab(text: "Returned"),
                  ],
                ),
              ),
              Expanded(child: TabBarView(
                children: [
                  Selector<FacilityAssignBloc,FacilityState>(
                    selector: (context,bloc) => bloc.facilityState,
                    builder: (context,facilityState,_){
                      var bloc = context.read<FacilityAssignBloc>();
                      if(facilityState == FacilityState.error){
                        return ErrorEmployeeWidget(
                            errorEmployee: bloc.errorMessage,
                            tryAgain: (){
                              bloc.getFacilityByEmployeeId();
                            });
                      }
                      else if(facilityState == FacilityState.success){
                        return Selector<FacilityAssignBloc,List<FacilityAssignVo>>(
                          selector: (context,bloc) => bloc.facilityAssignList ?? [],
                          builder: (context,facilityAssignmentList,_){
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // const Padding(
                                    //   padding: EdgeInsets.all(8.0),
                                    //   child: Text('ပေးအပ်ထားသော ပစ္စည်းများ'),
                                    // ),
                                    (facilityAssignmentList.isNotEmpty)
                                        ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: facilityAssignmentList.map((assign) {
                                            return FacilityCard(userRole: widget.userRole,facilityassign: assign,onDelete: _onDelete,);
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
                        );
                      }
                      else{
                        return const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FacilityShimmer(),
                          ],
                        );
                      }
                    },
                  ),
                  Selector<FacilityAssignBloc,List<FacilityAssignVo>>(
                    selector: (context,bloc) => bloc.pendingList ?? [],
                    builder: (context,pendingList,_){
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (pendingList.isNotEmpty)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: pendingList.map((assign) {
                                            return FacilityCard(userRole: widget.userRole,facilityassign: assign,onDelete: _onDelete,);
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
                  if(widget.userRole != 4)
                    Selector<FacilityAssignBloc,List<FacilityAssignVo>>(
                      selector: (context,bloc) => bloc.returnList ?? [],
                      builder: (context,returnedList,_){
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                (returnedList.isNotEmpty)
                                    ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: returnedList.map((assign) {
                                            return FacilityCard(userRole: widget.userRole,facilityassign: assign,onDelete: _onDelete,);
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
                ],
              ))
            ],
          )
        ),
      ),
    );
  }
}

class FacilityCard extends StatefulWidget {
  const FacilityCard({super.key, required this.userRole , required this.facilityassign, required this.onDelete});
  final int userRole;
  final FacilityAssignVo facilityassign;
  final Function(int,FacilityAssignBloc) onDelete;

  @override
  State<FacilityCard> createState() => _FacilityCardState();
}

class _FacilityCardState extends State<FacilityCard> {
  bool _isExpanded = false;

  Future<void> _navigateToEditPage(bool isAdd,FacilityAssignBloc bloc) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFacilityAssignPage(empId: widget.facilityassign.employeeId!, isAdd: isAdd,assignVo: widget.facilityassign,)),
    );
    if (result == true) {
      // Data has been updated, refresh the data
      bloc.getFacilityByEmployeeId();
    }
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<FacilityAssignBloc>();
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
                if(widget.facilityassign.returnStatus == 'false')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: const Text('Pending',style: TextStyle(fontSize: 8),),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0,bottom: 10,right: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(widget.facilityassign.facilityName ?? '',style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'))
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Assigned Date : ",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w200,fontSize: 13,fontFamily: 'DMSans')),

                            Text(Utils.getFormattedDate(widget.facilityassign.assignedDate),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Description : ",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w300,fontSize: 13,fontFamily: 'DMSans'),),

                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.facilityassign.description ?? '',style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                              ],
                            )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text("Status : ",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w300,fontSize: 13,fontFamily: 'DMSans'),),
                            ),

                            Expanded(child: Text(widget.facilityassign.status ?? '',style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15))),
                          ],
                        ),
                      ),
                      if(widget.facilityassign.returnStatus == "true")
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              const Text("Return reason: ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13),),

                              Expanded(child: Text(widget.facilityassign.returnReason ?? '',style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15))),
                            ],
                          ),
                        ),
                      if(widget.facilityassign.returnStatus == "true")
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              const Text("Return Date: ",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),

                              Expanded(child: Text(Utils.getFormattedDate(widget.facilityassign.returnedDate),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15))),
                            ],
                          ),
                        ),
                      (widget.userRole == 1)
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ///edit assign
                              Card(
                                child: TextButton.icon(
                                    onPressed: () {
                                      _navigateToEditPage(false, bloc);
                                    },
                                    icon: const Icon(Icons.edit,color: Colors.orange,),
                                    label: const Text('Edit')),
                              ),
                              ///delete assign
                              Card(
                                child: TextButton.icon(
                                    onPressed: () {
                                      widget.onDelete(widget.facilityassign.id!,bloc);
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
