package;

import hxd.res.DefaultFont;
import h2d.Slider;
import h2d.Text;
import hxd.Key;
import h2d.Graphics;

class Main extends hxd.App {

    var g:Graphics;

    var noise:Array<Float> = [];

    var perlin:Perlin;
    var size:Int = 10; //100
    var octaves:Int = 4;
    var persistance:Float = .5;
    var lacunarity:Float = 2.0;

    //Gui
    var octavesSlider:Slider;
    var persistanceSlider:Slider;
    var lacunaritySlider:Slider;

    static function main() {
        new Main();    
    }

    override function init():Void {
        g = new Graphics(s2d);

        var octavesHeader = new Text(DefaultFont.get(), s2d);
        octavesHeader.text = 'Octaves';
        octavesHeader.x += 32;
        octavesHeader.y += 16;
        octavesSlider = new Slider(100, 10, s2d);
        octavesSlider.minValue = 1;
        octavesSlider.maxValue = 5;
        octavesSlider.value = octaves;
        octavesSlider.x += 32;
        octavesSlider.y += 32;
        
        octavesSlider.onChange = () -> {
            octaves = Std.int(octavesSlider.value);

            generate();
        }

        var persistanceHeader = new Text(DefaultFont.get(), s2d);
        persistanceHeader.text = 'Persistance';
        persistanceHeader.x += 32;
        persistanceHeader.y += 48;
        persistanceSlider = new Slider(100, 10, s2d);
        persistanceSlider.minValue = .1;
        persistanceSlider.maxValue = 5;
        persistanceSlider.value = persistance;
        persistanceSlider.x += 32;
        persistanceSlider.y += 64;
        persistanceSlider.onChange = () -> {
            persistance = persistanceSlider.value;

            generate();
        }

        var lacunarityHeader = new Text(DefaultFont.get(), s2d);
        lacunarityHeader.text = 'Lacunarity';
        lacunarityHeader.x += 32;
        lacunarityHeader.y += 80;
        lacunaritySlider = new Slider(100, 10, s2d);
        lacunaritySlider.minValue = .1;
        lacunaritySlider.maxValue = 5;
        lacunaritySlider.value = lacunarity;
        lacunaritySlider.x += 32;
        lacunaritySlider.y += 96;
        lacunaritySlider.onChange = () -> {
            lacunarity = lacunaritySlider.value;

            generate();
        }

        perlin = new Perlin();



        generate();
    }

    function generate() {
        noise = [];

        for (i in 0...size) {
            for (j in 0...size) {
                var v = perlin.octavePerlin(i * .1, j * .1, octaves, persistance, lacunarity);

                noise.push(v);  
            }
        }

        draw();
    }



    function draw() {
        g.clear();
        g.lineStyle(1, 0xFFFFFF);
        g.beginFill(0xFFFFFF);

        for (i in 0...noise.length) {
            var height = 100;

            var from = noise[i] * height;
            var to = noise[i + 1] * height;

            var yOffset = s2d.height / 2;
            var length = s2d.width / noise.length;

            //g.drawRect(length * i, yOffset - (noise[i] * height), 5, 5);

            g.moveTo(length * i, yOffset - from);
            g.lineTo(length * (i + 1), yOffset - to);
        }
    }

    override function update(dt:Float):Void {

    }
}