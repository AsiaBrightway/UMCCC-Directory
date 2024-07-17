
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pahg_group/data/vos/request_body/personal_info_request.dart';
import 'package:pahg_group/exception/helper_functions.dart';
import 'package:pahg_group/ui/components/custom_drop_down_button.dart';
import 'package:pahg_group/ui/pages/family_page.dart';
import 'package:pahg_group/ui/themes/colors.dart';
import 'package:provider/provider.dart';
import '../../data/models/pahg_model.dart';
import '../../data/vos/personal_info_vo.dart';
import '../../widgets/loading_widget.dart';
import '../components/custom_text_field.dart';
import '../providers/auth_provider.dart';

class PersonalInfoPage extends StatefulWidget {
  final String name;
  final int role;
  final String userId;
  const PersonalInfoPage({super.key, required this.name, required this.userId, required this.role});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final PahgModel _model = PahgModel();
  List<PersonalInfoVo> personalInfo = [];
  String _token = '';
  int _currentUserRole = 0;
  int? personalInfoId;
  final Map<int, String> bloodType = {1: 'A', 2: 'B', 3: 'O', 4: 'AB'};
  final Map<int ,String> marriageList = {1: 'Single',2: 'Married',3: 'Divorce',4: 'Widower',5: 'Widow'};
  final Map<int ,String> licenseStatus = {1: 'Not Have',2: 'Have',3: 'Still Applying'};
  final Map<int ,String> licenseType = {1: 'က' ,2: 'ခ',3: 'ဃ'};
  final Map<int ,String> licenseColor = {1: 'Black', 2: 'Red'};
  final _addressController = TextEditingController();
  final _cellularPhoneController = TextEditingController();
  final _homePhoneController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _religionController = TextEditingController();
  final _raceController = TextEditingController();
  final _healthController = TextEditingController();
  final _hairColorController = TextEditingController();
  final _skinColorController = TextEditingController();
  final _eyeColorController = TextEditingController();
  final _emergencyName = TextEditingController();
  final _emergencyRelation = TextEditingController();
  final _emergencyAddress = TextEditingController();
  final _vehiclePunishmentDescription = TextEditingController();
  final _previousAppliedDescription = TextEditingController();
  final _sportsHobbyController = TextEditingController();
  final _socialActivitiesController = TextEditingController();
  final _emergencyCellularPhone = TextEditingController();
  final _emergencyHomePhone = TextEditingController();
  bool _selectedGender = true;
  int _selectedHandUsage = 2;
  int? _selectedBloodType;
  int? _selectedMarry;
  int? _selectedLicenseStatus;
  int? _selectedLicenseType;
  int? _selectedLicenseColor;
  bool _isVehiclePunished = false;
  bool _isPreviousApplied = false;
  bool _isEmergencyExpanded = false;
  bool _isAppearanceExpanded = false;
  bool _isDrivingLicenseExpanded = false;
  int age = 0;
  String _date = '';
  bool editMode = false;
  String bloodTypeName = "";
  String marriageStatusName = "";
  String licenseStatusName = "";
  String licenseTypeName = "";
  String licenseColorName = "";
  String? _addressErrorText;
  bool firstLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _currentUserRole = authModel.role;
    _model.getPersonalInfo(_token,'EmployeeId', widget.userId).then((response){
      setState(() {
        if(response.isEmpty){
          firstLoading = false;
          editMode = true;
        }
        if(response.isNotEmpty){
          firstLoading = false;
          personalInfo = response;
          bindPersonalInfo(personalInfo);
        }
      });
    }).catchError((error){
      setState(() {
        firstLoading = false;
      });
      showErrorRefreshDialog(context, error.toString(), _initializeData);
    });
  }

  void _handleGenderChange(bool? value) {
    setState(() {
      _selectedGender = value!;
    });
  }

  void _handleHandUsage(int? value) {
    setState(() {
      _selectedHandUsage = value!;
    });
  }

  void _updatePersonalInfo(){
    showDialog(context: context, barrierDismissible: false,builder: (context) => const LoadingWidget());
    if(personalInfoId != null){
      _model.updatePersonalInfo(_token,personalInfoId!, getPersonalData()).then((response){
        Navigator.of(context).pop();
        showSuccessScaffold(context, response?.message ?? "Success");
        _initializeData();
      }).catchError((error){
        Navigator.of(context).pop();
        showErrorDialog(context, error.toString());
      });
    }else{
      Navigator.of(context).pop();
      showErrorDialog(context, "Personal Id is null");
    }
  }

  void _addPersonalInfo(){
    showDialog(context: context, barrierDismissible: false,builder: (context) => const LoadingWidget());
    _model.addPersonalInfo(_token, getPersonalData()).then((response){
      Navigator.of(context).pop();
      showSuccessScaffold(context, response?.message ?? "Success");
      _initializeData();
    }).catchError((error){
      Navigator.of(context).pop();
      showErrorDialog(context, error.toString());
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cellularPhoneController.dispose();
    _homePhoneController.dispose();
    _placeOfBirthController.dispose();
    _nationalityController.dispose();
    _religionController.dispose();
    _raceController.dispose();
    _healthController.dispose();
    _sportsHobbyController.dispose();
    _socialActivitiesController.dispose();
    _hairColorController.dispose();
    _skinColorController.dispose();
    _eyeColorController.dispose();
    _emergencyName.dispose();
    _emergencyRelation.dispose();
    _emergencyAddress.dispose();
    _emergencyCellularPhone.dispose();
    _emergencyHomePhone.dispose();
    _vehiclePunishmentDescription.dispose();
    _previousAppliedDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: _onBackPressed,
        ),
        title: const Text('Personal Info',style: TextStyle(color: Colors.white,fontFamily: 'Ubuntu'),),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        actions: [
          (widget.role == 1 )
              ? (personalInfo.isEmpty)
                ? IconButton(onPressed: (){
                  if(validatePersonalInfo()){
                    _addPersonalInfo();
                  }
                  }, icon: const Icon(Icons.save,color: Colors.green,))
                  : (editMode)
                    ? IconButton(onPressed: (){
                      if(validatePersonalInfo()){
                        _updatePersonalInfo();
                      }
                  }, icon: const Icon(Icons.cloud_upload,color: colorAccent,))
                    : const SizedBox(width: 1)
                    : const SizedBox(width: 1),
            (widget.role == 1 && personalInfo.isNotEmpty)
              ? TextButton(onPressed: (){
                setState(() {
                editMode = !editMode;
                  });
                },
                child: (!editMode)
                    ? const Text('Edit',style: TextStyle(color: colorAccent),)
                    : const Text('Undo',style: TextStyle(color: colorAccent))
                )
              : const SizedBox(width: 1)
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: (firstLoading)
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 14,right: 10,top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///address text field
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    border: Border.all(color: Colors.grey.shade600),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: TextField(
                  controller: _addressController,
                  readOnly: widget.role != 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      labelText: 'Address',
                      errorText: _addressErrorText,
                      border: InputBorder.none,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w300),
                      floatingLabelBehavior: FloatingLabelBehavior.always
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    ///cellular is mobile phone
                      child: CustomTextField(controller: _cellularPhoneController,labelText: 'Cellular Phone',readOnly: _currentUserRole,keyboardType: TextInputType.number,)
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(controller: _homePhoneController,labelText: 'Home Phone',readOnly: _currentUserRole,keyboardType: TextInputType.number,),
                  ),
                ],
              ),
              ///date of birth
              GestureDetector(
                onTap: (){
                  if(_currentUserRole == 1){
                    _selectDate(context);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: const EdgeInsets.symmetric(vertical: 10),
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
                        child: const Icon(Icons.date_range),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Date Of Birth',style: TextStyle(fontFamily : 'Ubuntu',fontSize: 15,fontWeight: FontWeight.w300),),
                          Text(_date)
                        ],
                      ),
                      const SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Age',style: TextStyle(fontFamily: 'Ubuntu', fontSize: 15,fontWeight: FontWeight.w300),),
                          Text('$age')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              CustomTextField(controller: _placeOfBirthController, labelText: 'Place of Birth',readOnly: _currentUserRole),
              const SizedBox(height: 10),
              CustomTextField(controller: _nationalityController, labelText: 'Nationality',readOnly: _currentUserRole),
              const SizedBox(height: 10),
              CustomTextField(controller: _religionController, labelText: 'Religion',readOnly: _currentUserRole),
              const SizedBox(height: 10),
              CustomTextField(controller: _raceController, labelText: 'Race',readOnly: _currentUserRole),
              const SizedBox(height: 10),
              CustomTextField(controller: _healthController, labelText: 'Health',readOnly: _currentUserRole),
              const SizedBox(height: 10),
              CustomTextField(controller: _sportsHobbyController, labelText: 'Sports,Hobby',readOnly: _currentUserRole),
              const SizedBox(height: 10),
              CustomTextField(controller: _socialActivitiesController, labelText: 'Social Activities',readOnly: _currentUserRole),
              const SizedBox(height: 10,),
              ///gender radio button
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(stops: const [0.4,1.0], colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade400]) ///////////
                ),
                child: (editMode && _currentUserRole == 1)
                    ? ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text('Gender : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    const Text('Male'),
                    Radio(
                      value: true,
                      groupValue: _selectedGender,
                      activeColor: colorAccent,
                      onChanged: _handleGenderChange,
                    ),
                    const Text('Female'),
                    Radio(
                      value: false,
                      groupValue: _selectedGender,
                      activeColor: colorAccent,
                      onChanged: _handleGenderChange,
                    ),
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Gender :",style: TextStyle(fontFamily: 'Ubuntu',fontSize: 16),),
                    ),
                    (_selectedGender)
                        ? const Text(" Male",style: TextStyle(fontSize: 16))
                        : const Text(" Female",style: TextStyle(fontSize: 16))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ///hand usage radio button
              Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(stops: const [0.4,1.0], colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade400]
                  ),
                ),
                child: (editMode && _currentUserRole == 1)
                    ? ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text('Hand Usage : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    const Text('Left'),
                    Radio(
                      value: 1,
                      groupValue: _selectedHandUsage,
                      activeColor: colorAccent,
                      onChanged: _handleHandUsage,
                    ),
                    const Text('Right'),
                    Radio(
                      value: 2,
                      groupValue: _selectedHandUsage,
                      activeColor: colorAccent,
                      onChanged: _handleHandUsage,
                    ),
                  ],
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Hand Usage :",style: TextStyle(fontFamily: 'Ubuntu',fontSize: 16),),
                    ),
                    (_selectedHandUsage == 2)
                        ? const Text(" Right",style: TextStyle(fontSize: 16),)
                        : const Text(" Left",style: TextStyle(fontSize: 16))
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ///blood type and marriage
              (editMode && _currentUserRole == 1)
                  ? Row(
                children: [
                  Expanded(
                      child: bloodTypeWidget()
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: marriageStatus())
                ],
              )
                  : Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surfaceBright
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Blood Type : $bloodTypeName",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text("Marriage Status : $marriageStatusName",style: const TextStyle(fontSize: 16),)
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ///Appearance
              _buildAppearance(),
              const SizedBox(height: 10),
              _buildEmergencyContact(),
              const SizedBox(height: 20),
              _buildDrivingLicense(),
              const SizedBox(height: 20),
              _buildPreviousApplied(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white
                    ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FamilyPage(empId: widget.userId, userRole: _currentUserRole),));
                      },
                      child: Text("Go To Family"))
                ],
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      )
    );
  }

  Widget _buildEmergencyContact(){
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: const [0.4,1.0],
              colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade400]
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple)
      ),
      padding: const EdgeInsets.symmetric(horizontal:18,vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                _isEmergencyExpanded = !_isEmergencyExpanded;
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Emergency Contact'),
                  IconButton(
                    icon: Icon(_isEmergencyExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _isEmergencyExpanded = !_isEmergencyExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: _isEmergencyExpanded ?  270 : 0.0,
            child: Visibility(
              visible: _isEmergencyExpanded,
              child: AnimatedOpacity(
                opacity: _isEmergencyExpanded ? 1.0 : 0.0,
                curve: Curves.easeInOutBack,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    Expanded(child: CustomTextField(controller: _emergencyName, labelText: 'Name',readOnly: _currentUserRole)),
                    const SizedBox(height: 6,),
                    Expanded(child: CustomTextField(controller: _emergencyRelation, labelText: 'Relation',readOnly: _currentUserRole)),
                    const SizedBox(height: 6,),
                    Expanded(child: CustomTextField(controller: _emergencyAddress, labelText: 'Address',readOnly: _currentUserRole)),
                    const SizedBox(height: 6,),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: CustomTextField(controller: _emergencyCellularPhone,labelText: 'Cellular Phone',readOnly: _currentUserRole,keyboardType: TextInputType.number,)
                          ),
                          const SizedBox(width: 8,),
                          Expanded(
                            child: CustomTextField(controller: _emergencyHomePhone,labelText: 'Home Phone',readOnly: _currentUserRole,keyboardType: TextInputType.number,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearance(){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: const [0.4,1.0],
          colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade400]
        ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple)
      ),
      padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                _isAppearanceExpanded = !_isAppearanceExpanded;
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Appearance',style: TextStyle(fontFamily: 'Ubuntu'),),
                  IconButton(
                    icon: Icon(_isAppearanceExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _isAppearanceExpanded = !_isAppearanceExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            height: _isAppearanceExpanded ? 230 : 0.0,
            duration: const Duration(milliseconds: 400),
            child: Visibility(
              visible: _isAppearanceExpanded,
              child: AnimatedOpacity(
                opacity: _isAppearanceExpanded ? 1.0 : 0.0,
                curve: Curves.easeInOutBack,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    Expanded(child: CustomTextField(controller: _hairColorController, labelText: 'Hair Color',readOnly: _currentUserRole)),
                    const SizedBox(height: 6,),
                    Expanded(child: CustomTextField(controller: _skinColorController, labelText: 'Skin Color',readOnly: _currentUserRole)),
                    const SizedBox(height: 6,),
                    Expanded(child: CustomTextField(controller: _eyeColorController, labelText: 'Eye Color',readOnly: _currentUserRole))
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildDrivingLicense(){
    return Container(
        padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: const [0.4,1.0],
              colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade400]
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple),

      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                _isDrivingLicenseExpanded = !_isDrivingLicenseExpanded;
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Driving License',style: TextStyle(fontFamily: 'Ubuntu')),
                  IconButton(
                    icon: Icon(_isDrivingLicenseExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    onPressed: () {
                      setState(() {
                        _isDrivingLicenseExpanded = !_isDrivingLicenseExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
                height: _isDrivingLicenseExpanded ? 240 : 0.0,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    (editMode && _currentUserRole == 1)
                        ? Flexible(
                          child: CustomDropdownButton(
                              value: _selectedLicenseStatus,
                              hint: 'License Status',
                              items: licenseStatus,
                              onChanged: (int? newValue) {
                                setState(() {
                                  _selectedLicenseStatus = newValue!;
                                });
                              }),
                        )
                        : Flexible(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children: [
                                  const Text("License Status : "),
                                  Text(licenseStatusName)
                                ],
                              ),
                            ),
                        ),
                    const SizedBox(height: 10),
                    (editMode && _currentUserRole == 1)
                        ? CustomDropdownButton(
                            value: _selectedLicenseType,
                            hint: 'License Type',
                            items: licenseType,
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedLicenseType = newValue!;
                              });
                            })
                        : Flexible(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  const Text("License Type : "),
                                  Text(licenseTypeName)
                                ],
                              ),
                            ),
                        ),
                    const SizedBox(height: 10),

                    ///license color drop down
                    (editMode && _currentUserRole == 1)
                        ? CustomDropdownButton(
                            value: _selectedLicenseColor,
                            hint: 'License Color',
                            items: licenseColor,
                            onChanged: (int? value) {
                              setState(() {
                                _selectedLicenseColor = value!;
                              });
                            })
                        : Flexible(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  const Text("License Color : "),
                                  Text(licenseColorName)
                                ],
                              ),
                            ),
                        ),
                    const SizedBox(
                      height: 10,
                    ),

                    ///toggle vehicle punishment
                    Row(
                      children: [
                        const Flexible(
                          child: Text(
                            'Vehicle Punishment:',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Switch(
                              value: _isVehiclePunished,
                              activeColor: Colors.red.shade500,
                              onChanged: (bool value) {
                                setState(() {
                                  _isVehiclePunished = value;
                                });
                              }),
                        )
                      ],
                    ),
                    (_isVehiclePunished)
                        ? Flexible(
                          child: CustomTextField(
                              controller: _vehiclePunishmentDescription,
                              labelText: 'Vehicle Punishment Description',
                              readOnly: _currentUserRole),
                        )
                        : const SizedBox(height: 1)
                  ],
                ))
          ],
      )
    );
  }

  Widget _buildPreviousApplied(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: const [0.4,1.0],
              colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade400]
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple)
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Previous Applied:',style: TextStyle(fontFamily: 'Ubuntu',fontSize: 14),),
              const SizedBox(width: 5),
              Switch(
                  value: _isPreviousApplied,
                  onChanged: (bool value){
                    setState(() {
                      _isPreviousApplied = value;
                    });
                  })
            ],
          ),
          (_isPreviousApplied)
              ?CustomTextField(controller: _previousAppliedDescription, labelText: 'Previous Applied Description',readOnly: _currentUserRole)
              :const SizedBox(height: 1)
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(picked);
        age = _calculateAge(picked);
      });
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Widget bloodTypeWidget(){
    return SizedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          value: _selectedBloodType,
          hint: const Text('Blood Type', style: TextStyle(fontSize: 14),
          ),
          items: bloodType.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value,style: TextStyle(
                  overflow: TextOverflow.ellipsis,color: Theme.of(context).colorScheme.onSurface
              ),),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              _selectedBloodType = newValue!;
            });
          },
          buttonStyleData: ButtonStyleData(
            elevation: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black26,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 44,
          ),
        ),
      ),
    );
  }

  Widget marriageStatus(){
    return SizedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          value: _selectedMarry,
          hint: const Text('Marriage Status', style: TextStyle(fontSize: 14),
          ),
          items: marriageList.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value,style: TextStyle(
                  overflow: TextOverflow.ellipsis,color: Theme.of(context).colorScheme.onSurface
              ),),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              _selectedMarry = newValue!;
            });
          },
          buttonStyleData: ButtonStyleData(
            elevation: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black26,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 44,
          ),
        ),
      ),
    );
  }

  PersonalInfoRequest getPersonalData(){
    return  PersonalInfoRequest(
        id: 0,
        employeeId: widget.userId,
        gender: _selectedGender,
        address: _addressController.text,
        telNoOffice: _cellularPhoneController.text,
        telNoHome: _homePhoneController.text,
        dateOfBirth: _date,
        age: age,
        placeOfBirth: _placeOfBirthController.text,
        nationality: _nationalityController.text,
        religion: _religionController.text,
        race: _raceController.text,
        health: _healthController.text,
        bloodType: _selectedBloodType,
        handUsage: _selectedHandUsage,
        hairColor: _hairColorController.text,
        eyeColor: _eyeColorController.text,
        skinColor: _skinColorController.text,
        marriageStatus: _selectedMarry,
        emergencyContactName: _emergencyName.text,
        emergencyContactRelation: _emergencyRelation.text,
        emergencyContactMobilePhone: _emergencyCellularPhone.text,
        emergencyContactHomePhone: _emergencyHomePhone.text,
        emergencyContactOfficePhone: "--",
        emergencyContactAddress: _emergencyAddress.text,
        sportAndHobby: _sportsHobbyController.text,
        socialActivities: _socialActivitiesController.text,
        drivingLicenceStatus: _selectedLicenseStatus,
        drivingLicenceType: _selectedLicenseType,
        drivingLicenceColor: _selectedLicenseColor,
        vehiclePunishment: _isVehiclePunished,
        vehiclePunishmentDescription: _vehiclePunishmentDescription.text,
        previousApplied: _isPreviousApplied,
        previousAppliedDescription: _previousAppliedDescription.text,
        hRDepartmentRecord: ""
    );
  }

  bool validatePersonalInfo(){
    if(_addressController.text.toString().isEmpty){
      setState(() {
        _addressErrorText = "Company Name is required";
      });
      return false;
    }else{
      setState(() {
        _addressErrorText = null;
      });
    }
    return true;
  }

  void bindPersonalInfo(List<PersonalInfoVo> personalInfo){
    PersonalInfoVo personal = personalInfo.first;
    personalInfoId = personal.id;
    _addressController.text = personal.address ?? "";
    _cellularPhoneController.text = personal.telNoOffice ?? "";
    _homePhoneController.text = personal.telNoHome ?? "";
    _date = personal.dateOfBirth ?? "";
    age = personal.age ?? 0;
    _placeOfBirthController.text = personal.placeOfBirth ?? "";
    _nationalityController.text = personal.nationality ?? "";
    _religionController.text = personal.religion ?? "";
    _raceController.text = personal.race ?? "";
    _healthController.text = personal.health ?? "";
    _sportsHobbyController.text = personal.sportAndHobby ?? "";
    _socialActivitiesController.text = personal.socialActivities ?? "";
    _selectedGender = personal.gender!;
    _selectedHandUsage = personal.handUsage ?? 2;
    if(personal.bloodType != null){
      _selectedBloodType = personal.bloodType;
      bloodTypeName = bloodType[personal.bloodType]!;
    }
    if(personal.marriageStatus != null){
      marriageStatusName = marriageList[personal.marriageStatus]!;
      _selectedMarry = personal.marriageStatus;
    }
    _hairColorController.text = personal.hairColor ?? "";
    _skinColorController.text = personal.skinColor ?? "";
    _eyeColorController.text = personal.eyeColor ?? "";
    _emergencyName.text = personal.emergencyContactName ?? "";
    _emergencyRelation.text = personal.emergencyContactRelation ?? "";
    _emergencyAddress.text = personal.emergencyContactAddress ?? "";
    _emergencyCellularPhone.text = personal.emergencyContactMobilePhone ?? "";
    _emergencyHomePhone.text = personal.emergencyContactHomePhone ?? "";
    if(personal.drivingLicenceType != null){
      licenseTypeName = licenseType[personal.drivingLicenceType]!;
      _selectedLicenseType = personal.drivingLicenceType;
    }
    if(personal.drivingLicenceStatus != null){
      licenseStatusName = licenseStatus[personal.drivingLicenceStatus]!;
      _selectedLicenseStatus = personal.drivingLicenceStatus;
    }
    if(personal.drivingLicenceColor != null){
      licenseColorName = licenseColor[personal.drivingLicenceColor]!;
      _selectedLicenseColor = personal.drivingLicenceColor;
    }
    _isVehiclePunished = personal.vehiclePunishment!;
    _vehiclePunishmentDescription.text = personal.vehiclePunishmentDescription ?? "";
    _isPreviousApplied = personal.previousApplied!;
    _previousAppliedDescription.text = personal.previousAppliedDescription ?? "";
  }
}
