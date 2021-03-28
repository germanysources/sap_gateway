CLASS zcl_zrfc_service_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zrfc_service_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS flightsset_get_entityset REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ZRFC_SERVICE_DPC_EXT IMPLEMENTATION.


  METHOD flightsset_get_entityset.

    SELECT * FROM sflight INTO CORRESPONDING FIELDS OF TABLE et_entityset.

  ENDMETHOD.
ENDCLASS.
