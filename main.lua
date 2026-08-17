-- code:sub(p, p) for current character

local code = arg[1]
local p = 1

local vars = {}
local labels = {}

local valid_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:,;=+-#>"

-- check for labels first

for i = 1, #code do
    if code:sub(i, i) == ">" then
        if code:sub(i + 1, i + 1) ~= "" then
            if code:sub(i + 1, i + 1):match("%l") ~= nil then
                if labels[code:sub(i + 1, i + 1)] == nil then
                    labels[code:sub(i + 1, i + 1)] = i + 1
                else
                    print("ERR: You can't use the same label twice")
                    os.exit(1)
                end
            else
                print("ERR: Labels have to be a lowercase letter")
                os.exit(1)
            end
        else
            print("ERR: You have to declare a label if you use \">\"")
            os.exit(1)
        end
    end
end

-- and now the code

while p <= #code do
    -- declaring variables
    if code:sub(p, p) == ":" then
        if code:sub(p + 1, p + 1):match("%u") ~= nil then
            if vars[code:sub(p + 1, p + 1)] == nil then
                vars[code:sub(p + 1, p + 1)] = 0
            else
                print("ERR: You can't declare a variable twice")
                os.exit(1)
            end
        else
            print("ERR: Variables have to be an uppercase letter")
            os.exit(1)
        end
        -- setting the values of variables
    elseif code:sub(p, p) == "#" then
        if code:sub(p - 1, p - 1):match("%u") ~= nil then
            if vars[code:sub(p - 1, p - 1)] ~= nil then
                if code:sub(p + 1, p + 1):match("%d") ~= nil then
                    vars[code:sub(p - 1, p - 1)] = code:sub(p + 1, p + 1)
                elseif code:sub(p + 1, p + 1):match("%u") ~= nil then
                    vars[code:sub(p - 1, p - 1)] = vars[code:sub(p + 1, p + 1)]
                else
                    print("ERR: You can only set the variables to be single digit numbers or the values of other variables")
                    os.exit(1)
                end
            else
                print("ERR: Variable is not declared")
                os.exit(1)
            end
        else
            print("ERR: You can only set values of variables")
            os.exit(1)
        end
        -- taking user input
    elseif code:sub(p, p) == "," then
        if code:sub(p + 1, p + 1):match("%u") ~= nil then
            if vars[code:sub(p + 1, p + 1)] ~= nil then
                vars[code:sub(p + 1, p + 1)] = string.byte(io.read(1))
            else
                print("ERR: Variable is not declared")
                os.exit(1)
            end
        else
            print("ERR: You can only insert values into variables")
            os.exit(1)
        end
        -- outputting the value
    elseif code:sub(p, p) == ";" then
        if code:sub(p + 1, p + 1):match("%u") ~= nil then
            if vars[code:sub(p + 1, p + 1)] ~= nil then
                io.write(string.char(vars[code:sub(p + 1, p + 1)]))
            else
                print("ERR: Variable is not declared")
                os.exit(1)
            end
        else
            print("ERR: You can only print the values of variables")
            os.exit(1)
        end

        -- operations on variables
    elseif code:sub(p, p) == "+" then
        if code:sub(p - 1, p - 1):match("%u") ~= nil and code:sub(p + 1, p + 1):match("%u") ~= nil then
            vars[code:sub(p - 1, p - 1)] = (vars[code:sub(p - 1, p - 1)] + vars[code:sub(p + 1, p + 1)]) % 256
            vars[code:sub(p + 1, p + 1)] = 0
        else
            print("ERR: You can only operate variables")
            os.exit(1)
        end
    elseif code:sub(p, p) == "-" then
        if code:sub(p - 1, p - 1):match("%u") ~= nil and code:sub(p + 1, p + 1):match("%u") ~= nil then
            vars[code:sub(p - 1, p - 1)] = (vars[code:sub(p - 1, p - 1)] - vars[code:sub(p + 1, p + 1)]) % 256
            vars[code:sub(p + 1, p + 1)] = 0
        else
            print("ERR: You can only operate variables")
            os.exit(1)
        end

        -- jumping to a label if eq. to zero
    elseif code:sub(p, p) == "=" then
        if code:sub(p - 1, p - 1):match("%u") ~= nil then
            if vars[code:sub(p - 1, p - 1)] ~= nil then               -- check if var. exists
                if vars[code:sub(p - 1, p - 1)] == 0 then             -- check if it's zero
                    if code:sub(p + 1, p + 1):match("%l") ~= nil then
                        if labels[code:sub(p + 1, p + 1)] ~= nil then -- check if label exists
                            p = labels[code:sub(p + 1, p + 1)]
                        else
                            print("ERR: Label is not declared")
                            os.exit(1)
                        end
                    else
                        print("ERR: You can only jump to a label")
                        os.exit(1)
                    end
                else
                    goto continue
                end
            else
                print("ERR: Variable is not declared")
                os.exit(1)
            end
        else
            print("ERR: You can only check variables")
            os.exit(1)
        end
        ::continue::

        -- checking for invalid char.s
    elseif not valid_chars:match(code:sub(p, p)) then
        print("ERR: Invalid character")
        os.exit(1)
        -- terminating the program
    elseif code:sub(p, p) == "." then
        os.exit(0)
    end
    -- increment at the end
    p = p + 1
end

-- ":C:A#9:B#A+B#A+BC#AB#A+B#A+C#A;B:D#7C-D#3;C#A;A;AC+D;C:E#7:F#E+F#E+F#6B-E;B-F#6B-F#9;BA+F#2A+F#3;A;C+F#6;C-F#8;C-F#1;CB+F;B"
-- ":Z:A>a;A,AZ=a" is the cat program
-- ":Z:Y#1:X:A#7:B#A+B#A+B#A+B:C#7A-C:D#A,X-AX=aD-Y;D.>a;DZ=a" is the truth machine (this took sooo long (mainly cuz i coded the interpreter wrong)) (also anything else is treated as 0)