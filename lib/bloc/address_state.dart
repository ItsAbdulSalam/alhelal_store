class AddressState {
  final List<Map<String, dynamic>> addresses;
  final int selectedIndex;
  final bool isLoading;

  AddressState({
    required this.addresses,
    required this.selectedIndex,
    this.isLoading = false,
  });

  // أضف هذا الجزء تحديداً
  AddressState copyWith({
    List<Map<String, dynamic>>? addresses,
    int? selectedIndex,
    bool? isLoading,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
