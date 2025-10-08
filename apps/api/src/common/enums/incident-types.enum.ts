// src/incident-type/enums/incident-type.enum.ts

export enum IncidentTypeEnum {
    INCENDIE = 'INCENDIE',
    AGRESSION = 'AGRESSION',
    NATUREL = 'NATUREL',
    VOL = 'VOL',
    ARME = 'ARME',
    AUTRE = 'AUTRE',
    }

export const IncidentTypeConfig: Record<
    IncidentTypeEnum,
    { prevention_perimeter: number; prevention_validation: number }
> = {
    [IncidentTypeEnum.AGRESSION]: {
        prevention_perimeter: 100,
        prevention_validation: 50,
    },
    [IncidentTypeEnum.INCENDIE]: {
        prevention_perimeter: 500,
        prevention_validation: 100,
    },
    [IncidentTypeEnum.ARME]: {
        prevention_perimeter: 500,
        prevention_validation: 50,
    },
    [IncidentTypeEnum.NATUREL]: {
        prevention_perimeter: 500,
        prevention_validation: 100,
    },
    [IncidentTypeEnum.VOL]: {
        prevention_perimeter: 50,
        prevention_validation: 10,
    },
    [IncidentTypeEnum.AUTRE]: {
        prevention_perimeter: 50,
        prevention_validation: 10,
    },
};
