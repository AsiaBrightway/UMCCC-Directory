
import 'dart:io';

import 'package:pahg_group/data/vos/company_images_vo.dart';
import 'package:pahg_group/data/vos/department_vo.dart';
import 'package:pahg_group/data/vos/education_school_vo.dart';
import 'package:pahg_group/data/vos/employee_vo.dart';
import 'package:pahg_group/data/vos/facility_assign_vo.dart';
import 'package:pahg_group/data/vos/facility_vo.dart';
import 'package:pahg_group/data/vos/family_vo.dart';
import 'package:pahg_group/data/vos/graduate_vo.dart';
import 'package:pahg_group/data/vos/language_vo.dart';
import 'package:pahg_group/data/vos/nrc_township_vo.dart';
import 'package:pahg_group/data/vos/personal_info_vo.dart';
import 'package:pahg_group/data/vos/position_vo.dart';
import 'package:pahg_group/data/vos/post_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_category_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_company_image_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_company_request.dart';
import 'package:pahg_group/data/vos/request_body/add_department_request.dart';
import 'package:pahg_group/data/vos/request_body/add_employee_request.dart';
import 'package:pahg_group/data/vos/request_body/add_family_request.dart';
import 'package:pahg_group/data/vos/request_body/add_graduate_request.dart';
import 'package:pahg_group/data/vos/request_body/add_language_request.dart';
import 'package:pahg_group/data/vos/request_body/add_position_request.dart';
import 'package:pahg_group/data/vos/request_body/add_post_request.dart';
import 'package:pahg_group/data/vos/request_body/add_school_request.dart';
import 'package:pahg_group/data/vos/request_body/add_training_request.dart';
import 'package:pahg_group/data/vos/request_body/add_work_request.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import 'package:pahg_group/data/vos/request_body/login_request.dart';
import 'package:pahg_group/data/vos/request_body/path_user_request.dart';
import 'package:pahg_group/network/responses/facility_assign_response.dart';
import '../../network/data_agents/pahg_data_agent.dart';
import '../../network/data_agents/pahg_data_agent_impl.dart';
import '../../network/responses/post_method_response.dart';
import '../vos/category_vo.dart';
import '../vos/companies_vo.dart';
import '../vos/image_vo.dart';
import '../vos/request_body/personal_info_request.dart';
import '../vos/request_body/update_employee_request.dart';
import '../vos/token_vo.dart';
import '../vos/training_vo.dart';
import '../vos/user_vo.dart';
import '../vos/work_vo.dart';

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

  Future<List<CompaniesVo>> getActiveCompanies(String apiKey) async{
    var companies = await mDataAgent.getCompanies(apiKey);
    var activeCompanies = companies.where((company) => company.isActive!).toList();
    return activeCompanies;
  }
  
  Future<CompaniesVo> getCompanyId(String apiKey,int companyId){
    CompaniesVo company = CompaniesVo(0, '', '', '', '', '', null, 10, false);
    return mDataAgent.getCompanyById(apiKey, companyId).asStream().map((response) => response?.document ?? company).first;
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

  Future<PostMethodResponse?> addCompanyImages(String apiKey,int id,String imageUrl){
    AddCompanyImageVo addCompanyRequest = AddCompanyImageVo(0, id, imageUrl);
    return mDataAgent.addCompanyImages(apiKey, addCompanyRequest);
  }

  Future<PostMethodResponse?> deleteCompanyImage(String apiKey,int id){
    return mDataAgent.deleteCompanyImage(apiKey, id);
  }

  Future<List<EmployeeVo>> getEmployees(String apiKey,List<GetRequest> request,int pageNumber,int pageSize){
    return mDataAgent.getEmployees(apiKey, request,pageNumber,pageSize).asStream().map((response) => response?.document?.records ?? []).first;
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

  Future<EmployeeVo?> getEmployeeById(String apiKey,String userId){
    return mDataAgent.getEmployeeById(apiKey, userId).asStream().map((response) => response?.document).first;
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

  Future<List<EmployeeVo>> searchEmployeeResult(String apiKey,int itemsPerPage,String searchName){
    return mDataAgent.searchEmployee(apiKey,itemsPerPage, searchName).asStream().map((response) => response?.document?.records ?? []).first;
  }


  Future<List<EmployeeVo>> searchEmployeeByCompany(String apiKey,String searchName,String id){
    return mDataAgent.searchEmployeeByCompany(apiKey, searchName, id).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<List<FamilyVo>> getFamilyList(String apiKey,String columnName,String columnValue){
    GetRequest request = GetRequest(columnName: columnName, columnCondition: 1, columnValue: columnValue);
    List<GetRequest> requestList = [request];
    return mDataAgent.getFamilies(apiKey, requestList).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> updateFamily(String apiKey,int id,AddFamilyRequest request){
    return mDataAgent.updateFamily(apiKey, id, request);
  }

  Future<PostMethodResponse?> addFamily(String apiKey,AddFamilyRequest request){
    return mDataAgent.addFamily(apiKey, request);
  }

  Future<PostMethodResponse?> deleteFamily(String apiKey,int id){
    return mDataAgent.deleteFamily(apiKey, id);
  }

  Future<PostMethodResponse?> changeUserInfo(String apiKey,String id,PathUserRequest request){
    List<PathUserRequest> requestList = [request];
    return mDataAgent.changeUserInfo(apiKey, id, requestList);
  }

  Future<PostMethodResponse?> patchPersonalInfo(String apiKey,int id,PathUserRequest request){
    List<PathUserRequest> requestList = [request];
    return mDataAgent.patchPersonalInfo(apiKey, id, requestList);
  }

  Future<PostMethodResponse?> patchEducationGraduates(String apiKey,int id,PathUserRequest request){
    List<PathUserRequest> requestList = [request];
    return mDataAgent.patchEducationGraduates(apiKey, id, requestList);
  }

  Future<PostMethodResponse?> patchLanguage(String apiKey,int id,PathUserRequest request){
    List<PathUserRequest> requestList = [request];
    return mDataAgent.patchLanguage(apiKey, id, requestList);
  }

  Future<PostMethodResponse?> patchTraining(String apiKey,int id,PathUserRequest request){
    List<PathUserRequest> requestList = [request];
    return mDataAgent.patchTraining(apiKey, id, requestList);
  }

  Future<PostMethodResponse?> patchSchool(String apiKey,int id,PathUserRequest request){
    List<PathUserRequest> requestList = [request];
    return mDataAgent.patchSchool(apiKey, id, requestList);
  }

  Future<List<NrcTownshipVo>> getAllTownship(String apiKey){
    return mDataAgent.getTownship(apiKey).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<List<CategoryVo>> getCategories(String apiKey,GetRequest request){
    List<GetRequest> requestList = [request];
    return mDataAgent.getCategories(apiKey, requestList).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addCategory(String apiKey,AddCategoryVo requestBody){
    return mDataAgent.addCategory(apiKey, requestBody);
  }

  Future<PostMethodResponse?> updateCategory(String apiKey,int id,AddCategoryVo requestBody){
    return mDataAgent.updateCategory(apiKey, id, requestBody);
  }

  Future<List<PostVo>> getPosts(String apiKey,GetRequest request,int pageNumber,int limit){
    List<GetRequest> requestList = [request];
    return mDataAgent.getPosts(apiKey,pageNumber,limit,requestList).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addPost(String apiKey,AddPostRequest request){
    return mDataAgent.addPosts(apiKey, request);
  }

  Future<PostMethodResponse?> updatePost(String apiKey,int id,AddPostRequest request){
    return mDataAgent.updatePosts(apiKey, id, request);
  }

  Future<PostMethodResponse?> deletePostById(String apiKey,int id){
    return mDataAgent.deletePosts(apiKey, id);
  }

  Future<List<FacilityVo>?> getAllFacility(String apiKey){
    return mDataAgent.getAllFacility(apiKey).asStream().map((response) => response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addFacility(String apiKey,FacilityVo requestBody){
    return mDataAgent.addFacility(apiKey, requestBody);
  }

  Future<PostMethodResponse?> updateFacility(String apiKey,int id,FacilityVo requestBody){
    return mDataAgent.updateFacility(apiKey, id, requestBody);
  }

  Future<List<FacilityAssignVo>> getFacilityAssignByEmployee(String apiKey,GetRequest request){
    List<GetRequest> requestList = [request];
    return mDataAgent.getFacilityAssignByEmployee(apiKey, requestList).asStream().map((response)=> response?.document?.records ?? []).first;
  }

  Future<PostMethodResponse?> addFacilityAssign(String apiKey,FacilityAssignVo assign){
    return mDataAgent.addFacilityAssign(apiKey, assign);
  }
}