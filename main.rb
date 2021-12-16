require_relative 'fight'

args = Hash[ ARGV.flat_map{|s| s.scan(/--?([^=\s]+)(?:=(\S+))?/)} ]
slow = false

if (args.size > 0)
  if (args.key?('help') or args.key?('h'))
    puts "Usage example: ruby main.rb [--slow]"
    exit
  end
  
  slow = true if args.key?('slow')
end

fight = Fight.new('276236374547151')
fight.build_teams
fight.begin_fight(slow)
