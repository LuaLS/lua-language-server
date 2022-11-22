---@meta

---@class PrometheusLib
local PrometheusLib = {}

---@class PrometheusOptions
---is a table of configuration options that can be provided.
local PrometheusOptions = {}

---metric name prefix.
---This string will be prepended to metric names on output.
PrometheusOptions.prefix = ''
---Can be used to change the default name of error metric (see
---[Built-in metrics](https://github.com/knyar/nginx-lua-prometheus#built-in-metrics)
---for details).
PrometheusOptions.error_metric_name = ''
---sets per-worker counter sync interval in seconds.
---This sets the boundary on eventual consistency of counter metrics.
---Defaults to `1`.
PrometheusOptions.sync_interval = 0
---maximum size of a per-metric lookup table maintained by
---each worker to cache full metric names. Defaults to `1000`.
---If you have metrics with extremely high cardinality and lots
---of available RAM, you might want to increase this to avoid
---cache getting flushed too often.
---Decreasing this makes sense if you have a very large number of metrics
---or need to minimize memory usage of this library.
PrometheusOptions.lookup_max_size = 0

---Initializes the module.
---This should be called once from the
---[init_worker_by_lua_block](https://github.com/openresty/lua-nginx-module#init_worker_by_lua_block)
---section of nginx configuration.
---
---Example:
---```
---init_worker_by_lua_block {
---  prometheus = require("prometheus").init("prometheus_metrics", {sync_interval=3})
---}
---```
---@param dict_name string is the name of the nginx shared dictionary which will be used to store all metrics. Defaults to `prometheus_metrics` if not specified.
---@param options? PrometheusOptions is a table of configuration options that can be provided.
---@return Prometheus prometheus Returns a `prometheus` object that should be used to register metrics.
PrometheusLib.init = function(dict_name, options) end

---@class Prometheus
local Prometheus = {}

---Registers a counter.
---
---Should be called once for each gauge from the
---[init_worker_by_lua_block](https://github.com/openresty/lua-nginx-module#init_worker_by_lua_block)
---section.
---
---Example:
---```
---init_worker_by_lua_block {
---  prometheus = require("prometheus").init("prometheus_metrics")
---
---  metric_bytes = prometheus:counter(
---    "nginx_http_request_size_bytes", "Total size of incoming requests")
---  metric_requests = prometheus:counter(
---    "nginx_http_requests_total", "Number of HTTP requests", {"host", "status"})
---}
---```
---@param  name         string is the name of the metric.
---@param  description? string is the text description. Optional.
---@param  label_names? string[] is an array of label names for the metric. Optional.
---@return PrometheusCounter
function Prometheus:counter(name, description, label_names) end

---Registers a gauge.
---
---Should be called once for each gauge from the
---[init_worker_by_lua_block](https://github.com/openresty/lua-nginx-module#init_worker_by_lua_block)
---section.
---
---Example:
---```
---init_worker_by_lua_block {
---  prometheus = require("prometheus").init("prometheus_metrics")
---
---  metric_connections = prometheus:gauge(
---    "nginx_http_connections", "Number of HTTP connections", {"state"})
---}
---```
---@param  name         string is the name of the metric.
---@param  description? string is the text description. Optional.
---@param  label_names? string[] is an array of label names for the metric. Optional.
---@return PrometheusGauge
function Prometheus:gauge(name, description, label_names) end

---Registers a histogram.
---
---Should be called once for each histogram from the
---[init_worker_by_lua_block](https://github.com/openresty/lua-nginx-module#init_worker_by_lua_block)
---section.
---
---Example:
---```
---init_worker_by_lua_block {
---  prometheus = require("prometheus").init("prometheus_metrics")
---
---  metric_latency = prometheus:histogram(
---    "nginx_http_request_duration_seconds", "HTTP request latency", {"host"})
---  metric_response_sizes = prometheus:histogram(
---    "nginx_http_response_size_bytes", "Size of HTTP responses", nil,
---    {10,100,1000,10000,100000,1000000})
---}
---```
---@param  name         string is the name of the metric.
---@param  description? string is the text description. Optional.
---@param  label_names? string[] is an array of label names for the metric. Optional.
---@param  buckets?     number[] is an array of numbers defining bucket boundaries. Optional, defaults to 20 latency buckets covering a range from 5ms to 10s (in seconds).
---@return PrometheusHist
function Prometheus:histogram(name, description, label_names, buckets) end

---Presents all metrics in a text format compatible with Prometheus.
---This should be called in [content_by_lua_block](https://github.com/openresty/lua-nginx-module#content_by_lua_block)
---to expose the metrics on a separate HTTP page.
---
---Example:
---```
---location /metrics {
---  content_by_lua_block { prometheus:collect() }
---  allow 192.168.0.0/16;
---  deny all;
---}
---```
function Prometheus:collect() end

---Returns metric data as an array of strings.
---@return string[]
function Prometheus:metric_data() end

---@class PrometheusCounter
local PrometheusCounter = {}

---Increments a previously registered counter.
---This is usually called from log_by_lua_block globally or per server/location.
---
---The number of label values should match the number of label names
---defined when the counter was registered using `prometheus:counter()`.
---No label values should be provided for counters with no labels.
---Non-printable characters will be stripped from label values.
---
---Example:
---```
---log_by_lua_block {
---  metric_bytes:inc(tonumber(ngx.var.request_length))
---  metric_requests:inc(1, {ngx.var.server_name, ngx.var.status})
---}
---```
---@param value number is a value that should be added to the counter. Defaults to 1.
---@param label_values? string[] is an array of label values.
function PrometheusCounter:inc(value, label_values) end

---Delete a previously registered counter.
---This is usually called when you don't need to observe such counter
---(or a metric with specific label values in this counter) any more.
---If this counter has labels, you have to pass `label_values` to delete
---the specific metric of this counter.
---If you want to delete all the metrics of a counter with labels,
---you should call `Counter:reset()`.
---
---This function will wait for sync_interval before deleting the metric to
---allow all workers to sync their counters.
---@param label_values string[] The number of label values should match the number of label names defined when the counter was registered using `prometheus:counter()`. No label values should be provided for counters with no labels. Non-printable characters will be stripped from label values.
function PrometheusCounter:del(label_values) end

---Delete all metrics for a previously registered counter.
---If this counter have no labels, it is just the same as `Counter:del()` function.
---If this counter have labels, it will delete all the metrics with different label values.
---
---This function will wait for `sync_interval` before deleting the metrics to allow all workers to sync their counters.
function PrometheusCounter:reset() end

---@class PrometheusGauge
local PrometheusGauge = {}

---Sets the current value of a previously registered gauge.
---This could be called from
---[log_by_lua_block](https://github.com/openresty/lua-nginx-module#log_by_lua_block)
---globally or per server/location to modify a gauge on each request, or from
---[content_by_lua_block](https://github.com/openresty/lua-nginx-module#content_by_lua_block)
---just before `prometheus::collect()` to return a real-time value.
---
---@param value number is a value that the gauge should be set to. Required.
---@param label_values? string[] is an array of label values.
function PrometheusGauge:set(value, label_values) end

---Increments a previously registered gauge.
---This is usually called from log_by_lua_block globally or per server/location.
---
---The number of label values should match the number of label names
---defined when the gauge was registered using `prometheus:gauge()`.
---No label values should be provided for gauge with no labels.
---Non-printable characters will be stripped from label values.
---@param value number is a value that should be added to the gauge. Defaults to 1.
---@param label_values? string[] is an array of label values.
function PrometheusGauge:inc(value, label_values) end

---Delete a previously registered gauge.
---This is usually called when you don't need to observe such gauge
---(or a metric with specific label values in this gauge) any more.
---If this gauge has labels, you have to pass `label_values` to delete
---the specific metric of this gauge.
---If you want to delete all the metrics of a gauge with labels,
---you should call `Gauge:reset()`.
---
---This function will wait for sync_interval before deleting the metric to
---allow all workers to sync their counters.
---@param label_values string[] The number of label values should match the number of label names defined when the gauge was registered using `prometheus:gauge()`. No label values should be provided for counters with no labels. Non-printable characters will be stripped from label values.
function PrometheusGauge:del(label_values) end

---Delete all metrics for a previously registered gauge.
---If this gauge have no labels, it is just the same as `Gauge:del()` function.
---If this gauge have labels, it will delete all the metrics with different
---label values.
function PrometheusGauge:reset() end

---@class PrometheusHist
local PrometheusHist = {}

---Records a value in a previously registered histogram.
---Usually called from
---[log_by_lua_block](https://github.com/openresty/lua-nginx-module#log_by_lua_block)
---globally or per server/location.
---
---Example:
---```
---log_by_lua_block {
---  metric_latency:observe(tonumber(ngx.var.request_time), {ngx.var.server_name})
---  metric_response_sizes:observe(tonumber(ngx.var.bytes_sent))
---}
---```
---@param value string is a value that should be recorded. Required.
---@param label_values? string[] is an array of label values.
function PrometheusHist:observe(value, label_values) end

---Delete all metrics for a previously registered histogram.
---
---This function will wait for `sync_interval` before deleting the
---metrics to allow all workers to sync their counters.
function PrometheusHist:reset() end

return PrometheusLib
