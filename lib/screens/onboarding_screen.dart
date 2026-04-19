import 'package:first_store/screens/auth/auth_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
 // تأكد من المسار

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // بيانات الصفحات الثلاث
  final List<Map<String, String>> _onboardingData = [
    {
      "title": "أحدث التقنيات",
      "desc":
          "اكتشف تشكيلة واسعة من أحدث أجهزة الآيفون، الساعات الذكية، والسماعات الأصلية في مكان واحد.",
      "image": "assets/SplashScreen/1.jpeg",
    },
    {
      "title": "دفع آمن وسريع",
      "desc":
          "نوفر لك خيارات دفع متعددة وآمنة تماماً لضمان أفضل تجربة شراء لعملائنا في إسطنبول.",
      "image": "assets/SplashScreen/2.jpeg",
    },
    {
      "title": "توصيل لباب بيتك",
      "desc":
          "استمتع بخدمة توصيل سريعة وموثوقة لجميع مشترياتك بأعلى معايير الجودة.",
      "image": "assets/SplashScreen/3.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. الصفحات المنزلقة
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return _buildPageContent(
                _onboardingData[index]['title']!,
                _onboardingData[index]['desc']!,
                _onboardingData[index]['image']!,
              );
            },
          ),

          // 2. العناصر الثابتة في الأسفل (النقط والزر)
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // مؤشر النقط (Dots Indicator)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => _buildDot(index),
                  ),
                ),
                const Gap(40),

                // زر الانتقال أو البدء
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        // الانتقال لصفحة الترحيب في الصفحة الأخيرة
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthWelcomeScreen(),
                          ),
                        );
                      } else {
                        // الانتقال للصفحة التالية
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      _currentPage == _onboardingData.length - 1
                          ? "ابدأ الآن"
                          : "التالي",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ودجت بناء محتوى كل صفحة
  Widget _buildPageContent(String title, String desc, String image) {
    return Column(
      children: [
        // الصورة تأخذ الجزء العلوي بالكامل
        Expanded(
          flex: 3,
          child: Image.asset(image, fit: BoxFit.cover, width: double.infinity),
        ),
        // النصوص في الجزء السفلي
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const Gap(40),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(20),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ودجت النقطة
  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8, // تطول النقطة عند الاختيار
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.orange : Colors.grey[600],
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
