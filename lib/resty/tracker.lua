local ngx = ngx
local cjson = require('cjson')

local _M = {
    _VERSION = "0.01",
}

local mt = { __index = _M }

function _M.new(_, opts)
    opts = opts or {}
    local self = {
        data = {},
    }

    return setmetatable(self, mt)
end


function _M.hook_tracker_location(self)
    ngx.req.read_body() -- Get request body

    local data = ngx.req.get_body_data()

    if not data then
        ngx.log(ngx.ERR,"Received webhook without POST body")
        return false
    end

    local webhook_body = cjson.decode(data)
    table.insert(self.data, webhook_body)
    ngx.log(ngx.ERR,data);

    return true
end

function _M.hook_data(self)
    ngx.say(cjson.encode(self.data))
end

function _M.hook_tracker_online(self)
    return true
end

return _M
