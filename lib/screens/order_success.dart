import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';

class OrderSuccessScreen extends StatelessWidget {
  final double totalPrice;
  const OrderSuccessScreen({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const Gap(20),
              const Text("تم الطلب بنجاح!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Gap(20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("المبلغ الإجمالي المدفوع:"),
                    Text("\$${totalPrice.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  ],
                ),
              ),
              const Gap(40),
              ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(ClearCart()); // تصفير السلة
                  Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
                },
                child: const Text("العودة للرئيسية"),
              )
            ],
          ),
        ),
      ),
    );
  }
}