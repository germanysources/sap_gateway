interface ZIF_ZGET_DEPARTURES_AIRPORT
  public .


  types:
    S_MANDT type C length 000003 .
  types:
    S_CARR_ID type C length 000003 .
  types:
    S_CONN_ID type N length 000004 .
  types:
    LAND1 type C length 000003 .
  types:
    S_FROM_CIT type C length 000020 .
  types:
    S_FROMAIRP type C length 000003 .
  types:
    S_TO_CITY type C length 000020 .
  types:
    S_TOAIRP type C length 000003 .
  types S_DEP_TIME type T .
  types S_ARR_TIME type T .
  types:
    S_DISTANCE type P length 5  decimals 000004 .
  types:
    S_DISTID type C length 000003 .
  types:
    S_FLTYPE type C length 000001 .
  types:
    begin of SPFLI,
      MANDT type S_MANDT,
      CARRID type S_CARR_ID,
      CONNID type S_CONN_ID,
      COUNTRYFR type LAND1,
      CITYFROM type S_FROM_CIT,
      AIRPFROM type S_FROMAIRP,
      COUNTRYTO type LAND1,
      CITYTO type S_TO_CITY,
      AIRPTO type S_TOAIRP,
      FLTIME type INT4,
      DEPTIME type S_DEP_TIME,
      ARRTIME type S_ARR_TIME,
      DISTANCE type S_DISTANCE,
      DISTID type S_DISTID,
      FLTYPE type S_FLTYPE,
      PERIOD type INT1,
    end of SPFLI .
  types:
    ZAIRPORT type C length 000003 .
  types:
    begin of ZFLIGHT_PLAN.
    include type SPFLI.
    types:
      AIRPORT type ZAIRPORT,
      DATE type DATS,
    end of ZFLIGHT_PLAN .
  types:
    ZFLIGHT_PLAN_T                 type standard table of ZFLIGHT_PLAN                   with non-unique default key .
endinterface.
