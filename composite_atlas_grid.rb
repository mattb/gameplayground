require 'rubygems'
require 'RMagick'
include Magick

i = Image.new(512,512)
x = 0
y = 0
Dir.glob("x*.png").sort_by { |fn| fn.match(/(\d+).png/)[0].to_i }.each { |f|
    frame = Image.read(f).pop
    i.composite!(frame, x * 128, y * 128, OverCompositeOp)
    x += 1
    if x > 3
        x = 0
        y += 1
    end
}
i.write("grid.png")
