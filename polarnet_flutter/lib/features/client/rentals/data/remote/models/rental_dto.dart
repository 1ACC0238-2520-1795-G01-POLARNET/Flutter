class RentalRequestDto {
  final int id;
  final int clientId;
  final int equipmentId;
  final String requestType;
  final String? description;
  final String startDate;
  final String? endDate;
  final String status;
  final double totalPrice;
  final String? notes;
  final String? createdAt;

  RentalRequestDto({
    required this.id,
    required this.clientId,
    required this.equipmentId,
    required this.requestType,
    this.description,
    required this.startDate,
    this.endDate,
    this.status = "pending",
    required this.totalPrice,
    this.notes,
    this.createdAt,
  });

  factory RentalRequestDto.fromMap(Map<String, dynamic> map) {
    return RentalRequestDto(
      id: map['id'] ?? 0,
      clientId: map['client_id'],
      equipmentId: map['equipment_id'],
      requestType: map['request_type'],
      description: map['description'],
      startDate: map['start_date'],
      endDate: map['end_date'],
      status: map['status'] ?? 'pending',
      totalPrice: (map['total_price'] as num).toDouble(),
      notes: map['notes'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_id': clientId,
      'equipment_id': equipmentId,
      'request_type': requestType,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'total_price': totalPrice,
      'notes': notes,
      'created_at': createdAt,
    };
  }
}
