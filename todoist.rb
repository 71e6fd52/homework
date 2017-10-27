#!/usr/bin/env ruby

require 'json'

ID = {
  'C' => '2161861608',
  'M' => '2161861656',
  'E' => '2161861617',
  'S' => '2161861664',
  'H' => '2161861686',
  'I' => '2165900422',
  'N' => '2161861537'
}.freeze

delete = []
ID.each_value do |id|
  items = JSON.parse `curl https://todoist.com/api/v7/projects/get_data \
    -d token=65062a4daa6bf9a362447187dacf8af40f56617b \
    -d project_id=#{id}`

  items['items'].each do |item|
    delete << item['id']
  end
end

commands = [{
  type: 'item_delete',
  uuid: `uuidgen`.strip,
  args: { ids: delete }
}]

puts commands.to_json
`curl 'https://todoist.com/api/v7/sync' \
  -d token=65062a4daa6bf9a362447187dacf8af40f56617b \
  -d commands='#{commands.to_json}'`

commands = []
subject = ID['N']

homework = IO.popen './create.rb -m'
homework.each_line do |line|
  line.chomp!
  if ID.key? line
    subject = ID[line]
    next
  end
  puts "#{subject}: #{line}"

  command = {
    type: 'item_add',
    temp_id: `uuidgen`.strip,
    uuid: `uuidgen`.strip,
    args: {
      project_id: subject,
      content: line
    }
  }

  commands << command
end

puts commands.to_json
puts `curl 'https://todoist.com/api/v7/sync' \
  -d token=65062a4daa6bf9a362447187dacf8af40f56617b \
  -d commands='#{commands.to_json}'`
