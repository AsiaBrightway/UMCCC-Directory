
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/company_images_vo.dart';
import '../../data/vos/department_vo.dart';
import '../../data/vos/employee_vo.dart';
import '../../data/vos/request_body/get_request.dart';
import '../../exception/helper_functions.dart';
import '../providers/auth_provider.dart';
import 'employee_profile_page.dart';
import 'search_page.dart';

class CompanyDetailsPage extends StatefulWidget {
  final int companyId ;
  final String companyName;
  const CompanyDetailsPage({super.key, required this.companyId, required this.companyName});
  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  bool _isLoading = false;
  String _token = '';
  int _role = 0;
  List<EmployeeVo> employeeList = [];
  String? _selectedValue = "All";
  final PahgModel _model = PahgModel();
  final String companyName = "";
  List<CompanyImagesVo> companyImages = [];
  List<DepartmentVo> departments = [];
  final ScrollController _scrollController = ScrollController();
  bool _hasMore = true;
  File? _image;
  int _pageNumber = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initializeData() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
    _token = authProvider.token;
    _role = authProvider.role;
    GetRequest request = GetRequest(columnName: "CompanyId", columnCondition : 1, columnValue: widget.companyId.toString());
    _model.getCompanyImages(_token, request).then((response){
      setState(() {
        companyImages = response;
      });
    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Company Images Error : ${error.toString}"),
      ));
    });
    _model.getDepartmentListByCompany(_token, request).then((response){
      setState(() {
        departments = [DepartmentVo(0, widget.companyId, "All", true),...response];
      });
    });
    _fetchEmployee();
  }

  Future<void> _onRefreshBanner() async{
    GetRequest request = GetRequest(columnName: "CompanyId", columnCondition : 1, columnValue: widget.companyId.toString());
    _model.getCompanyImages(_token, request).then((response){
      setState(() {
        companyImages = response;
      });
    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Company Images Error : ${error.toString}"),
      ));
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore) {
      _fetchEmployee();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchEmployee(){
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
    });
    GetRequest request = GetRequest(columnName: "CompanyId", columnCondition : 1, columnValue: widget.companyId.toString());
    List<GetRequest> requestList = [request];
    // Check if more data exists
    _model.getEmployees(_token, requestList,_pageNumber,_pageSize).then((onValue){
      setState(() {
        _isLoading = false;
        employeeList.addAll(onValue);
        _hasMore = onValue.length == _pageSize; // Check if more data exists
        _pageNumber++;
      });
    }).catchError((onError){
      setState(() {
        _isLoading = false;
      });
      showErrorRefreshDialog(context, onError.toString(),_initializeData);
    });
  }

  void onDropDownChanged(String newValue){
    if(newValue == "All"){
      employeeList = [];
      _hasMore = true;
      _fetchEmployee();
    }else{
      GetRequest request = GetRequest(columnName: "CompanyId", columnCondition : 1, columnValue: widget.companyId.toString());
      int? deptId = departments.firstWhere((department) => department.departmentName == newValue).id;
      GetRequest deptRequest = GetRequest(columnName: "DepartmentId", columnCondition : 1, columnValue: deptId.toString());
      List<GetRequest> requestList = [request,deptRequest];
      _model.getEmployees(_token, requestList,1,100).then((onValue){
        setState(() {
          _pageNumber = 1;
          _hasMore = false;
          employeeList = onValue;
        });
      }).catchError((onError){
        showErrorDialog(context, onError.toString());
      });
    }
  }

  void _deleteBannerImage(int id) {
    if(_role == 1){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: const Text('Delete' ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            content: const Text('Are you sure to delete image?',style: TextStyle(fontSize: 16),),
            actions: <Widget>[
              TextButton(
                child: const Text("cancel"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _model.deleteCompanyImage(_token, id).then((onValue){
                    if(onValue?.code == 1){
                      _onRefreshBanner();
                      showSuccessScaffold(context, onValue?.message ?? "Success");
                    }else{
                      showErrorDialog(context, onValue?.message ?? "Not deleted");
                    }
                  }).catchError((onError){
                    showErrorDialog(context, onError.toString());
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _uploadImage(File image) async{
    _model.uploadImage(_token, image).then((onValue){
      _uploadImageToCompany(onValue!.file!);
    }).catchError((onError){
      showScaffoldMessage(context, onError.toString());
    });
  }

  Future<void> _uploadImageToCompany(String imageUrl) async{
    _model.addCompanyImages(_token, widget.companyId, imageUrl).then((response){
      setState(() {
        _onRefreshBanner();
      });
      showSuccessScaffold(context, response?.message ?? "success");
    }).catchError((onError){
      showErrorDialog(context, onError.toString());
    });
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: (){
                _navigateToSearch();
              },
              icon: const Icon(Icons.person_search,color: Colors.white)),
          (_role == 1)
              ? IconButton(
              onPressed: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
                if(file != null){
                  _image = File(file.path);
                  _uploadImage(_image!);
                }
              },
              icon: const Icon(Icons.add_a_photo,color: Colors.white))
              : const SizedBox(width: 1),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: _onBackPressed,
        ),
        title: Text(widget.companyName,style: const TextStyle(fontFamily: 'Ubuntu',color: Colors.white)),
        centerTitle: (_role != 1),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
              child: Column(
                children : [
                  const SizedBox(height: 10),
                  (companyImages.isEmpty)
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: Image.asset('assets/placeholder_image.png',color: Theme.of(context).colorScheme.onSurface,
                          fit: BoxFit.cover),
                    ),
                  )
                      : CompanyBannerCard(imagesVo: companyImages,onDelete: _deleteBannerImage,),
                  const SizedBox(height: 16),
                  ///drop down button
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width -36,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          value: _selectedValue,
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
                              _selectedValue = newValue;
                              onDropDownChanged(newValue!);
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
                            elevation: 4,
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
                  const SizedBox(height: 10,),
                ],
              )
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == employeeList.length) {
                  return Center(
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const SizedBox());
                }
                final employee = employeeList[index];
                return _employeeCard(employee: employee);
              },
              childCount: employeeList.length +
                  (_isLoading ? 1 : 0), // Include loading indicator
            ),
          ),
        ],
      ),
    );
  }

  Widget _employeeCard({required EmployeeVo employee}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
        child : GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfilePage(userId: employee.id!)));
          },
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5, // Extends the shadow beyond the box
                      blurRadius: 7, // Blurs the edges of the shadow
                      offset: const Offset(0, 3)
                  ),
                ],
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                        imageUrl :employee.getImageWithBaseUrl(),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 80,
                          width: 80,
                          color: Colors.grey[200],
                          child: Image.asset("assets/person_placeholder.jpg"),
                        ),
                      ),
                    )
                ),
                const SizedBox(width: 16,),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee.employeeName!,style: const TextStyle(
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500
                      )),
                      const SizedBox(height: 10),
                      Text(employee.departmentName!,style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w300
                      ),)
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  void _navigateToSearch(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(companyName: widget.companyName,companyId:widget.companyId,token: _token,searchType: 2)));
  }
}

class CompanyBannerCard extends StatefulWidget {
  final List<CompanyImagesVo> imagesVo ;
  final Function(int id) onDelete;
  const CompanyBannerCard({super.key, required this.imagesVo, required this.onDelete});

  @override
  State<CompanyBannerCard> createState() => _CompanyBannerCardState();
}


class _CompanyBannerCardState extends State<CompanyBannerCard> {
  final _pageController = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Banner Page View
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.22,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imagesVo.length,
              itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GestureDetector(
                        onLongPress: (){
                          widget.onDelete(widget.imagesVo[index].id!);
                        },
                        child: Image.network(
                          widget.imagesVo[index].getImageWithBaseUrl(),
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
              }),
        ),
        ///Spacer
        const SizedBox(height: 16),
        ///dots indicator
        SmoothPageIndicator(
            controller: _pageController,
            count: widget.imagesVo.length,
          effect: const SlideEffect(
            dotColor: Colors.grey,
            activeDotColor: Colors.blueAccent,
            dotWidth: 8,
            dotHeight: 8
          ),
          onDotClicked: (index){
              _pageController.jumpToPage(index);
          },
        )
      ],
    );
  }
}



