import 'package:flutter/material.dart';
 // استيراد المكتبة
import 'package:gap/gap.dart';

void showRatingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(10),
          const Icon(Icons.stars_rounded, color: Colors.orange, size: 60),
          const Gap(20),
          const Text(
            "ما رأيك في تجربتك؟",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const Gap(10),
          const Text(
            "تقييمك يساعدنا على تقديم خدمة أفضل في إسطنبول",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const Gap(25),

          // ويدجت النجوم
      

          const Gap(25),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "اكتب رأيك هنا (اختياري)...",
              fillColor: Colors.grey[100],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Gap(25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("شكراً لك! تم استلام تقييمك بنجاح."),
                ),
              );
            },
            child: const Text(
              "إرسال التقييم",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}
