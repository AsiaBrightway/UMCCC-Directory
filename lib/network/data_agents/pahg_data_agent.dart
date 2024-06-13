
import 'dart:io';

import 'package:pahg_group/data/vos/companies_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_company_request.dart';
import 'package:pahg_group/data/vos/request_body/add_department_request.dart';
import 'package:pahg_group/data/vos/request_body/add_employee_request.dart';
import 'package:pahg_group/data/vos/request_body/add_position_request.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import 'package:pahg_group/data/vos/request_body/login_request.dart';
import 'package:pahg_group/data/vos/request_body/update_employee_request.dart';
import 'package:pahg_group/network/responses/employee_response.dart';
import 'package:pahg_group/network/responses/login_response.dart';
import 'package:pahg_group/network/responses/post_method_response.dart';

import '../../data/vos/employee_vo.dart';
import '../responses/company_images_response.dart';
import '../responses/department_list_response.dart';
import '../responses/employee_list_response.dart';
import '../responses/image_upload_response.dart';
import '../responses/position_response.dart';
import '../responses/user_response.dart';

abstract class PahgDataAgent{

  Future<LoginResponse?> userLogin(LoginRequest request);

  Future<List<CompaniesVo>> getCompanies(String apiKey);

  Future<PostMethodResponse?> addCompany(String apiKey,AddCompanyRequest request);

  Future<PostMethodResponse?> updateCompany(String apiKey,int companyId,AddCompanyRequest request);

  Future<CompanyImagesResponse?> getCompanyImages(String apiKey,List<GetRequest> request);

  Future<EmployeeListResponse?> getEmployees(String apiKey, List<GetRequest> request);

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
}