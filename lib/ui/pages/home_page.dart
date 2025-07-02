import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/ui/components/home_banner_card.dart';
import 'package:pahg_group/ui/pages/business_group_page.dart';
import 'package:pahg_group/ui/pages/news_feed_page.dart';
import 'package:pahg_group/ui/themes/colors.dart';
import 'package:provider/provider.dart';
import '../../bloc/home_bloc.dart';
import '../../data/vos/category_vo.dart';
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
          title: const Text('U M C C C', style: TextStyle(color: Colors.white,fontFamily: 'NotoSans',fontWeight: FontWeight.w500)),
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
            const SliverToBoxAdapter(
              child: HomeBannerCard(),
            ),

            ///category list
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 60,
                  child: Selector<HomeBloc,List<CategoryVo>>(
                    selector: (context,bloc) => bloc.categoryList,
                    builder: (context,categoryList,_){
                      return categoryList.isNotEmpty
                            ? ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: categoryList.length,
                                itemBuilder: (context, index) {
                                  return CategoryCardWidget(
                                      category: categoryList[index]);
                                },
                              )
                            : const SizedBox(height: 20);
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
                          return Text('Nothing');
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
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'checkout-fab',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BusinessGroupPage(),
              ),
            );
          },
          label: const Text('Businesses',style: TextStyle(color: Colors.black,fontFamily: 'NotoSans')),
          icon: const Icon(Icons.group,color: goldColor),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }


}

class CategoryCardWidget extends StatelessWidget {
  final CategoryVo category;

  const CategoryCardWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Define a light color for the card in dark mode
    final cardBackgroundColor = isDark
        ? const Color(0xFFFAFAFA) // Light grey in dark mode
        : theme.cardColor;

    final textColor = isDark
        ? Colors.black // To contrast with light card in dark mode
        : theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsFeedPage(
                categoryId: category.id ?? 0,
                categoryName: category.category ?? ' ',
              ),
            ),
          );
        },
        child: Card(
          color: cardBackgroundColor,
          elevation: isDark ? 2 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            alignment: Alignment.center,
            child: Text(
              category.category ?? '',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Ubuntu',
                color: textColor,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          fontFamily: 'Ubuntu',
        ),
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required String title,
    required String iconPath,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        width: 24,
        color: iconColor ?? Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              child: Center(
                child: Image.asset('assets/umccc_logo.png', width: 100),
              ),
            ),

            _buildListTile(
              context: context,
              title: 'My Profile',
              iconPath: 'lib/icons/profile.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeProfilePage(userId: userId),
                  ),
                );
              },
            ),

            _buildListTile(
              context: context,
              title: 'Add Employee',
              iconPath: 'lib/icons/add_person.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const AddEmployeePage(isAdd: true, userId: ''),
                  ),
                );
              },
            ),

            const Divider(indent: 16, endIndent: 16),
            _buildSectionTitle('Company'),

            _buildListTile(
              context: context,
              title: 'Add Business',
              iconPath: 'lib/icons/edit_company.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCompanyPage(isAdd: true),
                  ),
                );
              },
            ),

            _buildListTile(
              context: context,
              title: 'Edit Business',
              iconPath: 'lib/icons/add_company.png',
              iconColor: Colors.deepOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCompanyPage(isAdd: false),
                  ),
                );
              },
            ),

            const Divider(indent: 16, endIndent: 16),
            _buildSectionTitle('Department'),

            _buildListTile(
              context: context,
              title: 'Add Department',
              iconPath: 'lib/icons/add_dept.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddDepartmentPage(isAdd: true),
                  ),
                );
              },
            ),

            _buildListTile(
              context: context,
              title: 'Edit Department',
              iconPath: 'lib/icons/edit_dept.png',
              iconColor: Colors.deepOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const AddDepartmentPage(isAdd: false),
                  ),
                );
              },
            ),

            const Divider(indent: 16, endIndent: 16),
            _buildSectionTitle('Position'),

            _buildListTile(
              context: context,
              title: 'Add Position',
              iconPath: 'lib/icons/add_chair.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPositionPage(isAdd: true),
                  ),
                );
              },
            ),

            _buildListTile(
              context: context,
              title: 'Edit Position',
              iconPath: 'lib/icons/edit_chair.png',
              iconColor: Colors.deepOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPositionPage(isAdd: false),
                  ),
                );
              },
            ),

            const Divider(indent: 16, endIndent: 16),
            _buildSectionTitle('Category'),

            _buildListTile(
              context: context,
              title: 'Add Category',
              iconPath: 'lib/icons/categories.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCategoryPage(isAdd: true),
                  ),
                );
              },
            ),

            _buildListTile(
              context: context,
              title: 'Edit Category',
              iconPath: 'lib/icons/categories.png',
              iconColor: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCategoryPage(isAdd: false),
                  ),
                );
              },
            ),

            _buildListTile(
              context: context,
              title: 'Add Facility',
              iconPath: 'lib/icons/facility_icon.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFacilityPage(isAdd: true),
                  ),
                );
              },
            ),

            _buildListTile(
              context: context,
              title: 'Edit Facility',
              iconPath: 'lib/icons/facility_icon.png',
              iconColor: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const AddFacilityPage(isAdd: false),
                  ),
                );
              },
            ),

            const Divider(indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Change Password',style: TextStyle(fontWeight: FontWeight.w400),),
                onTap: (){
                  showChangePasswordDialog(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Log out',style: TextStyle(fontWeight: FontWeight.w400,color: Colors.red),),
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
