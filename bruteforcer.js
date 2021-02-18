const childproc = require('child_process');
const path = require('path');
const fs = require('fs');

const romPath = 'C:\\dev\\projects\\smb\\practiserom\\main-mmc1.nes';
let fceuPath = '/mnt/c/games/emu/fceux_2.3/fceux.exe';
let fceuArgs = ["-lua", "bruteforcer.lua", romPath]
let instances = 1;
if (process.env.NESL) {
    fceuPath = '/mnt/c/dev/emu/nesl/out/build/x64-Release/nesl.exe';
    fceuArgs = ["bruteforcer.lua", romPath];
    instances = 4;
}

let args = [
    525,
    526,
    530,
    534,
    535,
    537,
    542,
    546,
    547,
    548,
    551,
    552,
    555,
    561,
    562,
    568,
    570,
    573,
    579,
    584,
    587,
    589,
    590,
    591,
    597,
    598,
    599,
    602,
    604,
    605,
    608,
    609,
    612,
    613,
    614,
    615,
    617,
];

if (!fs.existsSync(__dirname + '/out')) {
  fs.mkdirSync(__dirname + '/out');
}

async function runNext() {
    while (1) {
        if (args.length === 0) return;
        const arg = args.shift();
        const csvPath = path.join(__dirname, 'out', arg + '.csv');
        if (fs.existsSync(csvPath)) continue;
        console.log(`starting ${arg}`);

        const f = fs.createWriteStream(csvPath);
        const proc = childproc.spawn(fceuPath, fceuArgs, {
            cwd: __dirname,
            stdio: 'pipe'
        });

        proc.stdin.write(String(arg) + "\n");
        proc.stdout.pipe(f);
        proc.stderr.pipe(process.stderr);

        await new Promise(r => proc.on('exit', r));
        try { f.close(); } catch(ex) {}
    }
}

for (let i=0; i<instances; ++i) {
    runNext();
}

