
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/companies_vo.dart';
import 'package:pahg_group/ui/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../exception/helper_functions.dart';
import '../../widgets/loading_widget.dart';

class AddDepartmentPage extends StatefulWidget {
  final bool isAdd;
  const AddDepartmentPage({super.key,required this.isAdd});

  @override
  State<AddDepartmentPage> createState() => _AddDepartmentPageState();
}

class _AddDepartmentPageState extends State<AddDepartmentPage> {
  final PahgModel _model = PahgModel();
  List<CompaniesVo> companies = [];
  final _departmentController = TextEditingController();
  String? _departmentErrorText;
  String _token = '';
  int companyId = 0;
  String? _selectedCompany;
  bool _isActive = true;

  @override
  void didChangeDependencies() {
    final authModel = Provider.of<AuthProvider>(context);
    _token = authModel.token;
      _model.getAllCompanies(_token).then((companies){
        setState(() {
          this.companies = companies;
        });
      }).catchError((error){
        showErrorDialog(context, error.toString());
      });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _departmentController.dispose();
    super.dispose();
  }

  void createDepartment() async{
    showDialog(context: context, barrierDismissible: false,builder: (context) => const LoadingWidget());
    Future.delayed(Duration(seconds: 2));
    _model.addDepartment(_token, companyId, _departmentController.text.toString(), _isActive).then((response){
      Navigator.of(context).pop();                                              //dismiss loading
      _departmentController.clear();
      showSuccessDialog(context, response!.message.toString());
    }).catchError((error){
      Navigator.of(context).pop();                                              //dismiss loading
      showErrorDialog(context, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30,),
              const Center(child: Text('Add Department',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400))),
              const SizedBox(height: 40,),
              const Text('Company',style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.w300),),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 50,
                  width: MediaQuery.of(context).size.width - 36,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      value: _selectedCompany,
                      hint: const Text(
                        'Choose Company',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      items: companies.map((CompaniesVo value) {
                        return DropdownMenuItem<String>(
                          value: value.companyName,
                          child: Text(value.companyName ?? '',style: TextStyle(
                              overflow: TextOverflow.ellipsis,color: Theme.of(context).colorScheme.onSurface
                          ),),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCompany = newValue!;
                          CompaniesVo company = companies.firstWhere((company) => company.companyName == newValue);
                          companyId = company.id ?? 0;
                        });
                      },
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                        scrollbarTheme: const ScrollbarThemeData(
                          radius: Radius.circular(20),
                        ),
                      ),
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
                      iconStyleData: IconStyleData(
                        icon: const Icon(
                          Icons.keyboard_arrow_down_sharp,
                        ),
                        iconSize: 22,
                        iconEnabledColor: Colors.green[700],
                        iconDisabledColor: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              ///Department text field
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextFormField(
                  style: const TextStyle(fontSize: 18),
                  controller: _departmentController,
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
                    labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300),
                    labelText: 'Add Department Name',
                    errorText: _departmentErrorText,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.redAccent), // Bottom border color when focused
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isActive,
                      activeColor: Colors.green,
                      onChanged: (value){
                        setState(() {
                          _isActive = value!;
                        });
                      },
                    ),
                    const Text("isActive",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,fontFamily: 'Roboto'),),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 18),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')),
                  const SizedBox(width: 20,),
                  (widget.isAdd) ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 18),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: (){
                        if(validateInput()){
                          createDepartment();
                        }
                      },
                      child: const Text(' Save ',style: TextStyle(color: Colors.white),)
                  ) : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 18),
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: (){
                        if(validateInput()){
                         // updateCompany();
                        }
                      },
                      child: const Text('Update' ,style: TextStyle(color: Colors.white),)
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateInput() {
    if(_departmentController.text.toString().isEmpty){
      setState(() {
        _departmentErrorText = "Company Name is required";
      });
      return false;
    }else{
      setState(() {
        _departmentErrorText = null;
      });
    }
    return true;
  }
}
