# CyberArk Integration

Ansible playbooks and PowerShell functions for CyberArk automation.

## Folder Structure

```
cyberark-integration/
├── ansible-playbooks/
│   ├── add-cyberark-account.yml       - Add account to CyberArk vault
│   ├── get-cyberark-account.yml        - Get/retrieve account from vault
│   ├── add-local-admin-cyberark.yml    - Add local admin account
│   ├── get-domain-by-server.yml        - DNS lookup for domain name
│   └── cyberark-login-logout.yml       - Login/logout with logging
└── powershell/
    └── cyberark-functions.ps1          - Add-CyberArkAccount and Get-CyberArkAccount functions
```

## Prerequisites
- CyberArk PAS / Privilege Cloud
- AIM (Application Identity Manager) configured
- Ansible with uri module
- PowerShell 5.1+ (for PS functions)
