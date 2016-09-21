alias cdv='cd ~/src/cancerventetid'
alias cda='cd ~/src/nine/asa_proj'
alias cdn='cd ~/src/nine/pplus/plus-reporter'
alias cdc='cd ~/src/nine/csc/all_dev'
alias cds='cd ~/src/nine/skat'
alias cdn='cd ~/src/nine'
alias cdk='cd ~/src/karnov'

#alias kk="K=$(cdk && pwd);echo $K;"
# function _kgProjects(){
#   echo "stackedit amp content-store metadata-store missing-link xml-toolbox gitifier kg-site kg-site-assets kg-pipeline"
# }
# alias karnovUpdate="C=$(pwd);cdk; pwd; for f in $(_kgProjects); do cd \$f; pwd; git fetch; cd -; done;cd \$C"

# EDITOR update for bundler
export BUNDLER_EDITOR=subl

# lang settings, view with `locale` or `locale -a`
# export LANG=da_DK.UTF-8
export LANG=en_US.UTF-8


 ORACLE_HOME="$HOME/instantclient_11_2"
 export NLS_LANG="AMERICAN_AMERICA.UTF8" # or DANISH_DENMARK.WE8ISO8859P1
 export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$ORACLE_HOME"
 export TNS_ADMIN="$ORACLE_HOME" # or where you will place tnsnames.ora
 export PATH="$PATH:$ORACLE_HOME"


 #bintray
 export BINTRAY_USERNAME=jesperronn
 export BINTRAY_KEY=
