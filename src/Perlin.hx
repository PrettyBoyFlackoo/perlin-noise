package;

class Perlin {

    var perm:Array<Int> = [];

    public function new() {
        perm = generateRandomPermutationList();
    }

    function fade(t:Float) {
        return t * t * t * (t * (t * 6 - 15) + 10);
    }

    function lerp(t:Float, a:Float, b:Float) {
        return a + t * (b - a);
    }

    function grad(hash, x:Float, y:Float) {
        var h = hash & 7;
        var u = h < 4 ? x : y;
        var v = h < 4 ? y : x;

        return (h & 1 == 0 ? u : -u) + (h & 2 == 0 ? v : -v);
    }

    function perlin(x, y, perm) {
        var xi = Std.int(x) & 255;
        var yi = Std.int(y) & 255;
        var xf = x - Std.int(x);
        var yf = y - Std.int(y);

        
        var u = fade(xf);
        var v = fade(yf);

        var aa = perm[perm[xi] + yi];
        var ab = perm[perm[xi] + yi + 1];
        var ba = perm[perm[xi + 1] + yi];
        var bb = perm[perm[xi + 1] + yi + 1];

        var x1 = lerp(u, grad(aa, xf, yf), grad(ba, xf - 1, yf));
        var x2 = lerp(u, grad(ab, xf, yf - 1), grad(bb, xf - 1, yf - 1));
        
        var result = lerp(v, x1, x2);

        return (result + 1) / 2;
    }

    public function octavePerlin(x:Float, y:Float, octaves = 4, persistance = .5, lacunarity = 2.0) {
        var total = .0;
        var frequency = 1.0;
        var amplitude = 1.0;
        var maxValue = .0;

        for (i in 0...octaves) {
            total += perlin(x * frequency, y * frequency, perm) * amplitude;
            maxValue += amplitude;

            amplitude *= persistance;
            frequency *= lacunarity;
        }

        return total / maxValue;
    }

    function generateRandomPermutationList(size:Int = 256) {
        var list = [];

        for (i in 0...size) {
            var v = Math.round(Math.random() * 256);

            list.push(v);
        }

        return list;
    }
}