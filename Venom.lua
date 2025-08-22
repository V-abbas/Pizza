--[[

--]]
URL     = require("./libs/url")
JSON    = require("./libs/dkjson")
serpent = require("libs/serpent")
json = require('libs/json')
Redis = require('./libs/redis').connect('127.0.0.1', 6379)
http  = require("socket.http")
https   = require("ssl.https")
local Methods = io.open("./luatele.lua","r")
if Methods then
URL.tdlua_CallBack()
end
SshId = io.popen("echo $SSH_CLIENT ︙ awk '{ print $1}'"):read('*a')
luatele = require 'luatele'
local FileInformation = io.open("./Information.lua","r")
if not FileInformation then
if not Redis:get(SshId.."Info:Redis:Token") then
io.write('\27[1;31mارسل لي توكن البوت الان \nSend Me a Bot Token Now ↡\n\27[0;39;49m')
local TokenBot = io.read()
if TokenBot and TokenBot:match('(%d+):(.*)') then
local url , res = https.request('https://api.telegram.org/bot'..TokenBot..'/getMe')
local Json_Info = JSON.decode(url)
if res ~= 200 then
print('\27[1;34mعذرا توكن البوت خطأ تحقق منه وارسله مره اخره \nBot Token is Wrong\n')
else
io.write('\27[1;34mتم حفظ التوكن بنجاح \nThe token been saved successfully \n\27[0;39;49m')
TheTokenBot = TokenBot:match("(%d+)")
os.execute('sudo rm -fr .CallBack-Bot/'..TheTokenBot)
Redis:set(SshId.."Info:Redis:Token",TokenBot)
Redis:set(SshId.."Info:Redis:Token:User",Json_Info.result.username)
end 
else
print('\27[1;34mلم يتم حفظ التوكن جرب مره اخره \nToken not saved, try again')
end 
os.execute('lua Venom.lua')
end
if not Redis:get(SshId.."Info:Redis:User") then
io.write('\27[1;31mارسل معرف المطور الاساسي الان \nDeveloper UserName saved ↡\n\27[0;39;49m')
local UserSudo = io.read():gsub('@','')
if UserSudo ~= '' then
io.write('\n\27[1;34mتم حفظ معرف المطور \nDeveloper UserName saved \n\n\27[0;39;49m')
Redis:set(SshId.."Info:Redis:User",UserSudo)
else
print('\n\27[1;34mلم يتم حفظ معرف المطور الاساسي \nDeveloper UserName not saved\n')
end 
os.execute('lua Venom.lua')
end
if not Redis:get(SshId.."Info:Redis:User:ID") then
io.write('\27[1;31mارسل ايدي المطور الاساسي الان \nDeveloper ID saved ↡\n\27[0;39;49m')
local UserId = io.read()
if UserId and UserId:match('(%d+)') then
io.write('\n\27[1;34mتم حفظ ايدي المطور \nDeveloper ID saved \n\n\27[0;39;49m')
Redis:set(SshId.."Info:Redis:User:ID",UserId)
else
print('\n\27[1;34mلم يتم حفظ ايدي المطور الاساسي \nDeveloper ID not saved\n')
end 
os.execute('lua Venom.lua')
end
print('&&&&&')
local Informationlua = io.open("Information.lua", 'w')
Informationlua:write([[
return {
Token = "]]..Redis:get(SshId.."Info:Redis:Token")..[[",
UserBot = "]]..Redis:get(SshId.."Info:Redis:Token:User")..[[",
UserSudo = "]]..Redis:get(SshId.."Info:Redis:User")..[[",
SudoId = ]]..Redis:get(SshId.."Info:Redis:User:ID")..[[
}
]])
Informationlua:close()
local Venom = io.open("Venom", 'w')
Venom:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 Venom.lua
done
]])
Venom:close()
local Run = io.open("Run", 'w')
Run:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S Venom -X kill
screen -S Venom ./Venom
done
]])
Run:close()
Redis:del(SshId.."Info:Redis:User:ID");Redis:del(SshId.."Info:Redis:User");Redis:del(SshId.."Info:Redis:Token:User");Redis:del(SshId.."Info:Redis:Token")
os.execute('chmod +x Venom;chmod +x Run;./Run')
end
Information = dofile('./Information.lua')
Sudo_Id = Information.SudoId
UserSudo = '@'..Information.UserSudo
Token = Information.Token
UserBot = Information.UserBot
Venom = Token:match("(%d+)")
os.execute('sudo rm -fr .CallBack-Bot/'..Venom)
LuaTele = luatele.set_config{api_id=2692371,api_hash='fe85fff033dfe0f328aeb02b4f784930',session_name=Venom,token=Token}
function var(value)  
print(serpent.block(value, {comment=false}))   
end 

local json = require("dkjson")
local orders_file = "./orders.json"

-- تحميل البيانات من الملف
local function load_orders()
  local f = io.open(orders_file, "r")
  if not f then return {} end
  local content = f:read("*a")
  f:close()
  return json.decode(content) or {}
end

-- حفظ البيانات
local function save_orders(data)
  local f = io.open(orders_file, "w+")
  f:write(json.encode(data))
  f:close()
end

-- استقبال الرسائل
if text == "ابدأ" or text == "/start" then
  local reply_markup = LuaTele.replyMarkup{
    type = 'keyboard',
    resize = true,
    keyboard = {
      { {text="🍕 بيتزا"}, {text="🌭 جكسي"} },
      { {text="🍕+🌭 بيتزا + جكسي"} },
      { {text="📊 المجموع"} }
    }
  }
  return LuaTele.sendText(chat_id, msg_id, "اختار نوع الطلب 👇", "md", true, false, false, false, reply_markup)
end

-- الاصناف
if text == "🍕 بيتزا" or text == "🌭 جكسي" or text == "🍕+🌭 بيتزا + جكسي" then
  Redis:set("mode:"..chat_id, text) -- نخزن الصنف
  local reply_markup = LuaTele.replyMarkup{
    type = 'keyboard',
    resize = true,
    keyboard = {
      { {text="➕ إضافة طلب"}, {text="➖ حذف طلب"} },
      { {text="🔙 رجوع"} }
    }
  }
  return LuaTele.sendText(chat_id, msg_id, "شنو تريد تسوي؟", "md", true, false, false, false, reply_markup)
end

-- إضافة
if text == "➕ إضافة طلب" then
  local item = Redis:get("mode:"..chat_id)
  Redis:set("action:"..chat_id, "add|"..item)
  return LuaTele.sendText(chat_id, msg_id, "ارسل السعر 🔢")
end

-- حذف
if text == "➖ حذف طلب" then
  local item = Redis:get("mode:"..chat_id)
  Redis:set("action:"..chat_id, "del|"..item)
  return LuaTele.sendText(chat_id, msg_id, "ارسل السعر الموجود ❌")
end

-- استقبال السعر
if tonumber(text) then
  local action = Redis:get("action:"..chat_id)
  if action then
    local parts = {}
    for p in string.gmatch(action, "([^|]+)") do table.insert(parts, p) end
    local act, item = parts[1], parts[2]

    local orders = load_orders()
    orders[item] = orders[item] or {}

    if act == "add" then
      table.insert(orders[item], tonumber(text))
      save_orders(orders)
      LuaTele.sendText(chat_id, msg_id, "✅ تمت إضافة السعر "..text.." إلى "..item)
    elseif act == "del" then
      local found = false
      for i, v in ipairs(orders[item]) do
        if v == tonumber(text) then
          table.remove(orders[item], i)
          found = true
          break
        end
      end
      if found then
        save_orders(orders)
        LuaTele.sendText(chat_id, msg_id, "🗑️ تم حذف السعر "..text.." من "..item)
      else
        LuaTele.sendText(chat_id, msg_id, "⚠️ السعر غير موجود ضمن "..item)
      end
    end

    Redis:del("action:"..chat_id)
  end
end

-- المجموع
if text == "📊 المجموع" then
  local orders = load_orders()
  local totalCount, totalPrice = 0, 0
  local msg = "📊 قائمة المجموع:\n\n"
  for item, list in pairs(orders) do
    local count = #list
    local sum = 0
    for _,v in ipairs(list) do sum = sum + v end
    msg = msg.."▫️ "..item.." = "..count.." طلب (المجموع "..sum..")\n"
    totalCount = totalCount + count
    totalPrice = totalPrice + sum
  end
  msg = msg.."\n✨ العدد الكلي: "..totalCount.." طلب\n💰 المجموع الكلي: "..totalPrice
  return LuaTele.sendText(chat_id, msg_id, msg)
end

-- رجوع
if text == "🔙 رجوع" then
  local reply_markup = LuaTele.replyMarkup{
    type = 'keyboard',
    resize = true,
    keyboard = {
      { {text="🍕 بيتزا"}, {text="🌭 جكسي"} },
      { {text="🍕+🌭 بيتزا + جكسي"} },
      { {text="📊 المجموع"} }
    }
  }
  return LuaTele.sendText(chat_id, msg_id, "رجعنا للقائمة الرئيسية 👇", "md", true, false, false, false, reply_markup)
end
