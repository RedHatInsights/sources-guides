#!/bin/bash

file=""

for i in "$@"
do
case $i in
  -f|--from)
    file=$2
    shift
    shift
    ;;
  *)
    ;;
esac
done

if [[ -z ${file} ]]; then
  echo "Usage: ./grafana-dashboard.sh -f <dashboard-file.json>"
else
  filename=$(basename -- ${file})
  extension="${filename##*.}"
  filename="${filename%.*}"

  output_file="${filename}.configmap.yaml"

  echo "Converting: ${filename}.${extension} => ${output_file}"

  oc create configmap ${filename} --from-file=${file} -o yaml --dry-run > ${output_file}

  if [[ -f ${output_file} ]]; then
    echo "  labels:" >> ${output_file}
    echo "    grafana_dashboard: \"true\"" >> ${output_file}
    echo "  annotations:" >> ${output_file}
    echo "    grafana-folder: /grafana-dashboard-definitions/Insights" >> ${output_file}

    echo "Result: Success"
  else
    echo "Result: Failed"
    exit -1
  fi
fi
