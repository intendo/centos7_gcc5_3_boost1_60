#!/bin/bash


function error_message()
{
  if [ "$#" -ne "0" ]; then
    echo ""
    echo "ERROR: $*"
    echo ""
  fi

  exit 1
}


function get_value()
{
  if [ "$#" -ne "0" ]; then
    local value=`grep " $1=" Dockerfile         |  \
                 awk -F'=' '{print $NF}'        |  \
                 sed -e 's/"//g'`               || \
                 error_message "Can't find $1"
    echo $value
  else
    error_message "Must pass argument to get_value() function"
  fi
}


dockeruser=`get_value dockeruser`
package_name=`get_value package_name`
version=`get_value version`


docker pull intendo/docker_centos7_gcc5_3
docker build -t "$dockeruser/${package_name}:$version" . && docker push "$dockeruser/${package_name}:$version"


exit 0
