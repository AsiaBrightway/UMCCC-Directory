import 'dart:io';

import 'package:dio/dio.dart';
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
import 'package:pahg_group/data/vos/request_body/login_request.dart';
import 'package:pahg_group/data/vos/request_body/personal_info_request.dart';
import 'package:pahg_group/data/vos/request_body/update_employee_request.dart';
import 'package:pahg_group/network/api_constants.dart';
import 'package:pahg_group/network/responses/company_by_id_response.dart';
import 'package:pahg_group/network/responses/company_images_response.dart';
import 'package:pahg_group/network/responses/company_list_response.dart';
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
import 'package:pahg_group/network/responses/school_response.dart';
import 'package:pahg_group/network/responses/training_response.dart';
import 'package:pahg_group/network/responses/user_response.dart';
import 'package:pahg_group/network/responses/work_response.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../data/vos/request_body/add_company_image_vo.dart';
import '../data/vos/request_body/get_request.dart';
part 'pahg_api.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class PahgApi{
  factory PahgApi(Dio dio) = _PahgApi;
  
  @GET(kEndPointGetCompanies)
  Future<CompanyListResponse?> getCompanies(
      @Header(kParamAuthorization) String apiKey
    );

  @POST(kEndPointGetCompanies)
  Future<PostMethodResponse?> addCompany(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddCompanyRequest requestBody
      );

  @GET("$kEndPointGetCompanyById/{id}")
  Future<CompanyByIdResponse?> getCompanyById(
      @Header(kParamAuthorization) String apiKey,
      @Path('id') int companyId
      );

  @PUT("$kEndPointGetCompanyById/{id}")
  Future<PostMethodResponse?> updateCompany(
      @Header(kParamAuthorization) String apiKey,
      @Path('id') int companyId,
      @Body() AddCompanyRequest requestBody
      );

  @POST(kEndPointGetCompanyImages)
  Future<CompanyImagesResponse?> getCompanyImages(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> requestBody
    );

  @POST(kEndPointAddCompanyImages)
  Future<PostMethodResponse?> addCompanyImages(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddCompanyImageVo addRequest
      );

  @DELETE("$kEndPointAddCompanyImages/{id}")
  Future<PostMethodResponse?> deleteCompanyImage(
      @Header(kParamAuthorization) String apiKey,
      @Path('id') int imageId
      );

  @POST(kEndPointGetEmployees)
  Future<EmployeeListResponse?> getEmployeesByCompany(
      @Header(kParamAuthorization) String apiKey,
      @Query("page") int page,
      @Query("itemsPerPage") int pageSize,
      @Body() List<GetRequest> requestBody
      );

  @GET("$kEndPointGetEmployee/{emp_id}")
  Future<EmployeeResponse?> getEmployeeById(
      @Header(kParamAuthorization) String apiKey,
      @Path("emp_id") String userId,
      );

  @POST(kEndPointGetDepartmentByCompanyId)
  Future<DepartmentListResponse?> getDepartmentByCompanyId(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> requestBody
    );

  @POST(kEndPointLogin)
  Future<LoginResponse> loginResponse(
      @Body() LoginRequest requestBody
      );
  
  @GET("$kEndPointGetUserData/{user_id}")
  Future<UserResponse?> getUserById(
      @Header(kParamAuthorization) String apiKey,
      @Path('user_id') String userId,
      );

  @POST(kEndPointUploadImage)
  @MultiPart()
  Future<ImageUploadResponse?> uploadImage(
      @Header(kParamAuthorization) String apiKey,
      @Part(name: "file") File file
      );

  @POST(kEndPointAddDepartment)
  Future<PostMethodResponse?> addDepartment(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddDepartmentRequest requestBody
      );
  
  @PUT("$kEndPointAddDepartment/{dept_id}")
  Future<PostMethodResponse?> updateDepartment(
      @Header(kParamAuthorization) String apiKey,
      @Path('dept_id') int deptId,
      @Body() AddDepartmentRequest requestBody
      );

  @POST(kEndPointGetPositionByCompanyId)
  Future<PositionResponse?> getPosition(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> requestBody
      );

  @POST(kEndPointGetPositionsById)
  Future<PostMethodResponse?> addPosition(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddPositionRequest requestBody
      );

  @PUT("$kEndPointGetPositionsById/{position_id}")
  Future<PostMethodResponse?> updatePosition(
      @Header(kParamAuthorization) String apiKey,
      @Path('position_id') int positionId,
      @Body() AddPositionRequest requestBody
      );

  @POST(kEndPointGetUserData)
  Future<PostMethodResponse?> addUser(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddEmployeeRequest requestBody
      );

  @PUT("$kEndPointGetEmployee/{emp_id}")
  Future<PostMethodResponse?> updateEmployee(
      @Header(kParamAuthorization) String apiKey,
      @Path('emp_id') String empId,
      @Body() UpdateEmployeeRequest requestBody
      );

  @POST(kEndPointGetPersonalInfo)
  Future<PersonalInfoResponse?> getPersonalInfo(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> requestBody
      );

  @POST(kEndPointAddPersonalInfo)
  Future<PostMethodResponse?> addPersonalInfo(
      @Header(kParamAuthorization) String apiKey,
      @Body() PersonalInfoRequest requestBody
      );

  @PUT("$kEndPointAddPersonalInfo/{id}")
  Future<PostMethodResponse?> updatePersonalInfo(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int personalId,
      @Body() PersonalInfoRequest requestBody
      );

  @POST(kEndPointGetSchool)
  Future<SchoolResponse?> getSchoolList(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> requestBody
      );

  @PUT("$kEndPointUpdateSchool/{school_id}")
  Future<PostMethodResponse?> updateSchool(
      @Header(kParamAuthorization) String apiKey,
      @Path("school_id") int schoolId,
      @Body() AddSchoolRequest requestBody
      );

  @POST(kEndPointUpdateSchool)
  Future<PostMethodResponse?> addSchool(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddSchoolRequest request
      );

  @DELETE("$kEndPointUpdateSchool/{id}")
  Future<PostMethodResponse?> deleteSchool(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int schoolId
      );

  @POST(kEndPointGetGraduate)
  Future<GraduateResponse?> getGraduateList(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> requestBody
      );

  @POST(kEndPointAddGraduate)
  Future<PostMethodResponse?> addGraduate(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddGraduateRequest requestBody
      );

  @PUT("$kEndPointAddGraduate/{id}")
  Future<PostMethodResponse?> updateGraduate(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      @Body() AddGraduateRequest requestBody
      );
  
  @DELETE("$kEndPointAddGraduate/{id}")
  Future<PostMethodResponse?> deleteGraduate(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      );

  @POST(kEndPointGetTraining)
  Future<TrainingResponse?> getTraining(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> requestBody
      );

  @POST(kEndPointAddTraining)
  Future<PostMethodResponse?> addTraining(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddTrainingRequest requestBody
      );

  @PUT("$kEndPointAddTraining/{id}")
  Future<PostMethodResponse?> updateTraining(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      @Body() AddTrainingRequest request
      );

  @DELETE("$kEndPointAddTraining/{id}")
  Future<PostMethodResponse?> deleteTraining(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      );

  @POST(kEndPointGetLanguage)
  Future<LanguageResponse?> getLanguageList(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> request
      );

  @POST(kEndPointAddLanguage)
  Future<PostMethodResponse?> addLanguage(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddLanguageRequest request
      );

  @PUT("$kEndPointAddLanguage/{id}")
  Future<PostMethodResponse?> updateLanguage(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      @Body() AddLanguageRequest request
      );

  @DELETE("$kEndPointAddLanguage/{id}")
  Future<PostMethodResponse?> deleteLanguage(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id
      );

  ///work experience CRUD
  @POST(kEndPointGetWorkExp)
  Future<WorkResponse?> getWorkList(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> requestBody
      );

  @POST(kEndPointAddWorkExp)
  Future<PostMethodResponse?> addWorkExperience(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddWorkRequest request
      );

  @PUT("$kEndPointAddWorkExp/{id}")
  Future<PostMethodResponse?> updateWorkExperience(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      @Body() AddWorkRequest request
      );

  @DELETE("$kEndPointAddWorkExp/{id}")
  Future<PostMethodResponse?> deleteWorkExp(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      );

  @GET(kEndPointSearchEmployee)
  Future<EmployeeListResponse?> searchEmployee(
      @Header(kParamAuthorization) String apiKey,
      @Query("searchKey") String name
      );

  @GET(kEndPointSearchEmployeeCompany)
  Future<EmployeeListResponse?> searchEmployeeByCompany(
      @Header(kParamAuthorization) String apiKey,
      @Query("searchKey") String name,
      @Query("companyId") String id
      );

  @POST(kEndPointGetFamily)
  Future<FamilyResponse?> getFamilies(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> requestBody
      );
  
  @PUT("$kEndPointAddFamily/{id}")
  Future<PostMethodResponse?> updateFamily(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      @Body() AddFamilyRequest request
      );

  @POST(kEndPointAddFamily)
  Future<PostMethodResponse?> addFamily(
      @Header(kParamAuthorization) String apiKey,
      @Body() AddFamilyRequest request
      );

  @DELETE("$kEndPointAddFamily/{id}")
  Future<PostMethodResponse?> deleteFamily(
      @Header(kParamAuthorization) String apiKey,
      @Path("id") int id,
      );
}