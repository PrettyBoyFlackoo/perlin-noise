package;

import h2d.Tile;
import h2d.Bitmap;
import hxd.BitmapData;
import hxd.res.DefaultFont;
import h2d.Slider;
import h2d.Text;
import hxd.Key;
import h2d.Graphics;

class Main extends hxd.App {

    var g:Graphics;
    var drawMap:Array<Float> = [];
    var bmp:Bitmap;
    var bmpData:BitmapData;
    var mapTile:Tile;

    var noise2dMap:Array<Array<Float>> = [];

    var perlin:Perlin;
    var size:Int = 100; //100

    var scale:Float = 1.0;
    var octaves:Int = 4;
    var persistance:Float = .5;
    var lacunarity:Float = 1.0;
    var frequency:Float = 1.0;

    //Gui
    var scaleSlider:Slider;
    var octavesSlider:Slider;
    var persistanceSlider:Slider;
    var lacunaritySlider:Slider;
    var frequencySlider:Slider;

    var scaleHeader:Text;
    var octavesHeader:Text;
    var persistanceHeader:Text;
    var lacunarityHeader:Text;
    var frequencyHeader:Text;

    static function main() {
        new Main();    
    }

    override function init():Void {
        g = new Graphics(s2d);
        bmpData = new BitmapData(size, size);

        var scaleFactor = 3.0;

        bmp = new Bitmap(Tile.fromBitmap(bmpData), s2d);
        bmp.x = s2d.width / 2 - (bmp.tile.width * scaleFactor) / 2;
        bmp.y = s2d.height / 2 - (bmp.tile.height * scaleFactor) / 2;
        bmp.scale(scaleFactor);

        perlin = new Perlin();

        scaleHeader = new Text(DefaultFont.get(), s2d);
        scaleHeader.text = 'Scale: ' + scale;
        scaleHeader.x += 32;
        scaleHeader.y += 142;
        scaleSlider = new Slider(100, 10, s2d);
        scaleSlider.minValue = .1;
        scaleSlider.maxValue = 25;
        scaleSlider.value = scale;
        scaleSlider.x += 32;
        scaleSlider.y += 158;
        
        scaleSlider.onChange = () -> {
            scale = Math.round(scaleSlider.value * 100) / 100;

            generate();
        }

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
        persistanceSlider.maxValue = 1;
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
        lacunaritySlider.maxValue = 2;
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
        frequencySlider.maxValue = 1;
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
                var v = perlin.octavePerlin(i * .1, j * .1, scale, octaves, persistance, lacunarity, frequency);

                row.push(v);
            }

            noise2dMap.push(row);
        }

        draw();
    }

    function draw() {
      
        //draw1DNoise();
        draw2DNoise();

        //update text
        octavesHeader.text = 'Octaves: ' + octaves;
        persistanceHeader.text = 'Persistance: ' + persistance;
        lacunarityHeader.text = 'Lacunarity: ' + lacunarity;
        frequencyHeader.text = 'Frequency: ' + frequency;
        scaleHeader.text = 'Scale: ' + scale;
    }

    override function update(dt:Float):Void {

    }

    function draw1DNoise():Void {
        g.clear();
        g.lineStyle(1, 0xFFFFFF);
        g.beginFill(0xFFFFFF);

        var drawPoints = false;

        drawMap = [];

        //Convert 2d Array to 1D
        for (y in 0...size) {
            for (x in 0...size) {
                var i = getIndexFrom2DArray(y, x, size);
                var index = getPosFrom2DArray(i, size);

                var value = noise2dMap[index.row][index.col];

                drawMap.push(value);
            }
        }

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
    }

    function draw2DNoise():Void {
        drawMap = [];

        //Convert 2d Array to 1D
        for (y in 0...size) {
            for (x in 0...size) {
                var i = getIndexFrom2DArray(y, x, size);
                var index = getPosFrom2DArray(i, size);

                var value = noise2dMap[index.row][index.col];

                drawMap.push(value);
            }
        }


        //Draw 2D
        for (y in 0...bmpData.height) {
            for (x in 0...bmpData.width) {
                var i = getIndexFrom2DArray(y, x, size);
                var index = getPosFrom2DArray(i, size);

                var value = noise2dMap[index.row][index.col];
                
                bmpData.setPixel(x, y,  fromRGBToHex(Math.round(value * 255), Math.round(value * 255), Math.round(value * 255)));
            }
        }

        bmp.tile = Tile.fromBitmap(bmpData);
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

    inline function fromRGBToHex(r:Int, g:Int, b:Int, a:Int = 255):Int {
        return ((a << 24) | (r << 16) | (g << 8) | b);
    }
}