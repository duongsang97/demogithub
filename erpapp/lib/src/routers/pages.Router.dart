import 'package:erp/src/screens/auth/register/register.binding.dart';
import 'package:erp/src/screens/auth/register/register.container.dart';
import 'package:erp/src/screens/auth/signIn/pages/verification.Binding.dart';
import 'package:erp/src/screens/auth/signIn/pages/verification.Container.dart';
import 'package:erp/src/screens/profile/pages/asset/asset.Binding.dart';
import 'package:erp/src/screens/profile/pages/asset/asset.Container.dart';
import 'package:erp/src/screens/profile/elements/changePassword/changePassword.Binding.dart';
import 'package:erp/src/screens/profile/elements/changePassword/changePassword.Container.dart';
import 'package:erp/src/screens/profile/pages/identify/identify.Binding.dart';
import 'package:erp/src/screens/profile/pages/identify/identify.Container.dart';
import 'package:erp/src/screens/profile/pages/statusVerify/statusVerify.container.dart';
import 'package:erpcore/controllers/cameraView/cameraView.Binding.dart';
import 'package:erpcore/controllers/cameraView/cameraView.Container.dart';
import 'package:erp/src/screens/appUpgrade/appUpgrade.Binding.dart';
import 'package:erp/src/screens/appUpgrade/appUpgrade.Container.dart';
import 'package:erp/src/screens/auth/identityChecking/identityChecking.Binding.dart';
import 'package:erp/src/screens/auth/identityChecking/identityChecking.Container.dart';
import 'package:erp/src/screens/auth/signIn/signIn.Binding.dart';
import 'package:erp/src/screens/auth/signIn/signIn.Container.dart';
import 'package:erp/src/screens/chats/inbox/inbox.Binding.dart';
import 'package:erp/src/screens/chats/inbox/inbox.Container.dart';
import 'package:erp/src/screens/helper/helper.Binding.dart';
import 'package:erp/src/screens/systemInfo/systemInfo.Binding.dart';
import 'package:erp/src/screens/systemInfo/systemInfo.Container.dart';
import 'package:erp/src/screens/helper/helper.Container.dart';
import 'package:erp/src/screens/main/main.Binding.dart';
import 'package:erp/src/screens/main/main.Container.dart';
import 'package:erp/src/screens/notification/detailNotification/detailNotification.Binding.dart';
import 'package:erp/src/screens/notification/detailNotification/detailNotification.Container.dart';
import 'package:erp/src/screens/notification/homeNotification/homeNotification.Binding.dart';
import 'package:erp/src/screens/notification/homeNotification/homeNotification.Container.dart';
import 'package:erp/src/screens/profile/pages/profileDetail/profileDetail.Binding.dart';
import 'package:erp/src/screens/profile/pages/profileDetail/profileDetail.Container.dart';
import 'package:erpcore/controllers/webPage/webPage.Binding.dart';
import 'package:erpcore/controllers/webPage/webPage.Container.dart';
import 'package:erp/src/screens/welcome/welcome.Binding.dart';
import 'package:erp/src/screens/welcome/welcome.Container.dart';
import 'package:erpcore/controllers/pdfGenerate/pdfGenerate.binding.dart';
import 'package:erpcore/controllers/pdfGenerate/pdfGenerate.container.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erp/src/screens/profile/pages/signatureSign/signatureSign.Container.dart';
import 'package:erp/src/screens/profile/pages/signatureSign/signatureSign.Bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/profile/pages/statusVerify/statusVerify.binding.dart';
import 'app.Router.dart';
import 'package:erpcore/controllers/scanner/scanner.binding.dart';
import 'package:erpcore/controllers/scanner/scanner.container.dart';
import 'package:erpcore/routers/app.Router.dart' as erpCore;
import 'package:erp/src/screens/permission/permission.container.dart';
import 'package:erp/src/screens/permission/permission.binding.dart';

class AppPages {
  static List<PrCodeName> list = [
    PrCodeName(
      code : AppRouter.welcome,
      value : GetPage(
        name: AppRouter.welcome,
        page: () => WelcomeScreen(),
        binding: WelcomeBingding(),
      ),
    ),
    PrCodeName(
      code : AppRouter.permissionReview,
      value : GetPage(
        name: AppRouter.permissionReview,
        page: () => PermissionScreen(),
        binding: PermissionBinding(),
      ),
    ),
    PrCodeName(
    code : AppRouter.signIn,
      value : GetPage(
        name: AppRouter.signIn,
        page: () => SignInScreen(),
        binding: SignInBinding(),
      )
    ),
    PrCodeName(
    code : AppRouter.signUp,
      value : GetPage(
        name: AppRouter.signUp,
        page: () => RegisterScreen(),
        binding: RegisterBinding(),
      )
    ),
    PrCodeName(
      code : AppRouter.helper,
      value : GetPage(
        name: AppRouter.helper,
        page: () => HelperScreen(),
        binding: HelperBinding(),
      ),
    ),
    PrCodeName(
      code : AppRouter.cameraView,
      value : GetPage( 
        name: AppRouter.cameraView,
        page: () => CameraViewScreen(),
        binding: CameraViewBinding()
      ),
    ),
    PrCodeName(
      code : AppRouter.scannerView,
      value : GetPage(
        name: AppRouter.scannerView,
        page: () => ScannerScreen(),
        binding: ScannerBinding()
      ),
    ),
    PrCodeName(
      code : AppRouter.appUpgrade,
      value : GetPage(
        name: AppRouter.appUpgrade,
        page: () => AppUpgradeScreen(),
        binding: AppUpgradeBinding(),
      ),
    ),
    PrCodeName(
    code : AppRouter.main,
    value : GetPage(
        name: AppRouter.main,
        page: () => MainScreen(),
        binding: MainBinding(),
        children: [
          // GetPage(
          //   name: AppRouter.attendantMain,
          //   page: () => AttendantMainScreen(),
          //   binding: AttendantMainBinding(),
          // ),
          GetPage(
            name: AppRouter.inbox,
            page: () => InboxScreen(),
            binding: InboxBinding(),
          ),
          GetPage(
            name: AppRouter.profileDetail,
            page: () => ProfileDetailScreen(),
            binding: ProfileDetailBinding(),
          ),
          // // quản lý công việc
          // GetPage(
          //   name: AppRouter.taskMngMain,
          //   page: () => TaskMngMainScreen(),
          //   binding: TaskMngMainBinding(),
          // ),
          // xác thực tài khoản
          GetPage(
            name: AppRouter.identityChecking,
            page: () => IdentityCheckingScreen(),
            binding: IdentityCheckingBinding(),
            curve : Curves.elasticInOut,
            transition: Transition.zoom,
            transitionDuration: const Duration(milliseconds: 400)
          ),
          //Thông báo
          GetPage(
            name: AppRouter.homeNotification,
            page: () => HomeNotificationScreen(),
            binding: HomeNotificationBinding(),
          ),
          GetPage(
            name: AppRouter.detailNotification,
            page: () => DetailNotificationScreen(),
            binding: DetailNotificationBinding(),
          ),
          GetPage(
            name: AppRouter.systemInfo,
            page: () => SystemInfoScreen(),
            binding: SystemInfoBinding(),
          ),
          GetPage(
            name: AppRouter.pdfGenerate,
            page: () => PdfGenerateScreen(),
            binding: PdfGenerateBinding(),
          ),
          GetPage(
            name: AppRouter.verifyDashboard,
            page: () => StatusVerifyScreen(),
            binding: StatusVerifyBinding(),
          ),
        ]),
    ),
    // Activation
    PrCodeName(
      code: erpCore.AppRouter.webviewPage,
      value: GetPage(
        name: erpCore.AppRouter.webviewPage,
        page: () => WebPageScreen(),
        binding: WebPageBinding(),
      ), 
    ),
    PrCodeName(
      code: AppRouter.esignatureSign,
      value: GetPage(
        name: AppRouter.esignatureSign,
        page: () => SignatureSignScreen(),
        binding: SignatureSignBinding(),
      ), 
    ),
    PrCodeName(
      code: AppRouter.assetHome,
      value: GetPage(
        name: AppRouter.assetHome,
        page: () => AssetScreen(),
        binding: AssetBindings(),
      ), 
    ),
    PrCodeName(
      code: AppRouter.actChangePassword,
      value: GetPage(
        name: AppRouter.actChangePassword,
        page: () => ChangePasswordScreen(),
        binding: ChangePasswordBingding(),
      ),
    ),
    PrCodeName(
      code: AppRouter.identification,
      value: GetPage(
        name: AppRouter.identification,
        page: () => IdentifyScreen(),
        binding: IdentifyBinding(),
      ),
    ),
    PrCodeName(
      code: AppRouter.verification,
      value: GetPage(
        name: AppRouter.verification,
        page: () => VerificationScreen(),
        binding: VerificationBinding(),
      ),
    ),
  ];

}
