
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pahg_group/data/vos/companies_vo.dart';
import 'package:pahg_group/data/vos/error_vo.dart';
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
import 'package:pahg_group/data/vos/request_body/personal_info_request.dart';
import 'package:pahg_group/data/vos/request_body/update_employee_request.dart';
import 'package:pahg_group/exception/custom_exception.dart';
import 'package:pahg_group/network/data_agents/pahg_data_agent.dart';
import 'package:pahg_group/network/pahg_api.dart';
import 'package:pahg_group/network/responses/category_response.dart';
import 'package:pahg_group/network/responses/company_by_id_response.dart';
import 'package:pahg_group/network/responses/company_images_response.dart';
import 'package:pahg_group/network/responses/department_list_response.dart';
import 'package:pahg_group/network/responses/employee_list_response.dart';
import 'package:pahg_group/network/responses/employee_response.dart';
import 'package:pahg_group/network/responses/family_response.dart';
import 'package:pahg_group/network/responses/graduate_response.dart';
import 'package:pahg_group/network/responses/image_upload_response.dart';
import 'package:pahg_group/network/responses/language_response.dart';
import 'package:pahg_group/network/responses/login_response.dart';
import 'package:pahg_group/network/responses/personal_info_response.dart';
import 'package:pahg_group/network/responses/position_response.dart';
import 'package:pahg_group/network/responses/post_method_response.dart';
import 'package:pahg_group/network/responses/post_response.dart';
import 'package:pahg_group/network/responses/school_response.dart';
import 'package:pahg_group/network/responses/township_response.dart';
import 'package:pahg_group/network/responses/training_response.dart';
import 'package:pahg_group/network/responses/user_response.dart';
import 'package:pahg_group/network/responses/work_response.dart';

class PahgDataAgentImpl extends PahgDataAgent{

  late PahgApi mApi;

  static PahgDataAgentImpl? _singleton;

  factory PahgDataAgentImpl(){
    _singleton ??= PahgDataAgentImpl._internal();
    return _singleton!;
  }

  PahgDataAgentImpl._internal(){
    final dio = Dio();
    mApi = PahgApi(dio);
  }

  @override
  Future<List<CompaniesVo>> getCompanies(String apiKey) {
    return mApi.getCompanies(apiKey).asStream().map((response) => response?.document?.records ?? []).first
    .catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<CompanyImagesResponse?> getCompanyImages(String apiKey, List<GetRequest> request) {
    return mApi.getCompanyImages(apiKey, request).
    catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> addCompanyImages(String apiKey, AddCompanyImageVo request) {
    return mApi.addCompanyImages(apiKey, request).catchError((onError){
      throw _createException(onError);
    });
  }

  CustomException _createException(dynamic error){
    ErrorVo errorVo;
    if(error is DioException){
      errorVo = _parseDioError(error);
    } else if(error is TypeError){
      errorVo = ErrorVo(statusCode: 0, message: "Type Error : $error");
    }
    else {
      errorVo = ErrorVo(statusCode: 0, message: "Unexcepted Error $error");
    }
    return CustomException(errorVo);
  }

  ErrorVo _parseDioError(DioException error){
    try{
      if(error.response != null && error.response?.data != null){
        var data = error.response?.data;
        ///Json String to Map<String,dynamic>
        if(data is String){
          data = jsonDecode(data);
        }
        return ErrorVo.fromJson(data);
      }else if(error.response?.statusCode == 401){
        return ErrorVo(statusCode: 0, message: 'Unauthorized');
      }
      else if(error.type == DioExceptionType.sendTimeout){
        return ErrorVo(statusCode: 0, message: 'Send Timeout!');
      }
      else if(error.type == DioExceptionType.badResponse){
        return ErrorVo(statusCode: 0, message: 'Bad response');
      }
      else if(error.type == DioExceptionType.connectionError){
        return ErrorVo(statusCode: 0, message: 'Connection Error');
      }
      else if(error.type == DioExceptionType.connectionTimeout){
        return ErrorVo(statusCode: 408, message: 'Connection Timeout!');
      }
      else {
      return ErrorVo(statusCode: 401, message: 'No response data');
    }
    }catch(e){
      return ErrorVo(statusCode: 0, message: 'Invalid DioException Format $e');
    }
  }

  @override
  Future<EmployeeListResponse?> getEmployees(String apiKey, List<GetRequest> request,int pageNo,int pageSize) {
    return mApi.getEmployeesByCompany(apiKey,pageNo,pageSize,request)
        .catchError((error){
          throw _createException(error);
    });
  }

  @override
  Future<DepartmentListResponse?> getDepartmentListByCompanyId(String apiKey, List<GetRequest> request) {
    return mApi.getDepartmentByCompanyId(apiKey, request)
        .catchError((error){
          throw _createException(error);
    });
  }

  @override
  Future<LoginResponse?> userLogin(LoginRequest request) {
    return mApi.loginResponse( request)
        .catchError((error){
          throw _createException(error);
    });
  }

  @override
  Future<UserResponse?> getUserById(String apiKey, String userId) async {
    return mApi.getUserById(apiKey, userId).catchError((error) {
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> addCompany(String apiKey, AddCompanyRequest request) {
    return mApi.addCompany(apiKey, request).catchError((error) {
      throw _createException(error);
    });
  }

  @override
  Future<ImageUploadResponse?> uploadImage(String apiKey, File file) {
    return mApi.uploadImage(apiKey, file).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> updateCompany(String apiKey, int companyId, AddCompanyRequest request) {
    return mApi.updateCompany(apiKey, companyId, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> addDepartment(String apiKey, AddDepartmentRequest request) {
    return mApi.addDepartment(apiKey, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> updateDepartment(String apiKey, int deptId, AddDepartmentRequest request) {
    return mApi.updateDepartment(apiKey, deptId, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PositionResponse?> getPositions(String apiKey, List<GetRequest> request) {
    return mApi.getPosition(apiKey, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> addPosition(String apiKey, AddPositionRequest request) {
    return mApi.addPosition(apiKey, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> updatePosition(String apiKey, int positionId, AddPositionRequest request) {
    return mApi.updatePosition(apiKey, positionId, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> addUser(String apiKey, AddEmployeeRequest request) {
    return mApi.addUser(apiKey, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<EmployeeResponse?> getEmployeeById(String apiKey, String userId) {
    return mApi.getEmployeeById(apiKey, userId).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> updateEmployeeById(String apiKey, String userId, UpdateEmployeeRequest request) {
    return mApi.updateEmployee(apiKey, userId, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PersonalInfoResponse?> getPersonalInfo(String apiKey, List<GetRequest> request) {
    return mApi.getPersonalInfo(apiKey, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> addPersonalInfo(String apiKey, PersonalInfoRequest request) {
    return mApi.addPersonalInfo(apiKey, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> updatePersonalInfo(String apiKey, int personalId, PersonalInfoRequest request) {
    return mApi.updatePersonalInfo(apiKey, personalId, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<SchoolResponse?> getSchoolList(String apiKey, List<GetRequest> request) {
    return mApi.getSchoolList(apiKey, request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> updateSchool(String apiKey, int schoolId, AddSchoolRequest request) {
    return mApi.updateSchool(apiKey,schoolId,request).catchError((error){
      throw _createException(error);
    });
  }

  @override
  Future<PostMethodResponse?> addSchool(String apiKey, AddSchoolRequest request) {
    return mApi.addSchool(apiKey, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> deleteSchool(String apiKey, int schoolId) {
    return mApi.deleteSchool(apiKey, schoolId).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<GraduateResponse?> getGraduate(String apiKey, List<GetRequest> request) {
    return mApi.getGraduateList(apiKey,request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> addGraduate(String apiKey, AddGraduateRequest request) {
    return mApi.addGraduate(apiKey,request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> updateGraduate(String apiKey, int id, AddGraduateRequest request) {
    return mApi.updateGraduate(apiKey,id,request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> deleteGraduate(String apiKey, int id) {
    return mApi.deleteGraduate(apiKey,id).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<TrainingResponse?> getTrainingList(String apiKey, List<GetRequest> request) {
    return mApi.getTraining(apiKey,request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> addTraining(String apiKey, AddTrainingRequest request) {
    return mApi.addTraining(apiKey, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> updateTraining(String apiKey, int id, AddTrainingRequest request) {
    return mApi.updateTraining(apiKey,id, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> deleteTraining(String apiKey, int id) {
    return mApi.deleteTraining(apiKey, id).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<LanguageResponse?> getLanguageList(String apiKey, List<GetRequest> request) {
    return mApi.getLanguageList(apiKey, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> addLanguage(String apiKey, AddLanguageRequest request) {
    return mApi.addLanguage(apiKey, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> updateLanguage(String apiKey, int id, AddLanguageRequest request) {
    return mApi.updateLanguage(apiKey, id, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> deleteLanguage(String apiKey, int id) {
    return mApi.deleteLanguage(apiKey, id).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<WorkResponse?> getWorkList(String apiKey, List<GetRequest> request) {
    return mApi.getWorkList(apiKey, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> addWorkExperience(String apiKey, AddWorkRequest request) {
    return mApi.addWorkExperience(apiKey, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> updateWorkExperience(String apiKey, int id, AddWorkRequest request) {
    return mApi.updateWorkExperience(apiKey, id, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> deleteWorkExperience(String apiKey, int id) {
    return mApi.deleteWorkExp(apiKey, id).catchError((onError){
      throw _createException(onError);
    });
  }

  ///item per page to 50
  @override
  Future<EmployeeListResponse?> searchEmployee(String apiKey,int itemPerPage,String searchKey) {
    return mApi.searchEmployee(apiKey,50, searchKey,).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<EmployeeListResponse?> searchEmployeeByCompany(String apiKey, String searchKey, String id) {
    return mApi.searchEmployeeByCompany(apiKey, searchKey, id).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> deleteCompanyImage(String apiKey, int id) {
    return mApi.deleteCompanyImage(apiKey, id).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<FamilyResponse?> getFamilies(String apiKey, List<GetRequest> request) {
    return mApi.getFamilies(apiKey, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> updateFamily(String apiKey, int familyId, AddFamilyRequest request) {
    return mApi.updateFamily(apiKey, familyId, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> addFamily(String apiKey, AddFamilyRequest request) {
    return mApi.addFamily(apiKey, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> deleteFamily(String apiKey, int id) {
    return mApi.deleteFamily(apiKey, id).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<CompanyByIdResponse?> getCompanyById(String apiKey, int companyId) {
    return mApi.getCompanyById(apiKey, companyId).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> changeUserInfo(String apiKey,String id, List<PathUserRequest> request) {
    return mApi.changeUserInfo(apiKey, id, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> patchPersonalInfo(String apiKey, int id, List<PathUserRequest> request) {
    return mApi.patchPersonalInfo(apiKey, id, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> patchEducationGraduates(String apiKey, int id, List<PathUserRequest> request) {
    return mApi.patchEducationGraduate(apiKey, id, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> patchLanguage(String apiKey, int id, List<PathUserRequest> request) {
    return mApi.patchLanguage(apiKey, id, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> patchTraining(String apiKey, int id, List<PathUserRequest> request) {
    return mApi.patchTraining(apiKey, id, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> patchSchool(String apiKey, int id, List<PathUserRequest> request) {
    return mApi.patchSchool(apiKey, id, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<TownshipResponse?> getTownship(String apiKey) {
    return mApi.getAllTownship(apiKey,430).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<CategoryResponse?> getCategories(String apiKey, List<GetRequest> request) {
    return mApi.getCategories(apiKey, request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> addCategory(String apiKey, AddCategoryVo requestBody) {
    return mApi.addCategory(apiKey, requestBody).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> updateCategory(String apiKey, int id, AddCategoryVo requestBody) {
    return mApi.updateCategory(apiKey, id, requestBody).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostResponse?> getPosts(String apiKey, int pageNumber,int limit,List<GetRequest> request) {
    return mApi.getPosts(apiKey,pageNumber,limit,"id",request).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> addPosts(String apiKey, AddPostRequest requestBody) {
    return mApi.addPost(apiKey, requestBody).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> updatePosts(String apiKey, int id, AddPostRequest requestBody) {
    return mApi.updatePost(apiKey, id,requestBody).catchError((onError){
      throw _createException(onError);
    });
  }

  @override
  Future<PostMethodResponse?> deletePosts(String apiKey, int id) {
    return mApi.deletePost(apiKey, id).catchError((onError){
      throw _createException(onError);
    });
  }

}
