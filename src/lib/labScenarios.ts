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
  1: {
    id: 1,
    welcomeMessage: [
      "Welcome to HackPath Simulated Lab.",
      "Target IP: 10.10.10.1",
      "Goal: Find the open ports and discover the hidden flag.",
      "Type 'help' for available commands."
    ],
    expectedCommands: [
      {
        command: "help",
        output: [
          "Available commands:",
          "  help     - Show this message",
          "  clear    - Clear terminal",
          "  whoami   - Print current user",
          "  ping     - Send ICMP ECHO_REQUEST to network hosts",
          "  nmap     - Network exploration tool and security / port scanner",
          "  cat      - Concatenate files and print on the standard output"
        ]
      },
      {
        command: "whoami",
        output: ["root"]
      },
      {
        command: "ping 10.10.10.1",
        output: [
          "PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.",
          "64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=0.043 ms",
          "64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=0.046 ms",
          "--- 10.10.10.1 ping statistics ---",
          "2 packets transmitted, 2 received, 0% packet loss, time 1001ms"
        ]
      },
      {
        command: "nmap 10.10.10.1",
        output: [
          "Starting Nmap 7.93 ( https://nmap.org )",
          "Nmap scan report for 10.10.10.1",
          "Host is up (0.00013s latency).",
          "Not shown: 998 closed tcp ports (reset)",
          "PORT   STATE SERVICE",
          "22/tcp open  ssh",
          "80/tcp open  http",
          "",
          "Nmap done: 1 IP address (1 host up) scanned in 0.14 seconds."
        ]
      },
      {
        command: "cat flag.txt",
        output: ["cat: flag.txt: No such file or directory"]
      },
      {
        command: "cat /var/www/html/index.html",
        output: [
          "<!DOCTYPE html>",
          "<html>",
          "<body>",
          "<!-- TODO: Remove debug flag before production -->",
          "<!-- FLAG{h4ckp4th_nmap_m4st3r} -->",
          "<h1>Welcome to Target</h1>",
          "</body>",
          "</html>"
        ]
      },
      {
        command: "curl http://10.10.10.1",
        output: [
          "<!DOCTYPE html>",
          "<html>",
          "<body>",
          "<!-- TODO: Remove debug flag before production -->",
          "<!-- FLAG{h4ckp4th_nmap_m4st3r} -->",
          "<h1>Welcome to Target</h1>",
          "</body>",
          "</html>"
        ]
      }
    ],
    flag: "FLAG{h4ckp4th_nmap_m4st3r}"
  }
};
