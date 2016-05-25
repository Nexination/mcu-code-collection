pageName = '82.196.6.188'
port = 8000
apiKey = 'NCQyVGdVvs43j8itMcdOma2zFEy6ZsYd'
outputPin = 0
upperLimit = 0
lowerLimit = 1023
lastRead = 0
fallOffValue = 100

gpio.mode(outputPin, gpio.OUTPUT)
gpio.write(outputPin, gpio.HIGH)

function httpSend(json)
  local sock = nil
  sock = net.createConnection(net.TCP, 0)
  sock:on("receive", function(sck, c) print('recieved') print(c) end)
  sock:on("connection", function(sck,c)
      -- Wait for connection before sending.
      local fullJson = '{ "msg": "' .. json .. '", "api-key": "' .. apiKey .. '"}'
      print('connected')
      sock:send(
        'POST / HTTP/1.1\r\n'
        .. 'Host: ' .. pageName .. '\r\n'
        .. 'Connection: keep-alive\r\n'
        .. 'Accept: */*\r\n'
        .. 'Content-Type: application/json\r\n'
        .. 'Content-Length: ' .. string.len(fullJson) .. '\r\n\r\n'
        .. fullJson .. '\r\n'
      )
  end)
  sock:on("disconnection", function(connout, payloadout)
    sock:close();
    collectgarbage();
    print('disconnected')
  end)
  sock:connect(port,pageName)
end

function setLimits(readOut)
  --Set upperLimit
  if readOut > upperLimit then
    upperLimit = readOut
  end
  --Set lowerLimit
  if readOut < lowerLimit and readOut > fallOffValue then
    lowerLimit = readOut
  end
end

function checkWaterLevel(readOut)
  local waterSpan = upperLimit - lowerLimit
  local waterStatus = upperLimit - readOut
  local waterPercentage = (waterStatus / waterSpan) * 100
  if readOut < lastRead and readOut > fallOffValue then
    httpSend(math.fmod(waterPercentage,10))
  elseif readOut < fallOffValue and lastRead > fallOffValue then
    httpSend('done')
  end
end

tmr.alarm(0, 1000, tmr.ALARM_AUTO, function()
  gpio.write(outputPin, gpio.HIGH)
  local readOut = adc.read(0)
  gpio.write(outputPin, gpio.LOW)

  setLimits(readOut)
  checkWaterLevel(readOut)
  lastRead = readOut
end)
