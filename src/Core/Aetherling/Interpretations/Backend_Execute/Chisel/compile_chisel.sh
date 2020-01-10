set -o xtrace
cp $1 ${2}/src/main/scala/aetherling/modules/Top.scala
cd $2
sbt "runMain aetherling.modules.Top"
cp Top.v $3
cd -

