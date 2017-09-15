#!/bin/zsh

if [[ $# < 2 ]]
then
  echo 'wrong args'
  exit 1
fi

[[ $(date +%u) > 4 ]] && date='Fri' || date='today'

curl 'https://todoist.com/api/v7/sync' \
  -d token=65062a4daa6bf9a362447187dacf8af40f56617b \
  -d commands='[
{
  "type": "item_add",
  "temp_id": "'$(uuidgen)'",
  "uuid": "'$(uuidgen)'",
  "args": { "project_id": '$1', "content": "'$2'", "date_string": "today"'$3' }
}
]'
