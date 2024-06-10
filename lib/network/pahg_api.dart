

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pahg_group/data/vos/request_body/add_company_request.dart';
import 'package:pahg_group/data/vos/request_body/add_department_request.dart';
import 'package:pahg_group/data/vos/request_body/add_employee_request.dart';
import 'package:pahg_group/data/vos/request_body/add_position_request.dart';
import 'package:pahg_group/data/vos/request_body/login_request.dart';
import 'package:pahg_group/network/api_constants.dart';
import 'package:pahg_group/network/responses/company_images_response.dart';
import 'package:pahg_group/network/responses/company_list_response.dart';
import 'package:pahg_group/network/responses/department_list_response.dart';
import 'package:pahg_group/network/responses/employee_list_response.dart';
import 'package:pahg_group/network/responses/image_upload_response.dart';
import 'package:pahg_group/network/responses/login_response.dart';
import 'package:pahg_group/network/responses/position_response.dart';
import 'package:pahg_group/network/responses/post_method_response.dart';
import 'package:pahg_group/network/responses/user_response.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../data/vos/employee_vo.dart';
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

  @POST(kEndPointGetEmployees)
  Future<EmployeeListResponse?> getEmployeesByCompany(
      @Header(kParamAuthorization) String apiKey,
      @Body() List<GetRequest> requestBody
      );

  @GET("$kEndPointGetEmployee/{emp_id}")
  Future<EmployeeVo?> getEmployeeById(
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
}