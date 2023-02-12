// ignore: file_names
import 'package:apilocalstorage/models/model.dart';
import 'package:apilocalstorage/backendlogic/Database.dart';
import 'package:dio/dio.dart';

class EmpApiProvider {
  Future<List<Employee?>> getdata() async {
    try {
      var url = "https://jsonplaceholder.typicode.com/posts";
      Response response = await Dio().get(url);

      return (response.data as List).map((e) {
        
        DBProvider.db.createdata(Employee.fromJson(e));
      }).toList();
    } catch (e) {
    
      return Future.error(e.toString());
    }
  }
}
