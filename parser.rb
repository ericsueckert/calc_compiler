# Eric Eckert
# December 2016

require_relative 'scan.rb'

class Parser
    def initialize()
        @assignments = {"PI"=> Math::PI}
        @tokens = []
    end

    def parse(tokens)
        @tokens = tokens
        parse_program()
    end

    # Parses a program
    # Parsing possibilities -> statement | program statement
    def parse_program()
        #        puts "parsing program"
        parse_statement
        if @tokens.first.kind == Token::EOL
            return
        elsif @tokens.first.kind == Token::EOF
            abort
        else
            puts "Error: invalid input"
            abort
        end
    end

    # Parses a statement
    # Parsing possibilities -> exp, id=exp, clear id, list, quit, exit
    def parse_statement()
        #        puts "parsing statement"
        if @tokens.first.kind == Token::CLEAR
            # Case: Statement is a clear token
            # Return: Delete variable assignment from global hash
            @tokens.shift
            # Check after for variable ID
            if @tokens.first.kind == Token::ID
                # Check if hash contains variable ID
                id = @tokens.first.id
                @tokens.shift
                if @assignments.has_key?(id)
                    # Delete assignment
                    @assignments.delete(id)
                    print "Cleared ", id, $/
                else
                    # Return error if variable assignment doesn't exist
                    print 'Error: The variable ', @tokens.first.id, ' was never assigned.', $/
                    abort
                end
            else
                # Return error if ID does not follow clear
                puts 'Error: Expecting variable ID'
                abort
            end
        elsif @tokens.first.kind == Token::LIST
            # Case: Statement is a list token
            # Return: Print all current variable assignments in a list
            @tokens.shift
            @assignments.each do |var_id, value|
                print var_id, " = ", value, $/
            end
        elsif @tokens.first.kind == Token::QUIT
            # Case: Statement is a quit token
            # Return: Quit program
            puts "Quitting program."
            abort
        elsif @tokens[1].kind == Token::ASSGN
            # Case: Statement is an assignment statement
            # Return: Assign an evaluated expression to the variable id
            if @tokens.first.kind == Token::ID
                id = @tokens.first.id
                @tokens.shift
                @tokens.shift
                @assignments[id] = parse_exp
                print "Assigned ", @assignments[id], " to ", id, $/
            end
        else
            # Case: Statement is an expression
            # Return: Evaluated expression
            puts parse_exp
        end
    end

    # Parses an expression
    # Parsing possibilities -> term, exp + term, exp - term
    # Anything else is a syntax error
    def parse_exp()
        #        puts "parsing expression"
        exp = parse_term
        if @tokens.first.kind == Token::PLUS
            # Case: Exp is exp + term
            # Return: Evaluated exp + term
            @tokens.shift
            return exp + parse_exp
        elsif @tokens.first.kind == Token::SBTR
            # Case: Exp is exp - term
            # Return: Evaluated exp + term
            @tokens.shift
            return exp - parse_exp
        else
            # Case: Exp is term
            # Return: Evaluated expression
            return exp
        end
    end

    # Parses a term
    # Parsing possibilities -> power, term * power, term / power
    # Anything else is a syntax error
    def parse_term()
        #        puts "parsing term"
        term = parse_power
        if @tokens.first.kind == Token::MULT
            # Case: Term is a term * power
            # Return: Evaluated term * power
            @tokens.shift
            return term * parse_term
        elsif @tokens.first.kind == Token::DIV
            # Case: Term is a term / power
            # Return: Evaluated term / power
            @tokens.shift
            return term / parse_term
        else
            # Case: Term is a power
            # Return: Evaluated term
            return term
        end
    end

    # Parses a power
    # Parsing possibilities -> factor, factor ** power
    # Anything else is a syntax error
    def parse_power()
        #        puts "parsing power"
        # A Power must begin with a factor either way
        fact = parse_factor
        # Check the token after evaluating the factor
        if @tokens.first.kind == Token::POWR
            # Case: Power is factor to the power of a Power
            # Return: Evaluated factor to the power of a Power
            @tokens.shift
            return fact ** parse_power
        else
            # Case: Power is a factor
            # Return: Evaluated factor
            return fact
        end
    end

    # Parses a factor
    # Parsing possibilities -> id, number, negative number, (exp), sqrt(exp)
    # Anything else is a syntax error
    def parse_factor()
        #        puts "parsing factor"
        if @tokens.first.kind == Token::ID
            # Case: Factor is an ID
            # Return: Value mapped to ID
            # Pre: ID must be mapped, else returns error
            id = @tokens.first.id
            if @assignments.has_key?(id)
                @tokens.shift
                return @assignments[id]
            else
                print 'Error: The variable ', id, 'wasn\'t assigned to anything.', $/
                abort
            end
        elsif @tokens.first.kind == Token::NUM
            # Case: Factor is a number
            # Return: Number value
            number = @tokens.first.value
            @tokens.shift
            if number.include? "."
                return number.to_f
            else
                return number.to_i
            end
        elsif @tokens.first.kind == Token::SBTR
            # Case: Factor is a negative factor
            # Return: Negative factor
            @tokens.shift
            return -parse_factor
        elsif @tokens.first.kind == Token::LPAREN
            # Case: Factor is an expression in parentheses
            # Return: Evaluated expression
            @tokens.shift
            exp = parse_exp
            if @tokens.first.kind == Token::RPAREN
                @tokens.shift
                return exp
            else
                puts 'Error: ) expected'
                abort
            end
        elsif @tokens.first.kind == Token::SQRT
            # Case: Factor is square root operator on an expression
            # Return: Square root of evaluated expression
            # Pre: Square root operator must be followed by parentheses containing the expression
            @tokens.shift
            if @tokens.first.kind == Token::LPAREN
                @tokens.shift
                sqrt_exp = Math.sqrt(parse_exp())
                if @tokens.first.kind == Token::RPAREN
                    @tokens.shift
                    return sqrt_exp
                else
                    puts 'Error: Expecting closing parenthesis for Square root'
                    abort
                end
            else
                puts 'Error: Sqare root must be followed by parentheses'
                abort
            end
        else
            # Case: Not a factor
            # Return: Error
            if @tokens.first.kind == Token::RPAREN
                puts 'Error: Unexpected )'
                abort
            else
                puts 'Error: Not a factor'
                abort
            end
        end
    end
end
