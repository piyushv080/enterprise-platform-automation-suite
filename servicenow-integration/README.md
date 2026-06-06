# ServiceNow Integration

Ansible playbooks for ServiceNow CMDB and CI automation.

## Folder Structure

```
servicenow-integration/
├── playbooks/
│   ├── add-ci-to-snow.yml          - Add CI to ServiceNow
│   ├── create-ci.yml               - Create CI via task import
│   ├── debug-facts.yml             - Debug host facts (FQDN, IP, MAC, Serial)
│   ├── retrieve-cmdb-items.yml     - Retrieve all CMDB items
│   ├── cmdb-item-info.yml          - Get specific CMDB item info
│   └── test-snow-connectivity.yml  - Test ServiceNow API connectivity
├── tasks/                          - Reusable task files
└── env-setup.sh                   - Environment variable setup
```

## Environment Variables Required

| Variable       | Description                        |
|----------------|------------------------------------|
| SN_HOST        | ServiceNow instance URL            |
| SN_USERNAME    | ServiceNow admin username          |
| SN_PASSWORD    | ServiceNow admin password          |

## Setup

source env-setup.sh

## Prerequisites
- Ansible with servicenow.itsm collection installed
- ServiceNow developer or production instance access
