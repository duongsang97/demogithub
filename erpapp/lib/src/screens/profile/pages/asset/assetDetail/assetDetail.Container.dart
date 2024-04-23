import 'package:erp/src/screens/profile/pages/asset/assetDetail/assetDetail.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/image.Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:erpcore/components/shimmerPage/shimmerListDoc.Component.dart';
import 'package:erpcore/components/textInputs/textInput.Component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:cached_network_image/src/cached_image_widget.dart';

class AssetDetailScreen extends GetWidget<AssetDetailController>{

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        controller.fetchData();
      },
      child: Container(
        height: size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Obx(() => !controller.isLoading.value ? 
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.width * 0.3,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: controller.asset.value.urlImage != null && controller.asset.value.urlImage!.isNotEmpty
                        ? ClipRRect(borderRadius: BorderRadius.circular(10.0),child: CachedNetworkImage(
                            imageUrl: ImageUtils.getURLImage(handURLImageString(controller.asset.value.urlImage.toString())),
                            width: size.width * 0.2,
                            imageBuilder: (context, imageProvider) => ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                              child: Image(
                                image: imageProvider,
                                fit: BoxFit.contain,
                              ),
                            ),
                            placeholder: (context, url) => const SizedBox(width: 40, height: 40, child: Center(child: CircularProgressIndicator())),
                            errorWidget: (context, url, error) =>
                              Container(
                                decoration: const BoxDecoration(
                                  color: AppColor.notWhite,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                                ),
                                child: Icon(Icons.image, size: 50, color: AppColor.cottonSeed)
                              ),
                          )) 
                        : ClipRRect(borderRadius: BorderRadius.circular(10.0), child: Image.asset('assets/images/icons/no-image-icon-6.png', width: size.width * 0.2, color: AppColor.brightBlue,)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                AssetDetailItem(controllerFirst: controller.codeTextController, controllerSecond: controller.nameTextController , titleFirst: "Mã tài sản", titleSecond: "Tên",),
                AssetDetailItem(controllerFirst: controller.colorTextController, controllerSecond: controller.configTextController , titleFirst: "Màu sắc", titleSecond: "Cấu hình",),
                AssetDetailItem(controllerFirst: controller.accessoryTextController, controllerSecond: controller.supplierTextController , titleFirst: "Phụ kiện gắn thêm/Thay thế", titleSecond: "Cung cấp",),
                AssetDetailItem(controllerFirst: controller.accessoryTextController, controllerSecond: controller.supplierTextController , titleFirst: "Phụ kiện gắn thêm/Thay thế", titleSecond: "Cung cấp",),                  
                AssetDetailItem(controllerFirst: controller.assetSrcTextController, controllerSecond: controller.assetTypeTextController , titleFirst: "Nguồn", titleSecond: "Loại",),
                AssetDetailItem(controllerFirst: controller.orderPurchaseTextController, controllerSecond: controller.locationTextController , titleFirst: "Đơn hàng", titleSecond: "Địa điểm",),
                AssetDetailItem(controllerFirst: controller.departmentTextController, controllerSecond: controller.assetCostTextController , titleFirst: "Phòng ban", titleSecond: "Giá",),
                AssetDetailItem(controllerFirst: controller.transactionStatusTextController, controllerSecond: controller.statusTextController , titleFirst: "Trạng thái bàn giao", titleSecond: "Trạng thái tài sản",),
                TextInputComponent(
                  enable: false,
                  title: "Ngày bàn giao", 
                  controller: controller.transTextController,
                ),
              ],
            ),
          )
          : SizedBox(width: Get.width, child: const ShimmerListDocComponent())
        ),
      ),
    );
  }

}

class AssetDetailItem extends StatelessWidget {
  const AssetDetailItem({
    super.key,
    required this.controllerFirst,
    required this.controllerSecond,
    required this.titleFirst,
    required this.titleSecond,
  });

  final TextEditingController controllerFirst;
  final TextEditingController controllerSecond;
  final String titleFirst;
  final String titleSecond;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      child: Row(
        children: [
          Expanded(
            child: TextInputComponent(
              enable: false,
              title: titleFirst, 
              controller: controllerFirst,
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: TextInputComponent(
              enable: false,
              title: titleSecond, 
              controller: controllerSecond,
            ),
          ),
        ],
      ),
    );
  }
}