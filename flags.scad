use <belarusFlagPattern.scad>

BelarusFlag();
translate([2.5, 0, 0]) GermanFlag();

module BelarusFlag() {
    pattern = belarusFlagPattern();

    colorRed = [1, 0, 0];
    colorGreen = [0, 153/255, 0];
    colorWhite = [1, 1, 1];

    barWidth = 1;
    patternWidth = 9;
    bigWidth = 80;

    redHeight = 30;
    greenHeight = 15;

    totalHeight = redHeight + greenHeight;
    thickness = 1;

    scale([1/totalHeight, 1/totalHeight, 1]) {
        translate([0, -totalHeight, 0])
            color(colorRed) cube([barWidth, totalHeight, thickness]);
        translate([barWidth+patternWidth, -redHeight, 0])
            color(colorRed) cube([bigWidth, redHeight, thickness]);
        translate([barWidth+patternWidth, -totalHeight, 0])
            color(colorGreen) cube([bigWidth, greenHeight, thickness]);

        translate([barWidth, 0, 0]) scale([patternWidth/23, totalHeight/61, thickness])
            for (x = [0 : 1 : len(pattern[0])-1]) {
                column = [ for (y = [0 : 1 : len(pattern)-1]) pattern[y][x] ];
                rectangles = rle(column);
                for (index = [0 : 1 : len(rectangles)-1]) {
                    previousHeights = [for (i = [0 : 1 : index-1]) rectangles[i][1]];
                    y = sum(previousHeights);
                    symbol = rectangles[index][0];
                    height = rectangles[index][1];
                    color(symbol != " " ? colorRed : colorWhite)
                        translate([x, -y-height, 0])
                            cube([1, height, 1]);
                }
            }
    }
}

function head(input) = input[0];

function tail(input) = [ for (i = [1 : 1 : len(input)-1]) input[i] ];

function sum(input, result) =
    let (lresult = result == undef ? 0 : result)
    input == [] ? lresult : sum(tail(input), lresult+head(input));

function rle(input, lastSymbol, lastCount, result) =
    input == [] ? (
        result == undef ?
            [] :
            concat(result, [[lastSymbol, lastCount]])
    ) : (
        let (currentSymbol = head(input))
        let (isSame = currentSymbol == lastSymbol)
        isSame ?
            rle(tail(input), currentSymbol, lastCount + 1, result) :
            rle(tail(input), currentSymbol, 1, lastSymbol == undef ? [] : concat(result, [[lastSymbol, lastCount]]))
    );

module GermanFlag() {
    colorBlack = [0, 0, 0];
    colorRed = [1, 0, 0];
    colorGold = [1, 204/255, 0];

    scale([1/3, 1/3, 1]) {
        translate([0, -1, 0])
            color(colorBlack) cube([5, 1, 1]);
        translate([0, -2, 0])
            color(colorRed) cube([5, 1, 1]);
        translate([0, -3, 0])
            color(colorGold) cube([5, 1, 1]);
    }
}
