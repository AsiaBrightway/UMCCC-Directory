
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/data/models/pahg_model.dart';
import 'package:pahg_group/data/vos/companies_vo.dart';
import 'package:pahg_group/exception/helper_functions.dart';
import 'package:pahg_group/ui/pages/company_details_page.dart';
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
  String errorMessage = '';
  List<CompaniesVo> companies = [];

  @override
  void didChangeDependencies() {
    final authModel = Provider.of<AuthProvider>(context);
    _token = authModel.token;
    _userId = authModel.userId;
    _role = authModel.role;
    if(_role == 1 || _role == 2){
      _model.getCompanies(_token).then((companies) {
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
    super.didChangeDependencies();
  }

  Future<void> _refresh() async{
    if(_role == 1 || _role == 2){
      _model.getCompanies(_token).then((companies) {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          backgroundColor: Colors.grey,
          content: const Text("Refresh Complete",style: TextStyle(color: Colors.white),),
          duration: Duration(seconds: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 50),
          behavior: SnackBarBehavior.floating,
        ));
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
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.search,color: Colors.white)
          )
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
                  return CompanyCardWidget(companies: companies[index], index: index)                   ;// return GestureDetector(
                },
              ),
          )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(child: Text(errorMessage)),
    );
  }

  Widget CompanyCardWidget({required CompaniesVo companies,required int index}){
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
              Column(
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

