const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log("Upgrading Days 1 to 3 with high-quality content...");

  const upgrades = {
    1: {
      concept: `
# Welcome to Phase 1: Foundations

Today, you will learn the fundamentals of navigating a Linux terminal. The terminal is the absolute backbone of almost all cybersecurity operations. Hackers use command-line interfaces because they are significantly faster, highly scriptable, and often the only interface available when you successfully exploit a remote server.

## Essential Commands

You must familiarize yourself with these core commands:

- \`whoami\`: Prints the effective user ID. Crucial for determining your privilege level.
- \`ls -la\`: Lists all files in a directory, including hidden files (files starting with a dot) and their permissions.
- \`cat <filename>\`: Prints the entire contents of a file to the screen. 
- \`su <username>\`: Switch User. Allows you to switch your terminal session to another user account, provided you have their password.

> [!WARNING]
> Always check for hidden files when enumerating a directory! Developers often leave backup files, configuration files (like \`.env\`), or SSH keys in hidden directories.

## Your Mission

In today's lab, you have been dropped into a web server as the low-privilege \`www-data\` user. Your goal is to:
1. Identify any hidden files in the current directory.
2. Read the contents to discover credentials for another user on the system.
3. Switch to that user and retrieve the flag.
      `,
      quizzes: [
        {
          question: "Which command is used to list ALL files in a directory, including hidden files?",
          options: JSON.stringify(["ls", "ls -a", "cat", "whoami"]),
          answer: 1,
        },
        {
          question: "What does the 'whoami' command do?",
          options: JSON.stringify(["Shows the IP address of the machine", "Prints the current working directory", "Displays the current logged-in user", "Switches to the root user"]),
          answer: 2,
        },
        {
          question: "Why might a hacker specifically look for hidden files (files starting with a '.')?",
          options: JSON.stringify(["Because they execute faster", "They often contain sensitive config data like passwords or SSH keys", "They are the only files that contain flags", "Because Linux requires all files to be hidden"]),
          answer: 1,
        }
      ]
    },
    2: {
      concept: `
# Networking Fundamentals & Port Scanning

Before you can attack a machine, you must understand what is running on it. This phase of hacking is called **Enumeration**.

## IP Addresses & Ping

Computers communicate using IP Addresses (e.g., \`10.10.10.2\`). The simplest way to verify if a target is online is to use the \`ping\` command, which sends an ICMP Echo Request. If the target responds, it's alive. However, many modern firewalls block ICMP, so a failed ping doesn't guarantee the machine is dead.

## Port Scanning with Nmap

A server can run multiple services (like a web server, an email server, and an SSH server) simultaneously. It differentiates these using **Ports** (ranging from 1 to 65535). 

To discover which ports are open, we use \`nmap\` (Network Mapper), the industry standard for port scanning.

\`\`\`bash
# Basic scan (scans top 1000 ports)
nmap 10.10.10.2

# Scan assuming the host is online (bypasses ping block)
nmap -Pn 10.10.10.2
\`\`\`

> [!TIP]
> If a machine blocks ping (ICMP) requests, standard \`nmap\` will assume it's offline and abort. Use the \`-Pn\` flag to force nmap to scan the ports anyway!

## Your Mission

In today's lab, you will:
1. Attempt to ping the target machine.
2. Run an Nmap scan. If it fails due to blocked ping probes, use the correct flag to bypass it.
3. Discover the open port and use \`curl\` to retrieve the flag from the hidden web service.
      `,
      quizzes: [
        {
          question: "What protocol does the 'ping' command use to check if a host is alive?",
          options: JSON.stringify(["TCP", "UDP", "ICMP", "HTTP"]),
          answer: 2,
        },
        {
          question: "Which Nmap flag is used to skip the host discovery phase (useful if ping is blocked)?",
          options: JSON.stringify(["-sV", "-p-", "-O", "-Pn"]),
          answer: 3,
        },
        {
          question: "What is the maximum number of ports a machine can have?",
          options: JSON.stringify(["1000", "8080", "65535", "99999"]),
          answer: 2,
        }
      ]
    },
    3: {
      concept: `
# Web Directory Enumeration

When you find a web server running (usually on port 80 for HTTP or 443 for HTTPS), the first thing you see is the homepage. But web servers often host dozens or hundreds of unlinked pages, backup files, or hidden admin panels that the developer didn't want you to find.

## Brute-Forcing Directories

Since these hidden directories aren't linked anywhere, the only way to find them is to guess them. We do this using tools like **Gobuster**, **Ffuf**, or **Dirb**, which take a massive list of common directory names (a "wordlist") and rapidly request them from the server.

If the server responds with a \`200 OK\` status code, the directory exists! If it responds with \`404 Not Found\`, it doesn't.

\`\`\`bash
# Example Gobuster command
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt
\`\`\`

> [!IMPORTANT]
> The effectiveness of your enumeration is entirely dependent on the quality of your wordlist. The \`rockyou.txt\` wordlist is great for passwords, but terrible for directories. Use wordlists from repositories like \`SecLists\` for best results.

## Your Mission

In today's lab, you will:
1. Scan the target web server for hidden directories using Gobuster.
2. Identify a secret backup directory.
3. Use \`curl\` to inspect the files inside the backup directory and find the flag.
      `,
      quizzes: [
        {
          question: "What is the primary purpose of tools like Gobuster or Ffuf?",
          options: JSON.stringify(["To crack passwords", "To brute-force hidden URL paths and directories", "To exploit SQL injection", "To intercept web traffic"]),
          answer: 1,
        },
        {
          question: "Which HTTP status code indicates that a directory was successfully found?",
          options: JSON.stringify(["404 Not Found", "500 Internal Server Error", "200 OK", "403 Forbidden"]),
          answer: 2,
        },
        {
          question: "Why is the choice of wordlist important for directory enumeration?",
          options: JSON.stringify(["It determines the speed of the scan", "Different wordlists are needed for different operating systems", "A tool can only find a hidden directory if its name is in the wordlist", "Wordlists contain the exploit payloads"]),
          answer: 2,
        }
      ]
    }
  };

  for (const [dayStr, data] of Object.entries(upgrades)) {
    const dayId = parseInt(dayStr);
    
    // Update Day Concept
    await prisma.day.update({
      where: { id: dayId },
      data: { concept: data.concept }
    });

    // Delete existing quizzes for this day
    await prisma.quiz.deleteMany({
      where: { dayId }
    });

    // Insert new multi-question quizzes
    for (const q of data.quizzes) {
      await prisma.quiz.create({
        data: {
          dayId,
          question: q.question,
          options: q.options,
          answer: q.answer
        }
      });
    }
    
    console.log("Successfully upgraded Day " + dayId);
  }

  console.log("Upgrade complete.");
}

main().catch(e => {
  console.error(e);
  process.exit(1);
}).finally(async () => {
  await prisma.$disconnect();
});
