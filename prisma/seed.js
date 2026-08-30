const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database...');
  
  const phases = [
    { phase: 1, title: 'Foundations', days: 20 },
    { phase: 2, title: 'Reconnaissance', days: 20 },
    { phase: 3, title: 'Exploitation', days: 20 },
    { phase: 4, title: 'Web App Hacking', days: 20 },
    { phase: 5, title: 'Advanced Techniques', days: 20 },
    { phase: 6, title: 'Real-World Practice', days: 20 }
  ];

  let currentDayId = 1;

  for (const p of phases) {
    for (let i = 1; i <= p.days; i++) {
      const dayId = currentDayId++;
      
      const day = await prisma.day.upsert({
        where: { id: dayId },
        update: {},
        create: {
          id: dayId,
          phase: p.phase,
          title: `Day ${dayId}: ${p.title} - Module ${i}`,
          concept: `# Concept: ${p.title} Module ${i}\n\nThis is the content for Day ${dayId}. Complete this to proceed.`,
          labUrl: 'https://tryhackme.com',
          labPlatform: 'TryHackMe',
          xpReward: 50,
        }
      });

      // Create a quiz for this day
      await prisma.quiz.upsert({
        where: { id: dayId }, // assuming 1 quiz per day for simplicity
        update: {},
        create: {
          id: dayId,
          dayId: dayId,
          question: `What is the primary focus of Day ${dayId}?`,
          options: JSON.stringify([
            'Hacking NASA with HTML',
            p.title,
            'Writing GUI interfaces in Visual Basic',
            'None of the above'
          ]),
          answer: 1,
        }
      });
    }
  }
  
  // Seed some resources
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
    { id: 23, title: 'Burp Suite Community Edition', url: 'https://portswigger.net/burp/communitydownload', type: 'tool', difficulty: 'intermediate', isFree: true },
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

  // Seed skill nodes
  const skillNodes = [
    { id: 'linux_basics', name: 'Linux Basics', category: 'Fundamentals', description: 'Basic Linux commands', xpValue: 100, estimatedHours: 5, dayIds: '[1,2,3]' },
    { id: 'nmap', name: 'Nmap Scanning', category: 'Recon', description: 'Network enumeration', xpValue: 150, estimatedHours: 4, dayIds: '[21,22]' }
  ];

  for (const node of skillNodes) {
    await prisma.skillNode.upsert({
      where: { id: node.id },
      update: {},
      create: node
    });
  }

  console.log('Database seeded successfully.');
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
