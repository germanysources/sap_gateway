@AbapCatalog.sqlViewName: 'zspfliv'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flight plan with last change'
define view zspfli as select from spfli as p 
  left outer join zspfli_changes 
  as c on c.carrid = p.carrid and c.connid = p.connid {
  key p.carrid,
  key p.connid,
  p.airpfrom,
  p.countryfr,
  p.cityfrom,
  p.countryto,
  p.cityto,
  p.airpto,
  p.fltime,
  p.deptime,
  p.arrtime,
  p.distance,
  p.distid,
  p.fltype,
  p.period,
  case when c.last_change is null then tstmp_current_utctimestamp()
    else c.last_change end as last_change 
} 
 