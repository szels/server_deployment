#!/bin/bash

instances="p0 p1"
locals="at ch da de es fi fr it nl no pl se"
basepath="/data/deploy"
applicationpath="/data/app/"

hostname=`/bin/hostname -s | /usr/bin/awk -F- '{print $NF}'`
scriptname=`/usr/bin/basename ${0}`



if [ -f /tmp/${scriptname}.lock ]; then
        pid=`cat /tmp/${scriptname}.lock`
        if [ `ps $pid` >/dev/null 2>&1 -ne 0 ]; then
                exit
        fi
fi
echo $$ > /tmp/${scriptname}.lock



for local in $locals; do
	for instance in $instances; do
	        for file in ${basepath}/${local}/${hostname}/${instance}/*; do
	                if [ ! -f ${file} ]; then
	                        continue;
	                fi
			context=`basename $file | awk -F.war '{print $1}'`
			echo `date +%Y-%m-%d\ %H:%M:%S` ${instance}::${context}
			rm -rf ${applicationpath}/${instance}/webapps/${context}/
	                mv -v  ${file} ${applicationpath}/${instance}/webapps/
			/etc/init.d/tomcat5.5-${instance} restart
	        done
	        rm -f ${file}
	done
done



rm -f /tmp/${scriptname}.lock
