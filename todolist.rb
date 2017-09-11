#!/usr/bin/env ruby

ID = {
  'C' => '2161861608',
  'M' => '2161861656',
  'E' => '2161861617',
  'S' => '2161861664',
  'H' => '2161861686'
}.freeze

@class = '2161861537'
homework = IO.popen './create.rb -m'
homework.each_line do |line|
  line.chomp!
  if line =~ /^[A-Z]$/
    @class = ID[line]
    next
  end
  line += '" ", \"priority\": 4' if @class == '2161861686' && line =~ /^作业本/
  puts "#{@class}: #{line}"
  `./todolist.sh #{@class} "#{line}"`
end
