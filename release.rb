#!/usr/bin/env ruby

require 'json'

create = "./create.rb #{ARGV.join ' '}"
system "#{create} | pandoc -s -t html -B mine.html >index.html"

system 'git add .'
system %(git commit -m "#{Time.now.strftime '%Y%m%d'}")
system 'git push'

system 'pandoc -t docx index.html -o index.docx'
