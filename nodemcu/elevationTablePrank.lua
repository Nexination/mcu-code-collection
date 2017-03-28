-- adjustme.eu TC15 controller

-- Variables
pinUp = 1
pinDown = 2
sv = net.createServer(net.TCP, 30)
timer = 1000

-- Init pins
gpio.mode(pinUp, gpio.OUTPUT)
gpio.write(pinUp, gpio.LOW)
gpio.mode(pinDown, gpio.OUTPUT)
gpio.write(pinDown, gpio.LOW)

-- Raise and lower table
function hooptieTable()
  print('hooptied')
  gpio.write(pinUp, gpio.LOW)
end

-- Webserver setup
function receiver(sck, data)
  gpio.write(pinUp, gpio.HIGH)
  tmr.create():alarm(5000, tmr.ALARM_SINGLE, hooptieTable)
  print(data)
  sck:close()
end
if sv then
  sv:listen(80, function(conn)
    conn:on("receive", receiver)
    conn:send(
      'HTTP/1.1 200/OK\r\nServer: NodeLuau\r\nContent-Type: text/html\r\n\r\n'
      .. '<html><body><h1>Martin will now #sadface</h1><br /></html></body>'
    )
    conn:on("sent",function(conn) conn:close() end)
  end)
end

--onboardLed = 10
-- Init onboard LED
--gpio.mode(onboardLed, gpio.OUTPUT)
--gpio.write(onboardLed, gpio.LOW)

-- LED switch
--function toggleLed (pin)
--    value = gpio.LOW
--    if gpio.read(pin) == gpio.LOW then
--        value = gpio.HIGH
--    end
--    gpio.write(pin, value)
--end