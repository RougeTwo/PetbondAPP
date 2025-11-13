import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:petbond_uk/core/routes/routes.dart';
import 'dart:developer';
import 'package:petbond_uk/core/utils/file_universal.dart';
import 'package:petbond_uk/core/values/color_values.dart';
import 'package:petbond_uk/services/veterinarian/vet_services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ConnectBreederScanScreen extends StatefulWidget {
  const ConnectBreederScanScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConnectBreederScanScreenState();
}

class _ConnectBreederScanScreenState extends State<ConnectBreederScanScreen> {
  Barcode? result;
  QRViewController? controller;
  VeterinarianServices veterinarianServices = VeterinarianServices();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QR Scanner",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorValues.fontColor,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 20),
                  child: Center(
                    child: Text(
                      "To Connect Breeder go to Breeder Account Setting on Official PetBond App.",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          color: ColorValues.fontColor),
                    ),
                  ),
                )),
            Expanded(flex: 3, child: _buildQrView(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 350)
        ? 250.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: ColorValues.loginBackground,
          borderRadius: 2,
          borderLength: 20,
          borderWidth: 8,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        bool valid = isUUID(result!.code.toString());
        if (valid == true) {
          await controller.pauseCamera();
          veterinarianServices
              .connectToBreederByQR(
                  context: context, qr_id: result!.code.toString())
              .then((value) async {
            if (value != null) {
              EasyLoading.showError(value.toString());
              return await controller.resumeCamera();
            } else {
              EasyLoading.showSuccess("Connected Successfully");
              return Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushNamedAndRemoveUntil(
                    context, vetDashBoardScreen, (route) => false);
              });
            }
          });
        } else {
          EasyLoading.showInfo(
              "Invalid QR Code!\nMake sure you're scanning a QR code displayed on PetBond Official App");
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission denied',
            style: TextStyle(
                color: Colors.white,
                fontFamily: "NotoSans",
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
          backgroundColor: ColorValues.loginBackground,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
