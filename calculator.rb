# Eric Eckert
# December 2016

require_relative 'scan.rb'
require_relative 'parser.rb'

# Read a full line of input as tokens
def scan_line(scan)
    tokens = Array.new
    until false do
        token = scan.next_token
#        puts token.to_a
        tokens << token
#        if token.kind == 7 || token.kind == 0 || token.kind == 15
#            abort
        if token.kind == 2
            break
        end
    end
    return tokens
end


# Take input and read all tokens
# puts ARGV[0]
scan = Scanner.new
parser = Parser.new
if ARGV.length > 0
    file = File.new(ARGV[0], "r")
    until false do
        line = file.gets
        scan.next_line(line)
        parser.parse(scan_line(scan))
    end
else
    until false do
        line = gets
        scan.next_line(line)
        parser.parse(scan_line(scan))
    end
end
