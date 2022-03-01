if _G['VERSION'] then
    require 'ci.version'
    os.exit(0, true)
end

if _G['CHECK'] then
    require 'ci.check'
    os.exit(0, true)
end
