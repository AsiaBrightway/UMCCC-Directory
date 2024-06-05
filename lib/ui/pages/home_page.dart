import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the drawer icon color
        ),
        title: const Text(
          'P A H G',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.search,color: Colors.white)
          )
        ],
      ),
      drawer:  _role==1 ? const MyDrawer() : const UserDrawer() ,
      body: (companies.isNotEmpty)
          ? ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        String mCompanyName =
                            companies[index].companyName ?? '';
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompanyDetailsPage(
                                companyName: mCompanyName,
                                companyId: companies[index].id ?? 1,
                              ),
                            ));
                      },
                      child: CompanyCardWidget(companies: companies[index]));

              },
            )
          : isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(child: Text(errorMessage)),
    );
  }
}

class CompanyCardWidget extends StatelessWidget {
  const CompanyCardWidget({
    super.key,
    required this.companies,
  });

  final CompaniesVo companies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
              // child: Container(
              //   width: 80,
              //   height: 80,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(12),
              //     image: DecorationImage(
              //       image: CachedNetworkImage(imageUrl: companies.getImageWithBaseUrl(),),
              //       fit: BoxFit.cover
              //     )
              //   ),
              // )
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
    );
  }
}
