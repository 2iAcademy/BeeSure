/// Enum des types d'incidents
enum IncidentTypeEnum {
  INCENDIE,
  AGRESSION,
  NATUREL,
  VOL,
  ARME,
  AUTRE,
}

/// Configuration associée à chaque type d'incident
class IncidentTypeConfig {
  final int preventionPerimeter;
  final int preventionValidation;

  const IncidentTypeConfig({
    required this.preventionPerimeter,
    required this.preventionValidation,
  });
}

/// Map équivalente à l'objet TypeScript
const Map<IncidentTypeEnum, IncidentTypeConfig> incidentTypeConfigMap = {
  IncidentTypeEnum.AGRESSION: IncidentTypeConfig(
    preventionPerimeter: 100,
    preventionValidation: 50,
  ),
  IncidentTypeEnum.INCENDIE: IncidentTypeConfig(
    preventionPerimeter: 500,
    preventionValidation: 100,
  ),
  IncidentTypeEnum.ARME: IncidentTypeConfig(
    preventionPerimeter: 500,
    preventionValidation: 50,
  ),
  IncidentTypeEnum.NATUREL: IncidentTypeConfig(
    preventionPerimeter: 500,
    preventionValidation: 100,
  ),
  IncidentTypeEnum.VOL: IncidentTypeConfig(
    preventionPerimeter: 50,
    preventionValidation: 10,
  ),
  IncidentTypeEnum.AUTRE: IncidentTypeConfig(
    preventionPerimeter: 50,
    preventionValidation: 10,
  ),
};

extension IncidentTypeExtension on IncidentTypeEnum {
  String get label {
    switch (this) {
    case IncidentTypeEnum.INCENDIE:
    return "Incendie";
    case IncidentTypeEnum.AGRESSION:
    return "Agression";
    case IncidentTypeEnum.NATUREL:
    return "Catastrophe naturelle";
    case IncidentTypeEnum.VOL:
    return "Vol";
    case IncidentTypeEnum.ARME:
    return "Arme";
    case IncidentTypeEnum.AUTRE:
    return "Autre";
    }
  }
}