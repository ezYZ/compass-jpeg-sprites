class JpegSpriteStylesheetPostprocessor < Sprockets::Processor
  def evaluate(context, locals)
    # Get jpeg sprites by file name. Not ideal, but it"s unclear how else Compass
    # and Sprockets can talk.
    sprite_path = File.join "app/assets/images", "**", "*.jpg"
    sprites = Dir.glob(sprite_path).select do |image|
      image.match(/\/(jpe?g-sprites|sprites-jpe?g)\//) || image.match(/-jpe?g-s/)
    end

    sprites.each do |sprite|
      base = File.basename sprite
      data.gsub!(base.chomp("jpg") + "png", base)
    end
    data
  end
end

Rails.application.assets.register_postprocessor("text/css", JpegSpriteStylesheetPostprocessor)
