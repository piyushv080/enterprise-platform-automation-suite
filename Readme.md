# Enterprise Platform Automation Suite

> A curated portfolio of enterprise platform automation covering  
> ServiceNow ITSM, CyberArk Privileged Access, and proof-of-concept integrations built for large-scale IT operations.

![ServiceNow](https://img.shields.io/badge/ServiceNow-Yokohama-green?style=flat-square&logo=servicenow)
![CyberArk](https://img.shields.io/badge/CyberArk-PAM-blue?style=flat-square)
![Ansible](https://img.shields.io/badge/Ansible-Automation-red?style=flat-square&logo=ansible)
![Python](https://img.shields.io/badge/Python-3.x-blue?style=flat-square&logo=python)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=flat-square&logo=powershell)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI%2FCD-black?style=flat-square&logo=githubactions)

---

## About This Repository

This is a personal automation portfolio focused on enterprise platform integrations.  
The modules demonstrate real-world automation patterns used in enterprise environments, built using personal lab setups and public documentation.

**Stack:** ServiceNow · Ansible · Python · PowerShell · REST APIs · GitHub Actions  

---

## Modules

### 1. ServiceNow Automation

```
servicenow/
├── incident-automation/
├── change-management/
├── cmdb-automation/
├── catalog-automation/
├── flow-designer/
└── ansible-integration/
```

**Key capabilities:**
- Incident lifecycle automation using REST APIs  
- CMDB auto-updates after provisioning  
- Catalog fulfillment via Ansible AWX  
- Flow Designer integrations  

---

### 2. CyberArk Integration

```
cyberark/
├── ansible-playbooks/
│   ├── onboard-account.yml
│   ├── offboard-account.yml
│   └── rotate-credentials.yml
├── powershell/
│   ├── Get-CyberArkToken.ps1
│   ├── Add-AccountToSafe.ps1
│   ├── Get-AccountCredential.ps1
│   └── Remove-Account.ps1
└── integration/
    ├── servicenow-cyberark/
    └── ansible-cyberark/
```

**Key capabilities:**
- Account onboarding/offboarding via API  
- Secure credential retrieval  
- No hardcoded secrets  

---

### 3. Proof of Concept (POC)

```
poc/
├── servicenow-ansible-awx/
├── cyberark-ansible-integration/
├── servicenow-cmdb-sync/
└── end-to-end-provisioning/
```

**End-to-End Flow:**
ServiceNow → Approval → AWX → Provision → CMDB → CyberArk → Close

---

## GitHub Actions

- auto-merge-dev-to-main.yml
- setup-folder-structure.yml

---

## Technology Stack

- ServiceNow
- Ansible / AWX
- CyberArk
- Python
- PowerShell
- GitHub Actions
---

## Prerequisites

- ServiceNow instance
- CyberArk lab
- Ansible AWX
- Python 3.x
- PowerShell 5.1+

---

## Disclaimer

No proprietary or confidential data included.

---

## Connect

LinkedIn: https://linkedin.com/in/piyushv080  
GitHub: https://github.com/piyushv080

---

Built for enterprise-grade automation.
