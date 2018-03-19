#!/usr/bin/env ruby
# frozen_string_literal: true

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
    'k' => '《课时特训. 语文九年级 : 全一册',
    'w' => '文言文',
    'e' => '《e 路通',
    'b' => '背诵',
    'y' => '《核心素养读本·阅读与写作',
    'j' => '看 《核心素养读本·经典文学导读》',
    'z' => '《中考语文专项训练'
  },
  'M' => {
    '-' => '《义务教育教材作业本',
    '+' => '《全品',
    'j' => '《尖子生',
    'l' => '《励耘新中考. 数学:浙江地区专用',
    'a' => '《励耘新中考. 数学:浙江地区专用·作业本',
    'z' => '《走进重高培优讲义. 数学九年级 : 全一册',
    'q' => '《轻松走进重点高中',
    's' => '《励耘. 第四卷. 数学:浙江地区专用'
  },
  'E' => {
    '-' => '《义务教育教材作业本',
    'l' => '《励耘新同步. 九年级英语:全一册:外研版',
    'b' => '背诵',
    'k' => '《课时特训',
    'y' => '口语 100',
    's' => '《励耘. 第四卷. 英语:浙江地区专用'
  },
  'S' => {
    '-' => '《义务教育教材作业本',
    '+' => '《全品',
    't' => '《同步练习',
    'q' => '《全效学习'
  },
  'H' => {
    '-' => '《义务教育教材作业本',
    '+' => '《同步练习',
    't' => '《同步练习',
    'j' => '《精彩练习就练这一本. 历史与社会. 九年级. 全一册',
    'x' => '《中考总复习学习手册 : 省考点版. 配套练习. 历史与社会 思想品德'
  }
}

t.each_value { |a| a.merge! normal }
t['I'] = t['H']

def put_head
  puts Time.now.strftime('# %Y年%m月%d日')
end

def put_end
  puts nil, '----', nil
  puts <<~AGPL
    homework<br>
    Copyright (C) 2018 71e6fd52 <https://homework.71e6fd52.ml>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
  AGPL
end

machine = ARGV.include? '-m'
machine.freeze
ARGV.delete '-m'
type = nil
put_head unless machine
filename = ARGV.first
filename ||= Time.now.strftime('%Y%m%d.hw')
File.open(filename, 'r').each_line do |line|
  next if line =~ /^\./ # ignore comment
  if (m = line.match(/^[CMESHI]/))
    typename = m[0]
    type = t[typename]
    if machine
      puts typename
    else
      puts nil, "## #{cname[typename]}"
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

  name = "#{name}#{code}"
  name += '》' if name =~ /^《/

  if word.size == 3 && word[1] == '-'
    puts "#{name} 第 #{word[0]} - #{word[2]} 页"
  elsif word.find { |w| w =~ /[^\d]/ }
    puts "#{name}#{word.join ' '}"
  elsif word.size == 1
    puts "#{name} 第 #{word[0]} 页"
  else
    puts "#{name} 第 #{word.join ', '} 页"
  end
end.close

put_end unless machine
