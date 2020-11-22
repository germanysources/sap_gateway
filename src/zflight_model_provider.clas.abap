CLASS zflight_model_provider DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  INHERITING FROM /iwbep/cl_mgw_push_abs_model.

  PUBLIC SECTION.

    METHODS define REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS define_flight_plan_model
      RAISING
        /iwbep/cx_mgw_med_exception.

ENDCLASS.



CLASS ZFLIGHT_MODEL_PROVIDER IMPLEMENTATION.


  METHOD define.

    define_flight_plan_model( ).

    model->set_schema_namespace( 'ZFLIGHT_PLAN' ).

  ENDMETHOD.


  METHOD define_flight_plan_model.

    DATA(entity_type) = model->create_entity_type( iv_entity_type_name = 'FlightPlan' ).
    DATA(carrier_property) = entity_type->create_property( iv_property_name = 'Carrier'
      iv_abap_fieldname = 'CARRID' ).
    carrier_property->set_is_key( ).
    carrier_property->set_type_edm_string( ).
    carrier_property->set_filterable( abap_true ).

    DATA(conn_property) = entity_type->create_property( iv_property_name = 'FlightNumber'
      iv_abap_fieldname = 'CONNID' ).
    conn_property->set_is_key( ).
    conn_property->set_type_edm_string( ).
    conn_property->set_filterable( abap_true ).

    entity_type->bind_structure( iv_structure_name = 'SPFLI'
      iv_bind_conversions = abap_true ).

    DATA(entity_set) = entity_type->create_entity_set( 'FlightPlanSet' ).

  ENDMETHOD.
ENDCLASS.
