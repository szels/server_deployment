#!/bin/bash


instances="de02/p0 de02/p1 de03/p0 de03/p1 de04/p0 de04/p1"
locals="at ch da de es fi fr it nl no pl se"

basepath="/data/deploy"
scriptname=`/usr/bin/basename ${0}`


if [ -f /tmp/${scriptname}.lock ]; then
        pid=`cat /tmp/${scriptname}.lock`
        if [ `ps $pid` >/dev/null 2>&1 -ne 0 ]; then
                exit
        fi
fi
echo $$ > /tmp/${scriptname}.lock


for local in $locals ; do
	if [ -f ${basepath}/${local}/tendme.war ]; then
		mv -v ${basepath}/${local}/tendme.war ${basepath}/ROOT.war
	fi

	sleep 10;
	for file in ${basepath}/${local}/*.war ; do
	        if [ -f $file ]; then
			echo `date +%Y-%m-%d\ %H:%M:%S`
	                for instance in $instances; do
        	                mkdir -p ${basepath}/${local}/${instance}
                	        if [ ! -d ${basepath}/${local}/${instance} ]; then
                        	        continue
	                        else
        	                        cp -v ${file} ${basepath}/${local}/${instance}/
                	        fi
	                done
        	        chown -R tomcat55: ${basepath}
                	rm -f ${file}
	        fi
	done
done



rm -f /tmp/${siptname}.lock

