const robot = require('robotjs');

// Parse command-line arguments
function parseArgs() {
    const args = process.argv.slice(2);
    const config = {
        interval: 60, // Default: 60 seconds
        moveSize: 10, // Default: 10 pixels
        quiet: false,
        help: false
    };

    for (let i = 0; i < args.length; i++) {
        switch (args[i]) {
            case '--interval':
                config.interval = parseFloat(args[++i]) || 60;
                break;
            case '--move-size':
                config.moveSize = parseInt(args[++i]) || 10;
                break;
            case '--quiet':
                config.quiet = true;
                break;
            case '--help':
                config.help = true;
                break;
        }
    }

    return config;
}

// Show help with ASCII art
function showHelp() {
    console.log(`
╦╔═╔═╗╔═╗╔═╗  ╔═╗╦ ╦╔═╗╦╔═╔═╗  ☕
╠╩╗║╣ ║╣ ╠═╝  ╠═╣║║║╠═╣╠╩╗║╣   
╩ ╩╚═╝╚═╝╩    ╩ ╩╚╩╝╩ ╩╩ ╩╚═╝  

Keep your PC awake while you're away!

Usage: keep-awake [options]

Options:
  --interval <seconds>    Set interval between movements (default: 60)
  --move-size <pixels>    Set maximum movement size (default: 10)
  --quiet                 Suppress console output
  --help                  Show this help message

Examples:
  keep-awake --interval 30 --move-size 5
  keep-awake --quiet
  node index.js --interval 120 --move-size 20
`);
}

const config = parseArgs();

// Show help and exit if requested
if (config.help) {
    showHelp();
    process.exit(0);
}

// Define the duration and movement size from config
const INTERVAL = config.interval * 1000; // Convert seconds to milliseconds
const MOVE_SIZE = config.moveSize;

let count = 0;

// Print table header unless quiet mode
if (!config.quiet) {
    console.log(`\n⏰ Keep-Awake is running ☕`);
    console.log(`   Interval: ${config.interval}s | Move Size: ${MOVE_SIZE}px\n`);
    console.log('┌───────┬─────────────┬─────────────────┬────────────┬─────────────────┐');
    console.log('│ Count │ Time        │ Current         │ Offset     │ New             │');
    console.log('├───────┼─────────────┼─────────────────┼────────────┼─────────────────┤');
}

// Function to move the mouse randomly
function moveMouseRandomly() {
    count++;
    const now = new Date().toLocaleTimeString();
    const startPosition = robot.getMousePos();

    // Generate random offsets within the MOVE_SIZE limit
    const offsetX = Math.floor(Math.random() * MOVE_SIZE * 2 - MOVE_SIZE);
    const offsetY = Math.floor(Math.random() * MOVE_SIZE * 2 - MOVE_SIZE);

    // Calculate new position
    const newX = startPosition.x + offsetX;
    const newY = startPosition.y + offsetY;

    // Print row unless quiet mode
    if (!config.quiet) {
        const current = `[${startPosition.x}, ${startPosition.y}]`.padEnd(15);
        const offset = `[${offsetX}, ${offsetY}]`.padEnd(10);
        const newPos = `[${newX}, ${newY}]`.padEnd(15);
        console.log(`│ ${String(count).padStart(5)} │ ${now.padEnd(11)} │ ${current} │ ${offset} │ ${newPos} │`);
    }
    
    // Move the mouse to the new position
    robot.moveMouse(newX, newY);
}

setInterval(moveMouseRandomly, INTERVAL);
