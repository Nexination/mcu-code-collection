-- Set up accelerometer pins and device address
id=0
sda=1
scl=2
DEVICE_ADDRESS = 0x1C

-- Configure RGB LED PWM pins, start them and set them to 0 (off)
pwm.setup(5,500,256)
pwm.setup(6,500,256)
pwm.setup(7,500,256)
pwm.start(5)
pwm.start(6)
pwm.start(7)
pwm.setduty(5,0)
pwm.setduty(6,0)
pwm.setduty(7,0)

-- Initialize i2c to the accelerometer, set pin1 as sda, set pin2 as scl
i2c.setup(id, sda, scl, i2c.SLOW)
-- Do an i2c call to switch from standby to active
i2c.start(id)
i2c.address(id, DEVICE_ADDRESS, i2c.TRANSMITTER)
-- Here we look up the address associated with standby by writing to it
i2c.write(id, 0x2A)
-- Then we set the value of the address by writing again, it's how i2c is done
i2c.write(id, 0X01)
i2c.stop(id)

-- This function is set up much in the same fashion, but instead of setting a value we read it
function readRegistry(bitToRead)
    i2c.start(id)
    i2c.address(id, DEVICE_ADDRESS, i2c.TRANSMITTER)
    -- Pick the registry we want to read from
    i2c.write(id, bitToRead)
    i2c.start(id)
    i2c.address(id, DEVICE_ADDRESS, i2c.RECEIVER)
    -- Read the registry data
    dataByte = i2c.read(id, 2)
    i2c.stop(id)
    return string.byte(dataByte)
end

-- Tiny function to more easily change PWM of the RGB LED
function switchLed(r,g,b)
    pwm.setduty(5,r)
    pwm.setduty(6,g)
    pwm.setduty(7,b)
end

-- Set a repeat function to do a readout of the registry's and bind them to the RGB LED
function readCoordinates()
    print("X: " .. readRegistry(0x01) .. " " .. readRegistry(0x02))
    print("Y: " .. readRegistry(0x03) .. " " .. readRegistry(0x04))
    print("Z: " .. readRegistry(0x05) .. " " .. readRegistry(0x06))
    switchLed(readRegistry(0x01), readRegistry(0x03), readRegistry(0x05))
end
tmr.alarm(0,100,1,readCoordinates)