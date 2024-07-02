
import 'dart:io';

import 'package:pahg_group/data/vos/companies_vo.dart';
import 'package:pahg_group/data/vos/company_images_vo.dart';
import 'package:pahg_group/data/vos/department_vo.dart';
import 'package:pahg_group/data/vos/education_school_vo.dart';
import 'package:pahg_group/data/vos/employee_vo.dart';
import 'package:pahg_group/data/vos/graduate_vo.dart';
import 'package:pahg_group/data/vos/language_vo.dart';
import 'package:pahg_group/data/vos/personal_info_vo.dart';
import 'package:pahg_group/data/vos/position_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_company_request.dart';
import 'package:pahg_group/data/vos/request_body/add_department_request.dart';
import 'package:pahg_group/data/vos/request_body/add_employee_request.dart';
import 'package:pahg_group/data/vos/request_body/add_graduate_request.dart';
import 'package:pahg_group/data/vos/request_body/add_language_request.dart';
import 'package:pahg_group/data/vos/request_body/add_position_request.dart';
import 'package:pahg_group/data/vos/request_body/add_school_request.dart';
import 'package:pahg_group/data/vos/request_body/add_training_request.dart';
import 'package:pahg_group/data/vos/request_body/add_work_request.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import 'package:pahg_group/data/vos/request_body/login_request.dart';
import 'package:pahg_group/data/vos/request_body/personal_info_request.dart';
import 'package:pahg_group/data/vos/request_body/update_employee_request.dart';
import 'package:pahg_group/data/vos/token_vo.dart';
import 'package:pahg_group/data/vos/training_vo.dart';
import 'package:pahg_group/data/vos/user_vo.dart';
import 'package:pahg_group/data/vos/work_vo.dart';
import 'package:pahg_group/network/data_agents/pahg_data_agent.dart';
import 'package:pahg_group/network/data_agents/pahg_data_agent_impl.dart';
import 'package:pahg_group/network/responses/post_method_response.dart';

import '../vos/image_vo.dart';

class PahgModel {
  static final PahgModel _singleton = PahgModel._internal();

  factory PahgModel(){
    return _singleton;
  }

  PahgModel._internal();

  PahgDataAgent mDataAgent = PahgDataAgentImpl();

  Future<TokenVo> userLogin(String email, String password){
    LoginRequest request = LoginRequest(email, password);
    TokenVo tokenVo = TokenVo('', '', 0);
    return mDataAgent.userLogin(request).asStream().map((response) => response?.tokenVo ?? tokenVo).first;
  }

  Future<List<CompaniesVo>> getCompanies(String apiKey) async {
    List<CompaniesVo> companies = await mDataAgent.getCompanies(apiKey);
    List<CompaniesVo> isActiveCompany = companies.where((company) => company.isActive ?? false).toList();  //when bool is null,return false
    return isActiveCompany;
  }

  Future<List<CompaniesVo>> getAllCompanies(String apiKey) {
    return mDataAgent.getCompanies(apiKey);
  }

  Future<PostMethodResponse?> addCompany(
      String apiKey,String companyName,String address,
      String phoneNo,String about,String companyLogo,
      String startDate,String sortOrder,bool isActive){
    int order = 0;
    if(sortOrder.isNotEmpty){
      order = int.parse(sortOrder);
    }
    AddCompanyRequest request = AddCompanyRequest(0, companyName, address, phoneNo, about, companyLogo, startDate, order, isActive);
     return mDataAgent.addCompany(apiKey, request);
  }

  Future<PostMethodResponse?> updateCompany(String apiKey,int companyId,String companyName,String address,
  String phoneNo,String about,String companyLogo,
  String startDate,String sortOrder,bool isActive){
    int order = 0;
    if(sortOrder.isNotEmpty){
      order = int.parse(sortOrder);
    }
    AddCompanyRequest request = AddCompanyRequest(0, companyName, address, phoneNo, about, companyLogo, startDate, order, isActive);
    return mDataAgent.updateCompany(apiKey, companyId, request);
  }
  Future<List<CompanyImagesVo>> getCompanyImages(String apiKey,GetRequest request){
    List<GetRequest> requestList = [];
    requestList.add(request);
    return mDataAgent.getCompanyImages(apiKey, requestList).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<List<EmployeeVo>> getEmployees(String apiKey,List<GetRequest> request){
    return mDataAgent.getEmployees(apiKey, request).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<List<DepartmentVo>> getDepartmentListByCompany(String apiKey,GetRequest request){
    List<GetRequest> requestList = [];
    requestList.add(request);
    return mDataAgent.getDepartmentListByCompanyId(apiKey, requestList).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addDepartment(String apiKey,int companyId,String departmentName,bool isActive){
    AddDepartmentRequest request = AddDepartmentRequest(0, companyId, departmentName, isActive);
    return mDataAgent.addDepartment(apiKey, request);
  }

  Future<PostMethodResponse?> updateDepartment(String apiKey,int companyId,int deptId,String departmentName,bool isActive){
    AddDepartmentRequest request = AddDepartmentRequest(0, companyId, departmentName, isActive);
    return mDataAgent.updateDepartment(apiKey, deptId, request);
  }

  Future<UserVo?> getUserById(String apiKey,String userId){
    return mDataAgent.getUserById(apiKey, userId).asStream().map((response) => response?.document).first;
  }

  Future<ImageVo?> uploadImage(String apiKey,File file){
    return mDataAgent.uploadImage(apiKey, file).asStream().map((response) => response?.document).first;
  }

  Future<List<PositionVo>> getPositions(String apiKey,String columnName,String deptId){
    var request = GetRequest(columnName: columnName, columnCondition: 1, columnValue: deptId);
    List<GetRequest> requestList = [request];
    return mDataAgent.getPositions(apiKey, requestList).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addPosition(String apiKey,int deptId,String positionName,bool isActive){
    var request = AddPositionRequest(0, deptId, positionName, isActive);
    return mDataAgent.addPosition(apiKey, request);
  }

  Future<PostMethodResponse?> updatePosition(String apiKey,int positionId, int deptId,String position,bool isActive){
    var request = AddPositionRequest(0, deptId, position, isActive);
    return mDataAgent.updatePosition(apiKey, positionId, request);
  }

  Future<PostMethodResponse?> addUser(String apiKey,AddEmployeeRequest request){
    return mDataAgent.addUser(apiKey, request);
  }

  Future<EmployeeVo> getEmployeeById(String apiKey,String userId){
    var empvo = EmployeeVo('0123', '', '', 0, 0, 0, '', '', 'null', 'null', 'null');
    return mDataAgent.getEmployeeById(apiKey, userId).asStream().map((response) => response?.document ?? empvo).first;
  }

  Future<PostMethodResponse?> updateEmployee(String apiKey,String empId,UpdateEmployeeRequest request){
    return mDataAgent.updateEmployeeById(apiKey, empId, request);
  }

  Future<List<PersonalInfoVo>> getPersonalInfo(String apiKey,String columnName,String columnValue){
    GetRequest request = GetRequest(columnName: columnName, columnCondition: 1, columnValue: columnValue);
    List<GetRequest> requestList = [request];
    return mDataAgent.getPersonalInfo(apiKey, requestList).asStream().map((response)=> response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addPersonalInfo(String apiKey,PersonalInfoRequest request){
    return mDataAgent.addPersonalInfo(apiKey, request);
  }

  Future<PostMethodResponse?> updatePersonalInfo(String apiKey,int personalId,PersonalInfoRequest request){
    return mDataAgent.updatePersonalInfo(apiKey, personalId, request);
  }

  Future<List<EducationSchoolVo>> getSchoolList(String apiKey,String columnName,String columnValue){
    GetRequest request = GetRequest(columnName: columnName, columnCondition: 1, columnValue: columnValue);
    List<GetRequest> requestList = [request];
    return mDataAgent.getSchoolList(apiKey, requestList).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> updateSchool(String apiKey,int schoolId,AddSchoolRequest request){
    return mDataAgent.updateSchool(apiKey, schoolId, request);
  }

  Future<PostMethodResponse?> addSchool(String apiKey,AddSchoolRequest request){
    return mDataAgent.addSchool(apiKey, request);
  }

  Future<PostMethodResponse?> deleteSchool(String apiKey,int schoolId){
    return mDataAgent.deleteSchool(apiKey, schoolId);
  }
  
  Future<List<GraduateVo>> getGraduateList(String apiKey,String columnName,String columnValue){
    GetRequest request = GetRequest(columnName: columnName, columnCondition: 1, columnValue: columnValue);
    List<GetRequest> requestList = [request];
    return mDataAgent.getGraduate(apiKey, requestList).asStream().map((response)=> response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addGraduate(String apiKey,AddGraduateRequest request){
    return mDataAgent.addGraduate(apiKey, request);
  }

  Future<PostMethodResponse?> updateGraduate(String apiKey,int id,AddGraduateRequest request){
    return mDataAgent.updateGraduate(apiKey, id, request);
  }

  Future<PostMethodResponse?> deleteGraduate(String apiKey,int id){
    return mDataAgent.deleteGraduate(apiKey, id);
  }

  ///Training CRUD
  Future<List<TrainingVo>> getTrainingList(String apiKey,String columnName,String columnValue){
    GetRequest request = GetRequest(columnName: columnName, columnCondition: 1, columnValue: columnValue);
    List<GetRequest> requestList = [request];
    return mDataAgent.getTrainingList(apiKey, requestList).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addTraining(String apiKey,AddTrainingRequest request){
    return mDataAgent.addTraining(apiKey, request);
  }

  Future<PostMethodResponse?> updateTraining(String apiKey,int id,AddTrainingRequest request){
    return mDataAgent.updateTraining(apiKey, id, request);
  }

  Future<PostMethodResponse?> deleteTraining(String apiKey,int id){
    return mDataAgent.deleteTraining(apiKey, id);
  }

  ///Language CRUD
  Future<List<LanguageVo>> getLanguageList(String apiKey,String columnName,String columnValue){
    GetRequest request = GetRequest(columnName: columnName, columnCondition: 1, columnValue: columnValue);
    List<GetRequest> requestList = [request];
    return mDataAgent.getLanguageList(apiKey, requestList).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addLanguage(String apiKey,AddLanguageRequest request){
    return mDataAgent.addLanguage(apiKey, request);
  }

  Future<PostMethodResponse?> updateLanguage(String apiKey,int id,AddLanguageRequest request){
    return mDataAgent.updateLanguage(apiKey, id, request);
  }

  Future<PostMethodResponse?> deleteLanguage(String apiKey,int id){
    return mDataAgent.deleteLanguage(apiKey, id);
  }

  Future<List<WorkVo>> getWorkList(String apiKey,String columnName,String columnValue){
    GetRequest request = GetRequest(columnName: columnName, columnCondition: 1, columnValue: columnValue);
    List<GetRequest> requestList = [request];
    return mDataAgent.getWorkList(apiKey, requestList).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addWorkExperience(String apiKey,AddWorkRequest request){
    return mDataAgent.addWorkExperience(apiKey, request);
  }

  Future<PostMethodResponse?> updateWorkExperience(String apiKey,int id,AddWorkRequest request){
    return mDataAgent.updateWorkExperience(apiKey, id, request);
  }

  Future<PostMethodResponse?> deleteWorkExperience(String apiKey,int id){
    return mDataAgent.deleteWorkExperience(apiKey, id);
  }
}