set -o xtrace
cd $1
sbt 'runMain aetherling.modules.Top'
cd -

