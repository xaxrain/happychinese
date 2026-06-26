const fs = require('fs');
const path = require('path');

// Get the user input from the terminal (e.g., node generate.js HC-1 or node generate.js HC-1-Review)
const inputName = process.argv[2]; 

if (!inputName) {
    console.error("❌ Please provide a replacement name. Example: node generate.js HC-1-Review");
    process.exit(1);
}

const sourceFolder = './'; // Path where your current templates live
const outputFolder = `./`;


// Read all files in the current folder
const files = fs.readdirSync(sourceFolder);

// Regex pattern to catch "Template", "template", and any typos like "Tempalate"
const templateRegex = /temp[a|o]?late/gi;

files.forEach(file => {
    // Process only HTML files that contain our target template keywords
    if (templateRegex.test(file) && file.endsWith('.html')) {
        const oldPath = path.join(sourceFolder, file);
        
        // 1. Generate the clean new file name using your exact input
        let newFileName = file.replace(templateRegex, inputName);
        newFileName = newFileName.replace(/\s+/g, '_'); // Converts spaces to underscores for safe file paths

        const newPath = path.join(outputFolder, newFileName);

        // 2. Read the original template's content
        let content = fs.readFileSync(oldPath, 'utf8');

        // 3. Update the internal HTML content
        // Replace the page title <title>...</title> safely
        content = content.replace(/<title>.*?<\/title>/i, `<title>${inputName}</title>`);
        
        // Replace any remaining instance of the word "Template" (or typos) inside the page
        content = content.replace(templateRegex, inputName);

        // 4. Save the freshly generated copy
        fs.writeFileSync(newPath, content);
        console.log(`🚀 Copied & Updated: ${newFileName}`);
    }
});

console.log(`\n✅ Done! Check your new files inside the folder: ${outputFolder}`);