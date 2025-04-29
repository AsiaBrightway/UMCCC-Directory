import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/discipline_bloc.dart';
import 'package:pahg_group/ui/components/empty_data_widget.dart';
import 'package:pahg_group/ui/pages/add_discipline_page.dart';
import 'package:pahg_group/widgets/error_employee_widget.dart';
import 'package:provider/provider.dart';

import '../../data/vos/discipline_vo.dart';
import '../../utils/utils.dart';
import '../providers/auth_provider.dart';
import '../shimmer/facility_shimmer.dart';

class DisciplinePage extends StatefulWidget {
  const DisciplinePage({super.key, required this.userRole, required this.empId});

  final String empId;
  final int userRole;

  @override
  State<DisciplinePage> createState() => _DisciplinePageState();
}

class _DisciplinePageState extends State<DisciplinePage> {

  String _token = '';
  String _currentUserId = '';

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async{
    final authModel = context.read<AuthProvider>();
    _token = authModel.token;
    _currentUserId = authModel.userId;
  }

  Future<void> _navigateToEditPage(bool isAdd,DisciplineBloc bloc) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDisciplinePage(empId: widget.empId,isAdd: true,)),
    );
    if (result == true) {
      // Data has been updated, refresh the data
      bloc.getDisciplineListByEmployee();
    }
  }

  void _onDelete(int id,DisciplineBloc bloc){
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
                bloc.deleteDiscipline(context, id);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DisciplineBloc(_token,widget.empId,_currentUserId,null),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
            onPressed: _onBackPressed,
          ),
          centerTitle: true,
          title: const Text("Discipline",style: TextStyle(color: Colors.white,fontFamily: 'Ubuntu')),
        ),
        floatingActionButton: (widget.userRole == 1)
            ? Consumer<DisciplineBloc>(
                builder: (BuildContext context, DisciplineBloc value, Widget? child){
                  var bloc = context.read<DisciplineBloc>();
                  return FloatingActionButton.extended(
                    onPressed: () {
                      _navigateToEditPage(true, bloc);
                    },
                    backgroundColor: Colors.orangeAccent,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Discipline'),
                  );
                },
            )
            : null,
        body: Selector<DisciplineBloc,DisciplineState>(
          selector: (context,bloc) => bloc.disciplineState,
          builder: (context,disciplineState,_){
            var bloc = context.read<DisciplineBloc>();

            if(disciplineState == DisciplineState.error){
              return Center(
                child: ErrorEmployeeWidget(
                  errorEmployee: bloc.errorMessage ?? '',
                  tryAgain: () {
                    bloc.getDisciplineListByEmployee();
                    },
                ),
              );

            }else if(disciplineState == DisciplineState.success){
              return Selector<DisciplineBloc,List<DisciplineVo>>(
                selector: (context,bloc) => bloc.disciplineList ?? [],
                builder: (context,disciplineList,_){
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (disciplineList.isNotEmpty)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: disciplineList.map((discipline) {
                                        return DisciplineCard(discipline: discipline,userRole: widget.userRole,onDelete: _onDelete);
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
            }else{
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FacilityShimmer(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class DisciplineCard extends StatefulWidget {
  const DisciplineCard({super.key, required this.discipline, required this.userRole, required this.onDelete});
  final DisciplineVo discipline;
  final int userRole;
  final Function(int,DisciplineBloc) onDelete;

  @override
  State<DisciplineCard> createState() => _DisciplineCardState();
}

class _DisciplineCardState extends State<DisciplineCard> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Future<void> _navigateToEditPage(bool isAdd,DisciplineBloc bloc) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDisciplinePage(empId: widget.discipline.employeeId ?? '',isAdd: false,discipline: widget.discipline,)),
    );
    if (result == true) {
      // Data has been updated, refresh the data
      bloc.getDisciplineListByEmployee();
    }
  }

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<DisciplineBloc>();
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
                  padding: const EdgeInsets.only(top: 4.0,bottom: 10,right: 6,left: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(widget.discipline.disciplineType ?? '',style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'))
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Description : ",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w200,fontSize: 13,fontFamily: 'DMSans')),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.discipline.description ?? '',style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 14),
                              child: Text("Date : ",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w200,fontSize: 13,fontFamily: 'DMSans')),
                            ),

                            Text(Utils.getFormattedDate(widget.discipline.disciplineDate),style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0,top: 8,bottom: 8),
                            child: Text("Status : ",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w200,fontSize: 13,fontFamily: 'DMSans')),
                          ),

                          Expanded(
                              child: Text(widget.discipline.status ?? '',style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15))
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Action taken by : ",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w200,fontSize: 13,fontFamily: 'DMSans')),

                            Text(widget.discipline.actionTakenBy ?? '',style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 15)),
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
                                    widget.onDelete(widget.discipline.id!,bloc);
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

