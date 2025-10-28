import '../../core/services/base_services.dart';
import '../../core/utils/response_model.dart';
import '../../models/shared/sale_commission_tax_model.dart';

class SaleCommissionTaxService extends BaseService {
  Future<SaleCommissionTaxModel> getComissionValue() async {
    method = "get";
    activateLoader = false;
    requestUrl = generateURL("sale_commission_tax");
    ResponseModel _responseModel = await request(null);
    SaleCommissionTaxModel saleCommissionTaxModel = SaleCommissionTaxModel();
    if (_responseModel.statusCode >= 200 && _responseModel.statusCode < 300) {
      saleCommissionTaxModel =
          SaleCommissionTaxModel.fromJson(_responseModel.body);
    }
    return saleCommissionTaxModel;
  }
}
