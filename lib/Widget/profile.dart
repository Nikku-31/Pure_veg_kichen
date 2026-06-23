import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0B1B4D),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.deepPurple,
                        size: 30,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Profile Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff18B88A),
                        Color(0xff1DBFA8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Top Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Text(
                              "👨‍🍳",
                              style: TextStyle(fontSize: 40),
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Rajesh Kumar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "@rajesh.veg",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Member since Jan 2024",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Passionate about healthy vegetarian cooking and exploring new recipes! 🍲",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// Quick Actions
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0B1B4D),
                  ),
                ),

                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.6,
                  children: [
                    quickActionCard(
                      icon: "📋",
                      title: "My Plans",
                    ),
                    quickActionCard(
                      icon: "🛒",
                      title: "Groceries",
                    ),
                    quickActionCard(
                      icon: "👨‍🍳",
                      title: "My Recipes",
                    ),
                    quickActionCard(
                      icon: "🏆",
                      title: "Badges",
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// Recent Activity
                const Row(
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      color: Colors.blueGrey,
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Recent Activity",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0B1B4D),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                activityCard(
                  title: "Paneer Tikka Masala",
                  subtitle: "Cooked 2 days ago",
                  trailing: "⭐ 4.8",
                ),

                const SizedBox(height: 14),

                activityCard(
                  title: "Buddha Bowl",
                  subtitle: "Liked 5 days ago",
                  trailing: "💗",
                ),

                const SizedBox(height: 14),

                activityCard(
                  title: "Veg Pasta Primavera",
                  subtitle: "Viewed 1 week ago",
                  trailing: "⭐ 4.7",
                ),
                const SizedBox(height: 30),

                /// Preferences
                const Row(
                  children: [
                    Text(
                      "⚙️",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Preferences",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0B1B4D),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      preferenceTile(
                        title: "Notifications",
                        trailing: const Icon(Icons.arrow_forward),
                      ),

                      Divider(height: 1),

                      preferenceTile(
                        title: "Dark Mode",
                        trailing: Switch(
                          value: false,
                          onChanged: (value) {},
                        ),
                      ),

                      Divider(height: 1),

                      preferenceTile(
                        title: "Language",
                        trailing: const Text(
                          "English",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      Divider(height: 1),

                      preferenceTile(
                        title: "Help & Support",
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// Account
                const Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0B1B4D),
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      preferenceTile(
                        title: "Email & Password",
                        trailing: const Icon(Icons.arrow_forward),
                      ),

                      const Divider(height: 1),

                      preferenceTile(
                        title: "Privacy Policy",
                        trailing: const Icon(Icons.arrow_forward),
                      ),

                      const Divider(height: 1),

                      preferenceTile(
                        title: "Logout",
                        textColor: Colors.red,
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget quickActionCard({
    required String icon,
    required String title,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 34),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xff0B1B4D),
            ),
          ),
        ],
      ),
    );
  }

  Widget activityCard({
    required String title,
    required String subtitle,
    required String trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0B1B4D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Text(
            trailing,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget preferenceTile({
    required String title,
    required Widget trailing,
    Color textColor = const Color(0xff0B1B4D),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}