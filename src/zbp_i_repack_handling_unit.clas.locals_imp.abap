CLASS lcl_buffer definition.
  PUBLIC SECTION.
    class-data equipments type table for create zi_repack_handling_unit\equipments.
ENDCLASS.



CLASS lhc_zi_repack_handling_unit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_repack_handling_unit RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_repack_handling_unit.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_repack_handling_unit RESULT result.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_repack_handling_unit.
    METHODS rba_equipments FOR READ
      IMPORTING keys_rba FOR READ zi_repack_handling_unit\equipments FULL result_requested RESULT result LINK association_links.

    METHODS cba_equipments FOR MODIFY
      IMPORTING entities_cba FOR CREATE zi_repack_handling_unit\equipments.


ENDCLASS.

CLASS lhc_zi_repack_handling_unit IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD rba_Equipments.
  ENDMETHOD.

  METHOD cba_Equipments.

    lcl_buffer=>equipments = entities_cba.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_repack_handling_unit DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_repack_handling_unit IMPLEMENTATION.

  METHOD finalize.


  ENDMETHOD.

  METHOD check_before_save.

  ENDMETHOD.

  METHOD save.

    DATa repack_tab type standard table of bapihurepack.

    data serial_num_tab type standard table of bapihuitmserialno.

    DATA return_tab type standard table of bapiret2.

    DATA hu_target type exidv.

    data(equipments) = lcl_buffer=>equipments[ 1 ]-%target.

    SELECT * from zi_repack_equi_combined_data for all entries in @equipments
    where HandlingUnitExternalID = @equipments-sourcehu
    and Equipment = @equipments-equipmentId INTO TABLE @DATA(combined_equi_data).

    loop at equipments assigning field-symbol(<equipments>) group by <equipments>-targethu.

      LOOP at group <equipments> assigning field-symbol(<equipment>).

        DATA(current_equi_data) = combined_equi_data[ equipment = <equipment>-equipmentId HandlingUnitExternalID = <equipment>-sourcehu  ].

        if hu_target is initial.
         hu_target = <equipment>-targethu.
        endif.

        APPEND VALUE #( source_hu = <equipment>-sourcehu
                        flag_packhu = abap_false
                        pack_qty = 1
                        material = current_equi_data-material
                        plant = current_equi_data-plant
                        stge_loc = current_equi_data-storagelocation ) TO repack_tab.

        APPEND VALUE #( serialno = <equipment>-equipmentId
                        row_index = sy-tabix ) to serial_num_tab.

      endloop.

            CALL FUNCTION 'BAPI_HU_REPACK'
        EXPORTING
            hukey         = hu_target
        TABLES
            repack        = repack_tab
            itemsserialno = serial_num_tab
            return        = return_tab.

    clear: hu_target, repack_tab, serial_num_tab, return_tab.

    endloop.

  ENDMETHOD.

  METHOD cleanup.
    clear lcl_buffer=>equipments.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
