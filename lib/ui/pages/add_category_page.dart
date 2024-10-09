
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:pahg_group/bloc/add_category_bloc.dart';
import 'package:provider/provider.dart';

import '../../data/vos/category_vo.dart';
import '../providers/auth_provider.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key, required this.isAdd});
  final bool isAdd;
  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {

  String _token = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async{
    final authModel = Provider.of<AuthProvider>(context,listen: false);
    _token = authModel.token;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddCategoryBloc(_token, widget.isAdd),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 26,bottom: 16.0,right: 16,left: 16),
              child: Selector<AddCategoryBloc,List<CategoryVo>?>(
                selector: (context,bloc) => bloc.categoryList,
                builder: (context,categoryList,_){
                  var bloc = context.read<AddCategoryBloc>();
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(widget.isAdd
                            ? "Add Category"
                            : "Edit Category",
                            style: const TextStyle(fontSize: 18,fontFamily: 'Ubuntu',fontWeight: FontWeight.w400)),
                        ///this dropdown is only use for edit category
                        if(!widget.isAdd)
                          Selector<AddCategoryBloc,int?>(
                              selector: (context,bloc) => bloc.updateParentId,
                              builder: (context,updateParentId,_){
                                return Container(
                                  margin: const EdgeInsets.only(top: 18),
                                  height: 50,
                                  width: MediaQuery.of(context).size.width - 36,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      value: updateParentId,
                                      hint: const Text('Select Parent', style: TextStyle(fontSize: 10)),
                                      items: bloc.parentCategoryList?.map((CategoryVo value) {
                                        return DropdownMenuItem<int>(
                                          value: value.id,
                                          child: Text(value.category ?? '', style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        bloc.updateParentId = newValue;
                                      },
                                      buttonStyleData: ButtonStyleData(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.black26,
                                          ),
                                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        height: 40,
                                        width: 140,
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),
                        Selector<AddCategoryBloc,int?>(
                            selector: (context,bloc) => bloc.selectedParentId,
                            builder: (context,selectedParentId,_){
                              return Container(
                                margin: const EdgeInsets.only(top: 18),
                                height: 50,
                                width: MediaQuery.of(context).size.width - 36,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    value: selectedParentId,
                                    hint: const Text('Parent ID', style: TextStyle(fontSize: 10)),
                                    items: categoryList?.map((CategoryVo value) {
                                      return DropdownMenuItem<int>(
                                        value: value.id,
                                        child: Text(value.category ?? '', style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600)),
                                      );
                                    }).toList(),
                                    onChanged: (int? newValue) {
                                      if(widget.isAdd != true){
                                        setState(() {
                                          CategoryVo categoryVo = bloc.categoryList!.firstWhere((category) => category.id == newValue);
                                          bloc.selectedParentId = categoryVo.id;
                                          bloc.isActive = categoryVo.isActive!;
                                          bloc.updateId = newValue;
                                          bloc.updateCategoryName(newValue.toString());
                                        });
                                      }else{
                                        bloc.selectedParentId = newValue;
                                      }
                                    },
                                    buttonStyleData: ButtonStyleData(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.black26,
                                        ),
                                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      height: 40,
                                      width: 140,
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                        const SizedBox(height: 16),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              border: Border.all(color: Colors.grey.shade600),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child: TextField(
                            controller: TextEditingController(text: bloc.categoryName),
                            onChanged: (value) => bloc.updateCategoryName(value),
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                                labelText: 'Category',
                                border: InputBorder.none,
                                labelStyle: TextStyle(fontWeight: FontWeight.w300),
                                floatingLabelBehavior: FloatingLabelBehavior.always
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Selector<AddCategoryBloc,bool>(
                          selector: (context,bloc) => bloc.isActive,
                          builder: (context,isActive,_){
                            return Row(
                              children: [
                                Checkbox(
                                  value: isActive,
                                  activeColor: Colors.green,
                                  onChanged: (value){
                                    bloc.isActive = value!;
                                  },
                                ),
                                const Text("isActive",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300,fontFamily: 'Roboto'),),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        ///Cancel Add Update Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.14,vertical: 18),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel')),
                            const SizedBox(width: 20,),
                            (widget.isAdd)
                                ? ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * 0.14,
                                          vertical: 18),
                                      backgroundColor: Colors.blue,
                                    ),
                                    onPressed: () {
                                      bloc.addCategory(context);
                                    },
                                    child: const Text(
                                      ' Save ',
                                      style: TextStyle(color: Colors.white),
                                    ))
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 5,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width * 0.14,
                                          vertical: 18),
                                      backgroundColor: Colors.orange,
                                    ),
                                    onPressed: () {
                                      bloc.updateCategory(context);
                                    },
                                    child: const Text(
                                      'Update',
                                      style: TextStyle(color: Colors.white),
                                    ))
                          ],
                        ),
                      ]
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
