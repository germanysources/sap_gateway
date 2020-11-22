CLASS zcl_zflight_model_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zflight_model_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS flightplanset_get_entity REDEFINITION.

    METHODS flightplanset_get_entityset REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZFLIGHT_MODEL_DPC_EXT IMPLEMENTATION.


  METHOD flightplanset_get_entity.
    DATA: BEGIN OF primary_key,
            carrierid    TYPE s_carr_id,
            connectionid TYPE s_conn_id,
          END OF primary_key.

    LOOP AT it_key_tab REFERENCE INTO DATA(key_value_pair).
      ASSIGN COMPONENT key_value_pair->*-name
        OF STRUCTURE primary_key
        TO FIELD-SYMBOL(<comp>).
      IF sy-subrc = 0.
        <comp> = key_value_pair->*-value.
      ENDIF.
    ENDLOOP.

    SELECT SINGLE * FROM spfli INTO er_entity
      WHERE carrid = primary_key-carrierid
      AND connid = primary_key-connectionid.

  ENDMETHOD.


  METHOD flightplanset_get_entityset.

    SELECT * FROM spfli INTO TABLE et_entityset.

  ENDMETHOD.
ENDCLASS.
