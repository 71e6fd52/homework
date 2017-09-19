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
  'n' => '报纸'
}
t = {
  'C' => {
    'k' => '《课时特训',
    'w' => '文言文',
    'm' => '默写',
    't' => '听写',
    'd' => '订正',
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
    'k' => '《课时特训'
  },
  'S' => {
    '-' => '《作业本',
    '+' => '《全品'
  },
  'H' => {
    '-' => '《作业本',
    '+' => '《同步练习',
    't' => '《同步练习'
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

puts
puts <<END
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/"><img alt="知识共享许可协议" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" /></a><br />本作品采用 <a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">CC BY-NC-ND 4.0</a> 进行许可。
END
