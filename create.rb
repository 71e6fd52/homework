#!/usr/bin/env ruby

cname = {
  'C' => '语文：',
  'M' => '数学：',
  'E' => '英语：',
  'S' => '科学：',
  'H' => '历史与社会：',
  'I' => '思想品德：'
}

normal = {
  'p' => '试卷',
  'n' => '报纸',
  'd' => '《单元学习体验与评价'
}
t = {
  'C' => {
    'k' => '《课时特训',
    'w' => '文言文',
    'e' => '《e 路通',
    'b' => '背诵',
    'y' => '《核心素养读本·阅读与写作',
    'j' => '看 《核心素养读本·经典文学导读》'
  },
  'M' => {
    '-' => '《作业本',
    '+' => '《全品',
    'j' => '《尖子生',
    'z' => '《走进重高'
  },
  'E' => {
    '-' => '《作业本',
    '+' => '《励耘新同步',
    'l' => '《励耘新同步',
    'b' => '背诵',
    'k' => '《课时特训',
    'y' => '口语 100'
  },
  'S' => {
    '-' => '《作业本',
    '+' => '《全品',
    't' => '《同步练习'
  },
  'H' => {
    '-' => '《作业本',
    '+' => '《同步练习',
    't' => '《同步练习',
    'j' => '《精彩练习'
  }
}

t.each_value { |a| a.merge! normal }

machine = ARGV.include? '-m'
machine.freeze
type = nil
time = Time.now
puts time.strftime('# %Y年%m月%d日') unless machine
File.open(time.strftime('%Y%m%d.hw'), 'r').each_line do |line|
  next if line =~ /^\./
  if (m = line.match(/^[CMESHI]/))
    typename = m[0]
    type = t[typename]
    puts unless machine
    print '## ' unless machine
    if machine
      puts typename
    else
      puts cname[typename]
    end
    next
  end
  print '1. ' unless machine
  first = line[0]
  other = line[1..-1]
  first = '-' if first == ' '
  name = type[first] if type
  if name.nil?
    puts line
    next
  end
  word = other.split(/\s/)
  code = word.shift if word[0] =~ /^[AB12]$/
  word.shift if word[0] == ''
  unless word.shift == 'p'
    name += '》' if name =~ /^《/
    puts "#{name}#{other}"
    next
  end

  code ||= ''
  code += '》' if name =~ /^《/

  if word.size == 3 && word[1] == '-'
    puts "#{name}#{code} 第 #{word[0]} - #{word[2]} 页"
  elsif word.find { |w| w =~ /[^\d]/ }
    puts "#{name}#{word.join ' '}"
  elsif word.size == 1
    puts "#{name}#{code} 第 #{word[0]} 页"
  else
    puts "#{name}#{code} 第 #{word.join ', '} 页"
  end
end.close

puts unless machine
puts '本作品同时通过 ' \
  '[Creative Commons Attribution-ShareAlike 4.0 International License]' \
  '(http://creativecommons.org/licenses/by-sa/4.0/), ' \
  '[GNU Affero General Public License]' \
  '(https://www.gnu.org/licenses/agpl.html), ' \
  '[GNU Free Documentation License](https://www.gnu.org/licenses/fdl.html)' \
  ' 授权'
