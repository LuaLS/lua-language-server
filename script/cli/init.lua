if _G['VERSION'] then
    require 'cli.version'
    os.exit(0, true)
end

if _G['CHECK'] then
    require 'cli.check'
    os.exit(0, true)
end

if _G['DOC'] then
    require 'cli.doc' .runCLI()
    os.exit(0, true)
end
