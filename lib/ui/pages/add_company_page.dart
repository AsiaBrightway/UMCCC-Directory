import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pahg_group/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/companies_vo.dart';
import '../../utils/helper_functions.dart';
import '../../utils/image_compress.dart';
import '../../widgets/loading_widget.dart';
import '../providers/auth_provider.dart';

class AddCompanyPage extends StatefulWidget {
  final bool isAdd;
  const AddCompanyPage({super.key,required this.isAdd});

  @override
  State<AddCompanyPage> createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  final PahgModel _model = PahgModel();
  final _companyNameController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _addressController = TextEditingController();
  final _aboutController = TextEditingController();
  final _sortOrderController = TextEditingController();
  String imageUrlForCompanyImage = "";
  List<CompaniesVo> companies = [];
  String? _companyErrorText;
  String _token = '';
  String imageUrl = "";
  File? _image;
  bool _isActive = true;
  bool isImageSelected = false;
  String _date = '';
  int? _companyId;
  String? _selectedValue;

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
      });
    }
  }
  
  void saveCompanyWithoutImage() {
    _model.addCompany(
        _token,
        _companyNameController.text.toString(),
        _addressController.text.toString(),
        _phoneNoController.text.toString(),
        _aboutController.text.toString(),
        imageUrl,
        _date,
        _sortOrderController.text.toString(),
        _isActive
    ).then((value){
      Navigator.of(context).pop();                                              //dismiss loading
      clearTextField();
      showSuccessScaffold(context, value?.message ?? "Success");
    }).catchError((error){
      Navigator.of(context).pop();                                              //dismiss loading
      showErrorDialog(context, error.toString());
    });
  }

  void createCompany() async {
    showDialog(context: context, barrierDismissible: false,builder: (context) => const LoadingWidget());
    if(isImageSelected){
      _model.uploadImage(_token, _image!).then((response){
        imageUrl = response!.file!;
        saveCompanyWithoutImage();
      }).catchError((error){
        Navigator.of(context).pop();                                            //dismiss loading
        showErrorDialog(context, 'Image : ${error.toString()}');
      });
    }else{
      saveCompanyWithoutImage();
    }
  }

  void updateCompany() {
    showDialog(context: context, barrierDismissible: false,builder: (context) => const LoadingWidget());
    if(isImageSelected){
      _model.uploadImage(_token, _image!).then((response){
        imageUrl = response!.file!;
        updateCompanyWithoutImage();
      }).catchError((error){
        Navigator.of(context).pop();                                            //dismiss loading
        showErrorDialog(context, 'Image : ${error.toString()}');
      });
    }else{
      updateCompanyWithoutImage();
    }
  }

  @override
  void didChangeDependencies() {
    final authModel = Provider.of<AuthProvider>(context);
    _token = authModel.token;
    if(widget.isAdd == false){
      ///get all companies က isActive စစ်မထားတဲ့ model
      _model.getAllCompanies(_token).then((companies){
        setState(() {
          this.companies = companies;
        });
      }).catchError((error){
        showErrorDialog(context, error.toString());
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    companies.clear();
    _companyNameController.dispose();
    _phoneNoController.dispose();
    _addressController.dispose();
    _aboutController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ///Company List spinner
                (widget.isAdd == false) ?
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 14),
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        value: _selectedValue,
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
                            _selectedValue = newValue!;
                            bindCompanyData(newValue);
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
                            borderRadius: BorderRadius.circular(12),
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
                  ) : const SizedBox(height: 2),
                ///Image Pick from Gallery
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child : GestureDetector(
                          onTap: () async {
                            // Create an instance of ImagePicker
                            ImagePicker imagePicker = ImagePicker();

                            // Pick an image from the gallery
                            XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                            if (file != null) {
                              // Compress the image
                              File? compressFile = await compressAndGetFile(File(file.path), file.path,48);

                              // Update the state with the compressed file
                              if (compressFile != null) {

                                setState(() {
                                  _image = compressFile;
                                  isImageSelected = true;
                                });
                              }
                            }
                          },
                          child: (_image == null)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    imageUrlForCompanyImage,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/image_url_not_found.png',
                                        color: Colors.black,
                                        width: 90,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const Center(
                                        child: SizedBox(
                                            height: 90,
                                            width: 90,
                                            child: Padding(
                                              padding: EdgeInsets.all(24.0),
                                              child: CircularProgressIndicator(color: Colors.blue,),
                                            )),
                                      );
                                    },
                                  ))
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                  child: Image.file(_image!,width: 90,height: 90,fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                      return const Center(
                                          child: SizedBox(height: 90,width: 90,child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 16.0),
                                            child: CircularProgressIndicator(color: Colors.red),
                                          ))
                                      );
                                    },)
                              )
                      )
                  ),
                ),
                const SizedBox(height: 20),
                ///Company Name Text field
                TextFormField(
                  style: const TextStyle(fontSize: 18),
                    controller: _companyNameController,
                    cursorColor: Colors.deepOrange,
                    decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: Colors.blueAccent),
                      labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300),
                      labelText: 'Company Name',
                      errorText: _companyErrorText,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.redAccent), // Bottom border color when focused
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(fontSize: 18),
                  controller: _addressController,
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300),
                    prefixIcon: const Icon(Icons.location_on),
                    labelText: 'Address',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.deepOrange), // Bottom border color when focused
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 18),
                  controller: _phoneNoController,
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    labelText: 'Phone Number',
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.deepOrange), // Bottom border color when focused
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(fontSize: 18),
                  controller: _aboutController,
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    labelText: 'About',
                    labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300),
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.deepOrange)
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                ///start date card
                GestureDetector(
                  onTap: (){
                    _selectDate(context);
                  },
                  child: Container(
                    width: 170,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.shade100,
                            borderRadius: BorderRadius.circular(24)
                          ),
                          child: const Icon(Icons.date_range),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Start Date ',style: TextStyle(color: Colors.black,fontSize: 16,fontFamily: 'Roboto',fontWeight: FontWeight.w500),),
                            Text(Utils.getFormattedDate(_date),style: const TextStyle(color: Colors.black,fontFamily: 'Roboto',fontWeight: FontWeight.w300),)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                ///sort order and is active
                Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextField(
                        style: const TextStyle(fontSize: 18),
                        controller: _sortOrderController,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.deepOrange,
                        decoration: InputDecoration(
                          labelText: 'Sort Order',
                          labelStyle: TextStyle(color: Colors.grey[700],fontFamily:'Roboto',fontWeight: FontWeight.w300,fontSize: 12),
                          floatingLabelStyle: const TextStyle(color: Colors.blue),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.deepOrange),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 50,),
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
                const SizedBox(height: 30),
                ///Buttons
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
                            createCompany();
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
                            updateCompany();
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

  void updateCompanyWithoutImage() {
    _model.updateCompany(
        _token,
        _companyId!,
        _companyNameController.text.toString(),
        _addressController.text.toString(),
        _phoneNoController.text.toString(),
        _aboutController.text.toString(),
        imageUrl,
        _date,
        _sortOrderController.text.toString(),
        _isActive
    ).then((value){
      Navigator.of(context).pop();   //dismiss loading
      setState(() {
        _selectedValue = null;
      });
      showSuccessScaffold(context, value?.message ?? "Success");
    }).catchError((error){
      Navigator.of(context).pop();                                              //dismiss loading
      showErrorDialog(context, error.toString());
    });
  }

  bool validateInput() {
    if(_companyNameController.text.toString().isEmpty){
      setState(() {
        _companyErrorText = "Company Name is required";
      });
      return false;
    }else{
      setState(() {
        _companyErrorText = null;
      });
    }
    return true;
  }

  void clearTextField(){
    _companyNameController.clear();
    _phoneNoController.clear();
    _addressController.clear();
    _aboutController.clear();
    _sortOrderController.clear();
  }

  void bindCompanyData(String name){
    CompaniesVo company = companies.firstWhere((company) => company.companyName == name);
    imageUrlForCompanyImage =  company.getImageWithBaseUrl();
    imageUrl = company.companyLogo ?? '';
    _companyId = company.id ?? 0;
    _companyNameController.text = company.companyName ?? '';
    _addressController.text = company.address ?? '';
    _phoneNoController.text = company.phoneNO ?? '';
    _aboutController.text = company.about ?? '';
    _date = company.startDate ?? '';
    _sortOrderController.text = company.sortOrder.toString();
    _isActive = company.isActive!;
  }

  Future<File> xFileToFile(XFile xFile) async {
    // Use the path property of XFile to create a File
    return File(xFile.path);
  }
}


