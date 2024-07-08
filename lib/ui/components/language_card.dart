import 'package:flutter/material.dart';
import 'package:pahg_group/data/vos/language_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_language_request.dart';
import 'package:pahg_group/dialog/language_dialog.dart';
import 'package:pahg_group/ui/themes/colors.dart';

class LanguageCard extends StatefulWidget {
  final LanguageVo language;
  final String token;
  final int userRole;
  final Function(AddLanguageRequest language) onUpdate;
  final Function(String name,int languageId) onDelete;
  const LanguageCard({super.key,required this.token, required this.userRole, required this.onDelete, required this.onUpdate, required this.language});

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
  bool _isExpanded = true;
  bool editMode = true;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  String _proficiencyName(int proficiency){
    switch(proficiency){
      case 1:
        return "Normal";
      case 2:
        return "Good";
      case 3:
        return "Advanced";
      default:
        return "_";
    }
  }

  String _canTeachAndShare(bool teach){
    switch(teach){
      case true:
        return "Yes";
      case false:
        return "No";
      default:
        return "_";
    }
  }

  void _updateLanguage(AddLanguageRequest updatedLanguage){
    widget.onUpdate(updatedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: _toggleExpanded,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4,top: 4.0,bottom: 10,right: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.language.name}",style: const TextStyle(fontSize: 15,fontFamily: 'Ubuntu'),),
                      const Icon(Icons.keyboard_arrow_down,size: 20,)
                    ],
                  ),
                ),
                if(_isExpanded)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Proficiency: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),

                            Text(_proficiencyName(widget.language.proficiency ?? 0),style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            const Text("Can teach: ",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 13),),

                            Expanded(child: Text(_canTeachAndShare(widget.language.teach ?? false),style: const TextStyle(fontWeight: FontWeight.w300,fontSize: 13))),
                          ],
                        ),
                      ),
                      (widget.userRole == 1)
                          ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){
                              showLanguageDialog(context,language: widget.language, onSave: _updateLanguage);
                            }, icon: const Icon(Icons.edit,color: colorAccent)
                            ),
                            IconButton(onPressed: (){
                              widget.onDelete(widget.language.name!,widget.language.id!);
                            }, icon: const Icon(Icons.delete,color: colorAccent)
                            ),
                          ]
                      )
                          : const SizedBox(height: 1)
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
