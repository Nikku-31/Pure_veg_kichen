import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import '../AppManager/Model/CouponM/coupon_model.dart';
import '../AppManager/ViewModel/CouponVM/coupon_vm.dart';
import '../AppManager/ViewModel/CouponVM/apply_coupon_vm.dart';
import '../AppManager/ViewModel/CouponVM/get_coupon_byid_vm.dart';
import '../AppManager/ViewModel/DashboardVM/add_item_vm.dart';
class CouponSection extends StatelessWidget {
  final String itemId;
  const CouponSection({super.key,
    required this.itemId,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<CouponViewModel>(
            builder: (context, couponVM, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.local_offer,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Open Coupon",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        couponVM.coupons.isNotEmpty
                            ? couponVM.coupons.first.couponName
                            : "Coupons",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CouponScreen(
                    itemId: itemId,
                  ),
                ),
              );
            },
            child: Text(
              "See All",
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class CouponScreen extends StatefulWidget {
  final String? itemId;

  const CouponScreen({
    super.key,
    this.itemId,
  });

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<CouponViewModel>().fetchCoupons();
      if (widget.itemId != null) {
        final cartVM = context.read<AddItemVM>();

        for (final item in cartVM.items) {
          context
              .read<GetCouponByIdVM>()
              .getCouponsByItemId(item.itemId.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final couponVM = context.watch<CouponViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Available Coupons",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: couponVM.isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : couponVM.errorMessage != null
            ? Center(
          child: Text(
            couponVM.errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        )
            : couponVM.coupons.isEmpty
            ? const Center(
          child: Text("No Coupons Available"),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: couponVM.coupons.length,
          itemBuilder: (context, index) {
            Coupon coupon = couponVM.coupons[index];

            final byItemVM = context.watch<GetCouponByIdVM>();
            final cartVM = context.read<AddItemVM>();

            final cartItemIds = cartVM.items
                .map((e) => e.itemId.toString())
                .toList();

            final canApply = byItemVM.coupons.any(
                  (e) => e.couponCode == coupon.couponCode,
            );

            final isFromProfile = widget.itemId == null;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 170,
                    decoration: const BoxDecoration(
                      color: Color(0xffBDBDBD),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          "${coupon.discountValue}% OFF",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.local_offer,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  coupon.couponCode,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 32,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isFromProfile
                                        ? Colors.grey.shade400
                                        : canApply
                                        ? AppColors.primary
                                        : Colors.grey.shade400,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: isFromProfile
                                      ? null
                                      : canApply
                                      ? () {
                                    // ======= Tumhara Existing Apply Logic =======

                                    context.read<ApplyCouponVM>().applyCoupon(
                                      couponCode: coupon.couponCode,
                                      couponName: coupon.couponName,
                                      discount: double.tryParse(coupon.maxDiscount) ?? 0,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Coupon ${coupon.couponCode} Applied",
                                        ),
                                      ),
                                    );

                                    Navigator.pop(context);

                                    // ======= Existing Logic End =======
                                  }
                                      : null,
                                  child: const Text(
                                    "Apply",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  coupon.couponName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                coupon.description.isEmpty
                                    ? "No Description"
                                    : coupon.description,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Minimum Order"),
                              Text("₹${coupon.minOrderAmount}"),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Maximum Discount"),
                              Text("₹${coupon.maxDiscount}"),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Valid Till"),
                              Expanded(
                                child: Text(
                                  coupon.endDate,
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}