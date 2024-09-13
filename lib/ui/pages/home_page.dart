
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pahg_group/state/company_list/company_list_notifier.dart';
import 'package:pahg_group/state/company_list/company_list_state.dart';
import 'package:pahg_group/widgets/error_employee_widget.dart';
import 'package:provider/provider.dart';

import '../../data/vos/companies_vo.dart';
import '../components/my_drawer.dart';
import '../components/user_drawer.dart';
import '../providers/auth_provider.dart';
import 'company_details_page.dart';
import 'search_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _token = '';
  String _userId = '';
  int _role = 0;
  CompanyListNotifier? companyListNotifier;
  final companyNotifierProvider = NotifierProvider<CompanyListNotifier,CompanyListState>((){
    return CompanyListNotifier();
  });

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _initializeData());
  }

  Future<void> _initializeData() async {
    final authModel = context.read<AuthProvider>();
    setState(() {
      _token = authModel.token;
      _userId = authModel.userId;
      _role = authModel.role;
    });
    companyListNotifier?.getCompanyList(_role, _token, _userId);
  }

  @override
  Widget build(BuildContext context) {
    companyListNotifier = ref.read(companyNotifierProvider.notifier);
    final companyListState = ref.watch(companyNotifierProvider);

    return Scaffold(
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
      body: switch(companyListState){

        CompanyListLoading() => const Center(child: CircularProgressIndicator(),),

        CompanyListFailed(error : String error) => Center(
          child: ErrorEmployeeWidget(
            errorEmployee: error,
            tryAgain: () => companyListNotifier?.getCompanyList(_role, _token, _userId),
          ),
        ),

        CompanyListSuccess(companies : List<CompaniesVo> companies) => RefreshIndicator(
          onRefresh: () async {
            companyListNotifier?.getCompanyList(_role, _token, _userId);
          },
          child: ListView.builder(
            itemCount: companies.length,
            itemBuilder: (context, index) {
              return companyCardWidget(companies: companies[index], index: index)                   ;// return GestureDetector(
            },
          ),
        ),

        WidgetForEmployee() => Center(child: Image.asset('lib/icons/team_vector.png')),
      }
    );
  }

  Widget companyCardWidget({required CompaniesVo companies,required int index}){
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
            navigateToCompany(context,index,companies);
          },
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      companies.getImageWithBaseUrl(),width: 80,height: 80,fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace){
                        return Image.asset('assets/simple_placeholder.png',width: 90,height: 90,fit: BoxFit.cover,);
                      },
                    ),
                  )
              ),
              const SizedBox(width: 16,),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(companies.companyName!,style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    )),
                    const SizedBox(height: 10),
                    Text(companies.address!)
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

