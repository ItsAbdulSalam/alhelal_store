class AddressState {
  final List<Map<String, String>> addresses;
  final int selectedIndex;
  final bool isLoading;

  AddressState({
    required this.addresses,
    required this.selectedIndex,
    this.isLoading = false,
  });
}