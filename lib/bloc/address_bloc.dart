import 'dart:convert';

import 'package:first_store/bloc/address_event.dart';
import 'package:first_store/bloc/address_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc()
    : super(AddressState(addresses: [], selectedIndex: 0, isLoading: true)) {
    on<LoadAddresses>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final String? savedData = prefs.getString('user_addresses');
      final int savedIndex = prefs.getInt('selected_index') ?? 0;

      if (savedData != null) {
        List<Map<String, String>> loaded = List<Map<String, String>>.from(
          json.decode(savedData).map((item) => Map<String, String>.from(item)),
        );
        emit(AddressState(addresses: loaded, selectedIndex: savedIndex));
      } else {
        emit(
          AddressState(
            addresses: [
              {"title": "المنزل", "desc": "Istanbul -  Esenler  -  519Street"},
              {"title": "العمل", "desc": "Istanbul - Eyüpsultan - Flatofis"},
            ].toList(),
            selectedIndex: 0,
          ),
        );
      }
    });

    on<SelectAddress>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('selected_index', event.index);
      emit(
        AddressState(addresses: state.addresses, selectedIndex: event.index),
      );
    });
  }
}
