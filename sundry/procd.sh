#!/bin/bash
read -p 'sure to run this script [YES|yes/NO|no] ' ret
if [ "$ret" = "NO" -o "$ret" = "no" ]; then
	echo "goodbye"
	exit
fi

procddir="./procd"
dbcofingdir="./dbconfig"
configfile=''

if [ ! -d "$procddir" -o ! -d "$dbcofingdir" ]; then
	echo "procd or dbconfig is not exists in current dir"
	exit
fi

procdfiles=`ls $procddir`
configfiles=`ls $dbcofingdir`

if [ -z "$procdfiles" -o -z "$configfiles" ]; then
	echo "procd or dbconfig is empty"
	exit
fi

function errorCheck(){
	if [ "$1" ]; then
		echo $2$1 >> '/tmp/proc.log'
		echo $2$1 | mail -s 'procedure run error' fangzhihui@new18.cn
		rm /tmp/procerror.log
		echo 'error occur'
		echo $2$1
		exit
	else
		return
	fi
}

function parseConfig(){
	while read line;
	do
		eval "$line"
	done < $1
}

for procdfile in $procdfiles
do
	#读取数据库配置信息
	configfile="${procdfile%.*}.conf"
	parseConfig $configfile
	
	echo "start running $procdfile:" >> '/tmp/proc.log'
	echo "start running $procdfile:"
	mysql -h$dbhost -u$dbuser -p$dbpass -e "use $dbname; source $procddir/$procdfile;" > /tmp/procerror.log 2>&1
	runret=$(grep 'ERROR' /tmp/procerror.log)
	errorCheck "$runret" "create procedure error: "
	echo '' > /tmp/procerror.log 
	echo "procedure create successfully" >> '/tmp/proc.log'
	echo "procedure create successfully"
	
	echo "start running proc_importMenu:" >> '/tmp/proc.log' 
	echo "start running proc_importMenu:"
	mysql -h$dbhost -u$dbuser -p$dbpass -e "use crm_fzhtest;call proc_importMenu();" > /tmp/procerror.log 2>&1
	runret=$(grep 'ERROR' /tmp/procerror.log)
	errorCheck "$runret" "proc_importMenu running error: "
	echo '' > /tmp/procerror.log 
	echo "proc_importMenu run successfully" >> '/tmp/proc.log'
	echo "proc_importMenu run successfully"
	
	echo "check mapping table datas:" >> '/tmp/proc.log' 
	echo "check mapping table datas:"
	runret=$(mysql -h$dbhost -u$dbuser -p$dbpass -e "use crm_fzhtest;select count(1) from mapping;" | grep '^0$')
	if [ "$runret" ]; then
		runret="mapping table is empty"
	fi
	errorCheck "$runret" "error: "
	echo "mapping datas check successfully" >> '/tmp/proc.log'
	echo "mapping datas check successfully"
	
	echo "start running proc_importSource:" >> '/tmp/proc.log'
	echo "start running proc_importSource:"
	mysql -h$dbhost -u$dbuser -p$dbpass -e "use crm_fzhtest;call proc_importSource();" > /tmp/procerror.log 2>&1
	runret=$(grep 'ERROR' /tmp/procerror.log)
	errorCheck "$runret" "proc_importSource running error: "
	echo '' > /tmp/procerror.log
	echo "proc_importSource run successfully" >> '/tmp/proc.log'
	echo "proc_importSource run successfully"
	
	echo "start running proc_importPool:" >> '/tmp/proc.log'
	echo "start running proc_importPool:"
	mysql -h$dbhost -u$dbuser -p$dbpass -e "use crm_fzhtest;call proc_importPool();" > /tmp/procerror.log 2>&1
	runret=$(grep 'ERROR' /tmp/procerror.log)
	errorCheck "$runret" "proc_importPool running error: "
	echo '' > /tmp/procerror.log 
	echo "proc_importPool run successfully" >> '/tmp/proc.log'
	echo "proc_importPool run successfully"

	tflag=0
	while [ "$tflag" = 0 ]
	do
		read -p 'new department team and jobnumber has created successfully [YES|yes/NO|no/EXIT|exit] ' ret
		if [ "$ret" = "YES" -o "$ret" = "yes" ]; then
			let "tflag=1"
		elif [ "$ret" = "YES" -o "$ret" = "yes" ]; then
			echo "new department team and jobnumber must create before run proc_importRecord human interrupt \n\n" >> '/tmp/proc.log'
			echo "human interrupt"
			exit
		else
			echo "new department team and jobnumber must create before run proc_importRecord"
		fi
	done

	echo "start running proc_importRecord:" >> '/tmp/proc.log'
	echo "start running proc_importRecord:"
	mysql -h$dbhost -u$dbuser -p$dbpass -e "use crm_fzhtest;call proc_importRecord();" > /tmp/procerror.log 2>&1
	runret=$(grep 'ERROR' /tmp/procerror.log)
	errorCheck "$runret" "proc_importRecord running error: "
	echo '' > /tmp/procerror.log 
	echo "proc_importRecord run successfully" >> '/tmp/proc.log'
	echo "proc_importRecord run successfully"
	
	read -p "continue to run another procedure file or break [C|c/B/b] " ret
	
	if [ "$ret" = "B" -o "$ret" = "b" ]; then
		break
	fi
done
echo "datas import success, delete extract datas now [YES|yes/NO|no] " ret

if [ "$ret" = "YES" -o "$ret" = "yes" ]; then
	parseConfig $configfile
	echo "start running $procdfile:" >> '/tmp/proc.log'
	mysql -h$dbhost -u$dbuser -p$dbpass -e "use $dbname; source $procddir/delete.sql;" > /tmp/procerror.log 2>&1
	runret=$(grep 'ERROR' /tmp/procerror.log)
	errorCheck "$runret" "create delete procedure error: "
	echo '' > /tmp/procerror.log 
	echo "procedure create successfully" >> '/tmp/proc.log'
	
	echo "start running proc_delphone:" >> '/tmp/proc.log'
	mysql -h$dbhost -u$dbuser -p$dbpass -e "use crm_fzhtest;call proc_delphone();" > /tmp/procerror.log 2>&1
	runret=$(grep 'ERROR' /tmp/procerror.log)
	errorCheck "$runret" "proc_delphone running error: "
	rm /tmp/procerror.log 
	echo 'datas import and delete sucessfully \n\n' >> '/tmp/proc.log'
	echo 'datas import and delete sucessfully'
else
	echo 'done import success \n\n' >> '/tmp/proc.log'
	echo 'done import success'
fi
exit

