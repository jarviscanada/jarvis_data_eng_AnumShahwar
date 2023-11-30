psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters"
    exit 1
fi

hostname=$(hostname -f)
lscpu_out=`lscpu`
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
Architecture= $(echo $lscpu_out | egrep ^Architecture: | awk {print $2} | xargs)
cpu_model= $(echo "$lscpu_out" | egrep "^Model:" | awk '{print $2}' | xargs)
cpu_mhz= $(echo "$lscpu_out" | egrep "^CPU\sMHz:" | awk '{print $3}' | xargs)
l2_cache= $(echo "$lscpu_out" | egrep "^L2\scache:" | awk '{print $3}' | xargs)
total_mem= $ (vmstat --unit M | tail -1 | awk '{print $4}')
timestamp= date +"%Y-%m-%d %H:%M:%S"



host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";


insert_stmt="INSERT INTO host_info (cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp) VALUES ('$2', $x86_64, $79, $2200.146, $256K, $2093, ' 2023-11-30 01:56:22');"

