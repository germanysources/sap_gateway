*&---------------------------------------------------------------------*
*& Report ZFILL_FLIGHT_MODEL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFILL_FLIGHT_MODEL.

START-OF-SELECTION.

  DATA(airlines) = VALUE scarr_tab(
    ( carrid = 'LH' carrname = 'Lufthansa' )
    ( carrid = 'EK' carrname = 'Emirates' )
  ).
  MODIFY scarr FROM TABLE airlines.

  DATA(plan) = VALUE spfli_tab(
    ( carrid = 'LH' connid = '0700'
    countryfr = 'DE' cityfrom = 'Munich' airpfrom = 'MUC'
    countryto = 'DE' cityto = 'Frankfurt' airpto = 'FRA'
    fltime = 60 distance = 300 distid = 'KM' )
     ( carrid = 'EK' connid = '0400'
    countryfr = 'DE' cityfrom = 'Munich' airpfrom = 'MUC'
    countryto = 'DE' cityto = 'Dubai' airpto = 'DXB'
    fltime = 180 distance = 3000 distid = 'KM' )
  ).
  MODIFY spfli FROM TABLE plan.

  DATA(last_change) = VALUE zspfli_changes( carrid = 'LH' connid = '0700' ).
  GET TIME STAMP FIELD last_change-last_change.
  MODIFY zspfli_changes FROM last_change.
  last_change = VALUE #( carrid = 'EK' connid = '0400' ).
  GET TIME STAMP FIELD last_change-last_change.
  MODIFY zspfli_changes FROM last_change.

  DATA(flight) = VALUE sflight( carrid = 'LH' connid = '0700'
    fldate = '20201101' ).
  MODIFY sflight FROM flight.

  DATA(airport) = VALUE sairport( id = 'MUC' name = 'Flughafen Muenchen' ).
  INSERT sairport FROM airport.
  airport = VALUE #( id = 'FRA' name = 'Flughafen Frankfurt' ).
  INSERT sairport FROM airport.
  airport = VALUE #( id = 'DXB' name = 'Flughafen Dubai' ).
  INSERT sairport FROM airport.

  DATA(city_airport) = VALUE scitairp( city = 'Muenchen' country = 'DE' airport = 'MUC' ).
  INSERT scitairp FROM city_airport.
  city_airport = VALUE #( city = 'Frankfurt' country = 'DE' airport = 'FRA' ).
  INSERT scitairp FROM city_airport.
  city_airport = VALUE #( city = 'Dubai' country = 'UAE' airport = 'DXB' ).
  INSERT scitairp FROM city_airport.
