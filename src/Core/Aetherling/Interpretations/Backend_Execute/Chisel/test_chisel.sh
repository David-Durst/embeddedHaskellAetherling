set -o xtrace
cp $1 ${2}/src/test/scala/aetherling/modules/Top.scala
cd $2
sbt "testOnly aetherling.modules.TopTester"
test_result=$?

if [ $# -gt 2 ]
then
    results_dir=$(ls -td ${2}/test_run_dir/top/aetherling.modules.TopTester*/ | head -1)
    mkdir -p $3
    cp ${results_dir}/Top.v $4
fi

cd -
exit $test_result
