import 'dart:io';

class EquipmentDetailsData {
  final String manufacturerName;
  final String modelNumber;
  final String serialNumber;
  final String systemType;
  final int basementInlets;
  final int firstFloorInlets;
  final int secondFloorInlets;
  final int thirdFloorInlets;
  final List<int>? additionalFloorInlets;
  final List<File>? photos;
  final List<File>? videos;
  final String additionalNotes;

  EquipmentDetailsData({
    required this.manufacturerName,
    required this.modelNumber,
    required this.serialNumber,
    required this.systemType,
    required this.basementInlets,
    required this.firstFloorInlets,
    required this.secondFloorInlets,
    required this.thirdFloorInlets,
    this.additionalFloorInlets,
    this.photos,
    this.videos,
    required this.additionalNotes,
  });
}

class FloorInlets {
  final String label;
  final int inlets;

  FloorInlets({required this.label, required this.inlets});
}
