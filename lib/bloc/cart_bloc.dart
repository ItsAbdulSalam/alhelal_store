// ═══════════════════════════════════════════════════════════
//  cart_bloc.dart — Cloud Synchronized Version
// ═══════════════════════════════════════════════════════════
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_store/models/productModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CartBloc() : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart); // حدث جديد لتحميل السلة من السحابة
    on<AddToCart>(_onAdd);
    on<UpdateQuantity>(_onUpdate);
    on<RemoveFromCart>(_onRemove);
    on<ClearCart>(_onClear);
  }

  // 1. تحميل السلة عند فتح التطبيق
  Future<void> _onLoadCart(LoadCart e, Emitter<CartState> emit) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();
    final items = snapshot.docs
        .map((doc) => CartItem.fromMap(doc.data()))
        .toList();

    emit(CartUpdated(items));
  }

  // 2. إضافة منتج وتحديث السحابة
  Future<void> _onAdd(AddToCart e, Emitter<CartState> emit) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final cartDoc = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(e.product.id);

    // إذا كان المنتج موجوداً نزيد الكمية، وإذا لم يكن موجوداً ننشئه
    await cartDoc.set({
      'product': e.product.toMap(),
      'quantity': FieldValue.increment(e.quantity),
    }, SetOptions(merge: true));

    add(LoadCart()); // إعادة التحميل لضمان دقة البيانات
  }

  // 3. تحديث الكمية (+ أو -)
  Future<void> _onUpdate(UpdateQuantity e, Emitter<CartState> emit) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final cartDoc = _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(e.product.id);

    if (e.isIncrement) {
      await cartDoc.update({'quantity': FieldValue.increment(1)});
    } else {
      // منطق الحذف إذا وصلت الكمية لـ 1 وضغط المستخدم ناقص
      final doc = await cartDoc.get();
      if (doc.exists && doc.data()?['quantity'] > 1) {
        await cartDoc.update({'quantity': FieldValue.increment(-1)});
      } else {
        await cartDoc.delete();
      }
    }
    add(LoadCart());
  }

  // 4. حذف منتج نهائياً
  Future<void> _onRemove(RemoveFromCart e, Emitter<CartState> emit) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .doc(e.product.id)
        .delete();
    add(LoadCart());
  }

  // 5. تفريغ السلة (بعد إتمام الشراء)
  Future<void> _onClear(ClearCart e, Emitter<CartState> emit) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final cartItems = await _firestore
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();
    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }
    emit(CartUpdated([]));
  }
}
