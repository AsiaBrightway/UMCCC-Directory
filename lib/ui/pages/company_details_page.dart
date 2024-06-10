
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import 'package:pahg_group/ui/pages/employee_profile_page.dart';
import 'package:pahg_group/ui/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../data/models/pahg_model.dart';
import '../../data/vos/company_images_vo.dart';
import '../../data/vos/department_vo.dart';
import '../../data/vos/employee_vo.dart';

class CompanyDetailsPage extends StatefulWidget {
  final int companyId ;
  final String companyName;
  const CompanyDetailsPage({super.key, required this.companyId, required this.companyName});
  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  String _token = '';
  late Future<List<EmployeeVo>> employeeFuture;
  String? _selectedValue;
  final PahgModel _model = PahgModel();
  final String companyName = "";
  List<CompanyImagesVo> companyImages = [];
  List<DepartmentVo> departments = [];

  @override
  void didChangeDependencies() {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    _token = authProvider.token;
    GetRequest request = GetRequest(columnName: "CompanyId", columnCondition : 1, columnValue: widget.companyId.toString());
    List<GetRequest> requestList = [request];
    _model.getCompanyImages(_token, request).then((response){
      setState(() {
        companyImages = response;
      });
    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Company Images Error : ${error.toString}"),
      ));
    });
    ///department call
    _model.getDepartmentListByCompany(_token, request).then((response){
      setState(() {
        departments = response;
      });
    });
    employeeFuture = _model.getEmployees(_token, requestList);
    super.didChangeDependencies();
  }

  void onDropDownChanged(String newValue){
    GetRequest request = GetRequest(columnName: "CompanyId", columnCondition : 1, columnValue: widget.companyId.toString());
    int? deptId = departments.firstWhere((department) => department.departmentName == newValue).id;
    GetRequest deptRequest = GetRequest(columnName: "DepartmentId", columnCondition : 1, columnValue: deptId.toString());
    List<GetRequest> requestList = [request,deptRequest];
    setState(() {
      employeeFuture = _model.getEmployees(_token, requestList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(widget.companyName,),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 10),
                (companyImages.isEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          height: 180,
                          child: Image.asset('assets/placeholder_image.png',
                              fit: BoxFit.cover),
                        ),
                      )
                    : CompanyBannerCard(imagesVo: companyImages),
                const SizedBox(height: 16,),
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
            ),
          ),
          ///Employee List
          SliverToBoxAdapter(
            child: FutureBuilder<List<EmployeeVo>>(
              future: employeeFuture,
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Center(child: Text(snapshot.error.toString()),);
                }
                if(snapshot.hasData){
                        return Column(
                          children: snapshot.data!.map((employee){
                            return _employeeCard(employee: employee);
                          }).toList(),
                        );
                }
                return const SizedBox(height: 50,child: Center(child: CircularProgressIndicator()));
              },)
          )
        ],
      ),
    );
  }

  Widget _employeeCard({required EmployeeVo employee}){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfilePage(userId: employee.id!),));
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
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
                  child: Image.network(
                    employee.getImageWithBaseUrl(),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: SizedBox(
                          width: 80,height: 80,
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Image.asset('lib/icons/profile.png',width: 80,height: 90); // Show error image
                    },
                  ),
                )
            ),
            const SizedBox(width: 16,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.employeeName!,style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                )),
                const SizedBox(height: 10),
                Text(employee.departmentName!,style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w300
                ),)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CompanyBannerCard extends StatelessWidget {
  final List<CompanyImagesVo> imagesVo ;
  CompanyBannerCard({super.key, required this.imagesVo });
  final _pageController = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///Banner Page View
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: imagesVo.length,
              itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imagesVo[index].getImageWithBaseUrl(),
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
                  );
              }),
        ),
        ///Spacer
        const SizedBox(height: 16),
        ///dots indicator
        SmoothPageIndicator(
            controller: _pageController,
            count: imagesVo.length,
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



