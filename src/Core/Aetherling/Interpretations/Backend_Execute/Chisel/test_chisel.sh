set -o xtrace
cp $1 ${2}/src/test/scala/aetherling/modules/Top.scala
cd $2
sbt "testOnly aetherling.modules.TopTester"
test_result=$?
cd -
exit $test_result
