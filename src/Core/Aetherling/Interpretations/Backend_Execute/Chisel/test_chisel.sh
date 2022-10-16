set -o xtrace
cp $1 ${2}/src/test/scala/aetherling/modules/Top.scala
cd $2
#sbt test:assembly
#res=$?
#if [ $res -gt 0 ]
#then
#    exit $res
#fi
#java -Xmx8G -cp target/scala-2.12/aetherling.jar org.scalatest.tools.Runner -s aetherling.modules.TopTester -t "Top should behave correctly" -o
sbt -mem 2048 "testOnly aetherling.modules.TopTester"
test_result=$?

if [ $# -gt 2 ]
then
    results_dir=$(ls -td ${2}/test_run_dir/top/aetherling.modules.TopTester*/ | head -1)
    mkdir -p $3
    cp ${results_dir}/Top.v $4
    cp ${results_dir}/mul.v ${4}_mul
fi

cd -
exit $test_result
