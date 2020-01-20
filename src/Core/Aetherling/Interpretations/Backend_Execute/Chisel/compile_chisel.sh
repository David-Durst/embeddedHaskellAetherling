set -o xtrace
cp $1 ${2}/src/main/scala/aetherling/modules/Top.scala
cd $2
sbt -mem 2048 "runMain aetherling.modules.Top"
cp Top.v $3
cd -

