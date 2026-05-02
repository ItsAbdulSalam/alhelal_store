import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_store/bloc/address_event.dart';
import 'package:first_store/bloc/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AddressBloc()
      : super(AddressState(addresses: [], selectedIndex: 0, isLoading: true)) {
    
    // 1. ── تحميل العناوين من Firestore ──
    on<LoadAddresses>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final user = _auth.currentUser;
        if (user == null) return;

        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .orderBy('createdAt', descending: true) // ترتيب العناوين حسب الأحدث
            .get();

        final loaded = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            "id": doc.id,
            "title": data['title']?.toString() ?? "",
            "desc": data['desc']?.toString() ?? "",
            "isDefault": data['isDefault'] ?? false,
          };
        }).toList();

        int defaultIndex = loaded.indexWhere((addr) => addr['isDefault'] == true);
        if (defaultIndex == -1) defaultIndex = 0;

        emit(state.copyWith(
          addresses: loaded,
          selectedIndex: defaultIndex,
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        // ignore: avoid_print
        print("خطأ في تحميل العناوين: $e");
      }
    });

    // 2. ── إضافة عنوان جديد ──
    on<AddAddress>((event, emit) async {
      try {
        final user = _auth.currentUser;
        if (user == null) return;

        // إضافة العنوان إلى Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .add({
          'title': event.title,
          'desc': event.desc,
          'isDefault': state.addresses.isEmpty, // اجعله افتراضي إذا كانت القائمة فارغة
          'createdAt': FieldValue.serverTimestamp(),
        });

        // إعادة تحميل القائمة لتحديث الواجهة
        add(LoadAddresses());
      } catch (e) {
        // ignore: avoid_print
        print("خطأ في إضافة العنوان: $e");
      }
    });

    // 3. ── حذف عنوان ──
    on<DeleteAddress>((event, emit) async {
      try {
        final user = _auth.currentUser;
        if (user == null) return;

        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('addresses')
            .doc(event.addressId)
            .delete();

        add(LoadAddresses());
      } catch (e) {
        // ignore: avoid_print
        print("خطأ في حذف العنوان: $e");
      }
    });

    // 4. ── اختيار العنوان (تحديث الـ UI) ──
    on<SelectAddress>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}