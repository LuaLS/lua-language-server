local stages = require "luacheck.stages"
local utils = require "luacheck.utils"

local format = {}

local color_support = not utils.is_windows or os.getenv("ANSICON")

local function get_message_format(warning)
   local message_format = assert(stages.warnings[warning.code], "Unkown warning code " .. warning.code).message_format

   if type(message_format) == "function" then
      return message_format(warning)
   else
      return message_format
   end
end

local function plural(number)
   return (number == 1) and "" or "s"
end

local color_codes = {
   reset = 0,
   bright = 1,
   red = 31,
   green = 32
}

local function encode_color(c)
   return "\27[" .. tostring(color_codes[c]) .. "m"
end

local function colorize(str, ...)
   str = str .. encode_color("reset")

   for _, color in ipairs({...}) do
      str = encode_color(color) .. str
   end

   return encode_color("reset") .. str
end

local function format_color(str, color, ...)
   return color and colorize(str, ...) or str
end

local function format_number(number, color)
   return format_color(tostring(number), color, "bright", (number > 0) and "red" or "reset")
end

-- Substitutes markers within string format with values from a table.
-- "{field_name}" marker is replaced with `values.field_name`.
-- "{field_name!}" marker adds highlight or quoting depending on color
-- option.
local function substitute(string_format, values, color)
   return (string_format:gsub("{([_a-zA-Z0-9]+)(!?)}", function(field_name, highlight)
      local value = tostring(assert(values[field_name], "No field " .. field_name))

      if highlight == "!" then
         if color then
            return colorize(value, "bright")
         else
            return "'" .. value .. "'"
         end
      else
         return value
      end
   end))
end

local function format_message(event, color)
   return substitute(get_message_format(event), event, color)
end

-- Returns formatted message for an issue, without color.
function format.get_message(event)
   return format_message(event)
end

local function capitalize(str)
   return str:gsub("^.", string.upper)
end

local function fatal_type(file_report)
   return capitalize(file_report.fatal) .. " error"
end

local function count_warnings_errors(events)
   local warnings, errors = 0, 0

   for _, event in ipairs(events) do
      if event.code:sub(1, 1) == "0" then
         errors = errors + 1
      else
         warnings = warnings + 1
      end
   end

   return warnings, errors
end

local function format_file_report_header(report, file_name, opts)
   local label = "Checking " .. file_name
   local status

   if report.fatal then
      status = format_color(fatal_type(report), opts.color, "bright")
   elseif #report == 0 then
      status = format_color("OK", opts.color, "bright", "green")
   else
      local warnings, errors = count_warnings_errors(report)

      if warnings > 0 then
         status = format_color(tostring(warnings).." warning"..plural(warnings), opts.color, "bright", "red")
      end

      if errors > 0 then
         status = status and (status.." / ") or ""
         status = status..(format_color(tostring(errors).." error"..plural(errors), opts.color, "bright"))
      end
   end

   return label .. (" "):rep(math.max(50 - #label, 1)) .. status
end

local function format_location(file, location, opts)
   local res = ("%s:%d:%d"):format(file, location.line, location.column)

   if opts.ranges then
      res = ("%s-%d"):format(res, location.end_column)
   end

   return res
end

local function event_code(event)
   return (event.code:sub(1, 1) == "0" and "E" or "W")..event.code
end

local function format_event(file_name, event, opts)
   local message = format_message(event, opts.color)

   if opts.codes then
      message = ("(%s) %s"):format(event_code(event), message)
   end

   return format_location(file_name, event, opts) .. ": " .. message
end

local function format_file_report(report, file_name, opts)
   local buf = {format_file_report_header(report, file_name, opts)}

   if #report > 0 then
      table.insert(buf, "")

      for _, event in ipairs(report) do
         table.insert(buf, "    " .. format_event(file_name, event, opts))
      end

      table.insert(buf, "")
   elseif report.fatal then
      table.insert(buf, "")
      table.insert(buf, "    " .. file_name .. ": " .. report.msg)
      table.insert(buf, "")
   end

   return table.concat(buf, "\n")
end

local function escape_xml(str)
   str = str:gsub("&", "&amp;")
   str = str:gsub('"', "&quot;")
   str = str:gsub("'", "&apos;")
   str = str:gsub("<", "&lt;")
   str = str:gsub(">", "&gt;")
   return str
end

format.builtin_formatters = {}

function format.builtin_formatters.default(report, file_names, opts)
   local buf = {}

   if opts.quiet <= 2 then
      for i, file_report in ipairs(report) do
         if opts.quiet == 0 or file_report.fatal or #file_report > 0 then
            table.insert(buf, (opts.quiet == 2 and format_file_report_header or format_file_report) (
               file_report, file_names[i], opts))
         end
      end

      if #buf > 0 and buf[#buf]:sub(-1) ~= "\n" then
         table.insert(buf, "")
      end
   end

   local total = ("Total: %s warning%s / %s error%s in %d file%s"):format(
      format_number(report.warnings, opts.color), plural(report.warnings),
      format_number(report.errors, opts.color), plural(report.errors),
      #report - report.fatals, plural(#report - report.fatals))

   if report.fatals > 0 then
      total = total..(", couldn't check %s file%s"):format(
         report.fatals, plural(report.fatals))
   end

   table.insert(buf, total)
   return table.concat(buf, "\n")
end

function format.builtin_formatters.TAP(report, file_names, opts)
   opts.color = false
   local buf = {}

   for i, file_report in ipairs(report) do
      if file_report.fatal then
         table.insert(buf, ("not ok %d %s: %s"):format(#buf + 1, file_names[i], fatal_type(file_report)))
      elseif #file_report == 0 then
         table.insert(buf, ("ok %d %s"):format(#buf + 1, file_names[i]))
      else
         for _, warning in ipairs(file_report) do
            table.insert(buf, ("not ok %d %s"):format(#buf + 1, format_event(file_names[i], warning, opts)))
         end
      end
   end

   table.insert(buf, 1, "1.." .. tostring(#buf))
   return table.concat(buf, "\n")
end

function format.builtin_formatters.JUnit(report, file_names)
   -- JUnit formatter doesn't support any options.
   local opts = {}
   local buf = {[[<?xml version="1.0" encoding="UTF-8"?>]]}
   local num_testcases = 0

   for _, file_report in ipairs(report) do
      if file_report.fatal or #file_report == 0 then
         num_testcases = num_testcases + 1
      else
         num_testcases = num_testcases + #file_report
      end
   end

   table.insert(buf, ([[<testsuite name="Luacheck report" tests="%d">]]):format(num_testcases))

   for file_i, file_report in ipairs(report) do
      if file_report.fatal then
         table.insert(buf, ([[    <testcase name="%s" classname="%s">]]):format(
            escape_xml(file_names[file_i]), escape_xml(file_names[file_i])))
         table.insert(buf, ([[        <error type="%s"/>]]):format(escape_xml(fatal_type(file_report))))
         table.insert(buf, [[    </testcase>]])
      elseif #file_report == 0 then
         table.insert(buf, ([[    <testcase name="%s" classname="%s"/>]]):format(
            escape_xml(file_names[file_i]), escape_xml(file_names[file_i])))
      else
         for event_i, event in ipairs(file_report) do
            table.insert(buf, ([[    <testcase name="%s:%d" classname="%s">]]):format(
               escape_xml(file_names[file_i]), event_i, escape_xml(file_names[file_i])))
            table.insert(buf, ([[        <failure type="%s" message="%s"/>]]):format(
               escape_xml(event_code(event)), escape_xml(format_event(file_names[file_i], event, opts))))
            table.insert(buf, [[    </testcase>]])
         end
      end
   end

   table.insert(buf, [[</testsuite>]])
   return table.concat(buf, "\n")
end

local fatal_error_codes = {
   ["I/O"] = "F1",
   ["syntax"] = "F2",
   ["runtime"] = "F3"
}

function format.builtin_formatters.visual_studio(report, file_names)
   local buf = {}

   for i, file_report in ipairs(report) do
      if file_report.fatal then
         -- Older docs suggest that line number after a file name is optional; newer docs mark it as required.
         -- Just use tool name as origin and put file name into the message.
         table.insert(buf, ("luacheck : fatal error %s: couldn't check %s: %s"):format(
            fatal_error_codes[file_report.fatal], file_names[i], file_report.msg))
      else
         for _, event in ipairs(file_report) do
               -- Older documentation on the format suggests that it could support column range.
               -- Newer docs don't mention it. Don't use it for now.
               local event_type = event.code:sub(1, 1) == "0" and "error" or "warning"
               local message = format_message(event)
               table.insert(buf, ("%s(%d,%d) : %s %s: %s"):format(
                  file_names[i], event.line, event.column, event_type, event_code(event), message))
         end
      end
   end

   return table.concat(buf, "\n")
end

function format.builtin_formatters.plain(report, file_names, opts)
   opts.color = false
   local buf = {}

   for i, file_report in ipairs(report) do
      if file_report.fatal then
         table.insert(buf, ("%s: %s (%s)"):format(file_names[i], fatal_type(file_report), file_report.msg))
      else
         for _, event in ipairs(file_report) do
            table.insert(buf, format_event(file_names[i], event, opts))
         end
      end
   end

   return table.concat(buf, "\n")
end

--- Formats a report.
-- Recognized options:
--    `options.formatter`: name of used formatter. Default: "default".
--    `options.quiet`: integer in range 0-3. See CLI. Default: 0.
--    `options.color`: should use ansicolors? Default: true.
--    `options.codes`: should output warning codes? Default: false.
--    `options.ranges`: should output token end column? Default: false.
function format.format(report, file_names, options)
   return format.builtin_formatters[options.formatter or "default"](report, file_names, {
      quiet = options.quiet or 0,
      color = (options.color ~= false) and color_support,
      codes = options.codes,
      ranges = options.ranges
   })
end

return format
