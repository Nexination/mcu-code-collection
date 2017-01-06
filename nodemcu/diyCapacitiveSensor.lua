local send_pin = 4 --GPIO2
local float_pin = 3 --GPIO0
gpio.mode(send_pin,gpio.OUTPUT) --transmit voltage
gpio.mode(float_pin,gpio.INT) --set to interrupt
counter = 0
comanda = 0
function print_comanda() 
    tmr.alarm(0, 500, 0, function()
        print("comanda = ", comanda)
        comanda = 0
    end)
end
function incr_comanda()
    tmr.alarm(1, 50, 0, function()
        if counter > 3 then
            comanda = comanda + 1
            counter = 0
            tmr.stop(1)
        end
    end)
end
function test()
    if gpio.read(float_pin) == gpio.HIGH then
        counter = counter + 1
        incr_comanda()
        print_comanda()
    end
end
pwm.setup(send_pin, 1000, 512) --set pwm cycle on transmit pin
pwm.start(send_pin) --start pwm
gpio.trig(float_pin,"both",test) --define interupt trigger function