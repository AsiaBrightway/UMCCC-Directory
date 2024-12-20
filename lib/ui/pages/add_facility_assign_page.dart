import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/facility_assign_bloc.dart';
import 'package:pahg_group/data/vos/facility_assign_vo.dart';
import 'package:provider/provider.dart';
import '../../data/vos/facility_vo.dart';
import '../../utils/utils.dart';
import '../components/custom_text_field.dart';
import '../providers/auth_provider.dart';

class AddFacilityAssignPage extends StatefulWidget {
  final bool isAdd;
  final String empId;
  final FacilityAssignVo? assignVo;
  const AddFacilityAssignPage({super.key, required this.empId, required this.isAdd,this.assignVo});

  @override
  State<AddFacilityAssignPage> createState() => _AddFacilityAssignPageState();
}

class _AddFacilityAssignPageState extends State<AddFacilityAssignPage> {

  String _currentUserId = '';
  String _token = '';

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

  ///error code
  void handleOptionSelected(FacilityVo item,FacilityAssignBloc bloc) {
    bloc.selectedItem = item;
  }

  Future<void> _selectDate(BuildContext context,FacilityAssignBloc bloc) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      bloc.assignedDate = picked.toString();
    }
  }

  Future<void> _selectReturnedDate(BuildContext context,FacilityAssignBloc bloc) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      bloc.returnedDate = picked.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(context) => FacilityAssignBloc(_token,widget.empId,_currentUserId,true,widget.assignVo),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isAdd
                ? 'Add Facility Assign'
                : 'Update Facility Assign',
            style: const TextStyle(fontFamily: 'Ubuntu',color: Colors.white),
          ),
          backgroundColor: Colors.blue.shade800,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white),

              onPressed: _onBackPressed
          ),
        ),
        body: SingleChildScrollView(
          child: Selector<FacilityAssignBloc,FacilityVo?>(
            selector: (context,bloc) => bloc.selectedItem,
            builder: (context,selectedItem,_){
              var bloc = context.read<FacilityAssignBloc>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(widget.isAdd)
                    const Padding(
                      padding: EdgeInsets.only(left: 35,top: 16),
                      child: Text(
                        "Select Facility",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,fontFamily: 'DMSans'),
                      ),
                    ),
                  ///show item list widget in add state
                  if(widget.isAdd)
                    GestureDetector(
                      onTap: (){
                        showFacilityItemDialog(context,handleOptionSelected);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 35,vertical: 14),
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceBright,
                            borderRadius: BorderRadius.circular(6)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Selector<FacilityAssignBloc,FacilityVo?>(
                                selector: (context, bloc) => bloc.selectedItem,
                                builder: (context, item, _) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: (item != null)
                                        ? Text(item.facilityName ?? '')
                                        : const Text('Items',style: TextStyle(fontSize: 13,color: Colors.grey,fontFamily: 'DMSans')),
                                  );
                                }),
                            const Icon(Icons.arrow_drop_down_sharp)
                          ],
                        ),
                      ),
                    ),
                  if(!widget.isAdd)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18,vertical: 8),
                          child: Text('Facility Name',style: TextStyle(fontFamily: 'DMSans',fontWeight: FontWeight.w400,fontSize: 12)),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              border: Border.all(color: Colors.grey.shade600),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(widget.assignVo?.facilityName ?? '',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 15),
                          )
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18,vertical: 8),
                        child: Text('Description of the selected item',style: TextStyle(fontFamily: 'DMSans',fontSize: 12)),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        border: Border.all(color: Colors.grey.shade600),
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: (widget.assignVo == null)
                        ? Text(selectedItem?.description ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 15),
                          )
                        : Text(widget.assignVo!.description ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 15),
                          ),
                  ),
                  ///assign date
                  Selector<FacilityAssignBloc,String?>(
                    selector: (context,bloc) => bloc.assignedDate,
                    builder: (context,assignedDate,_){
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
                                      const Text('Pick Assigned Date',style: TextStyle(fontFamily : 'DMSans',fontSize: 15,fontWeight: FontWeight.w300),),
                                      Text(Utils.getFormattedDate(assignedDate),style: const TextStyle(fontFamily: 'Ubuntu'),)
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
                  ///return date
                  if(!widget.isAdd)
                    Selector<FacilityAssignBloc,String?>(
                    selector: (context,bloc) => bloc.returnedDate,
                    builder: (context,returnedDate,_){
                      return GestureDetector(
                        onTap: (){
                          _selectReturnedDate(context, bloc);
                        },
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              margin: const EdgeInsets.symmetric(vertical: 4,horizontal: 18),
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
                                        child: const Icon(Icons.date_range_rounded,color: Color.fromRGBO(
                                            234, 148, 110, 1.0),)),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Pick Returned Date',style: TextStyle(fontFamily : 'DMSans',fontSize: 15,fontWeight: FontWeight.w300),),
                                      Text(Utils.getFormattedDate(returnedDate),style: const TextStyle(fontFamily: 'Ubuntu'),)
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
                  if(!widget.isAdd)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomTextField(
                        controller: TextEditingController(text: bloc.returnReason),
                        labelText: 'Return Reason',
                        onChange: (value) => bloc.returnReason = value,
                        readOnly: 1,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  if(!widget.isAdd)
                    Selector<FacilityAssignBloc,String?>(
                      selector: (context,bloc) => bloc.returnStatus,
                      builder: (context,returnedStatus,_){
                        returnedStatus ??= "null";
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
                          child: Row(
                            children: [
                              Radio(
                                value: 'null',
                                groupValue: returnedStatus,
                                activeColor: Colors.blue,
                                onChanged: (String? value){
                                  bloc.returnStatus = value!;
                                },
                              ),
                              const Text('Assign',style: TextStyle(fontFamily: 'DMSans'),),
                              Radio(
                                value: 'false',
                                groupValue: returnedStatus,
                                activeColor: Colors.orange,
                                onChanged: (String? value){
                                  bloc.returnStatus = value!;
                                },
                              ),
                              const Text('Pending',style: TextStyle(fontFamily: 'DMSans')),
                              Radio(
                                value: 'true',
                                groupValue: returnedStatus,
                                activeColor: Colors.red,
                                onChanged: (String? value){
                                  bloc.returnStatus = value!;
                                },
                              ),
                              const Text('Returned',style: TextStyle(fontFamily: 'DMSans')),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 32),
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
                              bloc.addFacilityAssign(context);
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
                                bloc.updateFacilityAssign(context);
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                          ))
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void showFacilityItemDialog(BuildContext context,Function(FacilityVo item,FacilityAssignBloc bloc) onOptionSelected) {
    var facilityAssignBloc = context.read<FacilityAssignBloc>();
    var itemList = facilityAssignBloc.itemList ?? [];
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text(
            'Choose One Item',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  final township = itemList[index];
                  return SimpleDialogOption(
                    onPressed: () {
                      onOptionSelected(itemList[index],facilityAssignBloc);
                      Navigator.pop(context);
                    },
                    child: Text(
                      township.facilityName ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
