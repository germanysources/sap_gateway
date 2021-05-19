CLASS zcx_flight_model DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cx_mgw_busi_exception
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS: BEGIN OF airport_unknown,
      msgid TYPE symsgid VALUE 'ZFLIGHT_MODEL',
      msgno TYPE symsgno VALUE '004',
      attr1 TYPE scx_attrname VALUE 'AIRPORT',
      attr2 TYPE scx_attrname VALUE '',
      attr3 TYPE scx_attrname VALUE '',
      attr4 TYPE scx_attrname VALUE '',
    END OF airport_unknown.
    DATA: airport TYPE s_airport.

    METHODS constructor
      IMPORTING
        !textid                 LIKE if_t100_message=>t100key OPTIONAL
        !previous               LIKE previous OPTIONAL
        !message_container      TYPE REF TO /iwbep/if_message_container OPTIONAL
        !http_status_code       TYPE /iwbep/mgw_http_status_code DEFAULT gcs_http_status_codes-bad_request
        !http_header_parameters TYPE /iwbep/t_mgw_name_value_pair OPTIONAL
        !sap_note_id            TYPE /iwbep/mgw_sap_note_id OPTIONAL
        !msg_code               TYPE string OPTIONAL
        !entity_type            TYPE string OPTIONAL
        !message                TYPE bapi_msg OPTIONAL
        !message_unlimited      TYPE string OPTIONAL
        !filter_param           TYPE string OPTIONAL
        !operation_no           TYPE i OPTIONAL
        airport                 TYPE s_airport OPTIONAL.
protected section.
private section.
ENDCLASS.



CLASS ZCX_FLIGHT_MODEL IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
MESSAGE_CONTAINER = MESSAGE_CONTAINER
HTTP_STATUS_CODE = HTTP_STATUS_CODE
HTTP_HEADER_PARAMETERS = HTTP_HEADER_PARAMETERS
SAP_NOTE_ID = SAP_NOTE_ID
MSG_CODE = MSG_CODE
ENTITY_TYPE = ENTITY_TYPE
MESSAGE = MESSAGE
MESSAGE_UNLIMITED = MESSAGE_UNLIMITED
FILTER_PARAM = FILTER_PARAM
OPERATION_NO = OPERATION_NO
.
me->AIRPORT = AIRPORT .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
