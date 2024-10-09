
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pahg_group/ui/pages/news_feed_page.dart';
import 'package:provider/provider.dart';
import '../../bloc/home_bloc.dart';
import '../../data/vos/category_vo.dart';
import '../../data/vos/companies_vo.dart';
import '../../widgets/error_employee_widget.dart';
import '../components/my_drawer.dart';
import '../components/user_drawer.dart';
import '../providers/auth_provider.dart';
import '../shimmer/home_shimmer.dart';
import 'company_details_page.dart';
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
  }

  Future<void> _initializeData() async {
    final authModel = Provider.of<AuthProvider>(context,listen: false);
      _token = authModel.token;
      _userId = authModel.userId;
      _role = authModel.role;
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
            const SliverToBoxAdapter(
              child: SizedBox(height: 8),
            ),
            ///category list
            SliverToBoxAdapter(
              child: SizedBox(
                height: 60,
                child: Selector<HomeBloc,List<CategoryVo>>(
                  selector: (context,bloc) => bloc.categoryList,
                  builder: (context,countryList,_){
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: countryList.length,
                      itemBuilder: (context,index){
                          return CategoryCardWidget(category: countryList[index]);
                        },
                    );
                  },
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
                          return companyCardWidget(companies: bloc.companyList[index], index: index);
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

class CategoryCardWidget extends StatelessWidget {
  final CategoryVo category;
  const CategoryCardWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsFeedPage(categoryId: category.id!,categoryName: category.category ?? ' ',),));
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


