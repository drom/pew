#!/usr/bin/env node
'use strict';

var fs = require('fs'),
    path = require('path'),
    Readable = require('stream').Readable,
    PNG = require('pngjs').PNG;

function pixelh (arr, idx) {
    return [1,0,2]
        .map(function (offset) {
            return ('00' + arr[idx + offset].toString(16)).slice(-2);
        })
        .join('');
}

fs.createReadStream(
    path.resolve(__dirname, 'Pulse.png'))
    .pipe(new PNG({
        filterType: 4
    }))
    .on('parsed', function () {
        var x, y, idx, line, output = [];
        for (y = 0; y < this.height; y++) {
            line = [];
            for (x = 0; x < this.width; x++) {
                idx = (this.width * y + x) << 2;
                line.push(pixelh(this.data, idx));
            }
            output.push(line.join(' '));
        }
        var ostream = new Readable;
        ostream.pipe(fs.createWriteStream('pew.txt'));
        ostream.push(output.join('\n'));
        ostream.push(null);
    });
