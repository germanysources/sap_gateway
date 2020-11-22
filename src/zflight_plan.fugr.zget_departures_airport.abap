FUNCTION ZGET_DEPARTURES_AIRPORT .
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     VALUE(AIRPORT) TYPE  ZAIRPORT
*"     VALUE(DATE) TYPE  DATS
*"  EXPORTING
*"     VALUE(DEPARTURES) TYPE  ZFLIGHT_PLAN_T
*"----------------------------------------------------------------------

  ##TOO_MANY_ITAB_FIELDS
  SELECT * FROM spfli INTO CORRESPONDING FIELDS OF TABLE departures
    WHERE airpfrom = airport
    AND EXISTS ( SELECT * FROM sflight WHERE carrid = spfli~carrid
      AND connid = spfli~connid AND fldate = date ).

ENDFUNCTION.
