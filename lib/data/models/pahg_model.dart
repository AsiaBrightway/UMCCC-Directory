
import 'dart:io';

import 'package:pahg_group/data/vos/companies_vo.dart';
import 'package:pahg_group/data/vos/company_images_vo.dart';
import 'package:pahg_group/data/vos/department_vo.dart';
import 'package:pahg_group/data/vos/employee_vo.dart';
import 'package:pahg_group/data/vos/position_vo.dart';
import 'package:pahg_group/data/vos/request_body/add_company_request.dart';
import 'package:pahg_group/data/vos/request_body/add_department_request.dart';
import 'package:pahg_group/data/vos/request_body/add_position_request.dart';
import 'package:pahg_group/data/vos/request_body/get_request.dart';
import 'package:pahg_group/data/vos/request_body/login_request.dart';
import 'package:pahg_group/data/vos/token_vo.dart';
import 'package:pahg_group/data/vos/user_vo.dart';
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
}