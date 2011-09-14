host = db.serverStatus().host;
cmdCount = 1;
prompt = function() {
  return db+"@"+host+" "+(cmdCount++)+"> ";
}
