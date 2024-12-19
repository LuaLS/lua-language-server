if _G['VERSION'] then
    require 'cli.version'
    os.exit(0, true)
end

if _G['CHECK'] then
    local checkPassed = require 'cli.check'
    os.exit(checkPassed and 0 or 1, true)
end

if _G['CHECK_WORKER'] then
    local checkPassed = require 'cli.check_worker'
    os.exit(checkPassed and 0 or 1, true)
end

if _G['DOC_UPDATE'] then
    require 'cli.doc' .runCLI()
    os.exit(0, true)
end

if _G['DOC'] then
    require 'cli.doc' .runCLI()
    os.exit(0, true)
end

if _G['VISUALIZE'] then
	local ret = require 'cli.visualize' .runCLI()
	os.exit(ret or 0, true)
end
