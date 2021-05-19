CLASS zcl_zflight_model_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zflight_model_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS flightplanset_get_entity REDEFINITION.

    METHODS flightplanset_get_entityset REDEFINITION.

    METHODS flightplanset_create_entity REDEFINITION.

    METHODS flightplanset_update_entity REDEFINITION.

    METHODS flightplanset_delete_entity REDEFINITION.

    METHODS flightplansyncse_get_entity REDEFINITION.

    METHODS flightplansyncse_get_entityset REDEFINITION.

    METHODS flightplansyncse_update_entity REDEFINITION.

  PRIVATE SECTION.
    TYPES: BEGIN OF _primary_key,
             carrierid    TYPE s_carr_id,
             connectionid TYPE s_conn_id,
           END OF _primary_key.

    METHODS get_primary_key
      IMPORTING
                it_key_tab    TYPE /iwbep/t_mgw_name_value_pair
      RETURNING VALUE(result) TYPE _primary_key.

    METHODS verify_primary_key
      IMPORTING
        it_key_tab         TYPE /iwbep/t_mgw_name_value_pair
        flight_plan_entity TYPE spfli
      RAISING
        /iwbep/cx_mgw_busi_exception.

    METHODS check_last_change
      IMPORTING
        flight_plan_entity TYPE zspfliv
      RAISING
        /iwbep/cx_mgw_busi_exception.

    METHODS verify_airport
      IMPORTING
        flight_plan_entity TYPE spfli
      RAISING
        /iwbep/cx_mgw_busi_exception.

ENDCLASS.



CLASS ZCL_ZFLIGHT_MODEL_DPC_EXT IMPLEMENTATION.


  METHOD check_last_change.

    SELECT COUNT(*) FROM zspfli_changes
      WHERE carrid = flight_plan_entity-carrid AND connid = flight_plan_entity-connid
      AND last_change > flight_plan_entity-last_change.
    IF sy-subrc = 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid           = VALUE #( msgid = 'ZFLIGHT_MODEL' msgno = 002 )
          http_status_code = /iwbep/cx_mgw_busi_exception=>gcs_http_status_codes-bad_request.
    ENDIF.

  ENDMETHOD.


  METHOD flightplanset_create_entity.
    DATA: flight_plan_entity TYPE spfli.

    io_data_provider->read_entry_data( IMPORTING es_data = flight_plan_entity ).

    INSERT spfli FROM flight_plan_entity.
    IF sy-subrc = 0.
      er_entity = flight_plan_entity.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid           = VALUE #( msgid = 'ZFLIGHT_MODEL' msgno = 000 )
          http_status_code = /iwbep/cx_mgw_busi_exception=>gcs_http_status_codes-bad_request.
    ENDIF.

  ENDMETHOD.


  METHOD flightplanset_delete_entity.

    DATA(primary_key) = get_primary_key( it_key_tab ).

    DELETE FROM spfli WHERE carrid = primary_key-carrierid AND
      connid = primary_key-connectionid.

  ENDMETHOD.


  METHOD flightplanset_get_entity.

    DATA(primary_key) = get_primary_key( it_key_tab ).

    SELECT SINGLE * FROM spfli INTO er_entity
      WHERE carrid = primary_key-carrierid
      AND connid = primary_key-connectionid.

  ENDMETHOD.


  METHOD flightplanset_get_entityset.
    DATA: offset    TYPE i,
          page_size TYPE i.

    DATA(osql_where_clause) = io_tech_request_context->get_osql_where_clause( ).

    IF io_tech_request_context->get_top( ) IS NOT INITIAL.
      " deliver a package
      page_size = CONV i( io_tech_request_context->get_top( ) )
        - CONV i( io_tech_request_context->get_skip( ) ).
      offset = io_tech_request_context->get_skip( ).
      SELECT * FROM spfli WHERE (osql_where_clause)
        ORDER BY carrid, connid INTO TABLE @et_entityset
        OFFSET @offset UP TO @page_size ROWS.
    ELSE.
      " deliver the result at once
      SELECT * FROM spfli INTO TABLE et_entityset
        WHERE (osql_where_clause).
    ENDIF.

    CLEAR es_response_context-inlinecount.
    IF io_tech_request_context->has_inlinecount( ) = abap_true.
      SELECT COUNT(*) FROM spfli
        WHERE (osql_where_clause).
      es_response_context-inlinecount = sy-dbcnt.
    ENDIF.

  ENDMETHOD.


  METHOD flightplanset_update_entity.
    DATA: flight_plan_entity TYPE spfli,
          last_change        TYPE zspfli_changes.

    io_data_provider->read_entry_data( IMPORTING es_data = flight_plan_entity ).
    verify_primary_key( it_key_tab = it_key_tab flight_plan_entity = flight_plan_entity ).

    verify_airport( flight_plan_entity ).

    UPDATE spfli FROM flight_plan_entity.
    IF sy-subrc = 0.
      er_entity = flight_plan_entity.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid           = VALUE #( msgid = 'ZFLIGHT_MODEL' msgno = 001 )
          http_status_code = /iwbep/cx_mgw_busi_exception=>gcs_http_status_codes-bad_request.
    ENDIF.

    last_change-carrid = flight_plan_entity-carrid.
    last_change-connid = flight_plan_entity-connid.
    GET TIME STAMP FIELD last_change-last_change.
    MODIFY zspfli_changes FROM last_change.

  ENDMETHOD.


  METHOD flightplansyncse_get_entity.

    DATA(primary_key) = get_primary_key( it_key_tab ).

    SELECT SINGLE * FROM zspfli
      INTO CORRESPONDING FIELDS OF @er_entity
      WHERE carrid = @primary_key-carrierid
      AND connid = @primary_key-connectionid.

  ENDMETHOD.


  METHOD flightplansyncse_get_entityset.
    DATA: offset    TYPE i,
          page_size TYPE i.

    DATA(osql_where_clause) = io_tech_request_context->get_osql_where_clause( ).

    IF io_tech_request_context->get_top( ) IS NOT INITIAL.
      " deliver a package
      page_size = CONV i( io_tech_request_context->get_top( ) )
        - CONV i( io_tech_request_context->get_skip( ) ).
      offset = io_tech_request_context->get_skip( ).
      SELECT * FROM zspfli WHERE (osql_where_clause)
        ORDER BY carrid, connid
        INTO CORRESPONDING FIELDS OF TABLE @et_entityset
        OFFSET @offset UP TO @page_size ROWS.
    ELSE.
      " deliver the result at once
      SELECT * FROM zspfli
        INTO CORRESPONDING FIELDS OF TABLE @et_entityset
        WHERE (osql_where_clause).
    ENDIF.

    CLEAR es_response_context-inlinecount.
    IF io_tech_request_context->has_inlinecount( ) = abap_true.
      SELECT COUNT(*) FROM zspfli
        WHERE (osql_where_clause).
      es_response_context-inlinecount = sy-dbcnt.
    ENDIF.

  ENDMETHOD.


  METHOD flightplansyncse_update_entity.
    DATA: flight_plan_entity    TYPE zspfliv,
          flight_plan_db_entity TYPE spfli,
          last_change           TYPE zspfli_changes.

    io_data_provider->read_entry_data( IMPORTING es_data = flight_plan_entity ).

    CALL FUNCTION 'ENQUEUE_EZSPFLI'
      EXPORTING
        carrid       = flight_plan_entity-carrid
        connid       = flight_plan_entity-connid
      EXCEPTIONS
        foreign_lock = 4.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid           = VALUE #( msgid = 'ZFLIGHT_MODEL' msgno = 003 )
          http_status_code = /iwbep/cx_mgw_busi_exception=>gcs_http_status_codes-forbidden.
    ENDIF.

    check_last_change( flight_plan_entity ).

    ##ENH_OK
    MOVE-CORRESPONDING flight_plan_entity TO flight_plan_db_entity.
    ##ENH_OK
    MOVE-CORRESPONDING flight_plan_entity TO last_change.
    verify_primary_key( it_key_tab = it_key_tab flight_plan_entity = flight_plan_db_entity ).
    verify_airport( flight_plan_db_entity ).

    UPDATE spfli FROM flight_plan_db_entity.
    IF sy-subrc = 0.
      er_entity = flight_plan_entity.
    ELSE.
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid           = VALUE #( msgid = 'ZFLIGHT_MODEL' msgno = 001 )
          http_status_code = /iwbep/cx_mgw_busi_exception=>gcs_http_status_codes-bad_request.
    ENDIF.

    GET TIME STAMP FIELD last_change-last_change.
    MODIFY zspfli_changes FROM last_change.

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


  METHOD verify_airport.

    SELECT COUNT(*) FROM sairport
      WHERE id = flight_plan_entity-airpfrom.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_model
        EXPORTING
          textid  = zcx_flight_model=>airport_unknown
          airport = flight_plan_entity-airpfrom.
    ENDIF.

    SELECT COUNT(*) FROM sairport
      WHERE id = flight_plan_entity-airpto.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_flight_model
        EXPORTING
          textid  = zcx_flight_model=>airport_unknown
          airport = flight_plan_entity-airpto.
    ENDIF.

  ENDMETHOD.


  METHOD verify_primary_key.

    DATA(primary_key) = get_primary_key( it_key_tab ).

    IF NOT ( flight_plan_entity-carrid = primary_key-carrierid AND
      flight_plan_entity-connid = primary_key-connectionid ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          textid           = VALUE #( msgid = 'ZFLIGHT_MODEL' msgno = 002 )
          http_status_code = /iwbep/cx_mgw_busi_exception=>gcs_http_status_codes-bad_request.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
