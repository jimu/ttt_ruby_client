#!/home/jimu/.rbenv/shims/ruby

require 'net/http'
require 'json'
require 'colorize'

ver = "0.0.1 2021-09-02"

puts "Tic-Tac-Toe Ruby Client v#{ver} Jim Urbas\n\n"



# list all matches
def list
  url = "http://osaka:3016/matches"

  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = false

  request = Net::HTTP::Get.new(uri.path, {'Content-Type' => 'application/json'})

  response = http.request(request)

  matches = JSON.parse(response.body)

  # header
  puts "%4s %-20s" % ['ID', 'Title']
  puts '-'*4 + ' ' + '-'*20

  matches.each do |m|
    puts "G%03d %-20s" % [m['id'], m['title']]
  end
end


# ask match id and delete match if valid
def delete_ui
  print 'Enter match id: '

  id = gets.chomp.to_i

  delete id if id > 0
end


# delete match id
def delete id
  url = "http://osaka:3016/matches/#{id}"

  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = false

  request = Net::HTTP::Delete.new(uri.path, {'Content-Type' => 'application/json'})

  response = http.request(request)

  code = response.code.to_i

  success = code.between?(200, 399)

  puts success ? "Success" : "Failure(#{code}) for id:#{id}"

end
  

while true

  print 'L'.yellow.bold + 'ist, ' +
        'D'.yellow.bold + 'elete, ' +
        'e' + 'X'.yellow.bold + 'it' +
        '> '

  command = gets

  break if !command

  case command.chomp.upcase
    when 'L'
      list
    when 'X'
      exit 0
    when 'D'
      delete_ui
  end
end



