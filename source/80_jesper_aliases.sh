alias cdv='cd ~/src/cancerventetid'
alias cdk='cd ~/src/karnovgroup'

#alias kk="K=$(cdk && pwd);echo $K;"
function _kgProjects(){
  echo "stackedit amp content-store metadata-store missing-link xml-toolbox gitifier kg-site kg-site-assets kg-pipeline"
}
alias karnovUpdate="C=$(pwd);cdk; pwd; for f in $(_kgProjects); do cd \$f; pwd; git fetch; cd -; done;cd \$C"



 ORACLE_HOME="$HOME/instantclient_11_2"
 export NLS_LANG="AMERICAN_AMERICA.UTF8" # or DANISH_DENMARK.WE8ISO8859P1
 export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$ORACLE_HOME"
 export TNS_ADMIN="$ORACLE_HOME" # or where you will place tnsnames.ora
 export PATH="$PATH:$ORACLE_HOME"