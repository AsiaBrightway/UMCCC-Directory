import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../bloc/search_employee_bloc.dart';
import '../../data/vos/data_class_for_search_bloc.dart';
import '../../data/vos/employee_vo.dart';
import 'employee_profile_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.token, required this.searchType, this.companyName, this.companyId,});
  final String token;
  final int searchType;
  final String? companyName;
  final int? companyId;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin{
  EntityType _selectedEntity = EntityType.person;

  final _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late SearchEmployeeBloc _searchEmployeeBloc ;

  @override
  void initState() {
    super.initState();
    _searchEmployeeBloc = SearchEmployeeBloc(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchEmployeeBloc.onDispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    final trackColor = Colors.grey.shade300;
    final selectedTextColor = Colors.black;
    final unselectedTextColor = Colors.grey.shade600;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: _onBackPressed,
        ),
        backgroundColor: Colors.blue.shade800,
        title: const Text("SEARCH",style: TextStyle(color: Colors.white,fontSize: 14),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              padding: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                  borderRadius: BorderRadius.circular(16)
              ),
              child: TextField(
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  if (widget.searchType == 1) {
                    /// 1 is coming from home page 2 is from company page
                    DataClassForSearchBloc dataClass = DataClassForSearchBloc(
                        widget.token, 1, 0, value,
                        entity: _selectedEntity);
                    _searchEmployeeBloc.queryStreamController.sink
                        .add(dataClass);
                  } else {
                    DataClassForSearchBloc dataClass = DataClassForSearchBloc(
                        widget.token, 2, widget.companyId!, value,
                        entity: _selectedEntity);
                    _searchEmployeeBloc.queryStreamController.sink
                        .add(dataClass);
                  }
                },
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Employee',
                  border: InputBorder.none,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                      : null,
                ),
              ),
            ),
          ),
          (widget.searchType == 2)
              ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text("Results in ${widget.companyName}",
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              )
              : const SizedBox(height: 1),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // First Segment
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedEntity = EntityType.person),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _selectedEntity == EntityType.person ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Person',
                          style: TextStyle(
                            color: _selectedEntity == EntityType.person ? selectedTextColor : unselectedTextColor,
                            fontWeight: _selectedIndex == 0 ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //  Second Segment
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedEntity = EntityType.business),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _selectedEntity == EntityType.business ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Business',
                          style: TextStyle(
                            color: _selectedEntity == EntityType.business ? selectedTextColor : unselectedTextColor,
                            fontWeight: _selectedIndex == 1 ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder(
              stream: _searchEmployeeBloc.employeeStreamController.stream,
              builder: (context, snapshot) {
                if(snapshot.hasData && snapshot.data != null){
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final employee = snapshot.data![index];
                      return _employeeCard(employee: employee);
                    },
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off),
                          Text(snapshot.error.toString()),
                        ],
                      ));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _employeeCard({required EmployeeVo employee}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeProfilePage(userId: employee.id!),));
        },
        child: Container(
          height: 100,
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
                  child: Hero(
                    tag: 112,
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
                          return Image.asset('assets/person_placeholder.jpg',width: 80,height: 90); // Show error image
                        },
                      ),
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
                  const SizedBox(height: 8),
                  Text(
                      employee.companyName ?? "empty company",
                      style: const TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w300
                      )
                  ),
                  const SizedBox(height: 8),
                  Text(
                      employee.departmentName ?? "empty dept",
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300
                      )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
