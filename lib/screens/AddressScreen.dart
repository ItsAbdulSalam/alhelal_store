import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(LoadAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("عناوين التوصيل | Addresses", 
          style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w900, fontSize: 17)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator(color: Colors.orange));
          if (state.addresses.isEmpty) return const Center(child: Text("لا توجد عناوين مضافة"));

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: state.addresses.length,
            itemBuilder: (context, index) => _buildAddressCard(state, index),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF1A1A1A),
        onPressed: () => _openMapPicker(),
        icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
        label: const Text("إضافة عنوان جديد", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAddressCard(AddressState state, int index) {
    bool isSelected = state.selectedIndex == index;
    var addr = state.addresses[index];
    String title = addr["title_ar"] ?? addr["title"] ?? "عنوان";

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GestureDetector(
        onTap: () => context.read<AddressBloc>().add(SelectAddress(index)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: isSelected ? Colors.orange : Colors.transparent, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: isSelected ? Colors.orange : const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(15)),
                child: Icon(title.contains("منزل") ? Icons.home_rounded : Icons.location_on_rounded, 
                  color: isSelected ? Colors.white : Colors.grey),
              ),
              const Gap(15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$title | ${addr["title_en"] ?? "Address"}", 
                      style: TextStyle(fontWeight: FontWeight.w900, color: isSelected ? Colors.orange : Colors.black)),
                    Text(addr["desc_ar"] ?? addr["desc"] ?? "", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              if (isSelected) const Icon(Icons.check_circle, color: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  void _openMapPicker() {
    // كود الخريطة (تم اختصاره هنا لعدم التكرار، استخدم النسخة التي أرسلتها لك سابقاً)
  }
}