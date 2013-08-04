# TODO

## Both

* Scaffold compass extension
* Robust config options (custom jpeg sprite regexes, PNG and JPG optimization)
* Rails integration

## Plan A

* Custom sprite engine that hooks into existing sprite engine
* Asset paths and file cleanup taken care of by compass

## Plan B

* `on_sprite_saved` callback that runs MiniMagick to convert PNG to JPG and cleanup JPG sprites
* `on_stylesheet_saved` callback to gsub modified paths
