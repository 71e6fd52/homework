#!/usr/bin/env ruby

require 'json'

ID = {
  'C' => '2161861608',
  'M' => '2161861656',
  'E' => '2161861617',
  'S' => '2161861664',
  'H' => '2161861686'
}.freeze

date = Time.now.strftime('%u').to_i > 4 && 'Sun' || 'today'
date.freeze

@class = '2161861537'
homework = IO.popen './create.rb -m'
homework.each_line do |line|
  line.chomp!
  if line =~ /^[A-Z]$/
    @class = ID[line]
    next
  end
  puts "#{@class}: #{line}"

  commands = {
    type: 'item_add',
    temp_id: `uuidgen`.strip,
    uuid: `uuidgen`.strip,
    args: {
      project_id: @class,
      content: line,
      date_string: date
    }
  }

  commands[:args]['priority'] = 4 if @class == ID['H'] && line =~ /^《作业本/

  `curl 'https://todoist.com/api/v7/sync' \
    -d token=65062a4daa6bf9a362447187dacf8af40f56617b \
    -d commands='[#{commands.to_json}]'`
end
