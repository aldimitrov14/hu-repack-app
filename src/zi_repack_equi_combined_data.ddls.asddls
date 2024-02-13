@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Combined Data for equipments - with serial numbers'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_REPACK_EQUI_COMBINED_DATA as select from I_HandlingUnitItem
{
    key HandlingUnitInternalID,
    key HandlingUnitItem,
    HandlingUnitExternalID,
    Plant,
    StorageLocation,
    Material,
    _HandlingUnitSerialNumber.Equipment
}
