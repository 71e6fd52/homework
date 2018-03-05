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
    'k' => '《课时特训. 语文九年级 : 全一册',
    'w' => '文言文',
    'e' => '《e 路通',
    'b' => '背诵',
    'y' => '《核心素养读本·阅读与写作',
    'j' => '看 《核心素养读本·经典文学导读》'
  },
  'M' => {
    '-' => '《义务教育教材作业本',
    '+' => '《全品',
    'j' => '《尖子生',
    'l' => '《励耘新中考. 数学:浙江地区专用',
    'a' => '《励耘新中考. 数学:浙江地区专用·作业本',
    'z' => '《走进重高培优讲义. 数学九年级 : 全一册'
  },
  'E' => {
    '-' => '《义务教育教材作业本',
    'l' => '《励耘新同步',
    'b' => '背诵',
    'k' => '《课时特训',
    'y' => '口语 100'
  },
  'S' => {
    '-' => '《义务教育教材作业本',
    '+' => '《全品',
    't' => '《同步练习'
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

def put_end(t = false)
  puts
  puts '----'
  puts '联合甩®荣誉出品', nil if t
  puts '本作品通过 ' \
    '[The GNU Affero General Public License]' \
    '(http://www.gnu.org/licenses/agpl.html) 许可。'
end

machine = ARGV.include? '-m'
machine.freeze
ARGV.delete '-m'
type = nil
put_head unless machine
# puts '1. 带排球' if Time.now.wday == 2
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
