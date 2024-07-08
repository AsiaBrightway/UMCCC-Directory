
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/ui/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/companies_vo.dart';
import '../../data/vos/department_vo.dart';
import '../../data/vos/position_vo.dart';
import '../../data/vos/request_body/get_request.dart';
import '../../exception/helper_functions.dart';
import '../../widgets/loading_widget.dart';

class AddPositionPage extends StatefulWidget {
  final bool isAdd;
  const AddPositionPage({super.key, required this.isAdd});

  @override
  State<AddPositionPage> createState() => _AddPositionPageState();
}

class _AddPositionPageState extends State<AddPositionPage> {
  final PahgModel _model = PahgModel();
  List<CompaniesVo> companies = [];
  List<DepartmentVo> departments = [];
  List<PositionVo> positions = [];
  final _positionController = TextEditingController();
  String? _positionErrorText;
  String _token = '';
  int positionId = 0;
  int companyId = 0;
  int departmentId = 0;
  String? _selectedDepartment;
  String? _selectedCompany;
  String? _selectedPosition;
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

  void updatePosition(){
    showDialog(context: context, barrierDismissible: false,builder: (context) => const LoadingWidget());
    _model.updatePosition(_token,positionId, departmentId, _positionController.text.toString(), _isActive).then((response){
      Navigator.of(context).pop();                                              //dismiss loading
      _positionController.clear();
      setState(() {
        _selectedPosition = null;
        positions.clear();
      });
      showSuccessScaffold(context, response?.message ?? "Success");
    }).catchError((error){
      Navigator.of(context).pop();
      showErrorDialog(context, error.toString());
    });
  }

  void createPosition(){
    showDialog(context: context, barrierDismissible: false,builder: (context) => const LoadingWidget());
    _model.addPosition(_token, departmentId, _positionController.text.toString(), _isActive).then((response){
      Navigator.of(context).pop();                                              //dismiss loading
      _positionController.clear();
      showSuccessScaffold(context, response?.message ?? "Success");
    }).catchError((error){
      showErrorDialog(context, error.toString());
    });
  }

  void getDepartmentList(int companyId){
    var request = GetRequest(columnName: 'CompanyId', columnCondition: 1, columnValue: companyId.toString());
    _model.getDepartmentListByCompany(_token, request).then((response){
      setState(() {
        departments.clear();
        departments = response;
      });
    }).catchError((error){
      showErrorDialog(context, error.toString());
    });
  }

  ///clear position id when the position list is empty.
  void getPositionList(int deptId){
    _model.getPositions(_token, 'DepartmentId', deptId.toString()).then((response){
      setState(() {
        positions.clear();
        positionId = 0;
        positions = response;
      });
    }).catchError((error){
      showErrorDialog(context, error.toString());
    });
  }

  @override
  void dispose() {
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: (widget.isAdd)
                ? const Text('Add Position',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400))
                : const Text('Edit Position' ,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),)
                ),
                const SizedBox(height: 40,),
                const Text('Company',style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.w300),),
                Center(
                  child: companyDropDown(),
                ),
                const SizedBox(height: 20),
                const Text('Department',style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.w300)),
                Center(
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Theme.of(context).colorScheme.onTertiaryContainer),
                      margin: const EdgeInsets.only(top: 10),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 36,
                      child: departments.isEmpty
                          ? const Padding(padding : EdgeInsets.all(14),child: Text('Empty'))
                          : departmentDropdown(),
                    )
                ),
                const SizedBox(height: 20),
                (widget.isAdd == false)
                    ? const Text('Position',style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.w300))
                    : const SizedBox(height: 1),
                Center(
                  child: (widget.isAdd)
                      ? const SizedBox(height: 2,)
                      :Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Theme.of(context).colorScheme.onTertiaryContainer),
                    margin: const EdgeInsets.only(top: 10),
                    height: 50,
                    width: MediaQuery.of(context).size.width - 36,
                    child: positions.isEmpty
                        ? const Padding(padding: EdgeInsets.all(14),child: Text('Empty'),)
                        : positionDropdown()
                  ),
                ),
                const SizedBox(height: 26,),
                ///when the text in the text field is updated, which causes the entire widget tree, including the FutureBuilder
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextFormField(
                    style: const TextStyle(fontSize: 18),
                    controller: _positionController,
                    cursorColor: Colors.deepOrange,
                    decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
                      labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300),
                      labelText: 'Add Position Name',
                      errorText: _positionErrorText,
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
                ///is active checkbox
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
                const SizedBox(height: 20,),
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
                    const SizedBox(width: 20,),
                    (widget.isAdd) ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.14,vertical: 18),
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: (){
                          if(validateInput()){
                            createPosition();
                          }
                        },
                        child: const Text(' Save ',style: TextStyle(color: Colors.white),)
                    ) : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.14,vertical: 18),
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: (){
                          if(validateInput()){
                            updatePosition();
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
      ),
    );
  }

  Widget companyDropDown(){
    return Container(
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
            ///Company item select လုပ်တိုင်း error မတက်အောင် dept list ကို clear လုပ်
            ///selectedDepartment ကို null ပြန်‌ပေးရတယ်။
            setState(() {
              _selectedCompany = newValue!;
              CompaniesVo company = companies.firstWhere((company) => company.companyName == newValue);
              companyId = company.id ?? 0;
              _selectedDepartment = null;
              getDepartmentList(companyId);
              _selectedPosition = null;
              _positionController.text = '';
              positions.clear();
              departments.clear();
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
    );
  }

  Widget departmentDropdown(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        value: _selectedDepartment,
        hint: const Text(
          'Choose Department',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        items: departments.map((DepartmentVo value) {
          return DropdownMenuItem<String>(
            value: value.departmentName,
            child: Text(value.departmentName ?? '',style: TextStyle(
                overflow: TextOverflow.ellipsis,color: Theme.of(context).colorScheme.onSurface
            ),),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedDepartment = newValue!;
            DepartmentVo department = departments.firstWhere((company) => company.departmentName == newValue);
            positions.clear();
            _selectedPosition = null;
            departmentId = department.id ?? 0;
            getPositionList(departmentId);
            _positionController.text = '';
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
    );
  }

  Widget positionDropdown(){
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        value: _selectedPosition,
        hint: const Text(
          'Choose Position',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        items: positions.map((PositionVo value) {
          return DropdownMenuItem<String>(
            value: value.position,
            child: Text(value.position ?? '',style: TextStyle(
                overflow: TextOverflow.ellipsis,color: Theme.of(context).colorScheme.onSurface
            ),),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedPosition = newValue!;
            PositionVo position = positions.firstWhere((position) => position.position == newValue);
            _positionController.text = newValue;
            positionId = position.id ?? 0;
            _isActive = position.isActive!;
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
    );
  }

  bool validateInput() {
    if(_positionController.text.toString().isEmpty){
      setState(() {
        _positionErrorText = "Position Name is required";
      });
      return false;
    }else{
      setState(() {
        _positionErrorText = null;
      });
    }
    return true;
  }
}
