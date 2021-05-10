CLASS zcl_zflight_model3_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zflight_model3_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS flightschedulese_get_entity
      REDEFINITION.
    METHODS flightschedulese_get_entityset
      REDEFINITION.

  PRIVATE SECTION.
    TYPES: BEGIN OF _primary_key,
             carrierid    TYPE s_carr_id,
             connectionid TYPE s_conn_id,
             flightdate   TYPE s_date,
           END OF _primary_key.

    METHODS get_primary_key
      IMPORTING
                it_key_tab    TYPE /iwbep/t_mgw_name_value_pair
      RETURNING VALUE(result) TYPE _primary_key.
ENDCLASS.



CLASS ZCL_ZFLIGHT_MODEL3_DPC_EXT IMPLEMENTATION.


  METHOD flightschedulese_get_entity.

    DATA(primary_key) = get_primary_key( it_key_tab ).

    SELECT SINGLE * FROM zflight_schedule
      INTO CORRESPONDING FIELDS OF @er_entity
      WHERE carrid = @primary_key-carrierid
      AND connid = @primary_key-connectionid
      AND fldate = @primary_key-flightdate.

  ENDMETHOD.


  METHOD flightschedulese_get_entityset.
    DATA: offset    TYPE i,
          page_size TYPE i.

    DATA(osql_where_clause) = io_tech_request_context->get_osql_where_clause( ).

    IF io_tech_request_context->get_top( ) IS NOT INITIAL.
      " deliver a package
      page_size = CONV i( io_tech_request_context->get_top( ) )
        - CONV i( io_tech_request_context->get_skip( ) ).
      offset = io_tech_request_context->get_skip( ).
      SELECT * FROM zflight_schedule WHERE (osql_where_clause)
        ORDER BY carrid, connid
        INTO CORRESPONDING FIELDS OF TABLE @et_entityset
        OFFSET @offset UP TO @page_size ROWS.
    ELSE.
      " deliver the result at once
      SELECT * FROM zflight_schedule
        INTO CORRESPONDING FIELDS OF TABLE @et_entityset
        WHERE (osql_where_clause).
    ENDIF.

    CLEAR es_response_context-inlinecount.
    IF io_tech_request_context->has_inlinecount( ) = abap_true.
      SELECT COUNT(*) FROM zflight_schedule
        WHERE (osql_where_clause).
      es_response_context-inlinecount = sy-dbcnt.
    ENDIF.

  ENDMETHOD.


  METHOD get_primary_key.

    LOOP AT it_key_tab REFERENCE INTO DATA(key_value_pair).
      ASSIGN COMPONENT key_value_pair->*-name
        OF STRUCTURE result
        TO FIELD-SYMBOL(<comp>).
      IF sy-subrc = 0.
        <comp> = key_value_pair->*-value.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
