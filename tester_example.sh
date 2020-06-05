DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#QUERY_FILE=/root/hive-testbench/sample-queries-tpcds/query78.sql
QUERY_FILE=/home/lbodor/queries/web_sales_join_date_dim_aggr.sql
HIVE_LOG=/tmp/root/hive.log
RESULTS_FILE=$DIR/results.log
SCALE=10TB

function run(){
	SETTINGS=$1
	python $DIR/query.py $QUERY_FILE $SETTINGS
	run_dag_result=$(ls -a /tmp/$USER/hive* | sort -r | xargs -I {} grep -i "run dag" {}  | rev | cut -d' ' -f 1 | rev | sed -e '$!d')

	SETTINGS_FILE_NAME=$(basename $SETTINGS)
	QUERY_FILE_NAME=$(basename $QUERY_FILE)
	
	echo "$SETTINGS_FILE_NAME $QUERY_FILE_NAME $SCALE: $run_dag_result" >> $RESULTS_FILE
}

echo "RUNNING SOME TESTS on $SCALE with query $QUERY_FILE..."

run $DIR/settings.sql
