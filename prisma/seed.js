const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database with expanded curriculum...');
  
  const phases = [
    { phase: 1, title: 'Foundations (Linux, Networking, Scripting)', days: 20 },
    { phase: 2, title: 'Reconnaissance & Enumeration', days: 20 },
    { phase: 3, title: 'Exploitation & Initial Access', days: 20 },
    { phase: 4, title: 'Web Application Hacking', days: 20 },
    { phase: 5, title: 'Advanced Techniques & Privilege Escalation', days: 20 },
    { phase: 6, title: 'Active Directory & Red Teaming', days: 20 }
  ];

  const detailedDays = {
    1: {
      title: "Introduction to Ethical Hacking & Linux Basics",
      concept: "# Welcome to Phase 1\n\nToday, we learn the fundamentals of navigating a Linux terminal, which is the backbone of almost all cybersecurity operations. You will learn commands like `ls`, `cd`, `cat`, and `whoami`.",
      question: "Which command is used to print the contents of a file to the terminal?",
      options: ['ls', 'cat', 'pwd', 'whoami'],
      answer: 1,
      labUrl: "internal", labPlatform: "HackPath Sim"
    },
    2: {
      title: "Networking 101: IP Addresses, MAC, and the OSI Model",
      concept: "# Networking Fundamentals\n\nUnderstanding how computers talk to each other is vital. Today we cover IPv4/IPv6, MAC addresses, and the 7 layers of the OSI model. Knowing the difference between TCP (reliable) and UDP (fast) is key for port scanning.",
      question: "Which OSI layer is responsible for logical addressing (IP addresses)?",
      options: ['Layer 1: Physical', 'Layer 2: Data Link', 'Layer 3: Network', 'Layer 4: Transport'],
      answer: 2,
      labUrl: "internal", labPlatform: "HackPath Sim"
    },
    3: {
      title: "Introduction to Port Scanning with Nmap",
      concept: "# Mapping the Network\n\nBefore attacking, you must know what is running. `nmap` is the industry standard tool for discovering open ports and running services. \n\n* `nmap -sV <IP>` probes open ports to determine service/version info.\n* `nmap -p- <IP>` scans all 65535 ports.",
      question: "What flag in Nmap is used to determine the version of the services running on open ports?",
      options: ['-O', '-sS', '-p-', '-sV'],
      answer: 3,
      labUrl: "internal", labPlatform: "HackPath Sim"
    },
    4: {
      title: "Web Directory Enumeration (Gobuster / Ffuf)",
      concept: "# Finding Hidden Paths\n\nWeb servers often host unlinked pages, backup files, or hidden admin panels. Tools like `gobuster` or `ffuf` use wordlists to rapidly brute-force URL paths. \n\nExample: `gobuster dir -u http://target.com -w common.txt`",
      question: "Why do we use wordlists in directory enumeration?",
      options: ['To crack passwords', 'To guess potential hidden URL paths rapidly', 'To exploit SQL injection', 'To bypass firewalls'],
      answer: 1,
      labUrl: "internal", labPlatform: "HackPath Sim"
    },
    5: {
      title: "Introduction to Web Protocols (HTTP/HTTPS)",
      concept: "# How the Web Works\n\nHTTP relies on requests (GET, POST) and responses (200 OK, 404 Not Found, 500 Server Error). Understanding headers and cookies is essential for session hijacking and web exploitation.",
      question: "Which HTTP status code indicates that the requested resource was NOT found?",
      options: ['200', '302', '403', '404'],
      answer: 3,
      labUrl: "internal", labPlatform: "HackPath Sim"
    },
    6: {
      title: "Basic Web Vulnerabilities: SQL Injection (SQLi)",
      concept: "# SQL Injection\n\nSQLi occurs when user input is unsafely embedded into a database query. It allows attackers to read, modify, or delete database contents. \n\nA classic authentication bypass payload is: `' OR 1=1 --`",
      question: "What is the primary cause of SQL Injection vulnerabilities?",
      options: ['Weak passwords', 'Lack of HTTPS', 'Improper sanitization of user input', 'Outdated server hardware'],
      answer: 2,
      labUrl: "internal", labPlatform: "HackPath Sim"
    },
    7: {
      title: "Cross-Site Scripting (XSS)",
      concept: "# XSS Fundamentals\n\nXSS allows an attacker to execute malicious JavaScript in a victim's browser. It comes in three main types: Reflected (in URL), Stored (saved in DB), and DOM-based. \n\nPayload example: `<script>alert(1)</script>`",
      question: "Which type of XSS is permanently saved on the target server (e.g., in a comment section)?",
      options: ['Reflected XSS', 'Stored XSS', 'DOM XSS', 'Blind XSS'],
      answer: 1,
      labUrl: "internal", labPlatform: "HackPath Sim"
    },
    8: {
      title: "Password Cracking & Hash Identification",
      concept: "# Breaking Hashes\n\nPasswords are usually stored as hashes (MD5, SHA256, bcrypt). You cannot 'decrypt' a hash; you must crack it by hashing a wordlist and comparing the results. Tools like `hashcat` and `john` are used for this.",
      question: "Which of the following is considered a strong, slow hashing algorithm suitable for passwords?",
      options: ['MD5', 'SHA1', 'bcrypt', 'Base64'],
      answer: 2,
      labUrl: "internal", labPlatform: "HackPath Sim"
    },
    9: {
      title: "Online Brute-Forcing (Hydra)",
      concept: "# Attacking Logins\n\nWhen you find an exposed login portal (SSH, FTP, Web), you can attempt to guess the password using `hydra`. \n\nExample: `hydra -l admin -P rockyou.txt ssh://10.10.10.5`",
      question: "What is the purpose of the 'rockyou.txt' file often used with Hydra?",
      options: ['It is a configuration file', 'It is a popular wordlist containing millions of leaked passwords', 'It is an exploit payload', 'It is a target list'],
      answer: 1,
      labUrl: "internal", labPlatform: "HackPath Sim"
    },
    10: {
      title: "Phase 1 Capstone Challenge",
      concept: "# Put it all together\n\nToday you will scan a machine, find a hidden directory, discover a login panel, brute-force the password, and retrieve the flag.",
      question: "In a typical engagement, what is the correct order of operations?",
      options: ['Exploit -> Recon -> Privilege Escalation', 'Recon -> Enumeration -> Exploit', 'Privilege Escalation -> Recon -> Exploit', 'Brute-force -> Scan -> Exploit'],
      answer: 1,
      labUrl: "internal", labPlatform: "HackPath Sim"
    }
  };

  let currentDayId = 1;

  for (const p of phases) {
    for (let i = 1; i <= p.days; i++) {
      const dayId = currentDayId++;
      
      const dayData = detailedDays[dayId] || {
        title: `Day ${dayId}: ${p.title} - Module ${i}`,
        concept: `# Concept: ${p.title} Module ${i}\n\nAdvanced topics covered in this module. Content unlocks upon reaching this day.`,
        question: `Generic knowledge check for Day ${dayId}.`,
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        answer: 0,
        labUrl: "internal",
        labPlatform: "HackPath Sim"
      };
      
      await prisma.day.upsert({
        where: { id: dayId },
        update: {
          title: dayData.title,
          concept: dayData.concept,
          labUrl: dayData.labUrl,
          labPlatform: dayData.labPlatform,
          xpReward: 50 + (p.phase * 10),
        },
        create: {
          id: dayId,
          phase: p.phase,
          title: dayData.title,
          concept: dayData.concept,
          labUrl: dayData.labUrl,
          labPlatform: dayData.labPlatform,
          xpReward: 50 + (p.phase * 10),
        }
      });

      await prisma.quiz.upsert({
        where: { id: dayId }, 
        update: {
          question: dayData.question,
          options: JSON.stringify(dayData.options),
          answer: dayData.answer,
        },
        create: {
          id: dayId,
          dayId: dayId,
          question: dayData.question,
          options: JSON.stringify(dayData.options),
          answer: dayData.answer,
        }
      });
    }
  }
  
  // Comprehensive Resources
  const resources = [
    { id: 1, title: 'Nmap Cheat Sheet', url: 'https://highon.coffee/blog/nmap-cheat-sheet/', type: 'cheatsheet', difficulty: 'beginner', isFree: true },
    { id: 2, title: 'Web Application Hacker\'s Handbook', url: 'https://portswigger.net/web-security', type: 'book', difficulty: 'intermediate', isFree: false },
    { id: 3, title: 'OWASP Top 10', url: 'https://owasp.org/www-project-top-ten/', type: 'guide', difficulty: 'beginner', isFree: true },
    { id: 4, title: 'PortSwigger Web Security Academy', url: 'https://portswigger.net/web-security', type: 'platform', difficulty: 'beginner', isFree: true },
    { id: 5, title: 'TryHackMe', url: 'https://tryhackme.com', type: 'platform', difficulty: 'beginner', isFree: true },
    { id: 6, title: 'HackTheBox', url: 'https://hackthebox.com', type: 'platform', difficulty: 'intermediate', isFree: false },
    { id: 7, title: 'OverTheWire', url: 'https://overthewire.org', type: 'platform', difficulty: 'beginner', isFree: true },
    { id: 8, title: 'Exploit Database', url: 'https://www.exploit-db.com', type: 'tool', difficulty: 'intermediate', isFree: true },
    { id: 9, title: 'GTFOBins', url: 'https://gtfobins.github.io/', type: 'cheatsheet', difficulty: 'intermediate', isFree: true },
    { id: 10, title: 'PayloadAllTheThings', url: 'https://github.com/swisskyrepo/PayloadsAllTheThings', type: 'cheatsheet', difficulty: 'intermediate', isFree: true },
    { id: 11, title: 'PentesterLab', url: 'https://pentesterlab.com', type: 'platform', difficulty: 'advanced', isFree: false },
    { id: 12, title: 'Metasploit Unleashed', url: 'https://www.offensive-security.com/metasploit-unleashed/', type: 'guide', difficulty: 'intermediate', isFree: true },
    { id: 13, title: 'Wireshark Documentation', url: 'https://www.wireshark.org/docs/', type: 'guide', difficulty: 'beginner', isFree: true },
    { id: 14, title: 'The Cyber Mentor', url: 'https://www.youtube.com/c/TheCyberMentor', type: 'video', difficulty: 'beginner', isFree: true },
    { id: 15, title: 'IppSec', url: 'https://www.youtube.com/c/ippsec', type: 'video', difficulty: 'intermediate', isFree: true },
    { id: 16, title: 'OSINT Framework', url: 'https://osintframework.com/', type: 'tool', difficulty: 'beginner', isFree: true },
    { id: 17, title: 'Shodan', url: 'https://www.shodan.io/', type: 'tool', difficulty: 'intermediate', isFree: false },
    { id: 18, title: 'VulnHub', url: 'https://www.vulnhub.com/', type: 'platform', difficulty: 'intermediate', isFree: true },
    { id: 19, title: 'SecLists', url: 'https://github.com/danielmiessler/SecLists', type: 'tool', difficulty: 'beginner', isFree: true },
    { id: 20, title: 'HackTricks', url: 'https://book.hacktricks.xyz/', type: 'guide', difficulty: 'intermediate', isFree: true },
    { id: 21, title: 'RevShells', url: 'https://www.revshells.com/', type: 'tool', difficulty: 'beginner', isFree: true },
    { id: 22, title: 'CyberChef', url: 'https://gchq.github.io/CyberChef/', type: 'tool', difficulty: 'beginner', isFree: true },
    { id: 23, title: 'Burp Suite Community', url: 'https://portswigger.net/burp/communitydownload', type: 'tool', difficulty: 'intermediate', isFree: true },
    { id: 24, title: 'Bugcrowd University', url: 'https://www.bugcrowd.com/hackers/bugcrowd-university/', type: 'guide', difficulty: 'intermediate', isFree: true },
    { id: 25, title: 'Hacker101', url: 'https://www.hacker101.com/', type: 'guide', difficulty: 'beginner', isFree: true }
  ];

  for (const r of resources) {
    await prisma.resource.upsert({
      where: { id: r.id },
      update: {},
      create: r
    });
  }

  // Massive Skill Tree Expansion
  const skillNodes = [
    // Phase 1: Foundations
    { id: 'linux_basics', name: 'Linux Basics', category: 'Fundamentals', description: 'Navigating the Linux terminal and managing files.', xpValue: 100, estimatedHours: 5, dayIds: '[1,2]' },
    { id: 'networking', name: 'Networking Concepts', category: 'Fundamentals', description: 'OSI Model, TCP/UDP, IP and MAC addressing.', xpValue: 150, estimatedHours: 8, dayIds: '[3,4]' },
    { id: 'scripting', name: 'Bash & Python Scripting', category: 'Fundamentals', description: 'Writing basic automation scripts.', xpValue: 200, estimatedHours: 10, dayIds: '[15,16,17]' },
    
    // Phase 2: Recon
    { id: 'osint', name: 'OSINT', category: 'Reconnaissance', description: 'Open Source Intelligence gathering.', xpValue: 150, estimatedHours: 5, dayIds: '[21,22]' },
    { id: 'nmap', name: 'Nmap Scanning', category: 'Reconnaissance', description: 'Network enumeration and port scanning.', xpValue: 150, estimatedHours: 4, dayIds: '[23,24]' },
    { id: 'dir_enum', name: 'Web Directory Enum', category: 'Reconnaissance', description: 'Using Gobuster, ffuf, and dirb.', xpValue: 150, estimatedHours: 4, dayIds: '[25,26]' },
    
    // Phase 3: Exploitation
    { id: 'metasploit', name: 'Metasploit Framework', category: 'Exploitation', description: 'Using MSF to exploit known vulnerabilities.', xpValue: 300, estimatedHours: 8, dayIds: '[41,42,43]' },
    { id: 'password_cracking', name: 'Password Cracking', category: 'Exploitation', description: 'Cracking hashes with Hashcat & John.', xpValue: 200, estimatedHours: 6, dayIds: '[45,46]' },
    { id: 'shells', name: 'Reverse & Bind Shells', category: 'Exploitation', description: 'Catching shells and upgrading TTYs.', xpValue: 250, estimatedHours: 5, dayIds: '[48,49]' },
    
    // Phase 4: Web
    { id: 'burpsuite', name: 'Burp Suite Basics', category: 'Web App Hacking', description: 'Intercepting and modifying HTTP traffic.', xpValue: 200, estimatedHours: 6, dayIds: '[61,62]' },
    { id: 'sqli', name: 'SQL Injection', category: 'Web App Hacking', description: 'Exploiting databases via web inputs.', xpValue: 350, estimatedHours: 12, dayIds: '[64,65,66]' },
    { id: 'xss', name: 'Cross-Site Scripting', category: 'Web App Hacking', description: 'Reflected, Stored, and DOM XSS.', xpValue: 300, estimatedHours: 10, dayIds: '[67,68]' },
    { id: 'ssrf', name: 'SSRF', category: 'Web App Hacking', description: 'Server-Side Request Forgery attacks.', xpValue: 350, estimatedHours: 8, dayIds: '[71,72]' },
    
    // Phase 5: Advanced & PrivEsc
    { id: 'linux_privesc', name: 'Linux PrivEsc', category: 'Privilege Escalation', description: 'SUID, Cron jobs, Kernel exploits.', xpValue: 400, estimatedHours: 15, dayIds: '[81,82,83]' },
    { id: 'windows_privesc', name: 'Windows PrivEsc', category: 'Privilege Escalation', description: 'Services, Tokens, Registry exploits.', xpValue: 400, estimatedHours: 15, dayIds: '[85,86,87]' },
    { id: 'buffer_overflow', name: 'Buffer Overflows', category: 'Advanced', description: 'x86 architecture and basic memory corruption.', xpValue: 500, estimatedHours: 20, dayIds: '[91,92,93]' },
    
    // Phase 6: Active Directory & Pro
    { id: 'ad_enum', name: 'AD Enumeration', category: 'Red Teaming', description: 'Bloodhound, LDAP, PowerView.', xpValue: 300, estimatedHours: 10, dayIds: '[101,102]' },
    { id: 'kerberos_attacks', name: 'Kerberos Attacks', category: 'Red Teaming', description: 'Kerberoasting & AS-REP Roasting.', xpValue: 400, estimatedHours: 12, dayIds: '[105,106]' },
    { id: 'lateral_movement', name: 'Lateral Movement', category: 'Red Teaming', description: 'Pass the Hash, WMI, WinRM.', xpValue: 350, estimatedHours: 10, dayIds: '[108,109]' },
    { id: 'c2_infra', name: 'C2 Infrastructure', category: 'Red Teaming', description: 'Cobalt Strike, Mythic, Empire basics.', xpValue: 450, estimatedHours: 15, dayIds: '[115,116]' }
  ];

  for (const node of skillNodes) {
    await prisma.skillNode.upsert({
      where: { id: node.id },
      update: {},
      create: node
    });
  }

  // Create Skill Prerequisites
  const prerequisites = [
    { nodeId: 'nmap', prereqId: 'networking' },
    { nodeId: 'dir_enum', prereqId: 'networking' },
    { nodeId: 'scripting', prereqId: 'linux_basics' },
    { nodeId: 'shells', prereqId: 'linux_basics' },
    { nodeId: 'metasploit', prereqId: 'nmap' },
    { nodeId: 'password_cracking', prereqId: 'linux_basics' },
    { nodeId: 'burpsuite', prereqId: 'networking' },
    { nodeId: 'sqli', prereqId: 'burpsuite' },
    { nodeId: 'xss', prereqId: 'burpsuite' },
    { nodeId: 'ssrf', prereqId: 'burpsuite' },
    { nodeId: 'linux_privesc', prereqId: 'shells' },
    { nodeId: 'windows_privesc', prereqId: 'shells' },
    { nodeId: 'buffer_overflow', prereqId: 'scripting' },
    { nodeId: 'ad_enum', prereqId: 'windows_privesc' },
    { nodeId: 'kerberos_attacks', prereqId: 'ad_enum' },
    { nodeId: 'lateral_movement', prereqId: 'kerberos_attacks' },
    { nodeId: 'c2_infra', prereqId: 'lateral_movement' }
  ];

  for (const p of prerequisites) {
    await prisma.skillPrerequisite.upsert({
      where: {
        nodeId_prerequisiteId: { nodeId: p.nodeId, prerequisiteId: p.prereqId }
      },
      update: {},
      create: {
        nodeId: p.nodeId,
        prerequisiteId: p.prereqId
      }
    }).catch(() => {}); // ignore duplicates/errors if re-running
  }

  console.log('Database seeded successfully with expanded content.');
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
