@EndUserText.label: 'Repack Equipments - Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_REPACK_QUERY_PROVIDER'
define root custom entity ZI_REPACK_EQUIPMENTS
{
  key equipmentId : equnr;
  key sourceHU: exidv;
  targetHU: exidv;
  repairOrderId: crmt_object_id;
  hier_level: int1;
  hu: association to ZI_REPACK_HANDLING_UNIT on hu.huId = sourceHU;
  
}
