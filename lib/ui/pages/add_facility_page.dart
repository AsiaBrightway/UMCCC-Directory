import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/add_facility_bloc.dart';
import 'package:pahg_group/data/vos/facility_vo.dart';
import 'package:provider/provider.dart';
import '../components/custom_text_field.dart';
import '../providers/auth_provider.dart';

class AddFacilityPage extends StatefulWidget {
  const AddFacilityPage({super.key, required this.isAdd});
  final bool isAdd;

  @override
  State<AddFacilityPage> createState() => _AddFacilityPageState();
}

class _AddFacilityPageState extends State<AddFacilityPage> {
  String _token = '';
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _userId = authModel.userId;
    _token = authModel.token;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddFacilityBloc(_token,_userId),
      child: Scaffold(
        body: Selector<AddFacilityBloc,List<FacilityVo>>(
          selector: (context,bloc) => bloc.facilityList ?? [],
          builder: (BuildContext context, List<FacilityVo> value, Widget? child) {

            var bloc = context.read<AddFacilityBloc>();
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(widget.isAdd
                          ? "Add Facility"
                          : "Edit Facility",
                          style: const TextStyle(fontSize: 18,fontFamily: 'Ubuntu',fontWeight: FontWeight.w400)),
                    ),
                    if(!widget.isAdd)
                      Selector<AddFacilityBloc,int?>(
                          selector: (context,bloc) => bloc.selectedId,
                          builder: (context,selectedId,_){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text('Select item to edit',style: TextStyle(fontFamily: 'DMSans'),),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10,bottom: 8),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width - 36,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      value: selectedId,
                                      hint: const Text('Select Parent', style: TextStyle(fontSize: 14)),
                                      items: bloc.facilityList?.map((FacilityVo value) {
                                        return DropdownMenuItem<int>(
                                          value: value.id,
                                          child: Text(value.facilityName ?? '', style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600)),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        bloc.setSelectedId(newValue!);
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        height: 40,
                                        width: 140,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                      ),
                    const SizedBox(height: 10,),
                    Selector<AddFacilityBloc,int?>(
                        selector: (context,bloc) => bloc.selectedId,
                        builder: (context,selectedId,_){
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: CustomTextField(
                                  controller: TextEditingController(text: bloc.facilityName),
                                  labelText: 'Facility Name',
                                  onChange: (value) => bloc.setFacilityName = value,
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
                              Selector<AddFacilityBloc,bool>(
                                selector: (context,bloc) => bloc.statusCondition ?? true,
                                builder: (context,gender,_){
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
                                    child: ButtonBar(
                                      alignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Text('Valid',style: TextStyle(fontFamily: 'DMSans'),),
                                        Radio(
                                          value: true,
                                          groupValue: gender,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value){
                                            bloc.statusCondition = value!;
                                          },
                                        ),
                                        const Text('Invalid',style: TextStyle(fontFamily: 'DMSans')),
                                        Radio(
                                          value: false,
                                          groupValue: gender,
                                          activeColor: Colors.red,
                                          onChanged: (bool? value){
                                            bloc.statusCondition = value!;
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          );
                        },
                    ),
                    const SizedBox(height: 8),
                    Selector<AddFacilityBloc,bool>(
                      selector: (context,bloc) => bloc.isLoading,
                      builder: (context,isLoading,_){
                        if(isLoading){
                          return const Center(child: CircularProgressIndicator());
                        }else{
                          return Row(
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
                              const SizedBox(width: 20),
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
                                      bloc.addFacility(context);
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
                                    bloc.updateFacility(context);
                                  },
                                  child: const Text(
                                    'Update',
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          );
                        }
                      },
                    )
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
