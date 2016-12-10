# Eric Eckert
# December 2016

require 'readline'

# Class Token is a simple structure that holds identifiers for each token
# type. Each Token object will be instantiated with a type.
# Types of Tokens: End of File, ID (variable name), Left Parenthesis,
# Right Parenthesis, Clear, List, Quit, Addition, Subtraction, Multiplication,
# Division, Power, Number, Assignment, End of Line, Sqare Root, Syntax Error
#
class Token
    # Identifier constants
    EOF ||= 0
    ID ||= 1
    LPAREN ||= 3
    RPAREN ||= 4
    CLEAR ||= 5
    LIST ||= 6
    QUIT ||= 7
    PLUS ||= 8
    SBTR ||= 9
    MULT ||= 10
    POWR ||= 11
    DIV ||= 12
    NUM ||= 13
    ASSGN ||= 14
    EOL ||= 2
    ERR ||= 15
    SQRT ||= 16
    def initialize(kind, id = nil, value = nil)
        @id = id
        @kind = kind
        @value = value
    end

    def kind()
        return @kind
    end

    def value()
        return @value
    end

    def id()
        return @id
    end

    # Returns a string describing the Token
    def to_a()
        case @kind
        when 0 then "End of file"
        when 1 then "ID: " + @id
        when 2 then "End of line"
        when 3 then "Left parenthesis"
        when 4 then "Right parenthesis"
        when 5 then "Clear assignment"
        when 6 then "List all assignments"
        when 7 then "Quit program"
        when 8 then "Operator: addition"
        when 9 then "Operator: subtraction"
        when 10 then "Operator: multiplication"
        when 11 then "Operator: power"
        when 12 then "Operator: division"
        when 13 then "Number: " + @value
        when 14 then "Assignment"
        when 15 then "Syntax Error"
        when 16 then "Operator: square root"
        end
    end
end

# Class Scanner contains methods to read lines of input and turn it into Token objects
class Scanner
    def initialize()
        @input = ""
    end

    # Will return the next Token object
    def next_token()
        if @input.nil?
            return Token.new(Token::EOF)
        end
        skip_white_space
#        puts @input
        if @input =~ /^exit(\s|$)/i
            @input .gsub!(/^exit/i, "")
            return Token.new(Token::QUIT)
        elsif @input =~ /^quit(\s|$)/i
            @input.gsub!(/^quit/i, "")
            return Token.new(Token::QUIT)
        elsif @input =~ /^list(\s|$)/i
            @input.gsub!(/^list/i, "")
            return Token.new(Token::LIST)
        elsif @input =~ /^clear(\s|$)/i
            @input.gsub!(/^clear/i, "")
            return Token.new(Token::CLEAR)
        elsif @input =~ /^\(/
            @input.gsub!(/^\(/, "")
            return Token.new(Token::LPAREN)
        elsif @input =~ /^\)/
            @input.gsub!(/^\)/, "")
            return Token.new(Token::RPAREN)
        elsif @input =~ /^\+/
            @input.gsub!(/^\+/, "")
            return Token.new(Token::PLUS)
        elsif @input =~ /^\-/
            @input.gsub!(/^\-/, "")
            return Token.new(Token::SBTR)
        elsif @input =~ /^\*\*/
            @input.gsub!(/^\*\*/, "")
            return Token.new(Token::POWR)
        elsif @input =~ /^\*/
            @input.gsub!(/^\*/, "")
            return Token.new(Token::MULT)
        elsif @input =~ /^\//
            @input.gsub!(/^\//, "")
            return Token.new(Token::DIV)
        elsif @input =~ /^\=/
            @input.gsub!(/^\=/, "")
            return Token.new(Token::ASSGN)
        elsif @input =~ /^[0-9]+\.?[0-9]*/
            token = Token.new(Token::NUM, nil, /^[0-9]+/.match(@input)[0])
            @input.gsub!(/^[0-9]+\.?[0-9]*/, "")
            return token
        elsif @input =~ /^sqrt(\s|\(|$)/i
            @input.gsub!(/^sqrt/i, "")
            return Token.new(Token::SQRT)
        elsif @input =~ /^[a-zA-Z]\w*/
            token = Token.new(Token::ID, /^[a-zA-Z]\w*/.match(@input)[0], nil)
            @input.gsub!(/^[a-zA-Z]\w*/, "")
            return token
        elsif @input.empty?
            return Token.new(Token::EOF)
        elsif @input =~ /^\n/
            @input.gsub!(/^\n/, "")
            return Token.new(Token::EOL)
        else
            return Token.new(Token::ERR)
        end
    end

    # Skip all insignificant whitespace at the beginning of input
    def skip_white_space()
        @input.gsub!(/^[^\S\r\n]+/, "")
    end

    # Update the input line
    def next_line(line)
        @input = line
    end

end
