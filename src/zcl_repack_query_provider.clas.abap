CLASS zcl_repack_query_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_repack_query_provider IMPLEMENTATION.
  METHOD if_rap_query_provider~select.


    DATA(paging) = io_request->get_paging( ).

    DATA(filter) = io_request->get_filter( ).

    DATA(ranges) = filter->get_as_ranges( ).



    CASE io_request->get_entity_id( ).
    WHEN 'ZI_REPACK_HANDLING_UNIT'.

     DATA entity_hu type standard table of zi_repack_handling_unit with key huId.

     if ranges is not initial.



     DATA(search_term) = ranges[ 1 ]-range[ 1 ]-low.

     SELECT * from I_handlingunitheader into table @DATA(hu) where HandlingUnitExternalID = @search_term.

     else.

     SELECT * from I_HANDLINGUNITHEADER into table @hu.

     endif.

     entity_hu = CORRESPONDING #( hu mapping huId = HandlingUnitExternalID
                                              ).

     loop at entity_hu assigning field-symbol(<hu>).
        <hu>-hier_level = 0.
     endloop.

     io_response->set_data( entity_hu ).

     io_response->set_total_number_of_records( lines( entity_hu ) ).

    WHEN 'ZI_REPACK_EQUIPMENTS'.


     DATA entity_equi type standard table of zi_repack_equipments with key equipmentId.

     ranges = filter->get_as_ranges( ).

     if ranges is not initial.


     search_term = ranges[ 1 ]-range[ 1 ]-low.

     SELECT * from ZI_REPACK_EQUI_COMBINED_DATA into table @DATA(items) where HandlingUnitExternalID = @search_term.

     else.

     SELECT * from ZI_REPACK_EQUI_COMBINED_DATA into table @items.

     endif.

     entity_equi = CORRESPONDING #( items mapping equipmentId = equipment
                                                  sourceHU = HandlingUnitExternalID ).

     loop at entity_equi assigning field-symbol(<equi>).
        <equi>-hier_level = 1.
     endloop.

     io_response->set_data( entity_equi ).

     io_response->set_total_number_of_records( lines( entity_equi ) ).

    ENDCASE.
  ENDMETHOD.

ENDCLASS.
