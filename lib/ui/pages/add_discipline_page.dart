import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/discipline_bloc.dart';
import 'package:pahg_group/data/vos/discipline_vo.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../components/custom_text_field.dart';
import '../providers/auth_provider.dart';

class AddDisciplinePage extends StatefulWidget {
  final bool isAdd;
  final String empId;
  final DisciplineVo? discipline;
  const AddDisciplinePage({super.key, required this.empId, required this.isAdd, this.discipline});

  @override
  State<AddDisciplinePage> createState() => _AddDisciplinePageState();
}

class _AddDisciplinePageState extends State<AddDisciplinePage> {

  String _currentUserId = '';
  String _token = '';

  Future<void> _selectDate(BuildContext context,DisciplineBloc bloc) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      bloc.date = picked.toString();
    }
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

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DisciplineBloc(_token, widget.empId, _currentUserId,widget.discipline),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
            onPressed: _onBackPressed,
          ),
          centerTitle: true,
          title: Text(
              (widget.isAdd)
                  ? "Add Discipline"
                  : "Update Discipline",
              style: const TextStyle(color: Colors.white,fontFamily: 'Ubuntu')),
        ),
        body: Selector<DisciplineBloc,DisciplineVo?>(
          selector: (context,bloc) => bloc.disciplineForUpdate,
          builder: (context,discipline,_){
            var bloc = context.read<DisciplineBloc>();
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomTextField(
                      controller: TextEditingController(text: bloc.type),
                      labelText: 'Discipline Type',
                      onChange: (value) => bloc.type = value,
                      readOnly: 1,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomTextField(
                      controller: TextEditingController(text: bloc.status),
                      labelText: 'Status',
                      onChange: (value) => bloc.status = value,
                      readOnly: 1,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomTextField(
                      controller: TextEditingController(text: bloc.actionTaken),
                      labelText: 'Action Taken By',
                      onChange: (value) => bloc.actionTaken = value,
                      readOnly: 1,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomTextField(
                      controller: TextEditingController(text: bloc.description),
                      labelText: 'Description',
                      onChange: (value) => bloc.description = value,
                      readOnly: 1,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  /// discipline date
                  Selector<DisciplineBloc,String?>(
                    selector: (context,bloc) => bloc.date,
                    builder: (context,date,_){
                      return GestureDetector(
                        onTap: (){
                          _selectDate(context, bloc);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              margin: const EdgeInsets.symmetric(vertical: 16,horizontal: 18),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceBright,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(8), width: 40, height: 40,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surfaceBright,
                                        borderRadius: BorderRadius.circular(24)
                                    ),
                                    child: Card(
                                        color: Theme.of(context).colorScheme.surfaceBright,
                                        child: const Icon(Icons.date_range_rounded)),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Pick Date',style: TextStyle(fontFamily : 'DMSans',fontSize: 15,fontWeight: FontWeight.w300),),
                                      Text(Utils.getFormattedDate(date),style: const TextStyle(fontFamily: 'Ubuntu'),)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  /// cancel and save
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.14,vertical: 18),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel')),
                      const SizedBox(width: 8,),
                      (widget.isAdd)
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                padding: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * 0.14,
                                    vertical: 18),
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                bloc.addDiscipline(context);
                              },
                              child: const Text(
                                ' Save ',
                                style: TextStyle(color: Colors.white),
                              )
                          )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: MediaQuery.of(context).size.width * 0.14,
                                      vertical: 18),
                                  backgroundColor: Colors.orange),
                              onPressed: () {
                                bloc.updateDiscipline(context);
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                          ))
                    ],
                  )
                ],
              ),
            );
          },
        )
      ),
    );
  }
}
