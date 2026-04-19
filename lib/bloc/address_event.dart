abstract class AddressEvent {}

class LoadAddresses extends AddressEvent {}

class SelectAddress extends AddressEvent {
  final int index;
  SelectAddress(this.index);
}

class AddAddress extends AddressEvent {
  final Map<String, String> newAddress;
  AddAddress(this.newAddress);
}