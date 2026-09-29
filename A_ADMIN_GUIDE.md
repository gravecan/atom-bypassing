# 🔐 Atomic Auth - Admin Guide

## 🌐 YOUR VPS INFO

**Server:** 44.195.19.197  
**Backend Port:** 8080  
**MongoDB Port:** 27017 (internal only)  
**SSH Key:** `C:\\Users\\Opsec\\Downloads\\atomickey.pem`

\---

## 🔌 HOW TO ACCESS VPS

### **From Windows (PowerShell or CMD):**

```powershell
ssh -i "C:\\Users\\Opsec\\Downloads\\atomickey.pem" ubuntu@44.195.19.197
```

You'll see:

```
ubuntu@ip-172-31-9-176:\~$
```

✅ You're now inside your VPS!

\---

## 👥 HOW TO ADD USERS (LICENSE KEYS)

### **STEP 1: Connect to VPS**

```powershell
ssh -i "C:\\Users\\Opsec\\Downloads\\atomickey.pem" ubuntu@44.195.19.197
```

### **STEP 2: Open MongoDB**

```bash
mongosh
```

You'll see: `test>`

### **STEP 3: Select Atomic Database**

```javascript
use atomic
```

You'll see: `switched to db atomic`

### **STEP 4: Create New License Key**

```javascript
db.keys.insertOne({
    key: "ATOMIC-Z3X8-C5V2-B7N4-M9QW",
    username: "NewUserName",
    hwid: null,
    expired: false,
    banned: false,
    createdAt: new Date()
})
```

✅ Done! New license key created!

\---

## 📊 MONGODB COMMANDS CHEAT SHEET

### **1. View All License Keys:**

```javascript
db.keys.find()
```

Prettier output:

```javascript
db.keys.find().pretty()
```

### **2. View Specific Key:**

```javascript
db.keys.findOne({ key: "ATOMIC-Z3X8-C5V2-B7N4-M9QW" })
```

### **3. Count Total Keys:**

```javascript
db.keys.countDocuments()
```

### **4. Find Keys by Username:**

```javascript
db.keys.find({ username: "NewUserName" })
```

### **5. Find All Active (Not Banned) Keys:**

```javascript
db.keys.find({ banned: false, expired: false })
```

### **6. Find Keys with HWID Set:**

```javascript
db.keys.find({ hwid: { $ne: null } })
```

### **7. Find Unused Keys (No HWID Yet):**

```javascript
db.keys.find({ hwid: null })
```

\---

## ✏️ EDIT EXISTING KEYS

### **Change Username:**

```javascript
db.keys.updateOne(
    { key: "ATOMIC-Z3X8-C5V2-B7N4-M9QW" },
    { $set: { username: "NewUsername" } }
)
```

### **Reset HWID (Allow Key on New PC):**

```javascript
db.keys.updateOne(
    { key: "ATOMIC-Z3X8-C5V2-B7N4-M9QW" },
    { $set: { hwid: null } }
)
```

### **Ban a Key:**

```javascript
db.keys.updateOne(
    { key: "ATOMIC-Z3X8-C5V2-B7N4-M9QW" },
    { $set: { banned: true } }
)
```

### **Unban a Key:**

```javascript
db.keys.updateOne(
    { key: "ATOMIC-Z3X8-C5V2-B7N4-M9QW" },
    { $set: { banned: false } }
)
```

### **Expire a Key:**

```javascript
db.keys.updateOne(
    { key: "ATOMIC-Z3X8-C5V2-B7N4-M9QW" },
    { $set: { expired: true } }
)
```

### **Unexpire a Key:**

```javascript
db.keys.updateOne(
    { key: "ATOMIC-Z3X8-C5V2-B7N4-M9QW" },
    { $set: { expired: false } }
)
```

\---

## 🗑️ DELETE KEYS

### **Delete Specific Key:**

```javascript
db.keys.deleteOne({ key: "ATOMIC-Z3X8-C5V2-B7N4-M9QW" })
```

### **Delete All Banned Keys:**

```javascript
db.keys.deleteMany({ banned: true })
```

### **Delete All Expired Keys:**

```javascript
db.keys.deleteMany({ expired: true })
```

\---

## 📝 BULK CREATE KEYS

### **Create 10 Keys at Once:**

```javascript
for (let i = 1; i <= 10; i++) {
    db.keys.insertOne({
        key: "ATOMIC-USER" + i + "-2024",
        username: "User" + i,
        hwid: null,
        expired: false,
        banned: false,
        createdAt: new Date()
    });
}
```

### **Create Keys with Custom Format:**

```javascript
const keyNames = \["Alpha", "Beta", "Gamma", "Delta", "Sigma"];

keyNames.forEach(name => {
    db.keys.insertOne({
        key: "ATOMIC-" + name.toUpperCase() + "-2024",
        username: name + "User",
        hwid: null,
        expired: false,
        banned: false,
        createdAt: new Date()
    });
});
```

\---

## 🔍 EXPORT KEYS TO TEXT

### **Export All Keys to JSON:**

```javascript
db.keys.find().forEach(function(doc) {
    print(doc.key + " | " + doc.username + " | HWID: " + (doc.hwid || "Not set"));
});
```

### **Export Only Active Keys:**

```javascript
db.keys.find({ banned: false, expired: false }).forEach(function(doc) {
    print(doc.key + " | " + doc.username);
});
```

\---

## 🛠️ BACKEND MANAGEMENT

### **Check Backend Status:**

```bash
sudo systemctl status atomic-auth
```

Should say: `active (running)` in green

### **Restart Backend:**

```bash
sudo systemctl restart atomic-auth
```

### **Stop Backend:**

```bash
sudo systemctl stop atomic-auth
```

### **Start Backend:**

```bash
sudo systemctl start atomic-auth
```

### **View Live Logs:**

```bash
sudo journalctl -u atomic-auth -f
```

Press `Ctrl+C` to stop viewing logs.

### **View Last 100 Log Lines:**

```bash
sudo journalctl -u atomic-auth -n 100
```

\---

## 📊 MONITOR CONNECTIONS

### **See Who's Currently Logged In:**

When you view logs, you'll see:

```
\[ATOMIC] Client connected: 1.2.3.4
\[ATOMIC] Login success - User: TestUser (ATOMIC-TEST-2024)
```

### **Check Open Connections to Port 8080:**

```bash
sudo netstat -tulpn | grep 8080
```

\---

## 🔐 MONGODB BACKUP

### **Create Backup:**

```bash
mongodump --db atomic --out /home/ubuntu/backup-$(date +%Y%m%d)
```

### **Restore Backup:**

```bash
mongorestore --db atomic /home/ubuntu/backup-20260812/atomic
```

### **Download Backup to Windows:**

From Windows PowerShell:

```powershell
scp -i "C:\\Users\\Opsec\\Downloads\\atomickey.pem" -r ubuntu@44.195.19.197:/home/ubuntu/backup-20260812 C:\\Users\\Opsec\\Downloads\\
```

\---

## 📋 COMMON WORKFLOWS

### **Add New Customer:**

1. Connect to VPS: `ssh -i atomickey.pem ubuntu@44.195.19.197`
2. Open MongoDB: `mongosh`
3. Select database: `use atomic`
4. Create key:

```javascript
   db.keys.insertOne({
       key: "ATOMIC-CUSTOMER123-2024",
       username: "Customer123",
       hwid: null,
       expired: false,
       banned: false,
       createdAt: new Date()
   })
   ```

5. Give customer the key: `ATOMIC-CUSTOMER123-2024`

### **Customer Changed PC (HWID Reset):**

1. Connect to VPS
2. Open MongoDB: `mongosh` → `use atomic`
3. Reset HWID:

```javascript
   db.keys.updateOne(
       { key: "ATOMIC-CUSTOMER123-2024" },
       { $set: { hwid: null } }
   )
   ```

4. Tell customer to login again

### **Customer Refund/Ban:**

1. Connect to VPS
2. Open MongoDB: `mongosh` → `use atomic`
3. Ban key:

```javascript
   db.keys.updateOne(
       { key: "ATOMIC-CUSTOMER123-2024" },
       { $set: { banned: true } }
   )
   ```

### **Check If Key Is Used:**

```javascript
db.keys.findOne({ key: "ATOMIC-CUSTOMER123-2024" })
```

If `hwid` is `null` → Not used yet  
If `hwid` has value → Already activated

\---

## 🔒 SECURITY TIPS

### **1. Change MongoDB Password:**

```bash
mongosh
use atomic
db.updateUser("atomic", { pwd: "NewStrongPassword123!" })
exit
```

Then update backend:

```bash
nano /home/ubuntu/atomic-backend-config.txt
```

Or rebuild backend with new password.

### **2. Backup Your SSH Key:**

Copy `C:\\Users\\Opsec\\Downloads\\atomickey.pem` to a safe location!

### **3. Regular Backups:**

Set up automatic daily backups:

```bash
crontab -e
```

Add:

```
0 3 \* \* \* mongodump --db atomic --out /home/ubuntu/backups/$(date +\\%Y\\%m\\%d)
```

This backs up at 3 AM daily.

\---

## 🆘 TROUBLESHOOTING

### **"Connection refused"**

Check if backend is running:

```bash
sudo systemctl status atomic-auth
```

If stopped, start it:

```bash
sudo systemctl start atomic-auth
```

### **"Can't login to MongoDB"**

```bash
mongosh -u atomic -p AtomicPass123 --authenticationDatabase atomic
```

### **"Backend won't start"**

View error logs:

```bash
sudo journalctl -u atomic-auth -n 50
```

### **"Forgot MongoDB password"**

1. Stop MongoDB:

```bash
   sudo systemctl stop mongod
   ```

2. Start MongoDB without auth:

```bash
   sudo mongod --dbpath /var/lib/mongodb --noauth --fork --logpath /var/log/mongodb/mongod.log
   ```

3. Reset password:

```bash
   mongosh
   use atomic
   db.updateUser("atomic", { pwd: "NewPassword" })
   exit
   ```

4. Restart normally:

```bash
   sudo killall mongod
   sudo systemctl start mongod
   ```

\---

## 📞 QUICK REFERENCE

|Task|Command|
|-|-|
|Connect to VPS|`ssh -i atomickey.pem ubuntu@44.195.19.197`|
|Open MongoDB|`mongosh` → `use atomic`|
|Create key|`db.keys.insertOne({key:"KEY",username:"NAME",hwid:null,expired:false,banned:false,createdAt:new Date()})`|
|View all keys|`db.keys.find()`|
|Reset HWID|`db.keys.updateOne({key:"KEY"},{$set:{hwid:null}})`|
|Ban key|`db.keys.updateOne({key:"KEY"},{$set:{banned:true}})`|
|Backend status|`sudo systemctl status atomic-auth`|
|View logs|`sudo journalctl -u atomic-auth -f`|
|Restart backend|`sudo systemctl restart atomic-auth`|

\---

## 🎓 EXAMPLE SESSION

```bash
# Connect to VPS
C:\\> ssh -i "C:\\Users\\Opsec\\Downloads\\atomickey.pem" ubuntu@44.195.19.197

# Open MongoDB
ubuntu@ip:\~$ mongosh

# Select database
test> use atomic

# Create new key
atomic> db.keys.insertOne({
    key: "ATOMIC-JOHN-2024",
    username: "John",
    hwid: null,
    expired: false,
    banned: false,
    createdAt: new Date()
})

# Verify it was created
atomic> db.keys.findOne({ key: "ATOMIC-JOHN-2024" })

# Exit MongoDB
atomic> exit

# Check backend logs
ubuntu@ip:\~$ sudo journalctl -u atomic-auth -n 10

# Disconnect from VPS
ubuntu@ip:\~$ exit
```

\---

**You're all set! Save this guide for managing your auth system!** 🚀

