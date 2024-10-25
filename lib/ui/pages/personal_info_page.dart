
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pahg_group/data/vos/nrc_township_vo.dart';
import 'package:pahg_group/utils/utils.dart';
import 'package:provider/provider.dart';
import '../../bloc/personal_info_bloc.dart';
import '../../data/vos/personal_info_vo.dart';
import '../../utils/helper_functions.dart';
import '../../utils/image_compress.dart';
import '../../utils/size_config.dart';
import '../components/custom_drop_down_button.dart';
import '../components/custom_text_field.dart';
import '../providers/auth_provider.dart';
import '../shimmer/personal_information_shimmer.dart';
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
  List<PersonalInfoVo> personalInfo = [];
  String _token = '';
  int _currentUserRole = 0;
  final Map<int, String> bloodTypeList = {1: 'A', 2: 'B', 3: 'O', 4: 'AB'};
  final Map<int ,String> marriageList = {1: 'Single',2: 'Married',3: 'Divorce',4: 'Widower',5: 'Widow'};
  final Map<int ,String> licenseStatusList = {1: 'Not Have',2: 'Have',3: 'Still Applying'};
  final Map<int ,String> licenseTypeList = {1: 'က' ,2: 'ခ',3: 'ဃ'};
  final Map<int ,String> licenseColorList = {1: 'Black', 2: 'Red'};
  final Map<int, String> stateList = {1: '1', 2: '2', 3: '2', 4: '4',5:'5',6:'6',7:'7',8:'8',9:'9',10:'10',11:'11',12:'12',13:'13',14:'14'};
  final Map<int, String> nationTypeList ={1: 'နိုင်',2: 'ဧည့်',3: 'သာ',4: 'ပြု',5: 'သီ',6: 'စ',};
  String frontDrivingImageUrl = "";
  String backDrivingImageUrl = "";

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
    _currentUserRole = authModel.role;
  }

  Future<void> _selectDate(BuildContext context,PersonalInfoBloc bloc) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      bloc.updatePersonalInfo(dateOfBirth: picked.toString(),age: _calculateAge(picked));
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

  String getBloodType(int? bloodTypeInt) {
    return bloodTypeList[bloodTypeInt] ?? ''; // Return 'Unknown' if the key doesn't exist
  }

  String getMarriageStatus(int? marriageStatus){
    return marriageList[marriageStatus] ?? '';
  }

  String getLicenseStatusName(int? licenseStatus){
    return licenseStatusList[licenseStatus] ?? '';
  }

  String getLicenseColorName(int? licenseColor){
    return licenseColorList[licenseColor] ?? '';
  }

  String getLicenseTypeName(int? licenseType){
    return licenseStatusList[licenseType] ?? '';
  }

  void _showPickerDialog(BuildContext context,int imageType,PersonalInfoBloc bloc) {
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
                  selectImage(imageType,ImageSource.gallery,bloc);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  selectImage(imageType,ImageSource.camera,bloc);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> selectImage(int imageType,ImageSource source,PersonalInfoBloc bloc) async{
    //Create an instance of ImagePicker
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      compressAndGetFile(File(file.path), file.path,48)
          .then((onValue){
            File? compressFile = onValue;
            if(compressFile != null){
              bloc.uploadImage(context,imageType, compressFile);
            }
          }).catchError((onError){
            showScaffoldMessage(context, onError.toString());
          });
    }
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ChangeNotifierProvider(
      create: (context) => PersonalInfoBloc(_token, widget.userId),
      child: Scaffold(
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
            if(_currentUserRole == 1)
              Selector<PersonalInfoBloc,bool>(
                selector: (context,bloc) => bloc.isDataEmpty,
                  builder: (context,isDataEmpty,_){
                  var bloc = context.read<PersonalInfoBloc>();
                    if(isDataEmpty == true){
                      return IconButton(onPressed: (){
                        bloc.addPersonalInformation(_token,widget.userId,context);
                      }, icon: const Icon(Icons.save,color: Colors.green,));
                    }
                    else{
                      return Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              bloc.updatePersonalInformation(_token,context);
                            },
                            icon: const Icon(Icons.cloud_upload, color: colorAccent),
                          ),
                          Selector<PersonalInfoBloc, bool>(
                            selector: (context, bloc) => bloc.editMode,
                            builder: (context, editMode, _) {
                              return TextButton(
                                onPressed: () {
                                  setState(() {
                                    bloc.toggleEditMode();
                                  });
                                },
                                child: (!editMode)
                                    ? const Text('Edit', style: TextStyle(color: colorAccent))
                                    : const Text('Undo', style: TextStyle(color: colorAccent)),
                              );
                            },
                          ),
                        ],
                      );
                    }
                  },
              ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            Selector<PersonalInfoBloc,PersonalInfoState>(
                selector: (context,bloc) => bloc.personalInfoState,
                builder: (context,personalInfoState,_){
                  var bloc = context.read<PersonalInfoBloc>();
                  ///Failed Widgets
                  if(personalInfoState == PersonalInfoState.error){
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off),
                          const SizedBox(height: 10),
                          Text(bloc.errorMessage ?? ''),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () => bloc.getPersonalInformation(_token,widget.userId), child: const Text('Try Again')
                          )
                        ],
                      ),
                    );
                  }
                  ///Success Widgets
                  else if(personalInfoState == PersonalInfoState.success){
                    return SingleChildScrollView(
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
                                controller: TextEditingController(text: bloc.personalInfo.address),
                                readOnly: _currentUserRole != 1,
                                onChanged: (value) => bloc.updatePersonalInfo(address: value),
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                    labelText: 'Address',
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(fontWeight: FontWeight.w300),
                                    floatingLabelBehavior: FloatingLabelBehavior.always
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  ///cellular is mobile phone
                                    child: CustomTextField(
                                      controller: TextEditingController(text: bloc.personalInfo.telNoOffice),
                                      labelText: 'Cellular Phone',
                                      onChange: (value) => bloc.updatePersonalInfo(telNoOffice: value),
                                      readOnly: _currentUserRole,
                                      keyboardType: TextInputType.number,
                                    )
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                      controller: TextEditingController(text: bloc.personalInfo.telNoHome),
                                      labelText: 'Home Phone',
                                      onChange: (value) => bloc.updatePersonalInfo(telNoHome: value),
                                      readOnly: _currentUserRole,
                                      keyboardType: TextInputType.number
                                  ),
                                ),
                              ],
                            ),
                            ///date of birth
                            GestureDetector(
                              onTap: (){
                                if(_currentUserRole == 1){
                                  _selectDate(context,bloc);
                                }
                              },
                              child: Selector<PersonalInfoBloc,String?>(
                                selector: (context,bloc) => bloc.personalInfo.dateOfBirth,
                                builder: (context,dateOfBirth,_){
                                  return Container(
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
                                            Text(Utils.getFormattedDate(dateOfBirth) ?? '')
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Age',style: TextStyle(fontFamily: 'Ubuntu', fontSize: 15,fontWeight: FontWeight.w300),),
                                            Text(bloc.personalInfo.age.toString())
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            CustomTextField(
                                controller: TextEditingController(text: bloc.personalInfo.placeOfBirth),
                                onChange: (value) => bloc.updatePersonalInfo(placeOfBirth: value),
                                labelText: 'Place of Birth',
                                readOnly: _currentUserRole),
                            const SizedBox(height: 10),
                            CustomTextField(
                                controller: TextEditingController(text: bloc.personalInfo.nationality),
                                onChange: (value) => bloc.updatePersonalInfo(nationality: value),
                                labelText: 'Nationality',
                                readOnly: _currentUserRole),
                            const SizedBox(height: 10),
                            CustomTextField(
                                controller: TextEditingController(text: bloc.personalInfo.religion),
                                onChange: (value) => bloc.updatePersonalInfo(religion: value),
                                labelText: 'Religion',
                                readOnly: _currentUserRole),
                            const SizedBox(height: 10),
                            CustomTextField(
                                controller: TextEditingController(text: bloc.personalInfo.race),
                                onChange: (value) => bloc.updatePersonalInfo(race: value),
                                labelText: 'Race',
                                readOnly: _currentUserRole),
                            const SizedBox(height: 10),
                            CustomTextField(
                                controller: TextEditingController(text: bloc.personalInfo.health),
                                onChange: (value) => bloc.updatePersonalInfo(health: value),
                                labelText: 'Health',
                                readOnly: _currentUserRole),
                            const SizedBox(height: 10),
                            CustomTextField(
                                controller: TextEditingController(text: bloc.personalInfo.sportAndHobby),
                                onChange: (value) => bloc.updatePersonalInfo(sportAndHobby: value),
                                labelText: 'Sports,Hobby',
                                readOnly: _currentUserRole),
                            const SizedBox(height: 10),
                            CustomTextField(
                                controller: TextEditingController(text: bloc.personalInfo.socialActivities),
                                onChange: (value) => bloc.updatePersonalInfo(socialActivities: value),
                                labelText: 'Social Activities',
                                readOnly: _currentUserRole),
                            const SizedBox(height: 10,),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).colorScheme.surfaceBright
                              ),
                              ///gender radio button
                              child: (bloc.editMode && _currentUserRole == 1)
                                  ? Selector<PersonalInfoBloc,bool>(
                                selector: (context,bloc) => bloc.personalInfo.gender ?? true,
                                builder: (context,gender,_){
                                  return ButtonBar(
                                    alignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const Text('Gender : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                                      const Text('Male'),
                                      Radio(
                                        value: true,
                                        groupValue: gender,
                                        activeColor: colorAccent,
                                        onChanged: (bool? value){
                                          bloc.updatePersonalInfo(gender: value);
                                        },
                                      ),
                                      const Text('Female'),
                                      Radio(
                                        value: false,
                                        groupValue: gender,
                                        activeColor: colorAccent,
                                        onChanged: (bool? value){
                                          bloc.updatePersonalInfo(gender: value);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0,right: 4),
                                    child: Text("Gender :",style: TextStyle(fontFamily: 'Ubuntu',fontSize: 14),),
                                  ),
                                  (bloc.personalInfo.gender ?? true)
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
                                  color: Theme.of(context).colorScheme.surfaceBright
                              ),
                              child: (bloc.editMode && _currentUserRole == 1)
                                  ? Selector<PersonalInfoBloc,int>(
                                selector: (context,handUsage) => bloc.personalInfo.handUsage ?? 1,
                                builder: (context,handUsage,_){
                                  return ButtonBar(
                                    alignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      const Text('Hand Usage : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                                      const Text('Left'),
                                      Radio(
                                        value: 1,
                                        groupValue: handUsage,
                                        activeColor: colorAccent,
                                        onChanged: (int? value){
                                          bloc.updatePersonalInfo(handUsage: value);
                                        },
                                      ),
                                      const Text('Right'),
                                      Radio(
                                        value: 2,
                                        groupValue: handUsage,
                                        activeColor: colorAccent,
                                        onChanged: (int? value){
                                          bloc.updatePersonalInfo(handUsage: value);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0,right: 4),
                                    child: Text("Hand Usage :",style: TextStyle(fontFamily: 'Ubuntu',fontSize: 14),),
                                  ),
                                  (bloc.personalInfo.handUsage == 2)
                                      ? const Text(" Right",style: TextStyle(fontSize: 16),)
                                      : const Text(" Left",style: TextStyle(fontSize: 16))
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ///blood type and marriage
                            (bloc.editMode && _currentUserRole == 1)
                                ? Row(
                              children: [
                                Expanded(child: bloodTypeWidget(context)),
                                const SizedBox(width: 10),
                                Expanded(child: marriageStatus(context))
                              ],
                            )
                                : Container(
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).colorScheme.surfaceBright
                              ),

                              ///Blood type and marriage status
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: 'Blood Type : ',
                                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                        children: [
                                          TextSpan(
                                            text: getBloodType(bloc.personalInfo.bloodType),
                                            style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                                color: Theme.of(context).colorScheme.onSurface,
                                                fontSize: 16
                                            ),
                                          )
                                        ]),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: 'Marriage Status : ',
                                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                        children: [
                                          TextSpan(
                                            text: getMarriageStatus(bloc.personalInfo.marriageStatus),
                                            style: TextStyle(
                                                fontFamily: 'Ubuntu',
                                                fontSize: 16,
                                                color: Theme.of(context).colorScheme.onSurface),
                                          )
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildNationalRegiCard(context),
                            const SizedBox(height: 10),
                            _buildAppearance(context),
                            const SizedBox(height: 10),
                            _buildEmergencyContact(context),
                            const SizedBox(height: 10),
                            _buildDrivingLicense(context),
                            const SizedBox(height: 10),
                            _buildPreviousApplied(context),
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
                                    child: const Row(
                                      children: [
                                        Text("Go To Family"),
                                        SizedBox(width: 4),
                                        Icon(Icons.keyboard_double_arrow_right)
                                      ],
                                    )),
                              ],
                            ),
                            const SizedBox(height: 20)
                          ],
                        ),
                      ),
                    );
                  }
                  ///Loading Widgets
                  else{
                    return const PersonalInformationShimmer();
                  }
                },
            ),
          ]
        )
      ),
    );
  }

  ///build emergency
  Widget _buildEmergencyContact(BuildContext context){
    var bloc = context.read<PersonalInfoBloc>();
    return Selector<PersonalInfoBloc,bool>(
      selector: (context,bloc) => bloc.isEmergencyExpanded,
      builder: (context,isEmergencyExpanded,_){
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: const [0.4,1.0],
                  colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade200]
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.deepPurple)
          ),
          padding: const EdgeInsets.symmetric(horizontal:16,vertical: 10),
          child: GestureDetector(
            onTap: (){
              bloc.toggleEmergencyExpanded();
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Emergency Contact'),
                      Icon(isEmergencyExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    ],
                  ),
                ),
                if(isEmergencyExpanded)
                  Column(
                    children: [
                      const SizedBox(height: 10,),
                      CustomTextField(
                          controller: TextEditingController(text: bloc.personalInfo.emergencyContactName),
                          onChange: (value) => bloc.updatePersonalInfo(emergencyContactName: value),
                          labelText: 'Name',readOnly: _currentUserRole
                      ),
                      const SizedBox(height: 6,),
                      CustomTextField(
                          controller: TextEditingController(text: bloc.personalInfo.emergencyContactRelation),
                          onChange: (value) => bloc.updatePersonalInfo(emergencyContactRelation: value),
                          labelText: 'Relation',
                          readOnly: _currentUserRole),
                      const SizedBox(height: 6,),
                      CustomTextField(
                          controller: TextEditingController(text: bloc.personalInfo.emergencyContactAddress),
                          onChange: (value) => bloc.updatePersonalInfo(emergencyContactAddress: value),
                          labelText: 'Address',
                          readOnly: _currentUserRole),
                      const SizedBox(height: 6,),
                      Row(
                        children: [
                          Expanded(child: CustomTextField(
                            controller: TextEditingController(text: bloc.personalInfo.emergencyContactOfficePhone),
                            onChange: (value) => bloc.updatePersonalInfo(emergencyContactOfficePhone: value),
                            labelText: 'Cellular Phone',
                            readOnly: _currentUserRole,
                            keyboardType: TextInputType.number,)
                          ),
                          const SizedBox(width: 8,),
                          Expanded(child: CustomTextField(
                            controller: TextEditingController(text: bloc.personalInfo.emergencyContactHomePhone),
                            onChange: (value) => bloc.updatePersonalInfo(emergencyContactMobilePhone: value),
                            labelText: 'Home Phone',
                            readOnly: _currentUserRole,
                            keyboardType: TextInputType.number,),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
   }

  ///build national id card
  Widget _buildNationalRegiCard(BuildContext context){
    var bloc = context.read<PersonalInfoBloc>();
    return Selector<PersonalInfoBloc,bool>(
      selector: (context,bloc) => bloc.isNrcExpanded,
      builder: (context,isNrcExpanded,_){
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: const [0.4,1.0],
                  colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade200]
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.deepPurple)
          ),
          padding: const EdgeInsets.symmetric(horizontal:16,vertical: 10),
          child: GestureDetector(
            onTap: (){
                bloc.toggleNrcExpanded();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('National Card',style: TextStyle(fontFamily: 'Ubuntu'),),
                      Icon(isNrcExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                    ],
                  ),
                ),
                if(isNrcExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///NRC Dropdown
                      const SizedBox(height: 18),
                      if(_currentUserRole == 1)
                        Row(
                        children: [
                          Expanded(child: stateListWidget(context)),
                          const SizedBox(width: 8),
                          Expanded(child: townshipDropdown(context)),
                          const SizedBox(width: 8),
                          Expanded(child: nationalTypeListDropdown(context)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: const EdgeInsets.symmetric(horizontal: 6,),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  border: Border.all(color: Colors.grey.shade600),
                                  borderRadius: BorderRadius.circular(6)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                child: TextField(
                                  maxLines: 1,
                                  controller: TextEditingController(text: bloc.nrcNo),
                                  keyboardType: TextInputType.number,
                                  onChanged : (value) => bloc.setNrcNo = value,
                                  readOnly: _currentUserRole != 1,
                                  decoration: const InputDecoration(
                                    labelStyle: TextStyle(fontWeight: FontWeight.w300),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Selector<PersonalInfoBloc,String>(
                        selector: (context,bloc) => bloc.nrcNumber ?? 'null nrc',
                        builder: (context,nrcNumber,_){
                          return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  border: Border.all(color: Colors.grey.shade600),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Text(nrcNumber)
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Selector<PersonalInfoBloc,String>(
                              selector: (context,bloc) => bloc.personalInfo.nrcFrontUrl ?? '',
                              builder: (context,nrcFrontUrl,_){
                                return Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: OpenContainer(
                                        closedBuilder:(context,action) => CachedNetworkImage(
                                          imageUrl: bloc.personalInfo.getImageWithBaseUrl(nrcFrontUrl),
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
                                        closedColor: Colors.black12,
                                        openBuilder: (context,action) =>
                                            ImageDetailsPage(imageUrl: bloc.personalInfo.getImageWithBaseUrl(nrcFrontUrl)),
                                      )
                                    ),
                                    if(_currentUserRole == 1)
                                      GestureDetector(
                                          onTap: (){
                                              _showPickerDialog(context,3,bloc);
                                          },
                                          child: Image.asset("lib/icons/add_camera.png", width: 30, height: 30, color: Colors.grey,))
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Selector<PersonalInfoBloc,String>(
                                selector: (context,bloc) => bloc.personalInfo.nrcBackUrl ?? '',
                                builder: (context,nrcBackUrl,_){
                                  return Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Flexible(
                                            child: OpenContainer(
                                                closedColor: Colors.black12,
                                                closedBuilder: (context,action) => CachedNetworkImage(
                                                  imageUrl: bloc.personalInfo.getImageWithBaseUrl(nrcBackUrl),
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
                                                openBuilder: (context,action) =>
                                                    ImageDetailsPage(imageUrl: bloc.personalInfo.getImageWithBaseUrl(nrcBackUrl))
                                            ),
                                          ),
                                        ),
                                        if(_currentUserRole == 1)
                                          GestureDetector(
                                              onTap: (){
                                                _showPickerDialog(context, 4, bloc);
                                              },
                                              child: Image.asset("lib/icons/add_camera.png", width: 30, height: 30, color: Colors.grey,)
                                          )
                                      ]
                                  );
                                }
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///build appearance
  Widget _buildAppearance(BuildContext context){
    var bloc = context.read<PersonalInfoBloc>();
    return Selector<PersonalInfoBloc,bool>(
        selector: (context,bloc) => bloc.isAppearanceExpanded,
        builder: (context,isAppearanceExpanded,_){
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: const [0.4,1.0],
                    colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade200]
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.deepPurple)
            ),
            padding: const EdgeInsets.symmetric(horizontal:16,vertical: 10),
            child: GestureDetector(
              onTap: (){
                bloc.toggleAppearanceExpanded();
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
                          Icon(isAppearanceExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    if(isAppearanceExpanded)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          CustomTextField(
                              controller: TextEditingController(text: bloc.personalInfo.skinColor),
                              onChange: (value) => bloc.updatePersonalInfo(hairColor: value),
                              labelText: 'Hair Color',
                              readOnly: _currentUserRole
                          ),
                          const SizedBox(height: 6,),
                          CustomTextField(
                              controller: TextEditingController(text: bloc.personalInfo.skinColor),
                              onChange: (value) => bloc.updatePersonalInfo(skinColor: value),
                              labelText: 'Skin Color',
                              readOnly: _currentUserRole),
                          const SizedBox(height: 6,),
                          CustomTextField(
                              controller: TextEditingController(text: bloc.personalInfo.eyeColor),
                              onChange: (value) => bloc.updatePersonalInfo(eyeColor: value),
                              labelText: 'Eye Color',readOnly: _currentUserRole)
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
   }

  ///Driving License
  Widget _buildDrivingLicense(BuildContext context){
    var bloc = context.read<PersonalInfoBloc>();
    return Selector<PersonalInfoBloc,bool>(
      selector: (context,bloc) => bloc.isDrivingLicenseExpanded,
      builder: (context,isDrivingLicenseExpanded,_){
        return Container(
            padding: const EdgeInsets.symmetric(horizontal:16,vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: const [0.4,1.0],
                  colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade200]
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.deepPurple),
            ),
            child: GestureDetector(
              onTap: (){
                bloc.toggleDrivingExpanded();
              },
              child: Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Driving License',style: TextStyle(fontFamily: 'Ubuntu')),
                        Icon(isDrivingLicenseExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  if(isDrivingLicenseExpanded)
                    Column(
                      children: [
                        Selector<PersonalInfoBloc,int?>(
                          selector: (context,bloc) => bloc.personalInfo.drivingLicenceStatus,
                          builder: (context,licenseStatus,_){
                            if(bloc.editMode && _currentUserRole == 1){
                              return CustomDropdownButton(
                                  value: licenseStatus,
                                  hint: 'License Status',
                                  items: licenseStatusList,
                                  onChanged: (int? newValue) {
                                    bloc.updatePersonalInfo(drivingLicenceStatus: newValue);
                                  });
                            }else{
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0,bottom: 8,top: 14),
                                child: Row(
                                  children: [
                                    const Text("License Status : "),
                                    Text(getLicenseStatusName(licenseStatus),style: const TextStyle(fontFamily: 'Ubuntu'),)
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        Selector<PersonalInfoBloc,int?>(
                          selector: (context,bloc) => bloc.personalInfo.drivingLicenceType,
                          builder: (context,licenseType,_){
                            if(bloc.editMode && _currentUserRole == 1){
                              return CustomDropdownButton(
                                  value: licenseType,
                                  hint: 'License Type',
                                  items: licenseTypeList,
                                  onChanged: (int? newValue) {
                                    bloc.updatePersonalInfo(drivingLicenceType: newValue);
                                  });
                            }else{
                              return Padding(
                                padding: const EdgeInsets.only(left: 8,bottom: 8),
                                child: Row(
                                  children: [
                                    const Text("License Type : "),
                                    Text(getLicenseTypeName(licenseType),style: const TextStyle(fontFamily: 'Ubuntu'))
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        ///license color drop down
                        Selector<PersonalInfoBloc,int?>(
                          selector: (context,bloc) => bloc.personalInfo.drivingLicenceColor,
                          builder: (context,licenseColor,_){
                            if(bloc.editMode && _currentUserRole == 1){
                              return CustomDropdownButton(
                                  value: licenseColor,
                                  hint: 'License Color',
                                  items: licenseColorList,
                                  onChanged: (int? value) {
                                    bloc.updatePersonalInfo(drivingLicenceColor: value);
                                  });
                            }else{
                              return Padding(
                                padding: const EdgeInsets.only(left: 8,bottom: 8),
                                child: Row(
                                  children: [
                                    const Text("License Color : "),
                                    Text(getLicenseColorName(licenseColor),style: const TextStyle(fontFamily: 'Ubuntu'))
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        ///toggle vehicle punishment
                        Selector<PersonalInfoBloc,bool>(
                          selector: (context,bloc) => bloc.personalInfo.vehiclePunishment ?? false,
                          builder: (context,vehiclePunishment,_){
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Vehicle Punishment:',
                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Switch(
                                          value: vehiclePunishment,
                                          activeColor: Colors.red.shade500,
                                          onChanged: (bool value) {
                                            if(_currentUserRole == 1) {
                                              bloc.updatePersonalInfo(vehiclePunishment: value);
                                            }
                                          }),
                                    )
                                  ],
                                ),
                                if(vehiclePunishment)
                                  CustomTextField(
                                      controller: TextEditingController(text: bloc.personalInfo.vehiclePunishmentDescription),
                                      onChange: (value) => bloc.updatePersonalInfo(vehiclePunishmentDescription: value),
                                      labelText: 'Vehicle Punishment Description',
                                      readOnly: _currentUserRole
                                  )
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        ///driving license image
                        Row(
                          children: [
                            Expanded(
                              child: Selector<PersonalInfoBloc,String>(
                                  selector: (context,bloc) => bloc.personalInfo.drivingLicenseFrontUrl ?? '',
                                  builder: (context,drivingLicenseFrontUrl,_){
                                    return Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Flexible(
                                              child: OpenContainer(
                                                  closedColor: Colors.black12,
                                                  closedBuilder: (context,action) => CachedNetworkImage(
                                                    imageUrl: bloc.personalInfo.getImageWithBaseUrl(drivingLicenseFrontUrl),
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
                                                  openBuilder: (context,action) =>
                                                      ImageDetailsPage(imageUrl: bloc.personalInfo.getImageWithBaseUrl(drivingLicenseFrontUrl))
                                              ),
                                            ),
                                          ),
                                          if(_currentUserRole == 1)
                                            GestureDetector(
                                                onTap: (){
                                                  _showPickerDialog(context, 1, bloc);
                                                },
                                                child: Image.asset("lib/icons/add_camera.png", width: 30, height: 30, color: Colors.grey,)
                                            )
                                        ]
                                    );
                                  }
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Selector<PersonalInfoBloc,String>(
                                  selector: (context,bloc) => bloc.personalInfo.drivingLicenseBackUrl ?? '',
                                  builder: (context,drivingLicenseBackUrl,_){
                                    return Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Flexible(
                                              child: OpenContainer(
                                                  closedColor: Colors.black12,
                                                  closedBuilder: (context,action) => CachedNetworkImage(
                                                    imageUrl: bloc.personalInfo.getImageWithBaseUrl(drivingLicenseBackUrl),
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
                                                  openBuilder: (context,action) =>
                                                      ImageDetailsPage(imageUrl: bloc.personalInfo.getImageWithBaseUrl(drivingLicenseBackUrl))
                                              ),
                                            ),
                                          ),
                                          if(_currentUserRole == 1)
                                            GestureDetector(
                                                onTap: (){
                                                  _showPickerDialog(context, 2, bloc);
                                                },
                                                child: Image.asset("lib/icons/add_camera.png", width: 30, height: 30, color: Colors.grey,)
                                            )
                                        ]
                                    );
                                  }
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                ],
              ),
            )
        );
      },
    );
  }

  Widget _buildPreviousApplied(BuildContext context){
    var bloc = context.read<PersonalInfoBloc>();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                stops: const [0.4,1.0],
                colors: [Theme.of(context).colorScheme.surfaceBright,Colors.blue.shade200]
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.deepPurple)
        ),
        child: Selector<PersonalInfoBloc,bool>(
          selector: (context,bloc) => bloc.personalInfo.previousApplied ?? false,
          builder: (context,previousApplied,_){
            return Column(
              children: [
                Row(
                  children: [
                    const Text('Previous Applied:',style: TextStyle(fontFamily: 'Ubuntu',fontSize: 14),),
                    const SizedBox(width: 5),
                    Switch(
                      value: previousApplied, // Set the switch state
                      onChanged: (bool value) {
                        if(_currentUserRole == 1){
                          bloc.updatePersonalInfo(previousApplied: value);
                        }
                      },
                    )
                  ],
                ),
                if(previousApplied)
                  CustomTextField(
                      controller: TextEditingController(
                          text: bloc.personalInfo.previousAppliedDescription),
                      onChange: (value) => bloc.updatePersonalInfo(
                          previousAppliedDescription: value),
                      labelText: 'Previous Applied Description',
                      readOnly: _currentUserRole)
              ],
            );
          },
        )
    );
  }

  Widget stateListWidget(BuildContext context){
    var bloc = context.read<PersonalInfoBloc>();
    return Selector<PersonalInfoBloc,int?>(
      selector: (context,bloc) => bloc.selectedState,
      builder: (context,selectedState,_){
        return SizedBox(
            child: Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    value: selectedState,
                    hint: const Text('State', style: TextStyle(fontSize: 8)),
                    items: stateList.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value, style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w600)),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      bloc.selectedState = newValue;
                    },
                    buttonStyleData: ButtonStyleData(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 40,
                    ),
                  ),
                ))
        );
      },
    );
  }

  Widget townshipDropdown(BuildContext context){
    var bloc = context.read<PersonalInfoBloc>();
    return Selector<PersonalInfoBloc,List<NrcTownshipVo>?>(
      selector: (context,bloc) => bloc.townshipList,
      builder: (context,townshipList,_){
        return  Selector<PersonalInfoBloc,String?>(
          selector: (context,bloc) => bloc.selectedTownship,
          builder: (context,selectedTownship,_){
            return SizedBox(
                child: Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      value: selectedTownship,
                      hint: const Text('Tsp', style: TextStyle(fontSize: 8)),
                      items: bloc.townshipList?.map((NrcTownshipVo value) {
                        return DropdownMenuItem<String>(
                          value: value.name,
                          child: Text(value.name ?? '', style: const TextStyle(fontSize: 8,fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        bloc.selectedTownship = newValue;
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
                )
            );
          },
        );
      },
    );
  }

  Widget nationalTypeListDropdown(BuildContext context){
    var bloc = context.read<PersonalInfoBloc>();
    return Selector<PersonalInfoBloc,String?>(
      selector: (context,bloc) => bloc.selectedNationalType,
      builder: (context,selectedNational,_){
        return SizedBox(
            child: Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  isExpanded: true,
                  value: selectedNational,
                  hint: const Text('Ctz', style: TextStyle(fontSize: 8)),
                  items: nationTypeList.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(entry.value, style: const TextStyle(fontSize: 8,fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    bloc.selectedNationalType = newValue;
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
            ));
      },
    );
  }

  Widget bloodTypeWidget(BuildContext context) {
    var bloc = context.read<PersonalInfoBloc>();
    return Selector<PersonalInfoBloc, int?>(
      selector: (context, bloc) => bloc.personalInfo.bloodType,
      builder: (context, bloodType, _) {
        return SizedBox(
            child: Expanded(
                child: CustomDropdownButton(
                    value: bloodType,
                    hint: 'Blood Type',
                    items: bloodTypeList,
                    onChanged: (int? newValue) {
                      bloc.updatePersonalInfo(bloodType: newValue);
                    })));
      },
    );
  }

  Widget marriageStatus(BuildContext context) {
    var bloc = context.read<PersonalInfoBloc>();
    return Selector<PersonalInfoBloc, int?>(
      selector: (context, bloc) => bloc.personalInfo.marriageStatus,
      builder: (context, marriageStatus, _) {
        return SizedBox(
            child: Expanded(
                child: CustomDropdownButton(
                    value: marriageStatus,
                    hint: 'Marriage Status',
                    items: marriageList,
                    onChanged: (int? newValue) {
                      bloc.updatePersonalInfo(marriageStatus: newValue);
                    })));
      },
    );
  }
}


