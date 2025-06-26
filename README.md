
# VirtualBox Manager - PowerShell GUI

## Description

This PowerShell script provides a simple graphical interface to manage VirtualBox virtual machines (VMs). It allows you to:

- ✅ Create a virtual machine with custom RAM and storage.
- 🚀 Start a virtual machine.
- ❌ Delete a virtual machine.
- 🔁 Clone a virtual machine.
- 📦 Import or export a virtual machine using the OVA format.

The interface is built with **Windows Forms**, offering a user-friendly experience on Windows.

---

## Prerequisites

- 🖥️ **VirtualBox** installed with `VBoxManage` accessible in your system `PATH`.
- 💻 Windows with **PowerShell** installed.
- 🔑 Administrator rights are recommended for VM management.

---

## Installation

1. Download or copy the PowerShell file `VirtualBoxManager.ps1`.
2. Open PowerShell as Administrator.
3. Allow script execution if not already enabled:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

4. Run the script:

```powershell
.\VirtualBoxManager.ps1
```

---

## Features

### 🛠️ VM Management

- **Create a VM:** 
  - Set the VM name.
  - Specify RAM (in MB).
  - Specify disk storage size (in MB).

- **Start a VM:** 
  - Launches the selected VM in GUI mode.

- **Delete a VM:**
  - Unregisters the VM and deletes its disk files.

- **Clone a VM:**
  - Creates a copy of an existing VM with a new name.

- **Import a VM:**
  - Exports the selected VM to an OVA file (if not already existing).
  - Imports this OVA with a new VM name.

### 📜 VM List

- Displays the list of existing VMs in VirtualBox.
- A refresh button updates the list at any time.

---

## Usage

1. Run the script.
2. The GUI opens with three main sections:
   - **VM List** (top left).
   - **Create VM** (bottom left).
   - **Clone / Import VM** (bottom right).

3. Select a VM from the list to:
   - Start it.
   - Delete it.
   - Clone it.

4. Fill in the required fields to create or clone a VM.

---

## OVA Export Directory

Exports are automatically generated in the following directory:

```
C:\Users\<YourUsername>\VirtualBox VMs\Export\
```

---

## Author

- **Maxime Violette**  
📧 maxime.violette@etu.unilasalle.fr

---

## License

This project was created as part of a virtualization lab assignment.  
It is free to use and modify for educational purposes.

---
