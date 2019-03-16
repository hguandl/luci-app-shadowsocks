-- Copyright (C) 2016-2017 Jian Chang <aa65535@live.com>
-- Licensed to the public under the GNU General Public License v3.

local m, s, o
local shadowsocks = "shadowsocks"
local sid = arg[1]
local shadowsocks_types = {
	"ShadowSocks",
	"ShadowSocksR"
}
local encrypt_methods = {
	"rc4-md5",
	"aes-128-cfb",
	"aes-192-cfb",
	"aes-256-cfb",
	"aes-128-ctr",
	"aes-192-ctr",
	"aes-256-ctr",
	"aes-128-gcm",
	"aes-192-gcm",
	"aes-256-gcm",
	"camellia-128-cfb",
	"camellia-192-cfb",
	"camellia-256-cfb",
	"bf-cfb",
	"salsa20",
	"chacha20",
	"chacha20-ietf",
	"chacha20-ietf-poly1305",
	"xchacha20-ietf-poly1305"
}
local encrypt_methods_r = {
    "none",
	"table",
	"rc4",
	"rc4-md5",
    "aes-128-cfb",
    "aes-192-cfb",
    "aes-256-cfb",
    "aes-128-ctr",
    "aes-192-ctr",
    "aes-256-ctr",
    "bf-cfb",
    "camellia-128-cfb",
    "camellia-192-cfb",
    "camellia-256-cfb",
    "cast5-cfb",
    "des-cfb",
    "idea-cfb",
    "rc2-cfb",
    "seed-cfb",
    "salsa20",
    "chacha20",
    "chacha20-ietf"
}
local protocols = {
	"origin",
    "auth_sha1",
    "auth_sha1_v2",
    "auth_sha1_v4",
    "auth_aes128_md5",
    "auth_aes128_sha1",
    "auth_chain_a",
    "auth_chain_b",
    "auth_chain_c",
    "auth_chain_d",
    "auth_chain_e",
    "auth_chain_f"
}
local obfuscation_methods = {
	"plain",
    "http_simple",
    "http_post",
    "tls1.2_ticket_auth"
}

m = Map(shadowsocks, "%s - %s" %{translate("ShadowSocks"), translate("Edit Server")})
m.redirect = luci.dispatcher.build_url("admin/services/shadowsocks/servers")
m.sid = sid
m.template = "shadowsocks/servers-details"

if m.uci:get(shadowsocks, sid) ~= "servers" then
	luci.http.redirect(m.redirect)
	return
end

-- [[ Edit Server ]]--
s = m:section(NamedSection, sid, "servers")
s.anonymous = true
s.addremove = false

o = s:option(Value, "alias", translate("Alias(optional)"))
o.rmempty = true

o = s:option(ListValue, "type", translate("Type"))
for _, v in ipairs(shadowsocks_types) do o:value(v, v) end
o.rmempty = false

o = s:option(Flag, "fast_open", translate("TCP Fast Open"))
o:depends("type", "ShadowSocks")
o.rmempty = false

o = s:option(Flag, "no_delay", translate("TCP no-delay"))
o:depends("type", "ShadowSocks")
o.rmempty = false

o = s:option(Value, "server", translate("Server Address"))
-- o.datatype = "ipaddr"
o.rmempty = false

o = s:option(Value, "server_port", translate("Server Port"))
o.datatype = "port"
o.rmempty = false

o = s:option(Value, "timeout", translate("Connection Timeout"))
o.datatype = "uinteger"
o.default = 60
o.rmempty = false

o = s:option(Value, "password", translate("Password"))
o.password = true

o = s:option(Value, "key", translate("Directly Key"))
o:depends("type", "ShadowSocks")

o = s:option(ListValue, "encrypt_method", translate("Encrypt Method"))
o:depends("type", "ShadowSocks")
for _, v in ipairs(encrypt_methods) do o:value(v, v:upper()) end

o = s:option(ListValue, "encrypt_method_r", translate("Encrypt Method"))
o:depends("type", "ShadowSocksR")
for _, v in ipairs(encrypt_methods_r) do o:value(v, v) end

o = s:option(Value, "plugin", translate("Plugin Name"))
o:depends("type", "ShadowSocks")
o.placeholder = "eg: obfs-local"

o = s:option(Value, "plugin_opts", translate("Plugin Arguments"))
o:depends("type", "ShadowSocks")
o.placeholder = "eg: obfs=http;obfs-host=www.bing.com"

o = s:option(ListValue, "protocol", translate("Protocol"))
o:depends("type", "ShadowSocksR")
for _, v in ipairs(protocols) do o:value(v, v) end
o.rmempty = false

o = s:option(Value, "protocol_opts", translate("Protocol Arguments"))
o:depends("type", "ShadowSocksR")

o = s:option(ListValue, "obfuscation_method", translate("Obfuscation Method"))
o:depends("type", "ShadowSocksR")
for _, v in ipairs(obfuscation_methods) do o:value(v, v) end
o.rmempty = false

o = s:option(Value, "obfuscation_opts", translate("Obfuscation Arguments"))
o:depends("type", "ShadowSocksR")

return m
