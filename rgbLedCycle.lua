-- Initialise PWM setup of RGB LED
pwm.setup(1,500,512)
pwm.setup(2,500,512)
pwm.setup(3,500,512)
pwm.start(1)
pwm.start(2)
pwm.start(3)
pwm.setduty(1,0)
pwm.setduty(2,0)
pwm.setduty(3,0)

-- Counter values
i = 0
l = 1

-- Timer with inline function that runs through the individual colours
tmr.alarm(0,100,1,function()
    local a = 1000
    if i ＜= a then
        pwm.setduty(l, i)
    else
        pwm.setduty(l, 0)
        if l == 3 then
            l = 0
        end
        l = l + 1
        i = 0
    end
    i = i + 100
end)