import 'dart:convert';
import 'dart:io';
import "dart:math";
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class ApiRequest {
  static final ApiRequest _request = ApiRequest._internal();
  static Map<String, String> standardHeaders = {
    'Content-type': 'application/json',
    'Accept': 'text/plain'
  };
  static List<String> hEATHERS = ["3ab3852d-f8e9-4f2d-8cbd-24c5e1572765"];

  static IOClient https() {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return IOClient(client);
  }

  static http.Client httpsClient() {
    var client = http.Client();
    return client;
  }

  static http.Request getOrPostRequest(String url, {String type = 'GET'}) {
    return http.Request(type, Uri.parse(url));
  }

  static Map<String, dynamic>? getApiRes(http.Response response) {
    return response.statusCode == 200
        ? jsonDecode(utf8.decode(response.bodyBytes))
        : null;
  }

  static String baseUrl = //'http://10.0.2.2:8000/';
      'https://lansonndehplumbingapi-qzetw3rvzq-uk.a.run.app/'; //'http://10.0.2.2:8000/'

  static Map<String, dynamic> getDecodedContent(http.Response response) {
    Map<String, dynamic> res = json.decode(response.body);
    return res;
  }

  factory ApiRequest() {
    return _request;
  }

  ApiRequest._internal();
  static Map<String, String> getStandardHeaders(
      {bool isPostRequest = false, String? headers}) {
    final random = Random();
    Map<String, String> currentHeaders = standardHeaders;
    String header = headers ?? hEATHERS[random.nextInt(hEATHERS.length)];
    if (isPostRequest) {
      return {
        'accept': 'application/json',
        'header': header,
        'Content-Type': 'application/x-www-form-urlencoded'
      };
    } else {
      currentHeaders.addAll({"header": header});
      return currentHeaders;
    }
  }

  static Future<Map<String, dynamic>?> likeOrViewAd(int adId,
      {String whatToUpdate = 'number_of_views',
      int viewedOrLikedBy = 0}) async {
    whatToUpdate = '${whatToUpdate}T$viewedOrLikedBy';
    String url = '${baseUrl}like_or_view_ad/$adId/$whatToUpdate';
    Uri uri = Uri.parse(url);
    http.Response response =
        await httpsClient().post(uri, headers: getStandardHeaders());
    return getApiRes(response);
  }

  static Future<int?> postReview(Map<String, String> params,
      {bool isForApp = false}) async {
    String url =
        isForApp ? '${baseUrl}post_app_feedback/' : '${baseUrl}post_review/';
    Uri uri = Uri.parse(url);
    http.Response response = await httpsClient().post(uri,
        body: params, headers: getStandardHeaders(isPostRequest: true));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = getApiRes(response)!;
      return isForApp ? responseBody['feedback_id'] : responseBody['review_id'];
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> genericPost(String endPoint,
      {required Map<String, String> params, String? header}) async {
    String url = baseUrl + endPoint;
    Uri uri = Uri.parse(url);
    http.Response response = await httpsClient().post(uri,
        body: params,
        headers: getStandardHeaders(isPostRequest: true, headers: header));
    // print(response.body);
    // print(response.statusCode);
    return getApiRes(response);
  }

  static Future<Map<String, dynamic>?> genericGet(String endPoint,
      {String? header}) async {
    String url = baseUrl + endPoint;
    Uri uri = Uri.parse(url);
    http.Response response = await httpsClient()
        .get(uri, headers: getStandardHeaders(headers: header));
    // print(response.body);
    // print(response.statusCode);
    return getApiRes(response);
  }

  static Future<List<dynamic>?> genericGetList(String endPoint) async {
    String url = baseUrl + endPoint;
    Uri uri = Uri.parse(url);
    http.Response response =
        await httpsClient().get(uri, headers: getStandardHeaders());
    return response.statusCode == 200
        ? (jsonDecode(response.body) as List<dynamic>)
        : null;
  }
}
