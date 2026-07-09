import 'package:flutter/material.dart';
import 'package:pure_veg/core/constants/app_colors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  /// Stats Data
  static final List<StatCardModel> stats = [
    StatCardModel(
      title: "5000+",
      subtitle: "Orders Delivered",
    ),
    StatCardModel(
      title: "4.9★",
      subtitle: "Customer Rating",
    ),
    StatCardModel(
      title: "100%",
      subtitle: "Pure Vegetarian",
    ),
    StatCardModel(
      title: "365",
      subtitle: "Days Fresh Service",
    ),
  ];

  @override
  State<AboutUs> createState() => _AboutUsState();
}
final List<WhyLoveModel> whyLoveList = [
  WhyLoveModel(
    emoji: "🌱",
    title: "100% Pure Veg",
    description:
    "Completely vegetarian kitchen with no compromise on purity.",
  ),
  WhyLoveModel(
    emoji: "🍲",
    title: "Freshly Cooked",
    description:
    "Prepared after every order for maximum freshness.",
  ),
  WhyLoveModel(
    emoji: "⭐",
    title: "Premium Quality",
    description:
    "Only high-quality ingredients and spices are used.",
  ),
  WhyLoveModel(
    emoji: "🚚",
    title: "Fast Delivery",
    description:
    "Hot & fresh food delivered quickly to your doorstep.",
  ),
];

class WhyLoveModel {
  final String emoji;
  final String title;
  final String description;

  const WhyLoveModel({
    required this.emoji,
    required this.title,
    required this.description,
  });
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    final double bannerHeight = MediaQuery.of(context).size.height * 0.40;
    return Scaffold(
      backgroundColor: const Color(0xffFDF8F2),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(
          color: AppColors.background
        ),
        title: Text("About Us",
        style: TextStyle(
          color: AppColors.background
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: bannerHeight,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/image/about.png",
                    fit: BoxFit.cover,
                  ),
                ),

                Container(
                  height: bannerHeight,
                  color: Colors.black.withOpacity(.55),
                ),
                SafeArea(
                  child: SizedBox(
                    height: bannerHeight,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: const Color(0xffF57C00),
                          child: const Center(
                            child: Text(
                              "🌿 Without onion & garlic option available! 🌿",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Pure Veg Kitchen",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Fresh • Hygienic • Made To Order",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35),
                          child: Text(
                            "We prepare every meal only after receiving your order, ensuring premium taste, freshness, and quality in every bite.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = (constraints.maxWidth - 28) / 3;
                        return Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: AboutUs.stats.map((item) {
                            return SizedBox(
                              width: itemWidth,
                              child: _statCard(item),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(.08),
                            blurRadius: 10,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Who We Are",
                            style: TextStyle(
                              fontSize:15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "We are a premium pure vegetarian cloud kitchen committed to serving freshly prepared meals with uncompromising hygiene and quality. Unlike mass-production kitchens, every dish is cooked after order confirmation using carefully selected ingredients and traditional cooking methods.",
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.8,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height:10),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Why Customers Love Us",
                          style: TextStyle(
                            fontSize:15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFF6B00),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height:5),

                    Padding(
                      padding: EdgeInsetsGeometry.zero,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final itemWidth = (constraints.maxWidth - 20) / 2;
                          return Wrap(
                            spacing: 10,
                            runSpacing: 20,
                            children: whyLoveList.map((item) {
                              return SizedBox(
                                width: itemWidth,
                                child: whyLoveCard(item),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 15),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withValues(alpha: .08),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Our Commitment",
                            style: TextStyle(
                              fontSize:20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffFF6B00),
                            ),
                          ),

                          const SizedBox(height: 5),

                          LayoutBuilder(
                            builder: (context, constraints) {

                              bool mobile = constraints.maxWidth < 700;

                              if (mobile) {
                                return Column(
                                  children: [
                                    commitmentCard(
                                      title: "Others",
                                      icon: Icons.close,
                                      iconColor: Colors.red,
                                      borderColor: Colors.red.shade200,
                                      bgColor: Colors.red.shade50,
                                      points: const [
                                        "Pre-cooked food",
                                        "Frozen ingredients",
                                        "Mass production",
                                        "Less quality control",
                                      ],
                                    ),

                                    const SizedBox(height:10),

                                    commitmentCard(
                                      title: "Pure Veg Kitchen",
                                      icon: Icons.check_box,
                                      iconColor: Colors.green,
                                      borderColor: Colors.green.shade200,
                                      bgColor: Colors.green.shade50,
                                      points: const [
                                        "Fresh cooking after order",
                                        "Premium ingredients",
                                        "High hygiene standards",
                                        "Home-style balanced taste",
                                      ],
                                    ),
                                  ],
                                );
                              }

                              return Row(
                                children: [

                                  Expanded(
                                    child: commitmentCard(
                                      title: "Others",
                                      icon: Icons.close,
                                      iconColor: Colors.red,
                                      borderColor: Colors.red.shade200,
                                      bgColor: Colors.red.shade50,
                                      points: const [
                                        "Pre-cooked food",
                                        "Frozen ingredients",
                                        "Mass production",
                                        "Less quality control",
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 20),

                                  Expanded(
                                    child: commitmentCard(
                                      title: "Pure Veg Kitchen",
                                      icon: Icons.check_box,
                                      iconColor: Colors.green,
                                      borderColor: Colors.green.shade200,
                                      bgColor: Colors.green.shade50,
                                      points: const [
                                        "Fresh cooking after order",
                                        "Premium ingredients",
                                        "High hygiene standards",
                                        "Home-style balanced taste",
                                      ],
                                    ),
                                  ),

                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _statCard(StatCardModel item) {
    return SizedBox(
      height: 80,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10,),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(.10),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Color(0xffFF6B00),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget whyLoveCard(WhyLoveModel item) {
  return Container(
    constraints: const BoxConstraints(
      minHeight: 100,
    ),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.orange.withOpacity(.08),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        Text(
          item.emoji,
          style: const TextStyle(fontSize: 20),
        ),

        const SizedBox(height:5),

        Text(
          item.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize:15,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height:5),

        Text(
          item.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
      ],
    ),
  );
}

Widget commitmentCard({
  required String title,
  required IconData icon,
  required Color iconColor,
  required Color borderColor,
  required Color bgColor,
  required List<String> points,
}) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: borderColor,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            const SizedBox(width:5),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:18,
              ),
            ),
          ],
        ),

        const SizedBox(height:5),

        ...points.map(
              (e) => Padding(
            padding: const EdgeInsets.only(bottom:0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "• ",
                  style: TextStyle(fontSize: 18),
                ),
                Expanded(
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1,
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
}
class StatCardModel {
  final String title;
  final String subtitle;

  const StatCardModel({
    required this.title,
    required this.subtitle,
  });
}