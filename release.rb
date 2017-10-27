#!/usr/bin/env ruby

require 'json'

body = `./create.rb | pandoc -t plain | sed '/^$/d ; /本作品/ {x; p; x;}'`
body = '-name ' + body
html = `./create.rb | pandoc -t html`
json = {
  msgtype: 'm.text',
  body: body,
  formatted_body: html,
  format: 'org.matrix.custom.html'
}.to_json
File.open File.join(ENV['HOME'], '.config', 'matrix-qq', 'token') do |f|
  @access_token = f.gets
end
uri = 'https://matrix.org:8448' \
  '/_matrix/client/r0/rooms/' \
  '%21pQhVQwYLoQvQELrEpI%3Amatrix.org/send/m.room.message/'
uri += `uuidgen`.strip
uri += '?access_token=' + @access_token
tmp = `mktemp`.chomp
File.open(tmp, 'w') { |f| f.puts json }
puts `curl --verbose -X PUT -d @#{tmp} #{uri}`
`rm -f #{tmp}`

`./create.rb | pandoc -s -t html >index.html`
`git add .`
`git commit -m "#{Time.now.strftime '%Y%m%d'}"`
`git push`
