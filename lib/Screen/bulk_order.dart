import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderItem {
  String category;
  String item;
  String variant;
  int qty;

  OrderItem({
    required this.category,
    required this.item,
    required this.variant,
    this.qty = 1,
  });
}
class BulkOrder extends StatefulWidget {
  const BulkOrder({super.key});

  @override
  State<BulkOrder> createState() => _BulkOrderState();
}

class _BulkOrderState extends State<BulkOrder> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  List<String> categories = [
    "Starter",
    "Main Course",
    "Rice",
    "Bread",
    "Dessert",
  ];
  Map<String, List<String>> items = {
    "Starter": [
      "Paneer Tikka",
      "Veg Manchurian",
      "Spring Roll",
    ],
    "Main Course": [
      "Shahi Paneer",
      "Dal Makhani",
      "Mix Veg",
    ],
    "Rice": [
      "Jeera Rice",
      "Veg Biryani",
    ],
    "Bread": [
      "Butter Naan",
      "Tandoori Roti",
    ],
    "Dessert": [
      "Gulab Jamun",
      "Rasgulla",
    ],
  };
  List<String> variants = [
    "Half",
    "Full",
  ];
  String? selectedCategory;
  String? selectedItem;
  String? selectedVariant;

  List<OrderItem> orderItems = [];

  double members = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7FAF8),

      appBar: AppBar(
        backgroundColor: const Color(0xff1B4332),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Bulk Order",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                /// HERO SECTION
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff1B4332),
                        Color(0xff2D6A4F),
                        Color(0xff40916C),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400",
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "Bulk & Party Orders",
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Feeding a crowd?\nOrder a full Veg Thali Spread",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Fresh home-style food for birthdays,\nparties and office events.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),


                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bulk Order",
                    style: TextStyle(
                      color: Colors.green.shade900,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Planning an event? Fill your details below.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// STEP 1 CARD
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      Row(
                        children: [

                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xff1B4332),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "1",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Your Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),

                              SizedBox(height: 3),

                              Text(
                                "Enter your information",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 25),

                      buildTextField(
                        controller: nameController,
                        label: "Full Name",
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 15),

                      buildTextField(
                        controller: phoneController,
                        label: "Mobile Number",
                        icon: Icons.phone,
                        keyboard: TextInputType.number,
                      ),

                      const SizedBox(height: 15),

                      buildTextField(
                        controller: pinController,
                        label: "PIN Code",
                        icon: Icons.pin_drop,
                        keyboard: TextInputType.number,
                      ),

                      const SizedBox(height: 15),

                      buildTextField(
                        controller: areaController,
                        label: "Delivery Area",
                        icon: Icons.location_city,
                      ),

                      const SizedBox(height: 15),

                      buildTextField(
                        controller: addressController,
                        label: "Address",
                        icon: Icons.home,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 25),

                      Row(
                        children: [

                          const Icon(
                            Icons.groups,
                            color: Colors.green,
                          ),

                          const SizedBox(width: 10),

                          const Text(
                            "Number of Members",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            members.toInt().toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.orange,
                            ),
                          )
                        ],
                      ),

                      Slider(
                        value: members,
                        min: 20,
                        max: 100,
                        divisions: 80,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            members = value;
                          });
                        },
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      Row(
                        children: [

                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xff1B4332),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "2",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Pick Your Dishes",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),

                              SizedBox(height: 3),

                              Text(
                                "Select category, item & variant",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 25),

                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: inputDecoration(
                          "Category",
                          Icons.restaurant_menu,
                        ),
                        items: categories.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            selectedCategory = v;
                            selectedItem = null;
                            selectedVariant = null;
                          });
                        },
                      ),

                      const SizedBox(height: 15),

                      DropdownButtonFormField<String>(
                        value: selectedItem,
                        decoration: inputDecoration(
                          "Item",
                          Icons.fastfood,
                        ),
                        items: (items[selectedCategory] ?? []).map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            selectedItem = v;
                          });
                        },
                      ),

                      const SizedBox(height: 15),

                      DropdownButtonFormField<String>(
                        value: selectedVariant,
                        decoration: inputDecoration(
                          "Variant",
                          Icons.layers,
                        ),
                        items: variants.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            selectedVariant = v;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {

                            if (selectedCategory == null ||
                                selectedItem == null ||
                                selectedVariant == null) {
                              return;
                            }

                            setState(() {
                              orderItems.add(
                                OrderItem(
                                  category: selectedCategory!,
                                  item: selectedItem!,
                                  variant: selectedVariant!,
                                ),
                              );

                              selectedCategory = null;
                              selectedItem = null;
                              selectedVariant = null;
                            });
                          },
                          icon: const Icon(Icons.add,color: Colors.white),
                          label: const Text(
                            "Add Item",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      if(orderItems.isEmpty)

                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "No Item Added",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                      if(orderItems.isNotEmpty)

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderItems.length,
                          itemBuilder: (context,index){

                            final item=orderItems[index];

                            return Card(

                              child: ListTile(

                                title: Text(item.item),

                                subtitle: Text(item.variant),

                                leading: CircleAvatar(
                                  backgroundColor: Colors.orange.shade100,
                                  child: const Icon(Icons.restaurant),
                                ),

                                trailing: SizedBox(
                                  width: 140,
                                  child: Row(

                                    children: [

                                      IconButton(

                                        onPressed: (){

                                          if(item.qty>1){

                                            setState(() {

                                              item.qty--;

                                            });

                                          }

                                        },

                                        icon: const Icon(Icons.remove_circle),

                                      ),

                                      Text(
                                        item.qty.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),

                                      IconButton(

                                        onPressed: (){

                                          setState(() {

                                            item.qty++;

                                          });

                                        },

                                        icon: const Icon(Icons.add_circle),

                                      ),

                                      IconButton(

                                        onPressed: (){

                                          setState(() {

                                            orderItems.removeAt(index);

                                          });

                                        },

                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),

                                      ),

                                    ],

                                  ),
                                ),

                              ),

                            );

                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [

                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xff1B4332),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "3",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Order Preview",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),

                              SizedBox(height: 3),

                              Text(
                                "Review your order",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12),
                              )
                            ],
                          )

                        ],
                      ),

                      const SizedBox(height: 25),

                      Text(
                        "Name : ${nameController.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      Text(
                        "Phone : ${phoneController.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      Text(
                        "PIN : ${pinController.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      Text(
                        "Area : ${areaController.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      Text(
                        "Address : ${addressController.text}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      Text(
                        "Members : ${members.toInt()}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const Divider(height: 35),

                      const Text(
                        "Selected Items",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 10),

                      if(orderItems.isEmpty)

                        const Text(
                          "No Item Selected",
                          style: TextStyle(color: Colors.grey),
                        ),

                      if(orderItems.isNotEmpty)

                        ...orderItems.map((e){

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(

                              children: [

                                const Icon(
                                  Icons.restaurant,
                                  size: 18,
                                  color: Colors.orange,
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: Text(
                                    "${e.item} (${e.variant})",
                                  ),
                                ),

                                Text(
                                  "x${e.qty}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )

                              ],

                            ),
                          );

                        }),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),

                          onPressed: sendWhatsApp,

                          icon: const Icon(
                            Icons.message,
                            color: Colors.white,
                          ),

                          label: const Text(
                            "Send Order on WhatsApp",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ),
                      )

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

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  InputDecoration inputDecoration(
      String text,
      IconData icon,
      ) {
    return InputDecoration(
      labelText: text,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );

}
  Future<void> sendWhatsApp() async {

    if(!_formKey.currentState!.validate()){
      return;
    }

    if(orderItems.isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add at least one item"),
        ),
      );

      return;

    }

    String message = "";

    message += "🌿 Bulk Order\n\n";

    message += "Name : ${nameController.text}\n";

    message += "Phone : ${phoneController.text}\n";

    message += "PIN : ${pinController.text}\n";

    message += "Area : ${areaController.text}\n";

    message += "Address : ${addressController.text}\n";

    message += "Members : ${members.toInt()}\n\n";

    message += "Items\n";

    for(var item in orderItems){

      message +=
      "• ${item.item} (${item.variant}) x ${item.qty}\n";

    }

    final Uri url = Uri.parse(

        "https://wa.me/919935592408?text=${Uri.encodeComponent(message)}"

    );

    if(await canLaunchUrl(url)){

      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

    }

  }

}