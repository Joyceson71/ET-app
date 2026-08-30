-- HackPath — Days 21-60 (Phase 2: Recon, Phase 3: Exploitation)

insert into public.days (id, phase, title, concept, lab_url, lab_platform, xp_reward) values

-- ================================================================
-- PHASE 2: RECONNAISSANCE (Days 21–40)
-- ================================================================

(21, 2, 'OSINT Fundamentals',
'## OSINT Fundamentals

OSINT (Open Source Intelligence) is the collection of information from publicly available sources. It is the first step of every professional penetration test and every major cyberattack.

**The OSINT Framework (osintframework.com):**
A categorized map of OSINT tools organized by data type: people, social networks, domains, IP addresses, email addresses, documents, and more.

**Key OSINT Sources:**
- **Whois:** Domain registration details, registrant contact, name servers
- **Shodan:** Internet-connected device search engine
- **Censys:** Similar to Shodan, with certificate transparency data
- **Google:** The most powerful OSINT tool when used with dork operators
- **LinkedIn:** Employee names, roles, tech stack from job postings
- **GitHub:** Source code, credentials, internal tools
- **Wayback Machine (archive.org):** Historical website snapshots
- **Hunter.io:** Email format discovery for domains

**Passive vs Active Recon:**
- **Passive:** Never touching the target directly (Shodan, Whois, Google) — zero detection risk
- **Active:** Direct interaction with target (port scanning, DNS queries to their server) — leaves traces

**Building a Target Profile:**
```
Target: example.com
1. Whois → Registrar, creation date, registrant email
2. DNS → A, MX, TXT, NS records → cloud providers, email provider
3. Google dorks → login pages, exposed files, subdomains
4. Shodan → exposed services on their IP ranges
5. LinkedIn → tech stack from job postings ("must know Kubernetes, AWS")
6. GitHub → source code repos, internal tooling, leaked keys
7. Wayback Machine → old pages that reveal structure
8. Hunter.io → email format (first.last@example.com)
```

**Maltego:** Graph-based OSINT tool for visualizing connections between entities — people, domains, IPs, organizations.',
'https://tryhackme.com/room/ohsint', 'TryHackMe', 50),

(22, 2, 'Google Dorking Mastery',
'## Google Dorking: Advanced Search for Hackers

Google indexes the entire public internet including sensitive files, login pages, and exposed databases. Google dork operators let you search with surgical precision.

**Core Operators:**
```
site:example.com            — Only results from this domain
filetype:pdf                — Only PDF files  
intitle:"index of"          — Directory listings
inurl:admin                 — "admin" in URL
intext:"password"           — "password" in page text
cache:example.com           — Google''s cached copy
link:example.com            — Pages linking to target
related:example.com         — Similar sites
```

**Dangerous Dorks:**

*Exposed files:*
```
site:example.com filetype:pdf confidential
site:example.com filetype:sql
site:example.com filetype:env
site:example.com filetype:log
```

*Admin panels:*
```
site:example.com inurl:admin
site:example.com inurl:login intitle:admin
site:example.com intitle:"phpMyAdmin"
```

*Credentials:*
```
site:github.com "example.com" password
site:example.com intext:"password" filetype:txt
```

*Open directories:*
```
intitle:"index of" site:example.com
intitle:"index of" "parent directory" site:example.com
```

*Camera/devices:*
```
inurl:"/view/index.shtml"    — Axis cameras
intitle:"webcamXP 5"
```

**GHDB (Google Hacking Database):** exploit-db.com/google-hacking-database — thousands of pre-built dorks organized by category.

**Ethics:** Only use dorks on systems you have permission to test. Discovering a vulnerability through Google doesn''t mean you can exploit it legally.

Practice: Try `site:yourschool.edu filetype:xlsx` — you may be surprised what you find publicly.',
'https://tryhackme.com/room/googledorking', 'TryHackMe', 50),

(23, 2, 'Shodan for Reconnaissance',
'## Shodan: The Search Engine for Hackers

Shodan continuously scans the entire internet and indexes banners from ports 21, 22, 23, 25, 80, 443, 8080, and thousands more. It reveals what services organizations expose to the internet.

**What Shodan Indexes:**
- Web servers with version info
- SSH banners with OpenSSH version
- FTP servers (including anonymous login)
- Industrial control systems (SCADA, ICS)
- Printers, routers, cameras
- Databases (MongoDB, Redis, Elasticsearch) — often unauthenticated

**Shodan Search Operators:**
```
hostname:example.com           — All IPs for a domain
org:"Target Corp"              — By organization name
net:203.0.113.0/24             — By IP range
port:3389                      — Specific port open
os:"Windows Server 2016"       — By OS
product:"Apache httpd"         — By product
version:"2.4.49"               — Specific version (find CVE targets!)
vuln:CVE-2021-44228            — Hosts vulnerable to specific CVE
country:US city:"New York"     — Geographic filters
```

**Shodan for Bug Bounty:**
```
hostname:*.target.com port:8080    — Non-standard web ports
hostname:*.target.com port:27017   — Exposed MongoDB
hostname:*.target.com product:Jenkins  — CI/CD servers
hostname:*.target.com "401 Unauthorized" http.title:"Admin"
```

**Censys (censys.io):**
Similar to Shodan but with better certificate data:
```
parsed.names: example.com          — Certs for domain
protocols: "443/https"              — HTTPS services
autonomous_system.name: "Target"    — By ASN
```

**Shodan CLI:**
```bash
pip install shodan
shodan init YOUR_API_KEY
shodan search "hostname:example.com"
shodan host 203.0.113.1
```

**What to Look For:**
- Old/unpatched service versions
- Services that shouldn''t be internet-facing (databases, admin panels)
- Default credentials (check Shodan''s screenshots for login pages)
- SSL certificate details revealing internal hostnames',
'https://tryhackme.com/room/shodan', 'TryHackMe', 50),

(24, 2, 'DNS Reconnaissance',
'## DNS Reconnaissance: Mapping the Attack Surface

DNS records reveal an organization''s entire infrastructure. A thorough DNS recon uncovers subdomains, mail servers, cloud providers, and internal hostnames.

**DNS Enumeration Commands:**
```bash
# Basic record lookup
dig example.com A          # IPv4 address
dig example.com MX         # Mail servers
dig example.com TXT        # SPF, DKIM, verification records
dig example.com NS         # Name servers
dig example.com CNAME      # Aliases

# Zone transfer attempt (often fails, but always try)
dig axfr @ns1.example.com example.com

# Reverse DNS lookup
dig -x 203.0.113.1

# Using nslookup
nslookup -type=MX example.com
nslookup -type=TXT example.com
```

**What TXT Records Reveal:**
```
"v=spf1 include:_spf.google.com include:sendgrid.net ~all"
         ↑ Uses Google Workspace    ↑ Uses SendGrid
"MS=ms12345" → Microsoft 365 tenant
"atlassian-domain-verification=..." → Uses Atlassian (Jira/Confluence)
"docusign=..." → Uses DocuSign
```

**Subdomain Enumeration Tools:**
```bash
# Sublist3r (passive)
sublist3r -d example.com -o subdomains.txt

# DNSrecon
dnsrecon -d example.com -t brt -D /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt

# Amass (most comprehensive)
amass enum -d example.com -passive

# Gobuster DNS mode
gobuster dns -d example.com -w /usr/share/seclists/Discovery/DNS/bitquark-subdomains-top100000.txt
```

**Certificate Transparency:**
```bash
# Find all certs issued for a domain
curl "https://crt.sh/?q=%.example.com&output=json" | jq .[].name_value | sort -u
```

**Virtual Host Discovery:**
Many IPs host multiple domains. Enumerate vhosts:
```bash
gobuster vhost -u http://10.0.0.1 -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt
```

**Cloud Provider Identification from DNS:**
- AWS: `*.amazonaws.com`, `*.elasticbeanstalk.com`
- Azure: `*.azurewebsites.net`, `*.cloudapp.azure.com`
- GCP: `*.appspot.com`, `*.googleapis.com`
- Cloudflare: MX points to Cloudflare IPs',
'https://tryhackme.com/room/dnsindetail', 'TryHackMe', 50),

(25, 2, 'Subdomain Enumeration and Takeover',
'## Subdomain Enumeration and Takeover Attacks

Subdomains often run forgotten services with weaker security than the main domain. Subdomain takeover is a high-impact, frequently found bug bounty vulnerability.

**Why Subdomains Matter:**
- `dev.example.com` — Development server with debug mode on
- `staging.example.com` — Pre-production with real data
- `old.example.com` — Legacy app running outdated software
- `vpn.example.com` — VPN gateway — worth targeting
- `jenkins.example.com` — CI/CD with code access
- `mail.example.com` — Webmail, often with weaker auth

**Comprehensive Subdomain Hunting:**
```bash
# 1. Passive (no direct contact with target)
amass enum -passive -d example.com

# 2. Certificate Transparency
curl "https://crt.sh/?q=%.example.com&output=json" | jq -r ''.[].name_value'' | sort -u

# 3. DNS brute force
gobuster dns -d example.com -w /usr/share/seclists/Discovery/DNS/n0kovo_subdomains.txt -t 50

# 4. Permutation (dev, staging, test variants)
dnsgen subdomains.txt | massdns -r resolvers.txt -t A -o S

# 5. ASN recon → IP ranges → reverse DNS
amass intel -org "Example Corp"
```

**Subdomain Takeover:**
Occurs when a subdomain''s DNS record points to a service that no longer exists.

```bash
# Scenario:
dig dev.example.com CNAME
# → dev-abandoned.netlify.app

# Check if that Netlify site is claimed:
curl https://dev-abandoned.netlify.app
# → 404/unclaimed? → You can register it!
```

**Vulnerable Providers (commonly misconfigured):**
Netlify, GitHub Pages, Heroku, Azure, AWS S3, Fastly, Shopify

**Tool: nuclei for mass detection:**
```bash
cat subdomains.txt | nuclei -t takeovers/
```

**Impact:** You control a subdomain of the target — can serve phishing pages under their brand, steal cookies (if `SameSite=None`), bypass CORS, and receive emails.',
'https://tryhackme.com/room/subdomainenumeration', 'TryHackMe', 50),

(26, 2, 'Email OSINT and Social Engineering Recon',
'## Email OSINT and Social Engineering Reconnaissance

Understanding your target''s people and communication patterns is essential for social engineering and phishing campaigns.

**Email Discovery:**
```bash
# Hunter.io API
curl "https://api.hunter.io/v2/domain-search?domain=example.com&api_key=KEY"
# Returns: email format, employee emails, confidence scores

# theHarvester - aggregates multiple sources
theHarvester -d example.com -b all -l 500

# LinkedIn scraping (manual) - note job titles and departments
```

**Email Format Patterns:**
```
first.last@company.com      — Most common
f.last@company.com
firstlast@company.com
first_last@company.com
```

Verify format: `smtp-user-enum -M VRFY -U users.txt -t mail.example.com`

**LinkedIn Recon:**
- Employee count and growth (rapid = rushed hiring = security gaps)
- Job postings reveal tech stack ("experience with AWS Lambda, PostgreSQL, Node.js")
- Employee names for targeted phishing
- Security team size and seniority
- Employees who recently left (still have access? Disgruntled?)

**GitHub Organization Recon:**
```bash
# Find org repos
curl https://api.github.com/orgs/TARGET/repos | jq .[].clone_url

# Find employees
curl https://api.github.com/orgs/TARGET/members | jq .[].login

# Secret scanning with truffleHog
trufflehog git https://github.com/TARGET/REPO
```

**Breach Data:**
- Have I Been Pwned (haveibeenpwned.com) — email breach check
- DeHashed (dehashed.com) — leaked password database
- Leaked credentials = account takeover if employees reuse passwords

**Pastebin/Darkweb Monitoring:**
`site:pastebin.com "example.com"` — Sometimes credentials or internal data gets pasted

**Building the Attack Package:**
```
Target: ACME Corp
Employees: John Smith (IT), Jane Doe (Finance)
Email format: john.smith@acme.com  
Tech: AWS, Salesforce, Office365
Breached emails: 3 employees in RockYou2021
Attack vector: Spear-phishing John (IT) with fake AWS billing alert
```',
'https://tryhackme.com/room/searchskills', 'TryHackMe', 50),

(27, 2, 'Passive Network Reconnaissance',
'## Passive Network Reconnaissance

Before touching a target''s network, extract everything possible from passive sources: BGP routing data, WHOIS, Shodan, certificate data, and traffic analysis.

**ASN Discovery:**
```bash
# Find ASN for organization
whois -h whois.radb.net TARGET_IP
# or
curl https://api.bgpview.io/search?query_term=example.com

# Get all IP ranges for an ASN
whois -h whois.radb.net -- ''-i origin AS12345'' | grep route
```

**IP Range Reconnaissance:**
```bash
# Find all IPs registered to a company
whois 203.0.113.0 | grep -i CIDR
amass intel -org "Example Corporation"

# Reverse WHOIS - find all domains registered to same org
# viewdns.info/reversewhois
```

**Web Archive Analysis (Wayback Machine):**
```bash
# Find all URLs ever indexed for a domain
curl "https://web.archive.org/cdx/search/cdx?url=*.example.com&output=text&fl=original&collapse=urlkey" | sort -u

# Look for:
# - Old admin panels
# - Exposed backup files (.bak, .old, .zip)
# - API endpoints no longer linked from frontend
# - Config files accidentally published
```

**SSL/TLS Certificate Analysis:**
```bash
# Censys for cert recon
curl "https://search.censys.io/api/v1/search/certificates" \
  -H "Authorization: Basic BASE64" \
  -d ''{"query":"parsed.names: example.com"}''

# View cert details for any domain
openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -text
# Reveals: SANs (internal hostnames!), org info, CA
```

**DNS History:**
- SecurityTrails (securitytrails.com) — historical DNS records
- DNSdumpster (dnsdumpster.com) — free DNS recon + map
- Past A records reveal IP address changes (old IP = old server still running?)

**Passive Recon Deliverable:**
By end of passive recon, you should have:
✓ All IP ranges owned by target
✓ All subdomains (50+ typically)
✓ Email format for phishing
✓ Technology stack (from job posts, headers, certs)
✓ Employee names and roles (LinkedIn)
✓ Any previously exposed secrets (GitHub, Pastebin)',
'https://tryhackme.com/room/passiverecon', 'TryHackMe', 50),

(28, 2, 'Nmap — The Art of Port Scanning',
'## Nmap — The Art of Port Scanning

Nmap (Network Mapper) is the most important tool in your arsenal. Master every scan type, output format, and NSE script category.

**Host Discovery (Ping Sweep):**
```bash
nmap -sn 192.168.1.0/24        # Ping sweep — find live hosts
nmap -sn -PE 192.168.1.0/24   # ICMP echo only
nmap -sn -PS22,80,443 10.0.0.0/24  # TCP SYN ping on specific ports
```

**Port Scan Types:**
```bash
nmap -sS target    # SYN scan (default root) — stealthy, no full connect
nmap -sT target    # TCP connect scan (no root needed)
nmap -sU target    # UDP scan (slow, important: DNS 53, SNMP 161, NFS 2049)
nmap -sF target    # FIN scan (IDS evasion)
nmap -sN target    # Null scan (no flags)
nmap -sX target    # Xmas scan (FIN+PSH+URG)
```

**Port Specification:**
```bash
nmap -p 80,443,8080  target    # Specific ports
nmap -p 1-1000       target    # Port range
nmap -p-             target    # All 65535 ports (slow)
nmap -F              target    # Fast: top 100 ports
nmap --top-ports 1000 target   # Top 1000 most common
```

**Service and Version Detection:**
```bash
nmap -sV target               # Service/version detection
nmap -sV --version-intensity 9 target   # Aggressive version
nmap -O target                # OS detection (root required)
nmap -A target                # Aggressive: OS + version + scripts + traceroute
```

**Output Formats (Always save output!):**
```bash
nmap -oN scan.txt target      # Normal text
nmap -oX scan.xml target      # XML (importable to Metasploit)
nmap -oG scan.gnmap target    # Grepable
nmap -oA scan target          # All formats simultaneously
```

**Speed (T0–T5):**
```bash
nmap -T0 target    # Paranoid (IDS evasion)
nmap -T1 target    # Sneaky
nmap -T3 target    # Normal (default)
nmap -T4 target    # Aggressive (fast — use for CTFs/labs)
nmap -T5 target    # Insane (may miss results)
```

**My Standard Workflow:**
```bash
# Step 1: Quick top ports
nmap -T4 -F target -oN quick_scan.txt

# Step 2: Full port scan
nmap -p- -T4 target -oN full_ports.txt

# Step 3: Version + scripts on open ports
nmap -sV -sC -p 22,80,443,8080 target -oA detailed_scan
```',
'https://tryhackme.com/room/furthernmap', 'TryHackMe', 50),

(29, 2, 'Nmap Scripting Engine (NSE)',
'## Nmap Scripting Engine — Automated Vulnerability Detection

NSE (Nmap Scripting Engine) extends Nmap with Lua scripts that perform service enumeration, vulnerability detection, and exploitation.

**Script Categories:**
```
auth      — Authentication bypass, default creds
brute     — Brute-force login
default   — Run with -sC; general enumeration
discovery — Network discovery, service info
exploit   — Proof-of-concept exploits
fuzzer    — Send malformed data
intrusive — May crash services (use with permission!)
malware   — Detect malware backdoors
safe      — Non-intrusive (safe to run)
vuln      — Vulnerability checks
```

**Running Scripts:**
```bash
nmap -sC target                    # Default scripts
nmap --script=vuln target          # All vuln scripts
nmap --script=http-enum target     # Enumerate web directories
nmap --script=smb-vuln-* target    # All SMB vulnerabilities
nmap --script=ssh-brute target     # SSH brute force
nmap --script=ftp-anon target      # FTP anonymous login
nmap --script=http-shellshock target  # Shellshock (CVE-2014-6271)
```

**Most Useful NSE Scripts:**
```bash
# HTTP
http-enum           — Enumerate web dirs/files
http-headers        — Show HTTP headers
http-methods        — Show allowed HTTP methods
http-robots.txt     — Fetch robots.txt
http-auth-finder    — Detect auth type
http-default-accounts — Try default credentials

# SMB (Windows)
smb-os-discovery    — OS version via SMB
smb-vuln-ms17-010   — EternalBlue vulnerability
smb-vuln-ms08-067   — Conficker vulnerability
smb-enum-shares     — List shares
smb-enum-users      — List users

# SSH
ssh-auth-methods    — What auth methods accepted
ssh-hostkey         — Get host key

# Databases
mysql-info          — MySQL info
mysql-empty-password — Check for empty root password
ms-sql-info         — MSSQL info

# FTP
ftp-anon            — Anonymous FTP login
ftp-bounce          — FTP bounce attack
```

**EternalBlue Detection:**
```bash
nmap --script=smb-vuln-ms17-010 -p 445 target
# "VULNERABLE" = can likely get SYSTEM via Metasploit
# module: exploit/windows/smb/ms17_010_eternalblue
```

**Creating Custom Scripts:** NSE scripts are Lua files in `/usr/share/nmap/scripts/`. Study existing scripts to learn the API.',
'https://tryhackme.com/room/nmap04', 'TryHackMe', 50),

(30, 2, 'Service Enumeration Deep Dive',
'## Service Enumeration: Extracting Maximum Information

After port scanning, enumerate each open service thoroughly. Every service leaks information about versions, configurations, and potential vulnerabilities.

**SSH Enumeration (Port 22):**
```bash
nmap --script=ssh-auth-methods -p 22 target    # Auth methods
nmap --script=ssh-hostkey -p 22 target         # Host key (fingerprint)
ssh -v target 2>&1 | grep "Server version"     # SSH version

# Password auth enabled? → brute force candidate
# Key-based only? → look for exposed private keys
```

**FTP Enumeration (Port 21):**
```bash
nmap --script=ftp-anon -p 21 target            # Anonymous login
ftp target                                      # Connect (try anonymous:anonymous)
# If anonymous: list files, download everything
ls -la
get interesting_file.txt
```

**SMB Enumeration (Port 445/139):**
```bash
# enumerate shares, users, OS
smbclient -L //target -N              # List shares (no password)
smbclient //target/share -N           # Connect to share
enum4linux -a target                  # Full SMB enumeration
crackmapexec smb target               # Quick info dump
crackmapexec smb target --shares      # List shares
```

**HTTP Enumeration (Port 80/443):**
```bash
whatweb target                        # Identify CMS, frameworks
nikto -h target                       # Web vulnerability scan
gobuster dir -u http://target -w /usr/share/seclists/Discovery/Web-Content/common.txt
dirb http://target /usr/share/wordlists/dirb/common.txt
curl -I http://target                 # Response headers
```

**SMTP Enumeration (Port 25/587):**
```bash
nc -v target 25
EHLO hackpath.io
VRFY admin@target.com          # Verify if user exists
EXPN admins                    # Expand alias (reveals users)
smtp-user-enum -M VRFY -U users.txt -t target
```

**SNMP Enumeration (Port 161/UDP):**
```bash
# Default community strings: public, private
nmap -sU -p 161 --script=snmp-info target
snmpwalk -v2c -c public target
snmp-check target               # Automated SNMP dump
# Reveals: running processes, installed software, network config, usernames
```

**MySQL Enumeration (Port 3306):**
```bash
mysql -h target -u root -p      # Try empty password
nmap --script=mysql-info,mysql-empty-password -p 3306 target
```

**Build an enumeration checklist** and run through it for every open port you find.',
'https://tryhackme.com/room/networksecurityprotocols', 'TryHackMe', 50),

(31, 2, 'Web Application Enumeration',
'## Web Application Enumeration

Before attempting to exploit a web application, you must thoroughly map its attack surface.

**Technology Fingerprinting:**
```bash
# WhatWeb - identify CMS, frameworks, libraries
whatweb -v https://target.com
whatweb -a 3 https://target.com     # Aggressive mode

# Wappalyzer - browser extension (shows stack visually)
# BuiltWith - detailed tech analysis at builtwith.com

# From response headers:
curl -I https://target.com | grep -i "server\|x-powered-by\|x-generator"
# Server: Apache/2.4.49 → Check CVE-2021-41773!
# X-Powered-By: PHP/7.2.0 → Old PHP, many CVEs
```

**Directory and File Discovery:**
```bash
# Gobuster (fastest)
gobuster dir -u http://target.com -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -x php,html,txt,bak -t 50

# FFuf (most flexible)
ffuf -w /usr/share/seclists/Discovery/Web-Content/common.txt -u http://target.com/FUZZ -mc 200,301,302,403

# Feroxbuster (recursive)
feroxbuster -u http://target.com -w wordlist.txt --depth 3
```

**High-Value Files to Find:**
```
/robots.txt        — Disallowed paths reveal hidden areas
/sitemap.xml       — All pages the site wants indexed
/.git/             — Source code! (git-dumper tool)
/backup.zip        — Database dumps, old versions
/phpinfo.php       — PHP configuration (paths, version, modules)
/.env              — Environment variables with DB creds
/wp-admin/         — WordPress admin
/admin/            — Generic admin panel
/api/              — API endpoints
/swagger.json      — API documentation
/graphql           — GraphQL endpoint
```

**Parameter Discovery:**
```bash
# Arjun - finds hidden GET/POST parameters
arjun -u https://target.com/search

# x8 - parameter discovery
x8 -u "https://target.com/api/data" -w params.txt
```

**JavaScript Analysis:**
```bash
# Extract all JS URLs from a page
curl https://target.com | grep -Eo ''src="[^"]+\.js"'' | sed ''s/src="//;s/"//''

# Find endpoints in JS files
cat app.js | grep -oP ''(?:GET|POST|PUT|DELETE|fetch|axios)\s*\(?[''"]([^''"]+)[''"]''
# Tool: LinkFinder
python3 linkfinder.py -i https://target.com -d
```

**Create a target map:** document every endpoint, parameter, and technology before attempting exploitation.',
'https://tryhackme.com/room/webfundamentals', 'TryHackMe', 50),

(32, 2, 'Vulnerability Scanning with Nikto and OpenVAS',
'## Vulnerability Scanning: Nikto, OpenVAS, and Nuclei

Vulnerability scanners automate the detection of known security issues. Use them as a starting point, not a final answer — manual verification is always required.

**Nikto — Web Vulnerability Scanner:**
```bash
# Basic scan
nikto -h http://target.com

# HTTPS
nikto -h https://target.com -ssl

# Specific port
nikto -h target.com -port 8080

# Output to file
nikto -h target.com -o nikto_scan.html -Format htm

# With Nmap integration
nmap -p80 target.com -oG - | nikto -h -
```

**What Nikto Checks:**
- Server version vulnerabilities
- Dangerous files (shells, backup files, config files)
- Outdated software with known CVEs
- Misconfigured servers
- Default files and programs
- Missing security headers
- Clickjacking vulnerabilities

**Nuclei — Template-Based Fast Scanner:**
```bash
# Install
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Scan with all templates
nuclei -u https://target.com

# Specific severity
nuclei -u https://target.com -severity critical,high

# Technology-specific
nuclei -u https://target.com -tags wordpress
nuclei -u https://target.com -tags cve

# Bulk scanning
cat urls.txt | nuclei -t exposures/ -t vulnerabilities/
```

**OpenVAS — Network Vulnerability Scanner:**
```bash
# Kali setup
sudo apt install openvas
sudo gvm-setup
sudo gvm-start
# Access at: https://127.0.0.1:9392
# Default: admin / (password shown during setup)
```

**Interpreting Results:**
- CRITICAL: Exploit immediately (RCE, SQLi, auth bypass)
- HIGH: Significant risk, prioritize
- MEDIUM: Should fix, lower exploitation risk
- LOW/INFORMATIONAL: Best practices, configuration issues

**False Positives:** Scanners frequently generate false positives. Always manually verify:
1. Reproduce the finding manually
2. Understand WHY it''s vulnerable
3. Demonstrate proof-of-concept (PoC)

**Combining Tools:** Run Nmap → Nikto → Nuclei → Manual testing. Each tool catches different things.',
'https://tryhackme.com/room/vulnerabilityscanning', 'TryHackMe', 50),

(33, 2, 'SMB and Active Directory Recon',
'## SMB and Active Directory Reconnaissance

SMB (Server Message Block) is Windows'' file-sharing protocol and one of the most exploited services in corporate environments. EternalBlue, WannaCry, NotPetya — all SMB attacks.

**SMB Protocol Versions:**
- SMBv1: Completely broken — EternalBlue exploitable. Should be disabled everywhere.
- SMBv2: Improved security
- SMBv3: Encryption support

**Check if SMBv1 is enabled:**
```bash
nmap --script smb-protocols -p 445 target
# Also: metasploit auxiliary/scanner/smb/smb2
```

**Full SMB Enumeration with enum4linux:**
```bash
enum4linux -a target
# Outputs: OS info, users, groups, shares, password policy, printers
```

**CrackMapExec (CME) — The Swiss Army Knife for AD:**
```bash
# Basic info
crackmapexec smb target

# List shares (no creds)
crackmapexec smb target --shares

# With credentials
crackmapexec smb target -u admin -p Password1

# Password spray across subnet
crackmapexec smb 192.168.1.0/24 -u users.txt -p passwords.txt

# Dump SAM database (after auth)
crackmapexec smb target -u admin -p Password1 --sam

# Pass-the-hash
crackmapexec smb target -u admin -H NTLM_HASH
```

**Active Directory Enumeration (authenticated):**
```bash
# BloodHound data collection
bloodhound-python -d example.local -u user -p pass -c All

# ldapdomaindump
ldapdomaindump -u domain\\user -p password ldap://target

# PowerView (from Windows)
Get-Domain
Get-DomainUser
Get-DomainGroup -Identity "Domain Admins"
Find-LocalAdminAccess
```

**Kerberoasting (extracting service ticket hashes):**
```bash
# impacket
GetUserSPNs.py domain/user:password -dc-ip 10.0.0.1 -request

# Crack offline
hashcat -m 13100 spns.txt /usr/share/wordlists/rockyou.txt
```

**Key AD Concepts:** Domain, Domain Controller, Kerberos, NTLM, LDAP, Group Policy, Trust relationships.',
'https://tryhackme.com/room/activedirectoryhardening', 'TryHackMe', 50),

(34, 2, 'Web Discovery and Fuzzing',
'## Web Discovery and Fuzzing

Fuzzing is the process of sending malformed or unexpected input to find hidden functionality, vulnerabilities, and crashes.

**FFUF (Fuzz Faster U Fool) — The Standard Tool:**
```bash
# Directory fuzzing
ffuf -w /usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt \
     -u http://target.com/FUZZ \
     -mc 200,301,302,403

# File fuzzing
ffuf -w files.txt -u http://target.com/FUZZ -e .php,.html,.txt,.bak,.zip

# Virtual host fuzzing
ffuf -w subdomains.txt -u http://target.com -H "Host: FUZZ.target.com" -mc 200

# Parameter fuzzing (GET)
ffuf -w params.txt -u "http://target.com/search?FUZZ=test"

# Parameter value fuzzing
ffuf -w payloads.txt -u "http://target.com/search?id=FUZZ"

# POST body fuzzing
ffuf -w payloads.txt -u http://target.com/login -X POST \
     -d "username=admin&password=FUZZ" -H "Content-Type: application/x-www-form-urlencoded"

# Filter by response size (remove noise)
ffuf -w wordlist.txt -u http://target.com/FUZZ -fs 4242
```

**Gobuster:**
```bash
gobuster dir -u http://target.com -w wordlist.txt -x php,html -t 50 -o results.txt
gobuster dns -d target.com -w subdomains.txt -t 50
gobuster vhost -u http://target.com -w subdomains.txt
```

**Important Wordlists (SecLists):**
```bash
/usr/share/seclists/Discovery/Web-Content/
  ├── common.txt                              # Basic directories
  ├── raft-large-directories.txt             # Comprehensive dirs
  ├── raft-large-files.txt                   # Files
  ├── api/api-endpoints.txt                  # API paths
  └── big.txt                                # Huge wordlist

/usr/share/seclists/Discovery/DNS/
  ├── subdomains-top1million-5000.txt        # Fast subdomain brute
  └── n0kovo_subdomains.txt                  # Comprehensive
```

**Recursive Scanning with Feroxbuster:**
```bash
feroxbuster -u http://target.com \
  -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt \
  --depth 4 \
  --threads 50 \
  --output ferox_results.txt
```

**Pro Tip:** Always check `robots.txt` first — it often lists exactly what admins don''t want scanned (which is exactly what you should scan).',
'https://tryhackme.com/room/contentdiscovery', 'TryHackMe', 50),

(35, 2, 'Recon-ng and Automated OSINT',
'## Recon-ng: Modular OSINT Framework

Recon-ng is a full-featured web reconnaissance framework with a Metasploit-like interface. It automates OSINT tasks across dozens of modules.

**Starting Recon-ng:**
```bash
recon-ng
[recon-ng][default] > 
```

**Core Concepts:**
```bash
workspaces create target_co    # Create isolated workspace
workspaces select target_co    # Switch workspace
modules search                 # List all modules
modules load recon/domains-hosts/hackertarget   # Load module
info                           # Show module options
options set SOURCE example.com  # Set target
run                            # Execute
show hosts                     # View collected data
```

**Key Modules:**
```bash
# Subdomain discovery
recon/domains-hosts/google_site_web     # Google site: search
recon/domains-hosts/hackertarget        # HackerTarget API
recon/domains-hosts/certificate_transparency  # crt.sh

# Contact/email discovery
recon/domains-contacts/whois_pocs       # Whois contacts
recon/domains-contacts/pgp_search       # PGP keyserver emails

# Host recon
recon/hosts-ports/shodan_ip             # Shodan port scan
recon/hosts-hosts/resolve               # Resolve hostnames

# Social media
recon/profiles-profiles/profiler        # Social profile aggregation
```

**SpiderFoot — Automated OSINT:**
```bash
# Web-based OSINT automation
pip3 install spiderfoot
spiderfoot -l 127.0.0.1:5001
# Browser: http://127.0.0.1:5001
# Create scan → Enter target domain → Select all modules → Run
# Produces: IPs, subdomains, emails, credentials, related companies
```

**theHarvester:**
```bash
theHarvester -d example.com -b google,bing,linkedin,twitter,github -l 500 -f results
# Collects: email addresses, hostnames, IPs from search engines
```

**Maltego (GUI):**
- Professional OSINT visualization
- "Transforms" connect entities (domain → IP → ASN → company → employees)
- Community edition is free with limited transforms

**Putting It All Together:**
Build a recon pipeline script:
```bash
#!/bin/bash
DOMAIN=$1
mkdir -p recon/$DOMAIN

# Passive
theHarvester -d $DOMAIN -b all -l 500 -f recon/$DOMAIN/harvester
amass enum -passive -d $DOMAIN -o recon/$DOMAIN/subdomains.txt
curl "https://crt.sh/?q=%.$DOMAIN&output=json" | jq -r ''.[].name_value'' | sort -u >> recon/$DOMAIN/subdomains.txt

# DNS
cat recon/$DOMAIN/subdomains.txt | while read sub; do
  dig +short $sub | grep -E "^[0-9]" >> recon/$DOMAIN/ips.txt
done

echo "[+] Found $(wc -l < recon/$DOMAIN/subdomains.txt) subdomains"
echo "[+] Found $(sort -u recon/$DOMAIN/ips.txt | wc -l) unique IPs"
```',
'https://tryhackme.com/room/recon', 'TryHackMe', 50),

(36, 2, 'Wireless Network Reconnaissance',
'## Wireless Network Security and Reconnaissance

Wireless networks present a unique attack surface — the signal travels through walls and can be captured by anyone nearby.

**Wireless Concepts:**
- **SSID:** Network name (can be hidden, but detectable)
- **BSSID:** Access point MAC address
- **Channel:** 1-14 (2.4GHz), 36-165 (5GHz)
- **Authentication:** Open, WEP (broken), WPA/WPA2-PSK, WPA2-Enterprise

**Setting Up Monitor Mode:**
```bash
sudo airmon-ng check kill           # Kill interfering processes
sudo airmon-ng start wlan0          # Enable monitor mode → wlan0mon
iwconfig                             # Verify mode: Monitor
```

**Network Discovery:**
```bash
sudo airodump-ng wlan0mon
# Shows: BSSID, Channel, ESSID (name), Clients, Encryption type
# Press Ctrl+C to stop
```

**Capturing WPA2 Handshake:**
```bash
# Target specific network
sudo airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w capture wlan0mon

# Deauthenticate a client to force reconnect (captures handshake)
sudo aireplay-ng -0 5 -a AA:BB:CC:DD:EE:FF -c CLIENT_MAC wlan0mon
# (-0 = deauth, 5 = packets, -a = AP, -c = client)
```

**Cracking WPA2:**
```bash
# hashcat (fastest)
hashcat -m 22000 capture-01.cap /usr/share/wordlists/rockyou.txt

# aircrack-ng
aircrack-ng capture-01.cap -w /usr/share/wordlists/rockyou.txt
```

**Evil Twin Attack:**
Create a fake AP with same SSID, deauth clients from real AP → they connect to you → capture credentials.
```bash
hostapd-wpe hostapd.conf   # WPA-Enterprise credential capture
```

**WPS Vulnerabilities:**
```bash
wash -i wlan0mon                   # Find WPS-enabled APs
reaver -i wlan0mon -b BSSID -vv   # WPS brute force (takes hours)
```

**Legal Note:** Only test wireless networks you own or have explicit written permission to test. War driving (passive scanning) laws vary by jurisdiction.',
'https://tryhackme.com/room/wifihacking101', 'TryHackMe', 50),

(37, 2, 'Cloud Reconnaissance: AWS, Azure, GCP',
'## Cloud Reconnaissance

Modern organizations run most infrastructure on AWS, Azure, or GCP. Cloud misconfigurations are among the most common and highest-impact vulnerabilities.

**AWS Recon — S3 Buckets:**
```bash
# Check if bucket exists and is public
aws s3 ls s3://target-company-backup --no-sign-request
aws s3 cp s3://target-bucket/secret.txt . --no-sign-request

# Bucket name patterns to try
target.com
target-com
target-backup
target-dev
target-staging
target-assets
target-logs

# GrayhatWarfare - search exposed buckets
# grayhatwarfare.com/buckets
```

**AWS Metadata Service (SSRF Target):**
```
http://169.254.169.254/latest/meta-data/
http://169.254.169.254/latest/meta-data/iam/security-credentials/
http://169.254.169.254/latest/meta-data/iam/security-credentials/EC2-ROLE
```
If you get SSRF, hit the metadata endpoint → steal IAM credentials → escalate in AWS.

**AWS CLI Recon with Stolen Keys:**
```bash
aws configure  # Enter stolen key/secret
aws sts get-caller-identity    # Who am I?
aws iam list-users             # All IAM users
aws s3 ls                      # All S3 buckets
aws ec2 describe-instances     # All EC2 instances
aws secretsmanager list-secrets  # Stored secrets!
```

**Azure Recon:**
```bash
# Find Azure subdomains
*.azurewebsites.net
*.blob.core.windows.net
*.table.core.windows.net
*.queue.core.windows.net

# AADInternals for Azure AD recon
Get-AADIntTenantID -Domain target.com
Get-AADIntLoginInformation -Domain target.com
```

**GCP Recon:**
```bash
# Exposed GCS buckets
gsutil ls gs://target-backup  --no-auth-required
curl https://storage.googleapis.com/target-bucket/
```

**CloudEnum — Multi-Cloud Enumeration:**
```bash
python3 cloud_enum.py -k target -k target-corp -k targetco
# Checks AWS S3, Azure Blob, GCP Storage simultaneously
```

**Key Findings in Bug Bounty:**
- Public S3 buckets with customer data
- EC2 instance metadata SSRF → credential theft
- Misconfigured Azure AD with guest access
- Exposed GCP service account keys in GitHub',
'https://tryhackme.com/room/cloudsecuritybasics', 'TryHackMe', 50),

(38, 2, 'Building a Recon Methodology',
'## Building Your Personal Recon Methodology

Professional pentesters have a repeatable, systematic methodology. Today you build yours.

**Recon Framework — PTES Phase 1:**
```
1. Scope Definition
   ├── In-scope assets (IPs, domains, apps)
   ├── Out-of-scope (critical infrastructure, third-parties)
   └── Rules of engagement (hours, notification requirements)

2. Passive Recon (no target contact)
   ├── WHOIS / ARIN for IP ranges
   ├── DNS: A, MX, TXT, NS, CNAME records
   ├── Certificate Transparency (crt.sh, Censys)
   ├── Shodan / Censys for exposed services
   ├── Google dorks for exposed files
   ├── LinkedIn for employees and tech stack
   ├── GitHub for source code and secrets
   └── Wayback Machine for historical data

3. Active Recon (direct target contact)
   ├── Nmap: host discovery → port scan → service detection
   ├── DNS: zone transfer attempts, brute force subdomains
   ├── Web: directory/file brute force, JS analysis
   └── Service: banner grabbing per open port

4. Analysis
   ├── Map attack surface (all entry points)
   ├── Identify outdated software versions
   ├── Note authentication mechanisms
   └── Prioritize targets by exploitability × impact
```

**Recon Automation Script Template:**
```bash
#!/bin/bash
# hackpath-recon.sh — Full recon pipeline

TARGET=$1
OUTDIR="recon_$(date +%Y%m%d)_$TARGET"
mkdir -p "$OUTDIR"/{passive,active,web}

echo "[1/5] Passive DNS recon..."
amass enum -passive -d "$TARGET" -o "$OUTDIR/passive/subdomains.txt"

echo "[2/5] Certificate transparency..."
curl -s "https://crt.sh/?q=%.$TARGET&output=json" | \
  jq -r ''.[].name_value'' | sort -u >> "$OUTDIR/passive/subdomains.txt"

echo "[3/5] Port scanning..."
nmap -T4 -p- --min-rate 1000 "$TARGET" -oA "$OUTDIR/active/nmap_full"

echo "[4/5] Web discovery..."
cat "$OUTDIR/passive/subdomains.txt" | while read sub; do
  gobuster dir -u "https://$sub" -w "$SECLISTS/common.txt" -q -o "$OUTDIR/web/$sub.txt" 2>/dev/null &
done
wait

echo "[5/5] Report: $(wc -l < $OUTDIR/passive/subdomains.txt) subdomains, checking Shodan..."
shodan search "hostname:$TARGET" --fields ip_str,port,org > "$OUTDIR/passive/shodan.txt"

echo "[✓] Recon complete: $OUTDIR/"
```

**Document Everything.** Your recon notes become your pentest report findings.',
'https://tryhackme.com/room/activerecon', 'TryHackMe', 50),

(39, 2, 'OSINT for Bug Bounty',
'## OSINT for Bug Bounty Hunting

Bug bounty programs pay researchers to find vulnerabilities. OSINT determines your scope and attack surface — maximizing findings.

**Reading a Bug Bounty Brief:**
```yaml
# Example: HackerOne program brief
Scope:
  In-scope:
    - *.example.com
    - api.example.com  
    - iOS app (com.example.app)
  Out-of-scope:
    - blog.example.com (third-party)
    - employee accounts

Rewards:
  Critical: $5,000 - $15,000
  High:     $1,000 - $5,000
  Medium:   $300 - $1,000
  Low:      $50 - $300
```

**Maximizing Attack Surface:**
1. `*.example.com` = ALL subdomains in scope → enumerate aggressively
2. Mobile apps → decompile for hardcoded keys, API endpoints
3. API scope → check for unauthenticated endpoints, BOLA vulnerabilities

**Bug Bounty Recon Stack:**
```bash
# Subdomain enumeration (all methods combined)
amass enum -d example.com -passive -o subs_passive.txt
github-subdomains -d example.com -t GITHUB_TOKEN -o subs_github.txt
subfinder -d example.com -o subs_subfinder.txt
cat subs_*.txt | sort -u > all_subs.txt

# HTTP probing (find live servers)
cat all_subs.txt | httprobe > live_hosts.txt
# or: cat all_subs.txt | httpx -silent > live_hosts.txt

# Screenshot all live hosts
gowitness file -f live_hosts.txt
eyewitness -f live_hosts.txt --web

# Scan all live hosts
nuclei -l live_hosts.txt -severity critical,high -o nuclei_findings.txt
```

**JavaScript Recon (High-Value):**
```bash
# Extract all JS files from live hosts
cat live_hosts.txt | waybackurls | grep ".js" | sort -u > js_files.txt

# Find API endpoints in JS
cat js_files.txt | xargs -I{} curl -s {} | grep -oP ''/api/[a-zA-Z/]+''

# Secret scanning
cat js_files.txt | xargs -I{} curl -s {} | grep -i "api_key\|secret\|password\|token"
```

**Low-Hanging Fruit Checklist:**
- [ ] CORS misconfiguration on API endpoints
- [ ] Open redirects in `redirect=`, `url=`, `next=` parameters
- [ ] Subdomain takeover (unclaimed CNAME targets)
- [ ] Exposed .git directory
- [ ] Default credentials on admin panels
- [ ] Unauthenticated API endpoints
- [ ] Information disclosure in error messages

**Program Selection Tips:**
- New programs have more unresearched surface
- Programs with "no reward limit" = more motivation
- Private programs (invitation only) = less competition',
'https://tryhackme.com/room/bugbountyintro', 'TryHackMe', 50),

(40, 2, 'Phase 2 Review — Recon Mastery',
'## Phase 2 Complete: Reconnaissance Mastery

You have completed the reconnaissance phase. This is arguably the most important phase — great pentesters spend 40% of their time on recon.

**Phase 2 Recap:**

✅ **OSINT:** Public sources, WHOIS, Hunter.io, LinkedIn, GitHub secret scanning

✅ **Google Dorking:** Exposed files, admin panels, database files, credentials

✅ **Shodan/Censys:** Internet-facing services, vulnerable versions, exposed devices

✅ **DNS Recon:** Zone transfers, subdomain enumeration, Certificate Transparency

✅ **Nmap:** All scan types, NSE scripts, service detection, OS fingerprinting

✅ **Service Enumeration:** HTTP, FTP, SSH, SMTP, SNMP, SMB, MySQL

✅ **Web Discovery:** Gobuster, FFUF, Feroxbuster, JS analysis

✅ **Cloud Recon:** AWS S3 buckets, Azure AD, GCP Storage

✅ **Bug Bounty OSINT:** Full automated recon pipeline

**CTF Practice:** Complete the "Advent of Cyber" on TryHackMe — 25 days of beginner-friendly challenges covering recon, web, and scripting.

**Phase 3 Preview — Exploitation Basics:**
Days 41–60 cover the transition from finding vulnerabilities to actually exploiting them:
- Metasploit deep dive
- Reverse and bind shells
- Password attacks (Hydra, Hashcat, John)
- File upload vulnerabilities
- Buffer overflows (x86 Linux and Windows)
- SQL Injection (manual and automated)
- Cross-Site Scripting (XSS)

**XP Milestone:** With Phase 2 complete, you''ve earned ~2,000 XP. Level: **Exploit Rookie**. The skill tree should show your Reconnaissance branch fully lit up in green.

**Real Talk:** Real-world recon takes days to weeks. Every service you find, every subdomain, every exposed file is a potential attack vector. The more thorough your recon, the more vulnerabilities you find.',
'https://tryhackme.com/room/nmap01', 'TryHackMe', 75)

on conflict (id) do nothing;
