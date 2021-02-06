interface ZIF_BAPI_FLBOOKING_CONFIRM
  public .


  types:
    S_CARR_ID type C length 000003 .
  types:
    S_BOOK_ID type N length 000008 .
  types:
    begin of BAPISBOKEY,
      AIRLINEID type S_CARR_ID,
      BOOKINGID type S_BOOK_ID,
    end of BAPISBOKEY .
  types:
    TESTRUN type C length 000001 .
  types:
    S_FBOSTAT3 type C length 000001 .
  types:
    begin of BAPISFLAUX,
      BAPIMAXROW type INT4,
      TESTRUN type TESTRUN,
      FBOSTATUS type S_FBOSTAT3,
    end of BAPISFLAUX .
  types:
    BAPI_MTYPE type C length 000001 .
  types:
    SYMSGID type C length 000020 .
  types:
    SYMSGNO type N length 000003 .
  types:
    BAPI_MSG type C length 000220 .
  types:
    BALOGNR type C length 000020 .
  types:
    BALMNR type N length 000006 .
  types:
    SYMSGV type C length 000050 .
  types:
    BAPI_PARAM type C length 000032 .
  types:
    BAPI_FLD type C length 000030 .
  types:
    BAPILOGSYS type C length 000010 .
  types:
    begin of BAPIRET2,
      TYPE type BAPI_MTYPE,
      ID type SYMSGID,
      NUMBER type SYMSGNO,
      MESSAGE type BAPI_MSG,
      LOG_NO type BALOGNR,
      LOG_MSG_NO type BALMNR,
      MESSAGE_V1 type SYMSGV,
      MESSAGE_V2 type SYMSGV,
      MESSAGE_V3 type SYMSGV,
      MESSAGE_V4 type SYMSGV,
      PARAMETER type BAPI_PARAM,
      ROW type INT4,
      FIELD type BAPI_FLD,
      SYSTEM type BAPILOGSYS,
    end of BAPIRET2 .
  types:
    __BAPIRET2                     type standard table of BAPIRET2                       with non-unique default key .
endinterface.
