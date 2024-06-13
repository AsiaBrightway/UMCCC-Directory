
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pahg_group/data/vos/companies_vo.dart';
import 'package:pahg_group/data/vos/employee_vo.dart';
import 'package:pahg_group/data/vos/error_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_company_request.dart';
import 'package:pahg_group/data/vos/request_body/add_department_request.dart';
import 'package:pahg_group/data/vos/request_body/add_employee_request.dart';
import 'package:pahg_group/data/vos/request_body/add_position_request.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import 'package:pahg_group/data/vos/request_body/login_request.dart';
import 'package:pahg_group/data/vos/request_body/update_employee_request.dart';
import 'package:pahg_group/exception/custom_exception.dart';
import 'package:pahg_group/network/data_agents/pahg_data_agent.dart';
import 'package:pahg_group/network/pahg_api.dart';
import 'package:pahg_group/network/responses/company_images_response.dart';
import 'package:pahg_group/network/responses/department_list_response.dart';
import 'package:pahg_group/network/responses/employee_list_response.dart';
import 'package:pahg_group/network/responses/employee_response.dart';
import 'package:pahg_group/network/responses/image_upload_response.dart';
import 'package:pahg_group/network/responses/login_response.dart';
import 'package:pahg_group/network/responses/position_response.dart';
import 'package:pahg_group/network/responses/post_method_response.dart';
import 'package:pahg_group/network/responses/user_response.dart';

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
  Future<EmployeeListResponse?> getEmployees(String apiKey, List<GetRequest> request) {
    return mApi.getEmployeesByCompany(apiKey, request)
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
}
