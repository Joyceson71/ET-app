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

  const detailedDays = require('./curriculumData');
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
