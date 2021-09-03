#!/home/jimu/.rbenv/shims/ruby

require 'net/http'
require 'json'

ver = "0.0.1 2021-09-02"

puts "Tic-Tac-Toe Ruby Client v#{ver} Jim Urbas\n\n"

url = "http://osaka:3016/matches"

uri = URI(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = false

request = Net::HTTP::Get.new(uri.path, {'Content-Type' => 'application/json'})

response = http.request(request)

matches = JSON.parse(response.body)

# header
puts "%4s %-20s" % ['ID', 'Title']
# puts "%4s %-20s" % ['--', '-'.times(20)]
puts '-'*4 + ' ' + '-'*20

matches.each do |m|
  puts "G%03d %-20s" % [m['id'], m['title']]
end
