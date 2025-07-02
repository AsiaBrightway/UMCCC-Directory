import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/group_bloc.dart';
import 'package:pahg_group/ui/pages/search_page.dart';
import 'package:provider/provider.dart';

import '../../bloc/home_bloc.dart';
import '../../data/vos/companies_vo.dart';
import '../../widgets/error_employee_widget.dart';
import '../providers/auth_provider.dart';
import '../shimmer/home_shimmer.dart';
import 'company_details_page.dart';

class BusinessGroupPage extends StatefulWidget {
  const BusinessGroupPage({super.key});

  @override
  State<BusinessGroupPage> createState() => _BusinessGroupPageState();
}

class _BusinessGroupPageState extends State<BusinessGroupPage> {
  String _token = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupBloc(_token),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[800],
            iconTheme: const IconThemeData(
              color: Colors.white, // Set the drawer icon color
            ),
            title: const Text('U M C C C', style: TextStyle(color: Colors.white,fontFamily: 'NotoSans',fontWeight: FontWeight.w500)),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(token: _token,searchType: 1)));
                  },
                  icon: const Icon(Icons.search,color: Colors.white)
              )
            ],
          ),
        body: Selector<GroupBloc,HomeState>(
          selector: (context,bloc) => bloc.homeState,
          builder: (context,homeState,_){
            var bloc = context.read<GroupBloc>();
            if(homeState == HomeState.error){
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorEmployeeWidget(errorEmployee: '', tryAgain: () => bloc.getCompanyList()),
                ],
              );
            }
            else if(homeState == HomeState.success){
              return StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: bloc.companyList.length,
                      itemBuilder: (context, index) {
                        return companyCardWidget(company: bloc.companyList[index], index: index);
                      });
                }
              );
            }
            ///this state was used for employee
            else if(homeState == HomeState.initial){
              return Center(child: Image.asset('lib/icons/team_vector.png'));
            }
            else {
              return const HomeShimmer();
            }
          },
        )
      ),
    );
  }

  Widget companyCardWidget({required CompaniesVo company,required int index}){
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: screenWidth >= 600
          ? const EdgeInsets.symmetric(horizontal: 16,vertical: 8)
          : const EdgeInsets.all(8.0),
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
          borderRadius: BorderRadius.circular(12),
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
}
