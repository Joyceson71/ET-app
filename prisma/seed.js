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
    { id: 1, title: 'Nmap Cheat Sheet', url: 'https://nmap.org', type: 'cheatsheet', difficulty: 'beginner', isFree: true },
    { id: 2, title: 'Web Application Hacker\'s Handbook', url: 'https://example.com', type: 'book', difficulty: 'intermediate', isFree: false }
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
