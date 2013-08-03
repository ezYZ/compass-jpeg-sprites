require "mini_magick"
require "fileutils"

on_sprite_saved do |sprite|
  if is_jpeg_sprite? sprite
    cleanup_old_jpegs sprite
    convert_to_jpeg sprite
  end
end

on_stylesheet_saved do |stylesheet|
  css = File.read stylesheet
  css = replace_png_with_jpeg css
  File.open(stylesheet, 'w') { |file| file.write(css) }
end


#
# Methods
#

def is_jpeg_sprite?(sprite)
  sprite.match(/\/(jpe?g-sprites|sprites-jpe?g)\//) || sprite.match(/-jpe?g-s/)
end

def cleanup_old_jpegs(png)
  root = png.match(/^(.+-s).+\.png$/)[1]
  root = root.sub(project_path.to_s + "/", "")
  Dir["#{root}*.jpg"].each { |file| FileUtils.rm(file) }
end

def convert_to_jpeg(filename)
  output = filename.chomp("png") + "jpg"
  image = MiniMagick::Image.open filename
  image.combine_options do |c|
    c.background "#ffffff"
    c.alpha "remove"
  end
  image.format "jpg"
  image.write output
  output
end

def replace_png_with_jpeg(css)
  sprite_path = File.join "app/assets/images", "**", "*.jpg"
  sprites = Dir.glob(sprite_path).select do |image|
    is_jpeg_sprite? image
  end

  sprites.each do |sprite|
    base = File.basename sprite
    css.gsub!(base.chomp("jpg") + "png", base)
  end
  css
end
