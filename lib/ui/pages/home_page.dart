
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/ui/pages/news_feed_page.dart';
import 'package:provider/provider.dart';
import '../../bloc/home_bloc.dart';
import '../../data/vos/category_vo.dart';
import '../../data/vos/companies_vo.dart';
import '../../dialog/change_password_dialog.dart';
import '../../utils/helper_functions.dart';
import '../../widgets/error_employee_widget.dart';
import '../components/user_drawer.dart';
import '../providers/auth_provider.dart';
import '../shimmer/home_shimmer.dart';
import 'add_category_page.dart';
import 'add_company_page.dart';
import 'add_department_page.dart';
import 'add_employee_page.dart';
import 'add_facility_page.dart';
import 'add_position_page.dart';
import 'company_details_page.dart';
import 'employee_profile_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _token = '';
  String _userId = '';
  int _role = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
    requestPermission();

  }

  Future<void> _initializeData() async {
    final authModel = Provider.of<AuthProvider>(context,listen: false);
      _token = authModel.token;
      _userId = authModel.userId;
      _role = authModel.role;
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //debugPrint('User granted permission');
    } else {
      //debugPrint('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create : (context) => HomeBloc(_token,_role,_userId),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the drawer icon color
          ),
          title: const Text('P A H G', style: TextStyle(color: Colors.white),),
          centerTitle: true,
          actions: [
            (_role == 1 || _role == 2)
              ? IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(token: _token,searchType: 1)));
                },
                icon: const Icon(Icons.search,color: Colors.white)
            )
              : const SizedBox(width: 1),
          ],
        ),
        drawer:  _role == 1
            ? MyDrawer(userId: _userId,)
            : UserDrawer(userId: _userId),
        body: CustomScrollView(
          slivers: [

            ///category list
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 60,
                  child: Selector<HomeBloc,List<CategoryVo>>(
                    selector: (context,bloc) => bloc.categoryList,
                    builder: (context,countryList,_){
                      return countryList.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: countryList.length,
                                itemBuilder: (context, index) {
                                  return CategoryCardWidget(
                                      category: countryList[index]);
                                },
                              )
                            : const SizedBox(height: 1);
                    },
                  ),
                ),
              ),
            ),

            ///company list for user 1,2,3
            Selector<HomeBloc,HomeState>(
              selector: (context,bloc) => bloc.homeState,
              builder: (context,homeState,_){
                var bloc = context.read<HomeBloc>();
                if(homeState == HomeState.error){
                  return SliverToBoxAdapter(
                      child: ErrorEmployeeWidget(errorEmployee: bloc.companyError, tryAgain: () => bloc.getCompanyList(_userId))
                  );
                }
                else if(homeState == HomeState.success){
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context,index){
                          return companyCardWidget(company: bloc.companyList[index], index: index);
                        },
                      childCount: bloc.companyList.length
                    ),
                  );
                }
                ///this state was used for employee
                else if(homeState == HomeState.initial){
                  return SliverToBoxAdapter(child: Center(child: Image.asset('lib/icons/team_vector.png')));
                }
                else {
                  return const SliverToBoxAdapter(
                      child: HomeShimmer()
                  );
                }
              },
            ),
          ],
        )
      ),
    );
  }

  Widget companyCardWidget({required CompaniesVo company,required int index}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Ink(
        height: 110,
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
        child: InkWell(
          onTap: (){
            navigateToCompany(context,index,company);
          },
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      company.getImageWithBaseUrl(),width: 80,height: 80,fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace){
                        return Image.asset('assets/simple_placeholder.png',width: 90,height: 90,fit: BoxFit.cover,);
                      },
                    ),
                  )
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.companyName ?? '',style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    )),
                    const SizedBox(height: 10),
                    Text(company.address ?? '')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void navigateToCompany(BuildContext context, int index, CompaniesVo company) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CompanyDetailsPage(
            companyId: company.id ?? 0,
            companyName: company.companyName ?? ''
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}

class CategoryCardWidget extends StatelessWidget {
  final CategoryVo category;
  const CategoryCardWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsFeedPage(categoryId: category.id ?? 0,categoryName: category.category ?? ' ',),));
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
              color: Theme.of(context).colorScheme.onPrimary,
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2, // Extends the shadow beyond the box
                    blurRadius: 2, // Blurs the edges of the shadow
                    offset: const Offset(0, 3)
                ),
            ]
          ),
          child: Center(
            child: Text(
              category.category ?? '',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.userId});
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onError,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: DrawerHeader(
                  child: Image.asset('assets/pahg_logo.png',width: 100,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/profile.png',width: 25,color: Theme.of(context).colorScheme.onSurface,),
                title: const Text('My Profile',style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfilePage(userId: userId),));
                },

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_person.png',width: 25,color: Theme.of(context).colorScheme.onSurface),
                title: const Text('Add Employee',style: TextStyle(fontWeight: FontWeight.w400)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEmployeePage(isAdd: true, userId: '',),));
                },
              ),
            ),
            const Padding(padding:  EdgeInsets.symmetric(horizontal: 8.0), child: Divider()),
            const Padding(padding: EdgeInsets.only(left: 12), child: Text('Company',style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Ubuntu'))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/edit_company.png',width: 25,color: Theme.of(context).colorScheme.onSurface,),
                title: const Text('Add Company',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCompanyPage(isAdd: true)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_company.png',width: 25,color: Colors.deepOrange,),
                title: const Text('Edit Company',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCompanyPage(isAdd: false),));
                },
              ),
            ),
            const Padding(padding:  EdgeInsets.symmetric(horizontal: 8.0), child: Divider(),
            ),
            const Padding(padding: EdgeInsets.only(left: 12), child: Text('Department',style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Ubuntu'),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_dept.png',width: 25,color: Theme.of(context).colorScheme.onSurface,),
                title: const Text('Add Department',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDepartmentPage(isAdd: true)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/edit_dept.png',width: 25,color: Colors.deepOrange,),
                title: const Text('Edit Department',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDepartmentPage(isAdd: false)));
                },
              ),
            ),
            const Padding(padding:  EdgeInsets.symmetric(horizontal: 8.0), child: Divider(),),
            const Padding(padding: EdgeInsets.only(left: 12), child: Text('Position',style: TextStyle(fontSize: 12,color: Colors.grey,fontFamily: 'Ubuntu'))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/add_chair.png',width: 25,color: Theme.of(context).colorScheme.onSurface,),
                title: const Text('Add Position',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPositionPage(isAdd: true),));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: Image.asset('lib/icons/edit_chair.png',width: 25,color: Colors.deepOrange,),
                title: const Text('Edit Position',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPositionPage(isAdd: false),));
                },
              ),
            ),
            const Padding(padding:  EdgeInsets.symmetric(horizontal: 8.0), child: Divider(),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading:  Image.asset('lib/icons/categories.png',width: 25,color: Theme.of(context).colorScheme.onSurface),
                title: const Text('Add Category',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCategoryPage(isAdd: true,),));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading:  Image.asset('lib/icons/categories.png',width: 25,color: Colors.orange,),
                title: const Text('Edit Category',style: TextStyle(fontWeight: FontWeight.w400)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCategoryPage(isAdd: false,),));
                },
              ),
            ),
            ///Facility
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading:  Image.asset('lib/icons/facility_icon.png',width: 25,color: Theme.of(context).colorScheme.onSurface),
                title: const Text('Add Facility',style: TextStyle(fontWeight: FontWeight.w400)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFacilityPage(isAdd: true,)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading:  Image.asset('lib/icons/facility_icon.png',width: 25,color: Colors.orange),
                title: const Text('Edit Facility',style: TextStyle(fontWeight: FontWeight.w400)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFacilityPage(isAdd: false,),));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  showChangePasswordDialog(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Log out',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  showLogoutDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



