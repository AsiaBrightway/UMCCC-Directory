
import 'dart:io';

import 'package:pahg_group/data/vos/companies_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_category_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_company_image_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_company_request.dart';
import 'package:pahg_group/data/vos/request_body/add_department_request.dart';
import 'package:pahg_group/data/vos/request_body/add_employee_request.dart';
import 'package:pahg_group/data/vos/request_body/add_family_request.dart';
import 'package:pahg_group/data/vos/request_body/add_graduate_request.dart';
import 'package:pahg_group/data/vos/request_body/add_language_request.dart';
import 'package:pahg_group/data/vos/request_body/add_position_request.dart';
import 'package:pahg_group/data/vos/request_body/add_school_request.dart';
import 'package:pahg_group/data/vos/request_body/add_training_request.dart';
import 'package:pahg_group/data/vos/request_body/add_work_request.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import 'package:pahg_group/data/vos/request_body/login_request.dart';
import 'package:pahg_group/data/vos/request_body/path_user_request.dart';
import 'package:pahg_group/data/vos/request_body/personal_info_request.dart';
import 'package:pahg_group/data/vos/request_body/update_employee_request.dart';
import 'package:pahg_group/network/responses/company_by_id_response.dart';
import 'package:pahg_group/network/responses/employee_response.dart';
import 'package:pahg_group/network/responses/login_response.dart';
import 'package:pahg_group/network/responses/post_method_response.dart';

import '../responses/category_response.dart';
import '../responses/company_images_response.dart';
import '../responses/department_list_response.dart';
import '../responses/employee_list_response.dart';
import '../responses/family_response.dart';
import '../responses/graduate_response.dart';
import '../responses/image_upload_response.dart';
import '../responses/language_response.dart';
import '../responses/personal_info_response.dart';
import '../responses/position_response.dart';
import '../responses/post_response.dart';
import '../responses/school_response.dart';
import '../responses/township_response.dart';
import '../responses/training_response.dart';
import '../responses/user_response.dart';
import '../responses/work_response.dart';

abstract class PahgDataAgent{

  Future<LoginResponse?> userLogin(LoginRequest request);

  Future<List<CompaniesVo>> getCompanies(String apiKey);

  Future<PostMethodResponse?> addCompany(String apiKey,AddCompanyRequest request);

  Future<CompanyByIdResponse?> getCompanyById(String apiKey,int companyId);

  Future<PostMethodResponse?> updateCompany(String apiKey,int companyId,AddCompanyRequest request);

  Future<CompanyImagesResponse?> getCompanyImages(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> addCompanyImages(String apiKey,AddCompanyImageVo request);

  Future<PostMethodResponse?> deleteCompanyImage(String apiKey,int id);

  Future<EmployeeListResponse?> getEmployees(String apiKey, List<GetRequest> request,int pageNo,int pageSize);

  Future<DepartmentListResponse?> getDepartmentListByCompanyId(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> addDepartment(String apiKey,AddDepartmentRequest request);

  Future<PostMethodResponse?> updateDepartment(String apiKey,int deptId,AddDepartmentRequest request);

  Future<UserResponse?> getUserById(String apiKey,String userId);

  Future<ImageUploadResponse?> uploadImage(String apiKey,File file);

  Future<PositionResponse?> getPositions(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> addPosition(String apiKey,AddPositionRequest request);

  Future<PostMethodResponse?> updatePosition(String apiKey,int positionId,AddPositionRequest request);

  Future<PostMethodResponse?> addUser(String apiKey,AddEmployeeRequest request);

  Future<EmployeeResponse?> getEmployeeById(String apiKey,String userId);

  Future<PostMethodResponse?> updateEmployeeById(String apiKey,String userId,UpdateEmployeeRequest request);

  Future<PersonalInfoResponse?> getPersonalInfo(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> addPersonalInfo(String apiKey,PersonalInfoRequest request);

  Future<PostMethodResponse?> updatePersonalInfo(String apiKey,int personalId,PersonalInfoRequest request);

  Future<SchoolResponse?> getSchoolList(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> updateSchool(String apiKey,int schoolId,AddSchoolRequest request);

  Future<PostMethodResponse?> addSchool(String apiKey,AddSchoolRequest request);

  Future<PostMethodResponse?> deleteSchool(String apiKey,int schoolId);

  Future<GraduateResponse?> getGraduate(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> addGraduate(String apiKey,AddGraduateRequest request);

  Future<PostMethodResponse?> updateGraduate(String apiKey,int id,AddGraduateRequest request);

  Future<PostMethodResponse?> deleteGraduate(String apiKey,int id);

  Future<TrainingResponse?> getTrainingList(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> addTraining(String apiKey,AddTrainingRequest request);

  Future<PostMethodResponse?> updateTraining(String apiKey,int id,AddTrainingRequest request);

  Future<PostMethodResponse?> deleteTraining(String apiKey,int id);

  Future<LanguageResponse?> getLanguageList(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> addLanguage(String apiKey,AddLanguageRequest request);

  Future<PostMethodResponse?> updateLanguage(String apiKey,int id,AddLanguageRequest request);

  Future<PostMethodResponse?> deleteLanguage(String apiKey,int id);

  Future<WorkResponse?> getWorkList(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> addWorkExperience(String apiKey,AddWorkRequest request);

  Future<PostMethodResponse?> updateWorkExperience(String apiKey,int id,AddWorkRequest request);

  Future<PostMethodResponse?> deleteWorkExperience(String apiKey,int id);

  Future<EmployeeListResponse?> searchEmployee(String apiKey,int itemsPerPage,String searchKey);

  Future<EmployeeListResponse?> searchEmployeeByCompany(String apiKey,String searchKey,String id);

  Future<FamilyResponse?> getFamilies(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> updateFamily(String apiKey,int familyId,AddFamilyRequest request);

  Future<PostMethodResponse?> deleteFamily(String apiKey,int id);

  Future<PostMethodResponse?> addFamily(String apiKey,AddFamilyRequest request);

  Future<PostMethodResponse?> changeUserInfo(String apiKey,String id,List<PathUserRequest> request);

  Future<PostMethodResponse?> patchPersonalInfo(String apiKey,int id,List<PathUserRequest> request);

  Future<PostMethodResponse?> patchEducationGraduates(String apiKey,int id,List<PathUserRequest> request);

  Future<PostMethodResponse?> patchLanguage(String apiKey,int id,List<PathUserRequest> request);

  Future<PostMethodResponse?> patchTraining(String apiKey,int id,List<PathUserRequest> request);

  Future<PostMethodResponse?> patchSchool(String apiKey,int id,List<PathUserRequest> request);

  Future<TownshipResponse?> getTownship(String apiKey,List<GetRequest> request);

  Future<CategoryResponse?> getCategories(String apiKey,List<GetRequest> request);

  Future<PostMethodResponse?> addCategory(String apiKey,AddCategoryVo requestBody);

  Future<PostMethodResponse?> updateCategory(String apiKey,int id,AddCategoryVo requestBody);

  Future<PostResponse?> getPosts(String apiKey,List<GetRequest> request,int pageNumber,int limit);
}