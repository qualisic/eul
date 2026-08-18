-- code:sub(p, p) for current character

local file = io.open(arg[1], "r")
if not file then
    print("ERR: Cannot read file")
	os.exit(1)
end

local code = file:read("a")
file:close()
local p = 1

local vars = {}
local labels = {}

local valid_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.:,;=+#>"

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
                else
                    print("ERR: You can only set the variables to be single digit numbers")
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

-- i'm not doing the truth machine and hello world for this version you can do it