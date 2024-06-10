import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pahg_group/data/vos/request_body/add_employee_request.dart';
import 'package:pahg_group/network/api_constants.dart';
import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/companies_vo.dart';
import '../../data/vos/department_vo.dart';
import '../../data/vos/position_vo.dart';
import '../../data/vos/request_body/get_request.dart';
import '../../exception/helper_functions.dart';
import '../../widgets/loading_widget.dart';
import '../providers/auth_provider.dart';

class AddEmployeePage extends StatefulWidget {
  final bool isAdd;
  const AddEmployeePage({super.key, required this.isAdd});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final PahgModel _model = PahgModel();
  String imageUrl = "";
  File? _image;
  String imageUrlForProfile = "";
  List<CompaniesVo> companies = [];
  List<DepartmentVo> departments = [];
  List<PositionVo> positions = [];
  bool isImageSelected = false;
  String _token = '';
  int positionId = 0;
  int companyId = 0;
  int departmentId = 0;
  String? _selectedDepartment;
  String? _selectedCompany;
  String? _selectedPosition;
  String? _emailErrorText;
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _employeeNumberController = TextEditingController();
  final _jdCodeController = TextEditingController();

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

  void addNewUserWithoutImage(){
    _model.addUser(_token, getEmployeeData()).then((value){
      Navigator.of(context).pop();                                              //dismiss loading
      clearTextField();
      setState(() {
        imageUrl = '';
        isImageSelected = false;
        _image = null;
      });
      showSuccessDialog(context, value!.message.toString());
    }).catchError((error){
      Navigator.of(context).pop();                                            //dismiss loading
      showErrorDialog(context,error.toString());
    });
  }

  void addNewUser(){
    showDialog(context: context, barrierDismissible: false,builder: (context) => const LoadingWidget());
    if(isImageSelected){
      _model.uploadImage(_token, _image!).then((response){
        imageUrl = response!.file!;
        addNewUserWithoutImage();
      }).catchError((error){
        Navigator.of(context).pop();                                            //dismiss loading
        showErrorDialog(context, error.toString());
      });
    }else{
      addNewUserWithoutImage();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    _employeeNumberController.dispose();
    _jdCodeController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child : GestureDetector(
                          onTap: () async{
                            ImagePicker imagePicker = ImagePicker();
                            XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                            setState(() {
                              if(file != null){
                                _image = File(file.path);
                                isImageSelected = true;
                              }
                            });
                          },
                          child: (_image == null) ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                imageUrlForProfile,width: 90,height: 90,fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace){
                                  return Image.asset('lib/icons/add_photo.png',width: 90,height: 90,fit: BoxFit.cover);
                                },
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return const Center(
                                    child: SizedBox(height: 90,child: CircularProgressIndicator()),
                                  );
                                },)
                          ) :
                          ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(_image!,width: 90,height: 90,fit: BoxFit.cover,)
                          )
                      )
                  ),
                ),
                const Text('company',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12),),
                Center(
                  child: companyDropDown(),
                ),
                  const SizedBox(height: 20),
                const Text('department',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12),),
                  Center(
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Theme.of(context).colorScheme.onTertiaryContainer),
                        margin: const EdgeInsets.only(top: 5),
                        height: 50,
                        width: MediaQuery.of(context).size.width - 36,
                        child: departments.isEmpty
                            ? const Padding(padding : EdgeInsets.all(14),child: Text('Empty'))
                            : departmentDropdown(),
                      )
                  ),
                const SizedBox(height: 20),
                const Text('position',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12)),
                Center(
                  child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Theme.of(context).colorScheme.onTertiaryContainer),
                      margin: const EdgeInsets.only(top: 5),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 36,
                      child: positions.isEmpty
                          ? const Padding(padding: EdgeInsets.all(14),child: Text('Empty'),)
                          : positionDropdown()
                  ),
                ),
                const SizedBox(height: 20),
                ///name text field
                TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    prefixIcon: const Icon(Icons.person_pin),
                    labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300),
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ///email text field
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300),
                    errorText: _emailErrorText,
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ///employee number text field
                TextField(
                  controller: _employeeNumberController,
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    prefixIcon: const Icon(Icons.person_pin),
                    labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300),
                    labelText: 'Employee Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                ///employee number text field
                TextField(
                  controller: _jdCodeController,
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    prefixIcon: const Icon(Icons.person_pin),
                    labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300),
                    labelText: 'JD Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ///cancel and save button
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
                    (widget.isAdd)
                        ? ElevatedButton(style: ElevatedButton.styleFrom(
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 18),
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: (){
                            if(validateInput()){
                              addNewUser();
                            }
                          },
                          child: const Text(' Save ',style: TextStyle(color: Colors.white),))
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 18),
                            backgroundColor: Colors.orange,
                          ),
                          onPressed: (){
                            if(validateInput()){

                            }
                          },
                          child: const Text('Update' ,style: TextStyle(color: Colors.white),)
                    )
                  ],
                ),
                const SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget companyDropDown(){
    return Container(
      margin: const EdgeInsets.only(top: 5),
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
            positionId = position.id ?? 0;
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

  AddEmployeeRequest getEmployeeData(){
    return AddEmployeeRequest(
        autoGenerate,
        4,
        defaultPassword,
        _emailController.text.toString(),
        autoGenerate,
        true,
        true,
        autoGenerate,
        _userNameController.text.toString(),
        imageUrl,
        companyId,
        departmentId,
        positionId,
        _employeeNumberController.text.toString(),
        _jdCodeController.text.toString()
    );
  }

  void clearTextField(){
    imageUrl = '';
    _userNameController.clear();
    _emailController.clear();
    _employeeNumberController.clear();
    _jdCodeController.clear();
  }

  bool validateInput() {
    if(_emailController.text.toString().isEmpty){
      setState(() {
         _emailErrorText = "Email is required";
      });
      return false;
    }else{
      setState(() {
        _emailErrorText = null;
      });
    }
    if(_userNameController.text.isEmpty){
      showErrorDialog(context, 'Name is required');
      return false;
    }
    if(companyId == 0){
      showErrorDialog(context, 'Check your company');
      return false;
    }
    if(departmentId == 0){
      showErrorDialog(context, 'Check your department');
      return false;
    }
    if(positionId == 0){
      showErrorDialog(context, 'Check your position');
      return false;
    }
    return true;
  }
}
