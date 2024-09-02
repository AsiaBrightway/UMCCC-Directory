
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../../data/models/pahg_model.dart';
import '../../data/vos/personal_info_vo.dart';
import '../../data/vos/request_body/personal_info_request.dart';
import '../../exception/helper_functions.dart';
import '../../utils/image_compress.dart';
import '../../utils/size_config.dart';
import '../../widgets/loading_widget.dart';
import '../components/custom_drop_down_button.dart';
import '../components/custom_text_field.dart';
import '../providers/auth_provider.dart';
import '../themes/colors.dart';
import 'family_page.dart';
import 'image_details_page.dart';

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
  File? _image;
  String _token = '';
  int _currentUserRole = 0;
  int? personalInfoId;
  final Map<int, String> bloodType = {1: 'A', 2: 'B', 3: 'O', 4: 'AB'};
  final Map<int ,String> marriageList = {1: 'Single',2: 'Married',3: 'Divorce',4: 'Widower',5: 'Widow'};
  final Map<int ,String> licenseStatus = {1: 'Not Have',2: 'Have',3: 'Still Applying'};
  final Map<int ,String> licenseType = {1: 'က' ,2: 'ခ',3: 'ဃ'};
  final Map<int ,String> licenseColor = {1: 'Black', 2: 'Red'};
  final Map<int, String> stateList = {1: '1', 2: '2', 3: '2', 4: '4',5:'5',6:'6',7:'7',8:'8',9:'9',10:'10',11:'11',12:'12',13:'13',14:'14'};
  final Map<int, String> nationTypeList ={1: 'နိုင်',2: 'ဧည့်',3: 'သာ',4: 'ပြု',5: 'သီ',6: 'စ',};
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
  final _nationalCardController = TextEditingController();
  final _startJoinDateController = TextEditingController();
  final _emergencyName = TextEditingController();
  final _emergencyRelation = TextEditingController();
  final _emergencyAddress = TextEditingController();
  final _vehiclePunishmentDescription = TextEditingController();
  final _previousAppliedDescription = TextEditingController();
  final _sportsHobbyController = TextEditingController();
  final _socialActivitiesController = TextEditingController();
  final _emergencyCellularPhone = TextEditingController();
  final _emergencyHomePhone = TextEditingController();
  final _nationalNumberController = TextEditingController();
  bool _selectedGender = true;
  int _selectedHandUsage = 2;
  int? _selectedState;
  int? _selectedNationalType;
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
  bool _isNRCExpanded = false;
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
  String frontDrivingImageUrl = "";
  String backDrivingImageUrl = "";
  File? _frontDrivingImage;
  File? _backDrivingImage;
  File? _frontNRCImage;
  File? _backNRCImage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  Future<void> uploadImage(int imageType) async{
    _model.uploadImage(_token, _image!).then((response){
      setState(() {
        switch(imageType){
          case 1 :
            frontDrivingImageUrl = response!.file!;
            _frontDrivingImage = _image;
            break;
          case 2 :
            backDrivingImageUrl = response!.file!;
            _backDrivingImage = _image;
        }
      });
    }).catchError((error){
      Navigator.of(context).pop();                                            //dismiss loading
      showErrorDialog(context, 'Image : ${error.toString()}');
    });
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _currentUserRole = authModel.role;
    await Future.delayed(const Duration(milliseconds: 800));
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

  void _showPickerDialog(BuildContext context,int imageType) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  selectImage(imageType,ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  selectImage(imageType,ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> selectImage(int imageType,ImageSource source) async{
    // Create an instance of ImagePicker
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      File? compressFile = await compressAndGetFile(File(file.path), file.path,48);
      if (compressFile != null) {
        setState(() {
          _image = compressFile;
          uploadImage(imageType);
        });
      }
    }
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
    if(validatePersonalInfo()){
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
  }

  void _addPersonalInfo(){
    if(validatePersonalInfo()){
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
    SizeConfig().init(context);
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
                  _addPersonalInfo();
                  }, icon: const Icon(Icons.save,color: Colors.green,))
                  : (editMode)
                    ? IconButton(onPressed: (){
                      _updatePersonalInfo();
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
      body: Stack(
      children: [
        FadeTransition(
          opacity: firstLoading ? const AlwaysStoppedAnimation(1.0) : const AlwaysStoppedAnimation(0.0),
            child: const Center(child: CircularProgressIndicator(color: Colors.blue))),
        FadeTransition(
          opacity: firstLoading ? const AlwaysStoppedAnimation(0.0) : const AlwaysStoppedAnimation(1.0),
          child: SingleChildScrollView(
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
                        gradient: LinearGradient(stops: const [0.4,1.0], colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade600])
                    ),
                    child: (editMode && _currentUserRole == 1)
                        ? ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text('Gender : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
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
                      gradient: LinearGradient(stops: const [0.4,1.0], colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade600]
                      ),
                    ),
                    child: (editMode && _currentUserRole == 1)
                        ? ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text('Hand Usage : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
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
                        RichText(
                          text: TextSpan(
                              text: 'Blood Type : ',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                              children: [
                                TextSpan(
                                  text: bloodTypeName,
                                  style: TextStyle(fontFamily: 'Ubuntu',color: Theme.of(context).colorScheme.onSurface),)
                              ]
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'Marriage Status : ',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                              children: [
                                TextSpan(
                                  text: marriageStatusName,
                                  style: TextStyle(fontFamily: 'Ubuntu',color: Theme.of(context).colorScheme.onSurface),)
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildNationalRegiCard(),
                  const SizedBox(height: 10),
                  _buildAppearance(),
                  const SizedBox(height: 10),
                  _buildEmergencyContact(),
                  const SizedBox(height: 10),
                  _buildDrivingLicense(),
                  const SizedBox(height: 10),
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
                          child: const Text("Go To Family"))
                    ],
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
        ]

      )

    );
  }

  ///build emergency
  Widget _buildEmergencyContact(){
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: const [0.4,1.0],
              colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade600]
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple)
      ),
      padding: const EdgeInsets.symmetric(horizontal:10,vertical: 10),
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
            duration: const Duration(milliseconds: 100),
            height: _isEmergencyExpanded ?  270 : 0.0,
            child: Visibility(
              visible: _isEmergencyExpanded,
              child: AnimatedOpacity(
                opacity: _isEmergencyExpanded ? 1.0 : 0.0,
                curve: Curves.easeInOutBack,
                duration: const Duration(milliseconds: 100),
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

  ///build national id card
  Widget _buildNationalRegiCard(){
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: const [0.4,1.0],
              colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade600]
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple)
      ),
      padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
      child: GestureDetector(
        onTap: (){
          setState(() {
            _isNRCExpanded = !_isNRCExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('National Card',style: TextStyle(fontFamily: 'Ubuntu'),),
                    Icon(_isNRCExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                  ],
                ),
              ),
              if(_isNRCExpanded)
              Column(
                children: [
                  CustomTextField(controller: _nationalCardController, labelText: 'NRC',readOnly: _currentUserRole),
                  const SizedBox(height: 8),
                  CustomTextField(controller: _startJoinDateController,labelText: 'Start Date',readOnly: _currentUserRole,),
                  const SizedBox(height: 8),
                  ///NRC Row
                  Row(
                      children: [
                        Expanded(child: stateListWidget()),
                        const SizedBox(width: 8),
                        Expanded(child: townshipDropdown()),
                        const SizedBox(width: 8),
                        Expanded(child: nationalTypeListDropdown()),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 6,),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              border: Border.all(color: Colors.grey.shade600),
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: TextField(
                                maxLines: 1,
                                controller: _nationalNumberController,
                                readOnly: _currentUserRole != 1,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelStyle: TextStyle(fontWeight: FontWeight.w300),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    //todo warning red
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _frontNRCImage == null
                                  ? OpenContainer(
                                    closedBuilder:(context,action) => CachedNetworkImage(
                                        //todo
                                        imageUrl: "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
                                        height: SizeConfig.blockSizeVertical * 17,
                                        width: SizeConfig.blockSizeHorizontal * 41,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, error, stackTrace) {
                                          return Container(
                                              height: SizeConfig.blockSizeVertical * 17,
                                              width: SizeConfig.blockSizeHorizontal * 40,
                                              color: Colors.black12,
                                              child: const Center(child: Text("Front Image")));
                                        },
                                      ),
                                    closedColor: Colors.black,
                                    openBuilder: (context,action) => ImageDetailsPage(imageUrl: "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg"),
                                  )
                                  : Image.file(
                                      _frontNRCImage!,
                                      width: SizeConfig.blockSizeHorizontal * 41,
                                      height: SizeConfig.blockSizeVertical * 16,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (BuildContext context, Object error, StackTrace? stackTrace) {
                                            return const Center(
                                              child: SizedBox(
                                                height: 90,
                                                width: 90,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                                  child: CircularProgressIndicator(color: Colors.red),
                                                )
                                              )
                                            );},
                                    ),
                            ),
                            GestureDetector(
                                onTap: (){
                                  _showPickerDialog(context,1);
                                },
                                child: Image.asset("lib/icons/add_camera.png", width: 30, height: 30, color: Colors.grey,))
                          ],
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _backNRCImage == null
                                  ? OpenContainer(
                                    closedBuilder: (context, action) =>  CachedNetworkImage(
                                      //todo
                                      imageUrl: "https://buffr.com/library/content/images/size/w1200/2023/10/free-images.jpg",
                                      height: SizeConfig.blockSizeVertical * 17,
                                      width: SizeConfig.blockSizeHorizontal * 41,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, error, stackTrace) {
                                        return Container(
                                            height: MediaQuery.of(context).size.height * 0.17,
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            color: Colors.black12,
                                            child: const Center(child: Text("Back Image"))
                                        );
                                      },
                                    ),
                                    openBuilder: (context, action) => const ImageDetailsPage(imageUrl: ""),
                                    closedColor: Colors.black12,
                                  )
                                  : Image.file(
                                      _backNRCImage!,
                                      width: MediaQuery.of(context).size.width * 0.4,
                                      height: MediaQuery.of(context).size.height * 0.16,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                        return const Center(child: SizedBox(height: 90, width: 90,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: 16.0),
                                              child: CircularProgressIndicator(color: Colors.red),
                                            )
                                        ));
                                      },
                                    ),
                            ),
                            GestureDetector(
                                onTap: (){
                                  _showPickerDialog(context,2);
                                },
                                child: Image.asset("lib/icons/add_camera.png", width: 30, height: 30, color: Colors.grey,))
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Appearance
  Widget _buildAppearance(){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: const [0.4,1.0],
          colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade600]
        ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple)
      ),
      padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
      child: GestureDetector(
        onTap: (){
          setState(() {
            _isAppearanceExpanded = !_isAppearanceExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Appearance',style: TextStyle(fontFamily: 'Ubuntu'),),
                    Icon(_isAppearanceExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                  ],
                ),
              ),
              if(_isAppearanceExpanded)
              Column(
                children: [
                  const SizedBox(height: 10),
                  CustomTextField(controller: _hairColorController, labelText: 'Hair Color',readOnly: _currentUserRole),
                  const SizedBox(height: 6,),
                  CustomTextField(controller: _skinColorController, labelText: 'Skin Color',readOnly: _currentUserRole),
                  const SizedBox(height: 6,),
                  CustomTextField(controller: _eyeColorController, labelText: 'Eye Color',readOnly: _currentUserRole)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Driving License
  Widget _buildDrivingLicense(){
    return Container(
        padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: const [0.4,1.0],
              colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade600]
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.deepPurple),
      ),
        child: GestureDetector(
          onTap: (){
            setState(() {
              _isDrivingLicenseExpanded = !_isDrivingLicenseExpanded;
            });
          },
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              child: Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Driving License',style: TextStyle(fontFamily: 'Ubuntu')),
                        Icon(_isDrivingLicenseExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  if(_isDrivingLicenseExpanded)
                  Column(
                    children: [
                      (editMode && _currentUserRole == 1)
                          ? CustomDropdownButton(
                              value: _selectedLicenseStatus,
                              hint: 'License Status',
                              items: licenseStatus,
                              onChanged: (int? newValue) {
                                setState(() {
                                  _selectedLicenseStatus = newValue!;
                                });
                              })
                          : Padding(
                            padding: const EdgeInsets.only(left: 8.0,bottom: 8,top: 14),
                            child: Row(
                              children: [
                                const Text("License Status : "),
                                Text(licenseStatusName,style: const TextStyle(fontFamily: 'Ubuntu'),)
                              ],
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
                          : Padding(
                            padding: const EdgeInsets.only(left: 8,bottom: 8),
                            child: Row(
                              children: [
                                const Text("License Type : "),
                                Text(licenseTypeName,style: const TextStyle(fontFamily: 'Ubuntu'))
                              ],
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
                          : Padding(
                            padding: const EdgeInsets.only(left: 8,bottom: 8),
                            child: Row(
                              children: [
                                const Text("License Color : "),
                                Text(licenseColorName,style: const TextStyle(fontFamily: 'Ubuntu'))
                              ],
                            ),
                          ),
                      const SizedBox(height: 10,),
                      ///toggle vehicle punishment
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Vehicle Punishment:',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
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
                          ? CustomTextField(
                              controller: _vehiclePunishmentDescription,
                              labelText: 'Vehicle Punishment Description',
                              readOnly: _currentUserRole)
                          : const SizedBox(height: 1),
                      const SizedBox(height: 8),
                      ///driving license image
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Flexible(
                                      child: _frontDrivingImage == null
                                          ? OpenContainer(
                                          closedColor: Colors.black12,
                                          closedBuilder: (context,action) => CachedNetworkImage(
                                            //todo
                                            imageUrl: "https://buffr.com/library/content/images/size/w1200/2023/10/free-images.jpg",
                                            height: SizeConfig.blockSizeVertical * 17,
                                            width: SizeConfig.blockSizeHorizontal * 41,
                                            fit: BoxFit.cover,
                                            errorWidget: (context, error, stackTrace) {
                                              return Container(
                                                  height: MediaQuery.of(context).size.height * 0.17,
                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                  color: Colors.black12,
                                                  child: const Center(child: Text("Front Image"))
                                              );
                                            },
                                          ),
                                          openBuilder: (context,action) => ImageDetailsPage(imageUrl: "https://buffr.com/library/content/images/size/w1200/2023/10/free-images.jpg"))
                                          : Image.file(
                                        _frontDrivingImage!,
                                        width: SizeConfig.blockSizeHorizontal * 41,
                                        height: SizeConfig.blockSizeVertical * 16,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          return const Center(
                                              child: SizedBox(height: 90, width: 90, child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                                child: CircularProgressIndicator(color: Colors.red),
                                              )));
                                        },
                                      )
                                  ),
                                ),
                                GestureDetector(
                                    onTap: (){
                                      _showPickerDialog(context,1);
                                    },
                                    child: Image.asset(
                                      "lib/icons/add_camera.png",
                                      width: 30,
                                      height: 30,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Flexible(
                                      child: _backDrivingImage == null
                                          ? OpenContainer(
                                          closedBuilder: (context,action) => CachedNetworkImage(
                                            //todo
                                            imageUrl: "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
                                            height: SizeConfig.blockSizeVertical * 16,
                                            width: SizeConfig.blockSizeHorizontal * 40,
                                            fit: BoxFit.cover,

                                            errorWidget: (context, error, stackTrace) {
                                              return Container(
                                                  height: MediaQuery.of(context).size.height * 0.17,
                                                  width: MediaQuery.of(context).size.width * 0.4,
                                                  color: Colors.black12,
                                                  child: const Center(child: Text("Back Image")));
                                            },
                                          ),
                                          closedColor: Colors.black,
                                          openBuilder: (context,action) =>
                                          const ImageDetailsPage(imageUrl: "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg")
                                      )
                                          : Image.file(
                                        _backDrivingImage!,
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        height: MediaQuery.of(context).size.height * 0.16,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace) {
                                          return const Center(
                                              child: SizedBox(height: 90, width: 90, child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                                child: CircularProgressIndicator(color: Colors.red),
                                              )));
                                        },
                                      )),
                                ),
                                GestureDetector(
                                    onTap: (){
                                      _showPickerDialog(context,2);
                                    },
                                    child: Image.asset(
                                      "lib/icons/add_camera.png",
                                      width: 30,
                                      height: 30,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )),
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
            elevation: 1,
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

  Widget stateListWidget(){
    return SizedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          value: _selectedState,
          hint: const Text('state', style: TextStyle(fontSize: 8)),
          items: stateList.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              _selectedState = newValue!;
            });

          },
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 40,
          ),
        ),
      ),
    );
  }

  Widget townshipDropdown(){
    return SizedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          value: _selectedState,
          items: stateList.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              _selectedState = newValue!;
            });
          },
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 40,
          ),
        ),
      ),
    );
  }

  Widget nationalTypeListDropdown(){
    return SizedBox(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          value: _selectedNationalType,
          hint: const Text('citizen', style: TextStyle(fontSize: 8)),
          items: nationTypeList.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value,style: TextStyle(fontSize: 8)),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              _selectedNationalType = newValue!;
            });
          },
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 40,
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
            elevation: 2,
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
