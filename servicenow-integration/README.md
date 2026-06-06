# ServiceNow Integration

Ansible playbooks for ServiceNow CMDB, CI, and Incident automation.

## Folder Structure

```
servicenow-integration/
├── playbooks/
│   ├── add-ci-to-snow.yml          - Add CI to ServiceNow
│   ├── create-ci.yml               - Create CI via task import
│   ├── debug-facts.yml             - Debug host facts (FQDN, IP, MAC, Serial)
│   ├── retrieve-cmdb-items.yml     - Retrieve all CMDB items
│   ├── cmdb-item-info.yml          - Get specific CMDB item info
│   ├── test-snow-connectivity.yml  - Test ServiceNow API connectivity
│   ├── incident-lifecycle.yml      - Full incident lifecycle (create, update, close)
│   ├── append-linux-server.yml     - Append new server to CI file
│   └── test-ci-creation.yml        - Test CI creation playbook
├── tasks/
│   └── create-ci-task.yml          - Reusable CI creation task
└── vars/
    └── create_ci.yaml              - Variable definitions for CI creation
```

## Environment Variables Required

| Variable     | Description                    |
|--------------|--------------------------------|
| SN_HOST      | ServiceNow instance URL        |
| SN_USERNAME  | ServiceNow admin username      |
| SN_PASSWORD  | ServiceNow admin password      |
| TEST_USER    | Test user for CI creation      |

## Prerequisites
- Ansible with `servicenow.itsm` collection installed
- ServiceNow developer or production instance access
