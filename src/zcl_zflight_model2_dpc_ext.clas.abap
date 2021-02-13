CLASS zcl_zflight_model2_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zflight_model2_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS bookingconfirmat_get_entity REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZFLIGHT_MODEL2_DPC_EXT IMPLEMENTATION.


  METHOD bookingconfirmat_get_entity.

    DATA(keys) = io_tech_request_context->get_keys( ).
    LOOP AT keys REFERENCE INTO DATA(key).
      ASSIGN COMPONENT key->*-name OF STRUCTURE er_entity
        TO FIELD-SYMBOL(<comp>).
      IF sy-subrc = 0.
        <comp> = key->*-value.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
