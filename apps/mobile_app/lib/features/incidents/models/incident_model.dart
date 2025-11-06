import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/base_model.dart';

@JsonSerializable()
class CreateIncident {
  final String userId;
  final String typeId;
  final String description;
  final double locationLatt;
  final double locationLong;

  CreateIncident({
    required this.userId,
    required this.typeId,
    required this.description,
    required this.locationLatt,
    required this.locationLong,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'type_id': typeId,
      'description': description,
      'location_latt': locationLatt,
      'location_long': locationLong,
    };
  }
}
