-- HackPath — Complete Seed Data
-- Run AFTER schema.sql and rls.sql
-- Includes: 120 days, 360 quiz questions, 80+ resources, 50+ skill nodes/edges, 12 badges

-- ============================================================
-- BADGES
-- ============================================================
insert into public.badges (id, name, description, icon, xp_reward) values
  ('b-firstblood',  'First Blood',      'Complete Day 1 of the curriculum',               '🩸', 0),
  ('b-weekwarrior', 'Week Warrior',      'Maintain a 7-day learning streak',               '🔥', 100),
  ('b-phase1',      'Phase 1 Cleared',   'Complete all 20 days of Foundations',            '🌐', 200),
  ('b-phase2',      'Phase 2 Cleared',   'Complete all 20 days of Reconnaissance',        '🔍', 200),
  ('b-phase3',      'Phase 3 Cleared',   'Complete all 20 days of Exploitation Basics',   '💥', 200),
  ('b-phase4',      'Phase 4 Cleared',   'Complete all 20 days of Web App Hacking',       '🕸️', 200),
  ('b-phase5',      'Phase 5 Cleared',   'Complete all 20 days of Advanced Techniques',   '⚡', 200),
  ('b-phase6',      'Phase 6 Cleared',   'Complete all 20 days of Real-World Practice',   '🏆', 200),
  ('b-quizmaster',  'Quiz Master',       'Pass 10 quizzes on the first attempt',           '🎯', 0),
  ('b-notetaker',   'Note Taker',        'Write notes on 50 different days',               '📝', 0),
  ('b-fullsend',    'Full Send',         'Complete all 120 days of the curriculum',        '🚀', 500),
  ('b-labrat',      'Lab Rat',           'Complete 20 hands-on labs',                      '🧪', 0)
on conflict (name) do nothing;

-- ============================================================
-- RESOURCES (80+ entries)
-- ============================================================
insert into public.resources (id, title, url, type, difficulty, description, is_free, source) values
-- PLATFORMS
  ('r-thm',      'TryHackMe',                        'https://tryhackme.com',                      'platform', 'beginner',     'Browser-based hacking labs and learning paths. Best starting point for beginners.',                       true,  'TryHackMe'),
  ('r-htb',      'HackTheBox',                       'https://hackthebox.com',                     'platform', 'intermediate', 'CTF-style machine hacking platform. Excellent for intermediate to advanced learners.',                   true,  'HackTheBox'),
  ('r-pico',     'PicoCTF',                          'https://picoctf.org',                        'platform', 'beginner',     'CMU-run beginner CTF platform. Great for learning fundamentals through puzzles.',                        true,  'Carnegie Mellon'),
  ('r-portswg',  'PortSwigger Web Security Academy', 'https://portswigger.net/web-security',       'platform', 'intermediate', 'Free, comprehensive web application security training by Burp Suite creators.',                         true,  'PortSwigger'),
  ('r-vulnhub',  'VulnHub',                          'https://vulnhub.com',                        'platform', 'intermediate', 'Download and run vulnerable VMs locally for offline practice.',                                         true,  'VulnHub'),
  ('r-otw',      'OverTheWire',                      'https://overthewire.org/wargames',           'platform', 'beginner',     'Linux wargames (Bandit series) teaching command-line and security fundamentals through challenges.',     true,  'OverTheWire'),
  ('r-ctftime',  'CTFtime',                          'https://ctftime.org',                        'platform', 'intermediate', 'Aggregator of upcoming CTF competitions worldwide with team rankings.',                                  true,  'CTFtime'),
  ('r-root-me',  'Root-Me',                          'https://root-me.org',                        'platform', 'beginner',     'Over 400 hacking challenges across many categories, all browser-based.',                                true,  'Root-Me'),

-- TOOLS
  ('r-nmap',     'Nmap',                             'https://nmap.org',                           'tool',     'beginner',     'The essential network scanner for host discovery, port scanning, and service detection.',               true,  'Gordon Lyon'),
  ('r-msf',      'Metasploit Framework',             'https://metasploit.com',                     'tool',     'intermediate', 'World''s most widely used penetration testing framework with thousands of modules.',                    true,  'Rapid7'),
  ('r-burp',     'Burp Suite Community',             'https://portswigger.net/burp',               'tool',     'intermediate', 'Industry-standard web application security testing proxy and scanner.',                                  true,  'PortSwigger'),
  ('r-wire',     'Wireshark',                        'https://wireshark.org',                      'tool',     'beginner',     'The world''s most popular network protocol analyzer for packet capture and analysis.',                  true,  'Wireshark Foundation'),
  ('r-gobus',    'Gobuster',                         'https://github.com/OJ/gobuster',             'tool',     'intermediate', 'Fast directory/file/DNS busting tool written in Go.',                                                   true,  'OJ Reeves'),
  ('r-nikto',    'Nikto',                            'https://github.com/sullo/nikto',             'tool',     'beginner',     'Web server vulnerability scanner checking for 6700+ potentially dangerous files.',                      true,  'CIRT'),
  ('r-john',     'John the Ripper',                  'https://www.openwall.com/john',              'tool',     'intermediate', 'Fast password cracker supporting hundreds of hash types.',                                              true,  'Openwall'),
  ('r-hashcat',  'Hashcat',                          'https://hashcat.net',                        'tool',     'intermediate', 'World''s fastest password recovery utility supporting GPU acceleration.',                               true,  'Jens Steube'),
  ('r-sqlmap',   'SQLMap',                           'https://sqlmap.org',                         'tool',     'intermediate', 'Automatic SQL injection detection and exploitation tool.',                                              true,  'Bernardo & Miroslav'),
  ('r-hydra',    'Hydra',                            'https://github.com/vanhauser-thc/thc-hydra', 'tool',     'intermediate', 'Fast and flexible online password brute-forcing tool supporting 50+ protocols.',                        true,  'van Hauser/THC'),
  ('r-netcat',   'Netcat',                           'https://nc110.sourceforge.io',               'tool',     'beginner',     'The TCP/IP Swiss Army knife for reading and writing network connections.',                              true,  'Hobbit'),
  ('r-enum4',    'enum4linux',                       'https://github.com/CiscoCXSecurity/enum4linux','tool',   'intermediate', 'Linux tool for enumerating Windows and Samba systems over SMB.',                                        true,  'Cisco CX Security'),
  ('r-blood',    'BloodHound',                       'https://github.com/BloodHoundAD/BloodHound', 'tool',     'advanced',     'Active Directory attack path analysis tool using graph theory.',                                        true,  'BloodHound AD'),
  ('r-linpeas',  'LinPEAS / WinPEAS',                'https://github.com/carlospolop/PEASS-ng',   'tool',     'intermediate', 'Privilege escalation auditing scripts for Linux and Windows.',                                          true,  'Carlos Polop'),
  ('r-responder','Responder',                        'https://github.com/lgandx/Responder',        'tool',     'advanced',     'LLMNR/NBT-NS poisoner for capturing NTLMv2 hashes on the local network.',                               true,  'Laurent Gaffié'),
  ('r-ffuf',     'FFUF',                             'https://github.com/ffuf/ffuf',               'tool',     'intermediate', 'Fast web fuzzer written in Go for directory discovery and parameter fuzzing.',                           true,  'Joona Hoijakka'),
  ('r-dirbuster','DirBuster',                        'https://github.com/KajanM/DirBuster',        'tool',     'beginner',     'OWASP directory and file brute-forcer for web servers.',                                               true,  'OWASP'),
  ('r-bettercap','Bettercap',                        'https://bettercap.org',                      'tool',     'advanced',     'Swiss Army knife for network attacks and monitoring, successor to ettercap.',                            true,  'Simone Margaritelli'),

-- BOOKS
  ('r-wahh',     'The Web Application Hacker''s Handbook','https://www.amazon.com/Web-Application-Hackers-Handbook-Exploiting/dp/1118026470','book','intermediate','Definitive guide to web application security testing — covers every class of web vulnerability.',false,'Stuttard & Pinto'),
  ('r-ptgw',     'Penetration Testing',              'https://nostarch.com/pentesting',            'book',     'beginner',     'Georgia Weidman''s hands-on pentest book — the best beginner-to-intermediate practical guide.',          false, 'Georgia Weidman'),
  ('r-haoe',     'Hacking: The Art of Exploitation', 'https://nostarch.com/hacking2.htm',          'book',     'advanced',     'Jon Erickson''s low-level book covering C, assembly, shellcode, and buffer overflows from scratch.',    false, 'Jon Erickson'),
  ('r-hp3',      'The Hacker Playbook 3',            'https://www.amazon.com/Hacker-Playbook-Practical-Penetration-Testing/dp/1980901759','book','intermediate','Red team tactics, tools, and techniques with real-world attack scenarios.',false,'Peter Kim'),
  ('r-rtfm',     'RTFM: Red Team Field Manual',      'https://www.amazon.com/Rtfm-Red-Team-Field-Manual/dp/1494295504','book','intermediate','Compact command reference for red teamers covering Linux, Windows, networking, and web.',false,'Ben Clark'),
  ('r-owasp-tg', 'OWASP Testing Guide v4.2',         'https://owasp.org/www-project-web-security-testing-guide','book','intermediate','Comprehensive methodology for web application security testing.',true,'OWASP'),

-- VIDEO CHANNELS
  ('r-tcm',      'TCM Security (YouTube)',           'https://youtube.com/@TCMSecurityAcademy',    'video',    'beginner',     'Practical Ethical Hacking free course + Active Directory attacks. One of the best free resources.',      true,  'Heath Adams / TCM'),
  ('r-nc',       'NetworkChuck (YouTube)',            'https://youtube.com/@NetworkChuck',          'video',    'beginner',     'Engaging networking and hacking content — great for beginners learning Linux and networking.',           true,  'NetworkChuck'),
  ('r-jh',       'John Hammond (YouTube)',            'https://youtube.com/@_JohnHammond',          'video',    'intermediate', 'CTF walkthroughs, malware analysis, and real-world hacking demonstrations.',                             true,  'John Hammond'),
  ('r-db',       'David Bombal (YouTube)',            'https://youtube.com/@davidbombal',           'video',    'beginner',     'Python hacking, Cisco networking, and cybersecurity career content.',                                    true,  'David Bombal'),
  ('r-ips',      'IppSec (YouTube)',                  'https://youtube.com/@ippsec',                'video',    'advanced',     'In-depth HackTheBox machine walkthroughs — the gold standard for HTB learning.',                         true,  'IppSec'),
  ('r-pm',       'Professor Messer (YouTube)',        'https://youtube.com/@professormesser',       'video',    'beginner',     'Free CompTIA Security+ study materials and networking fundamentals.',                                    true,  'Professor Messer'),
  ('r-liveovfl', 'LiveOverflow (YouTube)',            'https://youtube.com/@LiveOverflow',          'video',    'advanced',     'Binary exploitation, CTF deep-dives, and security research — excellent for advanced topics.',             true,  'LiveOverflow'),
  ('r-hacker101','Hacker101 (YouTube)',               'https://youtube.com/@hacker0x01',            'video',    'intermediate', 'HackerOne''s free web security training focused on bug bounty methodology.',                             true,  'HackerOne'),

-- CHEATSHEETS
  ('r-gtfobins', 'GTFOBins',                         'https://gtfobins.github.io',                 'cheatsheet','intermediate','Unix binaries that can be used to bypass local security restrictions — essential for privesc.',          true,  'norbemi / GTFOBins'),
  ('r-hacktricks','HackTricks',                      'https://book.hacktricks.xyz',                'cheatsheet','intermediate','Massive pentesting wiki covering every technique, protocol, and attack vector.',                         true,  'Carlos Polop'),
  ('r-pat',      'PayloadsAllTheThings',             'https://github.com/swisskyrepo/PayloadsAllTheThings','cheatsheet','intermediate','List of useful payloads and bypasses for web attacks, SQLi, SSTI, XXE, and more.',          true,  'swisskyrepo'),
  ('r-lolbas',   'LOLBAS',                           'https://lolbas-project.github.io',           'cheatsheet','intermediate','Living Off The Land Binaries for Windows — bypass defenses using built-in OS tools.',                  true,  'LOLBAS Project'),
  ('r-revshells','RevShells.com',                    'https://revshells.com',                      'cheatsheet','beginner',    'Reverse shell generator for every language and scenario.',                                              true,  'RevShells'),
  ('r-crt',      'CrackStation',                     'https://crackstation.net',                   'cheatsheet','beginner',    'Online hash cracker using massive precomputed lookup tables.',                                          true,  'CrackStation'),
  ('r-expldb',   'Exploit-DB',                       'https://exploit-db.com',                     'cheatsheet','intermediate','Archive of public exploits and vulnerable software — the go-to for known CVE exploits.',                true,  'Offensive Security'),
  ('r-cve',      'NVD - National Vulnerability Database','https://nvd.nist.gov',                   'article',  'beginner',    'Official US government CVE database with CVSS scores and patch information.',                            true,  'NIST'),

-- ARTICLES
  ('r-owasp10',  'OWASP Top 10 (2021)',              'https://owasp.org/Top10',                    'article',  'beginner',     'The definitive list of the 10 most critical web application security risks.',                            true,  'OWASP'),
  ('r-ptmeth',   'Pentest Methodology Guide',        'https://pentest-standard.org',               'article',  'intermediate', 'The Penetration Testing Execution Standard — industry methodology reference.',                           true,  'PTES'),
  ('r-sans-rk',  'SANS Reading Room',                'https://www.sans.org/white-papers',          'article',  'intermediate', 'Thousands of free security whitepapers covering every domain of cybersecurity.',                        true,  'SANS Institute'),
  ('r-redteam',  'Red Team Development and Operations','https://redteam.guide',                    'article',  'advanced',     'Comprehensive red team planning, tradecraft, and operational security guide.',                           true,  'Joe Vest'),
  ('r-bugcrowd', 'Bugcrowd University',              'https://github.com/bugcrowd/bugcrowd_university','article','beginner',  'Free bug bounty training modules from Bugcrowd covering web and mobile hacking.',                        true,  'Bugcrowd'),
  ('r-hackerone-disc','HackerOne Hacktivity',        'https://hackerone.com/hacktivity',           'article',  'intermediate', 'Public bug bounty disclosures — read real reports to understand vulnerabilities.',                       true,  'HackerOne'),
  ('r-infosec-w','Infosec Writeups (Medium)',        'https://infosecwriteups.com',                'article',  'beginner',     'Community CTF and bug bounty writeups — learn by reading how others solved challenges.',                 true,  'InfoSec Community'),
  ('r-kpntest',  'Kali Linux Revealed',              'https://kali.org/kali-linux-revealed',       'book',     'beginner',     'Free official book for learning Kali Linux from the ground up.',                                        true,  'Offensive Security'),
  ('r-sectubes', 'SecurityTube (Pentester Academy)', 'https://pentesteracademy.com',               'platform', 'intermediate', 'Video-based pentesting training platform with hands-on labs.',                                           false, 'Vivek Ramachandran')
on conflict (id) do nothing;

-- ============================================================
-- SKILL NODES (50+ nodes)
-- ============================================================
insert into public.skill_nodes (id, name, category, description, xp_value, estimated_hours, day_ids, pos_x, pos_y) values
-- Networking
  ('net-osi',    'OSI Model',           'Networking',      'Understand the 7 layers of the OSI model and how data flows through a network stack.',           50,  2,  '{1,2}',      100, 100),
  ('net-tcp',    'TCP/IP & Protocols',  'Networking',      'Master TCP/IP, UDP, ICMP, ARP and how they enable internet communication.',                      75,  3,  '{2,3}',      250, 100),
  ('net-subn',   'Subnetting & CIDR',   'Networking',      'Calculate subnets, CIDR notation, and understand IP address allocation.',                        50,  2,  '{3}',        400, 100),
  ('net-dns',    'DNS & DHCP',          'Networking',      'How DNS resolves domain names and DHCP assigns IP addresses. Attack vectors on both.',            50,  2,  '{4}',        550, 100),
  ('net-fw',     'Firewalls & VPNs',    'Networking',      'Firewall rules, NAT, packet filtering, and VPN tunneling concepts.',                             50,  2,  '{5}',        700, 100),
  ('net-pcap',   'Packet Analysis',     'Networking',      'Capture and analyze network traffic with Wireshark and tcpdump.',                                 75,  3,  '{6}',        850, 100),

-- Linux
  ('linux-cmd',  'Linux CLI Mastery',   'Linux',           'Navigate the filesystem, manage processes, and use pipes, redirects, and bash scripting.',       75,  4,  '{7,8}',      100, 250),
  ('linux-perm', 'File Permissions',    'Linux',           'Linux permission model: read/write/execute, setuid, setgid, sticky bit.',                        50,  2,  '{8}',        250, 250),
  ('linux-net',  'Linux Networking',    'Linux',           'ifconfig, ip, netstat, ss, route, and network troubleshooting commands.',                        50,  2,  '{9}',        400, 250),
  ('linux-svc',  'Services & Daemons',  'Linux',           'Manage systemd services, cron jobs, and understand init systems.',                               50,  2,  '{10}',       550, 250),
  ('linux-bash', 'Bash Scripting',      'Linux',           'Write automation scripts for reconnaissance, scanning, and report generation.',                  75,  4,  '{11,12}',    700, 250),

-- Web Technologies
  ('web-http',   'HTTP/HTTPS',          'Web',             'HTTP methods, status codes, headers, cookies, and the TLS handshake.',                           75,  3,  '{13,14}',    100, 400),
  ('web-html',   'HTML/JS/CSS Basics',  'Web',             'Understand DOM structure, JavaScript execution model, and same-origin policy.',                  50,  2,  '{13}',       250, 400),
  ('web-auth',   'Web Auth Mechanisms', 'Web',             'Session tokens, JWTs, OAuth 2.0, and API key authentication patterns.',                          75,  3,  '{14,15}',    400, 400),
  ('web-api',    'REST & GraphQL APIs', 'Web',             'Understand API structure, test endpoints, intercept requests with Burp.',                        75,  3,  '{15,16}',    550, 400),

-- Reconnaissance
  ('recon-osint','OSINT Fundamentals',  'Reconnaissance',  'Gather intelligence from public sources: social media, Whois, Shodan, Google Dorking.',         100, 5,  '{21,22,23}', 100, 550),
  ('recon-gd',   'Google Dorking',      'Reconnaissance',  'Advanced Google search operators to find exposed files, login pages, and sensitive data.',       50,  2,  '{22}',       250, 550),
  ('recon-shodan','Shodan Recon',       'Reconnaissance',  'Search Shodan for internet-facing services, devices, and vulnerability indicators.',              75,  3,  '{23}',       400, 550),
  ('recon-whois','Whois & DNS Recon',   'Reconnaissance',  'Extract domain registration data, reverse DNS, zone transfer attempts.',                         50,  2,  '{24}',       550, 550),
  ('recon-sub',  'Subdomain Discovery', 'Reconnaissance',  'Enumerate subdomains using Sublist3r, Amass, Certificate Transparency logs.',                    75,  3,  '{25,26}',    700, 550),
  ('recon-social','Social Engineering Recon','Reconnaissance','Analyze LinkedIn, GitHub, and breach databases to build target profiles.',                    50,  2,  '{27}',       850, 550),

-- Scanning & Enumeration
  ('scan-nmap',  'Nmap Scanning',       'Scanning',        'Full Nmap mastery: host discovery, port scanning, service detection, NSE scripting.',            100, 5,  '{28,29}',    100, 700),
  ('scan-svc',   'Service Enumeration', 'Scanning',        'Enumerate HTTP, FTP, SMB, SSH, SNMP, and other services for version and config info.',          75,  4,  '{30,31}',    250, 700),
  ('scan-vuln',  'Vulnerability Scanning','Scanning',      'Use Nessus, OpenVAS, and Nikto to identify known vulnerabilities in services.',                  75,  3,  '{32}',       400, 700),
  ('scan-smb',   'SMB Enumeration',     'Scanning',        'Enumerate SMB shares, users, and policies using smbclient, enum4linux, crackmapexec.',           75,  3,  '{33}',       550, 700),
  ('scan-web',   'Web Recon & Dirbusting','Scanning',      'Discover hidden directories, files, and parameters using Gobuster, Feroxbuster, FFUF.',          75,  3,  '{34}',       700, 700),

-- Exploitation
  ('exp-msf',    'Metasploit Framework','Exploitation',    'Use msfconsole to search, configure, and launch exploits. Meterpreter sessions.',               100, 5,  '{41,42,43}', 100, 850),
  ('exp-shells', 'Reverse & Bind Shells','Exploitation',   'Generate and catch reverse shells in bash, python, PHP, PowerShell.',                            75,  3,  '{43,44}',    250, 850),
  ('exp-bof',    'Buffer Overflows',    'Exploitation',    'Stack-based buffer overflow exploitation: EIP control, badchars, shellcode.',                    125, 8,  '{51,52,53,54,55}',400, 850),
  ('exp-pass',   'Password Attacks',    'Exploitation',    'Dictionary attacks, brute force, credential stuffing with Hydra, Hashcat, John.',                75,  4,  '{45,46}',    550, 850),
  ('exp-file',   'File Upload Attacks', 'Exploitation',    'Bypass file upload filters to achieve remote code execution.',                                    75,  3,  '{47}',       700, 850),

-- Web App Attacks
  ('web-sqli',   'SQL Injection',       'Web Attacks',     'Manual and automated SQLi: error-based, blind, time-based, UNION-based, OOB.',                  125, 6,  '{61,62,63}', 100, 1000),
  ('web-xss',    'Cross-Site Scripting','Web Attacks',     'Reflected, stored, and DOM-based XSS. Stealing cookies, session hijacking.',                    100, 5,  '{64,65}',    250, 1000),
  ('web-csrf',   'CSRF',               'Web Attacks',      'Cross-Site Request Forgery attacks and bypassing same-site cookie protections.',                  75,  3,  '{66}',       400, 1000),
  ('web-ssti',   'SSTI',               'Web Attacks',      'Server-Side Template Injection — identify template engines and achieve RCE.',                    100, 4,  '{67}',       550, 1000),
  ('web-xxe',    'XXE',                'Web Attacks',      'XML External Entity injection — read files, SSRF, and blind XXE via OOB.',                       100, 4,  '{68}',       700, 1000),
  ('web-idor',   'IDOR & BAC',         'Web Attacks',      'Insecure Direct Object References and Broken Access Control exploitation.',                       75,  3,  '{69}',       850, 1000),
  ('web-burp',   'Burp Suite Mastery', 'Web Attacks',      'Intercept, modify, repeat, fuzz, and automate web requests with Burp Suite.',                   100, 5,  '{70,71}',    100, 1150),
  ('web-apih',   'API Hacking',        'Web Attacks',      'Test REST/GraphQL APIs: auth bypass, BOLA, mass assignment, injection.',                         100, 5,  '{72,73}',    250, 1150),

-- Post-Exploitation
  ('post-enum',  'Post-Exploit Enum',  'Post-Exploitation','Enumerate local users, groups, processes, network, and cron jobs after access.',                 75,  3,  '{81,82}',    100, 1300),
  ('post-priv',  'Linux PrivEsc',      'Post-Exploitation','SUID, sudo misconfig, cron jobs, writable /etc/passwd, kernel exploits.',                       125, 6,  '{83,84,85}', 250, 1300),
  ('post-winpr', 'Windows PrivEsc',    'Post-Exploitation','Token impersonation, AlwaysInstallElevated, unquoted service paths, DLL hijacking.',             125, 6,  '{86,87,88}', 400, 1300),
  ('post-ad',    'Active Directory',   'Post-Exploitation','AD enumeration with BloodHound, Kerberoasting, Pass-the-Hash, DCSync.',                          150, 8,  '{89,90,91,92,93,94}',550,1300),
  ('post-pivot', 'Pivoting & Tunneling','Post-Exploitation','Port forwarding, SSH tunneling, proxychains, chisel for lateral movement.',                     100, 5,  '{95,96}',    700, 1300),
  ('post-persist','Persistence',       'Post-Exploitation','Scheduled tasks, registry run keys, backdoor accounts, cron persistence.',                       75,  3,  '{97}',       850, 1300),

-- Reporting
  ('rep-report', 'Pentest Reporting',  'Reporting',        'Write professional pentest reports: executive summary, findings, CVSS scoring, remediation.',    75,  4,  '{101,102}',  100, 1450),
  ('rep-cvss',   'CVSS Scoring',       'Reporting',        'Calculate CVSS v3.1 base, temporal, and environmental scores for findings.',                      50,  2,  '{102}',      250, 1450),
  ('rep-bb',     'Bug Bounty Reports', 'Reporting',        'Write impactful bug bounty reports: title, severity, PoC, impact, remediation.',                  75,  3,  '{103,104}',  400, 1450),
  ('rep-ctf',    'CTF Competition',    'Reporting',        'Strategy for CTF competitions: web, crypto, forensics, binary exploitation categories.',          75,  4,  '{105,106,107,108,109,110}',550,1450),
  ('rep-pentest','Mock Pentest',        'Reporting',        'Conduct a full simulated pentest: scope, recon, exploit, report, debrief.',                      150, 10, '{111,112,113,114,115,116,117,118,119,120}',700,1450)
on conflict (id) do nothing;

-- ============================================================
-- SKILL EDGES (prerequisite relationships)
-- ============================================================
insert into public.skill_edges (source, target) values
-- Networking prerequisites
  ('net-osi',   'net-tcp'),
  ('net-tcp',   'net-subn'),
  ('net-tcp',   'net-dns'),
  ('net-tcp',   'net-fw'),
  ('net-tcp',   'net-pcap'),
  ('net-tcp',   'scan-nmap'),
-- Linux prerequisites
  ('linux-cmd', 'linux-perm'),
  ('linux-cmd', 'linux-net'),
  ('linux-cmd', 'linux-svc'),
  ('linux-cmd', 'linux-bash'),
  ('linux-perm','post-priv'),
-- Web prerequisites
  ('web-http',  'web-html'),
  ('web-http',  'web-auth'),
  ('web-auth',  'web-api'),
  ('web-http',  'web-burp'),
-- Recon chain
  ('net-dns',   'recon-whois'),
  ('net-tcp',   'recon-osint'),
  ('recon-osint','recon-gd'),
  ('recon-osint','recon-shodan'),
  ('recon-whois','recon-sub'),
  ('recon-osint','recon-social'),
-- Scanning chain
  ('net-tcp',   'scan-nmap'),
  ('scan-nmap', 'scan-svc'),
  ('scan-svc',  'scan-smb'),
  ('scan-svc',  'scan-vuln'),
  ('web-http',  'scan-web'),
-- Exploitation chain
  ('scan-nmap', 'exp-msf'),
  ('exp-msf',   'exp-shells'),
  ('linux-cmd', 'exp-shells'),
  ('exp-shells','exp-bof'),
  ('scan-svc',  'exp-pass'),
  ('web-burp',  'exp-file'),
-- Web attack chain
  ('web-burp',  'web-sqli'),
  ('web-burp',  'web-xss'),
  ('web-xss',   'web-csrf'),
  ('web-burp',  'web-ssti'),
  ('web-burp',  'web-xxe'),
  ('web-burp',  'web-idor'),
  ('web-api',   'web-apih'),
-- Post-exploitation chain
  ('exp-shells','post-enum'),
  ('post-enum', 'post-priv'),
  ('post-enum', 'post-winpr'),
  ('post-priv', 'post-ad'),
  ('post-winpr','post-ad'),
  ('post-ad',   'post-pivot'),
  ('post-priv', 'post-persist'),
-- Reporting
  ('exp-msf',   'rep-report'),
  ('rep-report','rep-cvss'),
  ('rep-cvss',  'rep-bb'),
  ('rep-bb',    'rep-ctf'),
  ('rep-ctf',   'rep-pentest')
on conflict do nothing;
