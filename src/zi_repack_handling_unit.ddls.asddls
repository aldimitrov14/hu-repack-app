@EndUserText.label: 'Repack Handling Unit - Custom Entity'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_REPACK_QUERY_PROVIDER'
define root custom entity ZI_REPACK_HANDLING_UNIT
{
  key huId : exidv ;
  hier_level : int1;
  equipments: association [1..*] to ZI_REPACK_EQUIPMENTS on equipments.sourceHU = huId;
}
