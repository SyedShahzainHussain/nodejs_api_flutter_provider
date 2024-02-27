import 'package:api_with_nodejs/data/response/status.dart';

class ApiResponse<T> {
  Status status;
  String? message;
  T? data;
  ApiResponse(this.data, this.message, this.status);

  ApiResponse.loading() : status = Status.loading;
  ApiResponse.complete(this.data) : status = Status.complete;
  ApiResponse.error(this.message) : status = Status.error;
  @override
  String toString() {
    return "Status:$status \n Message:$message \n Data:$data";
  }
}
