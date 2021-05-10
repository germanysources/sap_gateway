@AbapCatalog.sqlViewName: 'zflight_schedv'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight schedule'
@OData.publish: true
define view zflight_schedule as select from spfli as p
  inner join sflight as f on f.carrid = p.carrid and f.connid = p.connid {
    key p.carrid,
    key p.connid,
    key f.fldate,
    p.cityfrom,
    p.airpfrom,
    p.cityto,
    p.airpto
} 
 