import 'package:first_store/models/productModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../models/cart_data.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    // 1. منطق إضافة منتج جديد أو زيادة كمية منتج موجود
    on<AddToCart>((event, emit) {
      final index = globalCartList.indexWhere(
        (item) => item.product.id == event.product.id,
      );
      if (index != -1) {
        globalCartList[index].quantity += event.quantity;
      } else {
        globalCartList.add(
          CartItem(product: event.product, quantity: event.quantity),
        );
      }
      emit(CartUpdated(List.from(globalCartList)));
    });

    // 2. منطق تحديث الكمية (زيادة أو نقصان) من داخل صفحة السلة
    on<UpdateQuantity>((event, emit) {
      final index = globalCartList.indexWhere(
        (item) => item.product.id == event.product.id,
      );
      if (index != -1) {
        if (event.isIncrement) {
          globalCartList[index].quantity++;
        } else {
          if (globalCartList[index].quantity > 1) {
            globalCartList[index].quantity--;
          } else {
            // إذا كانت الكمية 1 وضغط المستخدم على ناقص، يتم حذف المنتج
            globalCartList.removeAt(index);
          }
        }
        emit(CartUpdated(List.from(globalCartList)));
      }
    });

    // 3. منطق حذف منتج معين نهائياً عند الضغط على أيقونة السلة (Trash)
    on<RemoveFromCart>((event, emit) {
      globalCartList.removeWhere((item) => item.product.id == event.product.id);
      emit(CartUpdated(List.from(globalCartList)));
    });

    // 4. الحل النهائي للخطأ: منطق تصفير السلة بالكامل بعد نجاح الدفع
    on<ClearCart>((event, emit) {
      globalCartList.clear(); // مسح كل المحتويات من القائمة العالمية
      emit(
        CartUpdated(List.from(globalCartList)),
      ); // تحديث الواجهة لتعرض "السلة فارغة"
    });
  }
}
