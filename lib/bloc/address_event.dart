abstract class AddressEvent {}

class LoadAddresses extends AddressEvent {}

class SelectAddress extends AddressEvent {
  final int index;
  SelectAddress(this.index);
}

class AddAddress extends AddressEvent {
  final String title;
  final String desc;
  AddAddress({required this.title, required this.desc});
}

class DeleteAddress extends AddressEvent {
  final String addressId;
  DeleteAddress(this.addressId);
}
