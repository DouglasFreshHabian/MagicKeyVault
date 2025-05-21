<h1 align="center">
🔮 MagicKeyVault
	</h1>
 
<p align="center">
  <img src="https://github.com/DouglasFreshHabian/MagicKeyVault/blob/main/Graphics/Tux-The-Sorcerer.png" alt="My Image" width="400">
</p>


<h1 align="center">
Magic SysRq Key: An Essential Guide 🛠️
	</h1>

The **SysRq (System Request)** key, also known as the **PrintScreen** key, is a powerful tool in Linux systems that allows you to send low-level commands for system debugging, recovery, and emergency shutdowns. This guide explains how to work with the SysRq key, how to configure it, and what the different functions mean. 

---

### 1. **Determine Your Kernel Version** 🖥️

First, check the kernel release version:

```bash
uname -r
````

Example output:

```
6.8.0-59-generic
```

---

### 2. **Check SysRq Configuration in Kernel** 🔍

Check the kernel configuration file for the **CONFIG\_MAGIC\_SYSRQ** option:

```bash
ls /boot/config-6.8.0-59-generic
```

Ensure the **CONFIG\_MAGIC\_SYSRQ** option is enabled for SysRq key functionality:

```bash
grep -i CONFIG_MAGIC_SYSRQ /boot/config-6.8.0-59-generic
```

Example output:

```
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x01b6
CONFIG_MAGIC_SYSRQ_SERIAL=y
```

---

### 3. **Current SysRq Value** 📊

Check the current value of SysRq:

```bash
cat /proc/sys/kernel/sysrq
```

Example output:

```
176
```

### 4. **Understanding the SysRq Value** 🧠

The SysRq value is a bitmask determining which SysRq functions are enabled:

| Bit Value | Function                                |
| --------- | --------------------------------------- |
| 0         | Disable SysRq completely                |
| 1         | Enable all functions of SysRq           |
| 2         | Control console logging level           |
| 4         | Control keyboard (SAK, unraw)           |
| 8         | Debugging dumps of processes            |
| 16        | Sync all mounted filesystems            |
| 32        | Remount filesystems read-only           |
| 64        | Signal processes (term, kill, oom-kill) |
| 128       | Allow reboot/poweroff                   |
| 256       | Nicing of all RT tasks                  |

For example, **176** means:

* **128**: Catch-all (reboot/poweroff).
* **32**: Signal processes (kill, term, etc.).
* **16**: Remount read-only.

So, your system has **reboot**, **process signaling**, and **read-only remount** functions enabled.

---

### 5. **How to Change SysRq Value (Immediately)** 🔄

To change the SysRq value temporarily:

```bash
echo "1" > /proc/sys/kernel/sysrq
```

---

### 6. **Make SysRq Changes Persistent** ⚙️

To make the SysRq setting persistent across reboots, add it to the **99-sysctl.conf** file:

```bash
echo "kernel.sysrq = 1" >> /etc/sysctl.d/99-sysctl.conf
```

---

### 7. **The Famous `reisub` Sequence** 🐘

The **reisub** key sequence is a well-known emergency recovery tool, especially when the system becomes unresponsive. Here's what happens when you hold **Alt + SysRq** and press the keys in sequence:

* **r**: Switch the keyboard from raw to XLATE mode.
* **e**: Send SIGTERM to gracefully terminate processes.
* **i**: Send SIGKILL to force terminate unresponsive processes.
* **s**: Sync all mounted filesystems (flush cache to disk).
* **u**: Remount all filesystems as read-only.
* **b**: Reboot the system.

The **reisub** sequence is a safe way to recover a frozen system.

---

### 8. **SysRq Command Key List** 📝

SysRq commands are powerful and can help with system management in an emergency. For a complete list, check out the **SysRq** kernel documentation:

[Linux Magic System Request Key Hacks](https://www.kernel.org/doc/html/latest/admin-guide/sysrq.html)

---

### 9. **Understanding SysRq Bitmask (176)** 📊

To decode the SysRq value, use the following command:

```bash
awk '{ for(i=0;i<9;i++) if(and($1,2^i)) print 2^i }' /proc/sys/kernel/sysrq
```

This command breaks down the enabled SysRq functions in the system based on the bitmask value.

---

### 10. **Enabling All SysRq Functions** 🚀

To enable all SysRq functions, set the value to **1** (basic control) or **255** (full access):

```bash
echo 255 | sudo tee /proc/sys/kernel/sysrq
```

To make it persistent:

```bash
echo 'kernel.sysrq = 255' | sudo tee -a /etc/sysctl.d/99-sysctl.conf
```

---

### 11. **Best Practices for Production/Secure Environments** 🔐

In production environments or sensitive systems, consider restricting SysRq access for security:

* **0**: Disable all SysRq functions (max security).
* **1**: Enable basic output control (safe-ish).
* **16**: Allow read-only remount for emergency recovery.

To disable SysRq completely for added security:

```bash
echo 0 | sudo tee /proc/sys/kernel/sysrq
```

Make it persistent:

```bash
echo 'kernel.sysrq = 0' | sudo tee -a /etc/sysctl.d/99-disable-sysrq.conf
```

---

### TL;DR 📝

* **176** is a non-dangerous but non-minimal setting, allowing several SysRq functions.
* For **secure environments**, set **0** to completely disable SysRq.
* For **personal systems**, **176** or **255** is typically fine.
* Always ensure the correct configuration for your system’s needs.

---

### ✅ Recommended SysRq Setting for Paranoids

Set the value to **0** to disable all SysRq functions for maximum security:

```bash
echo 0 | sudo tee /proc/sys/kernel/sysrq
```

Make the change persistent:

```bash
echo 'kernel.sysrq = 0' | sudo tee -a /etc/sysctl.d/99-disable-sysrq.conf
```

Then apply:

```bash
sudo sysctl -p
```
---

## `magicKey.sh` Script 🔮

This script automates the process of checking the **SysRq (System Request) functionality** on a Linux system. It performs the following tasks:

### Key Features: 🌀
<details> 

 <summary>🖱 Click to Expand</summary>
 
1. **Kernel Version Check:**

   * It checks and displays the current Linux kernel version using the `uname -r` command.

2. **Kernel Configuration Check:**

   * It searches for the `CONFIG_MAGIC_SYSRQ` option in the kernel configuration file (located in `/boot/config-$(uname -r)`) to verify if SysRq functionality is enabled.

3. **Current SysRq Value Breakdown:**

   * It reads the current SysRq value from `/proc/sys/kernel/sysrq`, which is a bitmask determining which SysRq functions are enabled.
   * The script breaks down the SysRq value into its component flags, explaining which specific functions are enabled or disabled based on the bitmask.

4. **Colorful and Informative Output:**

   * The script uses colorful output to make the results more readable and visually engaging.
   * It displays the ASCII banner in a random color for added flair.
   * Each SysRq function is clearly labeled with its description (e.g., "Allow reboot/poweroff enabled").

5. **Error Handling:**

   * The script checks for the presence of necessary files (`/boot/config-$(uname -r)` and `/proc/sys/kernel/sysrq`), and provides informative error messages if these files are missing or inaccessible.

6. **SysRq Flags Explanation:**

   * For each enabled flag in the SysRq value, the script provides a detailed explanation, helping you understand the various functions like syncing filesystems, remounting filesystems as read-only, or sending kill signals to processes.

7. **Reserved Values Handling:**

   * It includes support for reserved values in the SysRq bitmask, notifying the user if a certain flag is reserved for future use or custom functions.
</details>

### How to Use: 🔧

1. Clone or download the script:

   ```bash
   git clone https://github.com/DouglasFreshHabian/MagicKeyVault.git
   ```

2. Navigate to the directory containing the script:

   ```bash
   cd MagicKeyVault
   ```

3. Make the script executable:

   ```bash
   chmod +x magicKey.sh
   ```

4. Run the script:

   ```bash
   ./magicKey.sh
   ```

The script will output the current kernel version, check the `CONFIG_MAGIC_SYSRQ` settings, and break down the current SysRq value to show which functions are enabled.

---


## 💬 Feedback & Contributions

Got ideas, bug reports, or improvements?
Feel free to open an issue or submit a pull request!

## 💖 Support This Project

If MagicKeyVault™ has helped you or your system, consider supporting the project!  
Your contributions help fuel future updates, testing, and new features.

Every bit of support is appreciated — thank you!


  <h2 align="center"> 
  <a href="https://www.buymeacoffee.com/dfreshZ" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>




<!-- Reach out to me if you are interested in collaboration or want to contract with me for any of the following:
	Building Github Pages
	Creating Youtube Videos
	Editing Youtube Videos
	Youtube Thumbnail Creation
	Anything Pertaining to Linux! -->

<!-- 
 _____              _       _____                        _          
|  ___| __ ___  ___| |__   |  ___|__  _ __ ___ _ __  ___(_) ___ ___ 
| |_ | '__/ _ \/ __| '_ \  | |_ / _ \| '__/ _ \ '_ \/ __| |/ __/ __|
|  _|| | |  __/\__ \ | | | |  _| (_) | | |  __/ | | \__ \ | (__\__ \
|_|  |_|  \___||___/_| |_| |_|  \___/|_|  \___|_| |_|___/_|\___|___/
        dfresh@tutanota.com Fresh Forensics, LLC 2025 -->
