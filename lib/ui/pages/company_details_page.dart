

import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
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
                (companyImages.isEmpty)?
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                      height: 180,
                      child: Image.asset('assets/placeholder_image.png',fit: BoxFit.cover),
                  ),
                )
                    : CompanyBannerCard(imagesVo: companyImages),

                ///drop down button
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width - 60,
                    child: DropdownButtonFormField<String>(
                      value: _selectedValue,
                      hint: const Text('Filter Employee by Department'),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primaryContainer, // Background color of the dropdown
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),

                      ),
                      icon: Icon(Icons.arrow_drop_down,color: Colors.green[300],),
                      iconSize: 24,
                      elevation: 16,
                      items: departments.map((DepartmentVo value) {
                        return DropdownMenuItem<String>(
                          value: value.departmentName,
                          child: Text(value.departmentName ?? '',style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          onDropDownChanged(newValue!);
                        });
                      },
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
    return Container(
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
                    return const Icon(Icons.person,size: 80,); // Show error image
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
                  fontWeight: FontWeight.bold
              )),
              const SizedBox(height: 10),
              Text(employee.departmentName!)
            ],
          )
        ],
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



