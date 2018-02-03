#!/usr/bin/env ruby

require 'json'

create = "./create.rb #{ARGV.join ' '}"
system "#{create} | pandoc -s -t html -B mine.html >index.html"

body = `lynx -dump -width=40 index.html`
body = "-name\n" + body
html = `#{create} | pandoc -t html`
json = {
  msgtype: 'm.text',
  body: body,
  formatted_body: html,
  format: 'org.matrix.custom.html'
}.to_json
File.open File.join(ENV['HOME'], '.config', 'matrix', 'token') do |f|
  @access_token = f.gets
end
uri = 'https://matrix.org:8448' \
  '/_matrix/client/r0/rooms/' \
  '%21pQhVQwYLoQvQELrEpI%3Amatrix.org/send/m.room.message/'
uri += `uuidgen`.strip
uri += '?access_token=' + @access_token
tmp = `mktemp`.chomp
File.open(tmp, 'w') { |f| f.puts json }
system "curl --verbose -X PUT -d @#{tmp} #{uri}"
system "rm -f #{tmp}"

system 'git add .'
system %(git commit -m "#{Time.now.strftime '%Y%m%d'}")
system 'git push'

system 'pandoc -t docx index.html -o index.docx'
