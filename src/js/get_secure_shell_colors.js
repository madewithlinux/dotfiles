// http://haacked.com/archive/2009/12/29/convert-rgb-to-hex.aspx/
function colorToHex(color) {
    if (color.substr(0, 1) === '#') {
        return color;
    }
    var digits = /(.*?)rgba\((\d+), (\d+), (\d+), (\d+)\)/.exec(color);
    
    var red = parseInt(digits[2]);
    var green = parseInt(digits[3]);
    var blue = parseInt(digits[4]);
    
    var rgb = blue | (green << 8) | (red << 16);
    return digits[1] + '#' + rgb.toString(16);
};


function get_colors() {
    var out = "";
    /* global term_ */
    var palette = term_.prefs_.get("color-palette-overrides");
    for (var index in palette) {
        out += "*.color"+ index + ":\t" + palette[index] + "\n";
    }
    var bg_color = term_.prefs_.get("background-color");
    var fg_color = term_.prefs_.get("foreground-color");
    
    console.log(bg_color);
    console.log(fg_color);
    
    out += "*.foreground:\t" + colorToHex(fg_color) + "\n";
    out += "*.background:\t" + colorToHex(bg_color) + "\n";
    out += "*.cursorColor:\t" + colorToHex(fg_color) + "\n";
    
    console.log(out);
}

