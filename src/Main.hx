package;

import hxd.res.DefaultFont;
import h2d.Slider;
import h2d.Text;
import hxd.Key;
import h2d.Graphics;

class Main extends hxd.App {

    var g:Graphics;

    var noise2dMap:Array<Array<Float>> = [];

    var perlin:Perlin;
    var size:Int = 10; //100
    var octaves:Int = 4;
    var persistance:Float = .5;
    var lacunarity:Float = 2.0;
    var frequency:Float = 1.0;

    //Gui
    var octavesSlider:Slider;
    var persistanceSlider:Slider;
    var lacunaritySlider:Slider;
    var frequencySlider:Slider;

    var octavesHeader:Text;
    var persistanceHeader:Text;
    var lacunarityHeader:Text;
    var frequencyHeader:Text;

    static function main() {
        new Main();    
    }

    override function init():Void {
        g = new Graphics(s2d);
        perlin = new Perlin();

        octavesHeader = new Text(DefaultFont.get(), s2d);
        octavesHeader.text = 'Octaves: ' + octaves;
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

        persistanceHeader = new Text(DefaultFont.get(), s2d);
        persistanceHeader.text = 'Persistance: ' + persistance;
        persistanceHeader.x += 32;
        persistanceHeader.y += 48;
        persistanceSlider = new Slider(100, 10, s2d);
        persistanceSlider.minValue = .1;
        persistanceSlider.maxValue = 5;
        persistanceSlider.value = persistance;
        persistanceSlider.x += 32;
        persistanceSlider.y += 64;
        persistanceSlider.onChange = () -> {
            persistance = Math.round(persistanceSlider.value * 100) / 100;

            generate();
        }

        lacunarityHeader = new Text(DefaultFont.get(), s2d);
        lacunarityHeader.text = 'Lacunarity: ' + lacunarity;
        lacunarityHeader.x += 32;
        lacunarityHeader.y += 80;
        lacunaritySlider = new Slider(100, 10, s2d);
        lacunaritySlider.minValue = .1;
        lacunaritySlider.maxValue = 5;
        lacunaritySlider.value = lacunarity;
        lacunaritySlider.x += 32;
        lacunaritySlider.y += 96;
        lacunaritySlider.onChange = () -> {
            lacunarity = Math.round(lacunaritySlider.value * 100) / 100;

            generate();
        }

        frequencyHeader = new Text(DefaultFont.get(), s2d);
        frequencyHeader.text = 'Frequency: ' + frequency;
        frequencyHeader.x += 32;
        frequencyHeader.y += 112;
        frequencySlider = new Slider(100, 10, s2d);
        frequencySlider.minValue = .1;
        frequencySlider.maxValue = 20;
        frequencySlider.value = frequency;
        frequencySlider.x += 32;
        frequencySlider.y += 128;
        frequencySlider.onChange = () -> {
            var val = Math.round(frequencySlider.value * 100) / 100;

            frequency = val;

            for (i in 0...10) {
                var j = i * 10; //10, 20, 30...

                if (frequency % j == 0) {
                    frequency -= 1;
                }
                
            }

            generate();
        }




        generate();
    }

    function generate() {
        noise2dMap = [];

        for (i in 0...size) {
            var row:Array<Float> = [];

            for (j in 0...size) {
                var v = perlin.octavePerlin(i * .1, j * .1, octaves, persistance, lacunarity, frequency);

                row.push(v);
            }

            noise2dMap.push(row);
        }

        draw();
    }



    function draw() {
      
        var drawMap = [];

        //Convert 2d Array to 1D
        for (y in 0...size) {
            for (x in 0...size) {
                var i = getIndexFrom2DArray(y, x, size);
                var index = getPosFrom2DArray(i, size);

                var value = noise2dMap[index.row][index.col];

                drawMap.push(value);
            }
        }

        ///Draw from 1D Array
        g.clear();
        g.lineStyle(1, 0xFFFFFF);
        g.beginFill(0xFFFFFF);


        var drawPoints = false;


        for (i in 0...drawMap.length) {
            var height = 100;

            var from = drawMap[i] * height;
            var to = drawMap[i + 1] * height;

            var yOffset = s2d.height / 2;
            var length = s2d.width / drawMap.length;

            if (drawPoints) {
                var blocksize = 5;
                g.drawRect(-(blocksize / 2) + length * i, -(blocksize / 2) + yOffset - (drawMap[i] * height), blocksize, blocksize);
            }

            g.moveTo(length * i, yOffset - from);
            g.lineTo(length * (i + 1), yOffset - to);
        }


        //update text
        octavesHeader.text = 'Octaves: ' + octaves;
        persistanceHeader.text = 'Persistance: ' + persistance;
        lacunarityHeader.text = 'Lacunarity: ' + lacunarity;
        frequencyHeader.text = 'Frequency: ' + frequency;

    }

    override function update(dt:Float):Void {

    }

    /**
		Returns Index number for 1D Array. Converts the `row` and `col` position
		into a single index to get the same position by 1 Number Index!
	**/
	static function getIndexFrom2DArray(row:Int, col:Int, numCols:Int):Int {
        return row * numCols + col;
    }

	/**
		Returns position for 2D Array. Converts the index number into
		a row and columns position to get the same position with 2 attributes
	**/
	static function getPosFrom2DArray(index:Int, numCols:Int):{row:Int, col:Int} {
        var row = Std.int(index / numCols);
        var col = Std.int(index % numCols);

        return { row: row, col: col };
    }
}