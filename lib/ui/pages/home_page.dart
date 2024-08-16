
import 'package:flutter/material.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/companies_vo.dart';
import 'package:pahg_group/exception/helper_functions.dart';
import 'package:pahg_group/ui/pages/company_details_page.dart';
import 'package:pahg_group/ui/pages/search_page.dart';
import 'package:pahg_group/ui/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../components/my_drawer.dart';
import '../components/user_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _token = '';
  String _userId = '';
  int _role = 0;
  final PahgModel _model = PahgModel();
  bool isLoading = true;
  List<CompaniesVo> companies = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final authModel = Provider.of<AuthProvider>(context,listen: true);
    _token = authModel.token;
    _userId = authModel.userId;
    _role = authModel.role;
    if(_role == 1 || _role == 2){
      _model.getCompanies(_token).then((companies) {
        setState(() {
          this.companies = companies;
        });
      }).catchError((error){
        ///exception can found without toString()
        showErrorDialog(context, error.toString());
      });
    }else if(_role == 3) {
      _model.getEmployeeById(_token, _userId).then((onValue){
        _model.getCompanyId(_token, onValue.companyId ?? 0).then((onValue) {
          setState(() {
            companies = [onValue];
          });
        }).catchError((onError) {
          showErrorDialog(context, onError.toString());
        });
      }).catchError((error){
        showErrorRefreshDialog(context, error.toString(),_initializeData);
      });
    }
    else{
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refresh() async{
    if(_role == 1 || _role == 2){
      _model.getCompanies(_token).then((companies) {
        showSuccessScaffold(context, "Refresh Complete");
        setState(() {
          this.companies = companies;
        });
      }).catchError((error){
        ///exception found without toString()
        showErrorDialog(context, error.toString());
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: (companies.isNotEmpty)
          ? RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  return companyCardWidget(companies: companies[index], index: index)                   ;// return GestureDetector(
                },
              ),
          )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                child: Column(
                  children: [
                    Image.asset('lib/icons/team_vector.png',)
                  ],
                ),
              )
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
            String mCompanyName = companies.companyName ?? '';
            navigateToCompany(context,index,mCompanyName);
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

  void navigateToCompany(BuildContext context, int index, String mCompanyName) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CompanyDetailsPage(
            companyId: companies[index].id ?? 0,
            companyName: mCompanyName
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

