*&---------------------------------------------------------------------*
*& Report ZFILL_FLIGHT_MODEL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFILL_FLIGHT_MODEL.

START-OF-SELECTION.

  DATA(plan) = VALUE spfli( carrid = 'LH' connid = '0700'
    countryfr = 'DE' cityfrom = 'Munich' airpfrom = 'MUC'
    countryto = 'DE' cityto = 'Frankfurt' airpto = 'FRA'
    fltime = 60 distance = 300 distid = 'KM' ).
  MODIFY spfli FROM plan.

  DATA(flight) = VALUE sflight( carrid = 'LH' connid = '0700'
    fldate = '20201101' ).
  MODIFY sflight FROM flight.
