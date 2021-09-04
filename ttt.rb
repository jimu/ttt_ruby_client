#!/home/jimu/.rbenv/shims/ruby

require 'net/http'
require 'json'
require 'colorize'

VER = "0.0.1 2021-09-02"




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

  puts response

  matches.each do |m|
    puts m
    puts "G%03d %-20s" % [m['id'].to_i, m['title']]
  end
end


# list all addresses
def list_addresses
  url = "http://osaka:3016/addresses"

  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = false

  request = Net::HTTP::Get.new(uri.path, {'Content-Type' => 'application/json'})

  response = http.request(request)

  matches = JSON.parse(response.body)

  # header
  puts "%4s %-20s %-8s %-20s" % ['ID', 'Name', 'Type', 'Address']
  puts "%4s %-20s %-8s %-20s" % ['-'*4, '-'*20, '-'*8, '-'*20]

  matches.each do |m|
    puts "%4d %-20s %-8s %-20s" % [m['id'], m['user_name'], m['type'], m['value']]
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
  

def prompt
  print 'L'.yellow.bold + 'ist, ' +
        'D'.yellow.bold + 'elete, ' +
        'A'.yellow.bold + 'ddrs, ' +
        'e' + 'X'.yellow.bold + 'it' +
        '> '
end

def main

  puts "Tic-Tac-Toe Ruby Client v#{VER} Jim Urbas\n\n"

  while true
    
    prompt

    command = gets

    break if !command

    case command.chomp.upcase
      when 'L'
        list
      when 'A'
        list_addresses
      when 'X'
        exit 0
      when 'D'
        delete_ui
    end
  end
end


main
