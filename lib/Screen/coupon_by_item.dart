import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pure_veg/core/constants/app_colors.dart';
import '../AppManager/Model/CouponM/get_coupon_byid_model.dart';
import '../AppManager/ViewModel/CouponVM/apply_coupon_vm.dart';
import '../AppManager/ViewModel/CouponVM/get_coupon_byid_vm.dart';
import 'coupon.dart';
class CouponByItemSection extends StatelessWidget {
  final String itemId;
  const  CouponByItemSection({super.key,
    required this.itemId,});

  @override
  Widget build(BuildContext context) {
    return Consumer2<GetCouponByIdVM, ApplyCouponVM>(
      builder: (context, couponVM, applyCouponVM, child) {
        final applied = applyCouponVM.isCouponApplied;
        return Container(
          margin: const EdgeInsets.only(bottom: 0),
          padding: const EdgeInsets.all(12),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(16),
          //   border: Border.all(
          //     color: Colors.grey.shade300,
          //   ),
          // ),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      applied ? "Coupon applied" : "Open Coupon",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => CouponScreen(
                            itemId: itemId,
                          ),
                        ),
                      );
                    },
                    child: Text("See all",
                      style: GoogleFonts.poppins(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DottedBorder(
              color: AppColors.primary.withValues(alpha: 0.45),
              strokeWidth: 1.2,
              dashPattern: const [6, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.local_offer_outlined,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                applied
                                    ? applyCouponVM.appliedCouponCode
                                    : couponVM.coupons.isNotEmpty
                                    ? couponVM.coupons.first.couponCode
                                    : "Coupons",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (applied)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "Applied",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 3),

                          Text(
                            applied
                                ? "Coupon applied on this order"
                                : "Tap See all to view available coupons",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (applied)
                      GestureDetector(
                        onTap: () {
                          applyCouponVM.removeCoupon();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Coupon Removed"),
                            ),
                          );
                        },
                        child: Text(
                          "Remove",
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              ),
            ],
          ),
        );
      },
    );
  }
}
class CouponByItemScreen extends StatefulWidget {
  final String itemId;
  const  CouponByItemScreen({super.key,
  required this.itemId});

  @override
  State<CouponByItemScreen> createState() => _CouponByItemScreenState();
}

class _CouponByItemScreenState extends State<CouponByItemScreen> {
  @override
  void initState() {
    super.initState();
    print("Screen ItemId = ${widget.itemId}");
    Future.microtask(() {
      context
          .read<GetCouponByIdVM>()
          .getCouponsByItemId(widget.itemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final couponVM = context.watch<GetCouponByIdVM>();
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
            : couponVM.error != null
            ? Center(
          child: Text(
            couponVM.error!,
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
            GetCouponById coupon = couponVM.coupons[index];
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
                                height: 30,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<ApplyCouponVM>().applyCoupon(
                                      couponCode: coupon.couponCode,
                                      couponName: coupon.couponName,
                                      discount: double.tryParse(coupon.maxDiscount) ?? 0,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "${coupon.couponCode} Applied Successfully",
                                        ),
                                      ),
                                    );

                                    Navigator.pop(context);
                                  },
                                  child: const Text("Apply"),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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

                              Consumer<ApplyCouponVM>(
                                builder: (context, applyCouponVM, child) {
                                  if (applyCouponVM.isCouponApplied &&
                                      applyCouponVM.appliedCouponCode == coupon.couponCode) {
                                    return TextButton(
                                      onPressed: () {
                                        applyCouponVM.removeCoupon();

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Coupon Removed"),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Remove",
                                        style: GoogleFonts.poppins(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }

                                  return Text(
                                    coupon.description.isEmpty
                                        ? "No Description"
                                        : coupon.description,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  );
                                },
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