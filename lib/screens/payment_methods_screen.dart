import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  int selectedPaymentIndex = 0;
  List<Map<String, dynamic>> cards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  // تحميل الكروت من الذاكرة
  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedCards = prefs.getString('user_cards');
    if (savedCards != null) {
      setState(() {
        cards = List<Map<String, dynamic>>.from(json.decode(savedCards));
        isLoading = false;
      });
    } else {
      // كروت افتراضية لأول مرة
      cards = [
        {
          "type": "Visa",
          "number": "4422 **** **** ****",
          "expiry": "09/27",
          "color": 0xFF1A1A1A,
        },
        {
          "type": "MasterCard",
          "number": "8855 **** **** ****",
          "expiry": "12/26",
          "color": 0xFFC5A059,
        },
      ];
      setState(() => isLoading = false);
    }
  }

  // حفظ الكروت في الذاكرة
  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_cards', json.encode(cards));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text(
          "طرق الدفع",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : Column(
              children: [
                const Gap(20),
                _buildCardsSlider(),
                const Gap(30),
                _buildAddCardButton(),
                const Spacer(),
                _buildConfirmButton(),
              ],
            ),
    );
  }

  Widget _buildCardsSlider() {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedPaymentIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedPaymentIndex = index),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width * 0.82,
                  margin: const EdgeInsets.only(left: 15, bottom: 10),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Color(cards[index]["color"]),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? Colors.orange : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cards[index]["type"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const Icon(
                            Icons.contactless_outlined,
                            color: Colors.white54,
                          ),
                        ],
                      ),
                      Text(
                        cards[index]["number"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "ALHELAL PRIME",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            cards[index]["expiry"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // زر التعديل فوق الكرت
                Positioned(
                  top: 10,
                  right: 25,
                  child: IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white70,
                      size: 20,
                    ),
                    onPressed: () => _showCardDialog(index: index),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddCardButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () => _showCardDialog(), // إضافة كرت جديد
        icon: const Icon(Icons.add_circle_outline, color: Colors.black),
        label: const Text(
          "إضافة بطاقة جديدة",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // نافذة الإضافة والتعديل الموحدة
  void _showCardDialog({int? index}) {
    TextEditingController numCtrl = TextEditingController(
      text: index != null ? cards[index]["number"] : "",
    );
    TextEditingController expCtrl = TextEditingController(
      text: index != null ? cards[index]["expiry"] : "",
    );
    String type = index != null ? cards[index]["type"] : "Visa";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 25,
          right: 25,
          top: 25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              index == null ? "إضافة بطاقة" : "تعديل البطاقة",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Gap(20),
            TextField(
              controller: numCtrl,
              decoration: const InputDecoration(
                labelText: "رقم البطاقة (مثال: 4422 **** **** ****)",
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(15),
            TextField(
              controller: expCtrl,
              decoration: const InputDecoration(
                labelText: "تاريخ الانتهاء (MM/YY)",
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                setState(() {
                  if (index == null) {
                    cards.add({
                      "type": type,
                      "number": numCtrl.text,
                      "expiry": expCtrl.text,
                      "color": 0xFF1A1A1A,
                    });
                  } else {
                    cards[index] = {
                      "type": type,
                      "number": numCtrl.text,
                      "expiry": expCtrl.text,
                      "color": cards[index]["color"],
                    };
                  }
                });
                _saveCards();
                Navigator.pop(context);
              },
              child: const Text(
                "حفظ البطاقة",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم اختيار طريقة الدفع بنجاح")),
          );
          Navigator.pop(context);
        },
        child: const Text(
          "تأكيد طريقة الدفع",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
