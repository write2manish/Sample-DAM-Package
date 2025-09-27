# Sample-DAM-Package

This repository contains a sample Digital Asset Management (DAM) provider integration for Salesforce. It demonstrates how to create and manage provider instances and select assets (e.g., Unsplash) via Lightning Web Components and Apex.

Important: This is a sample application for demonstration and learning purposes only. It is not production ready.

## Overview
- Lightning Web Components
  - `lwc/damProviderInstanceForm`: Simple form to create a `DAM_Provider_Instance_Request__c` record
  - `lwc/damProviderInstanceDelete`: UI to delete a provider instance
  - `lwc/unsplashImagePicker`: Asset picker UI for Unsplash images
- Apex
  - `DamProviderInstanceAction`, `DamProviderInstanceAdmin`: Server-side logic for instance create/delete
  - `MyUnsplashAssetsController`: Server-side helper for Unsplash integration
  - `DamProviderInstanceTrigger`: Trigger supporting lifecycle operations
- Metadata
  - Custom object: `DAM_Provider_Instance_Request__c` and fields
  - Tabs for form and delete pages
  - CSP Trusted Sites for Unsplash endpoints
  - Provider metadata under `dgtAssetMgmtProviders` and component registration in `dgtAssetMgmtPrvdLghtCpnts`

## Prerequisites
- Salesforce CLI installed (`sf`)
- Authorized Salesforce org (any alias of your choice)

## Getting Started

### Setting up your development environment

#### 1. Install Salesforce CLI
- **Download**: [Salesforce CLI Official Download Page](https://developer.salesforce.com/tools/sfdxcli)
- **Documentation**: [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- **Installation methods**: 
  - [Install via npm](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm)
  - [Install via standalone installer](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm)

#### 2. Install VS Code and Salesforce Extension Pack
- **VS Code**: [Download Visual Studio Code](https://code.visualstudio.com/)
- **Salesforce Extension Pack**: [Install from VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=salesforce.salesforcedx-vscode-pack)
- **Documentation**: [VS Code for Salesforce Development](https://developer.salesforce.com/tools/vscode/en/getting-started/install)

#### 3. Clone and setup this repository
```bash
# Clone the repository
git clone https://github.com/write2manish/Sample-DAM-Package.git
cd Sample-DAM-Package

# Authenticate with your Salesforce org
sf org login web -a <your-org-alias>

# Verify connection
sf org display -o <your-org-alias>
```

#### 4. Deploy to your target org
```bash
# Deploy all metadata
sf project deploy start -o <your-org-alias>

# Assign required permissions
sf org assign permset --name DAM_Provider_Instance_Access -o <your-org-alias>
```

### Additional Resources
- **Salesforce CLI Commands**: [Complete CLI Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
- **VS Code Salesforce Development**: [VS Code Salesforce Documentation](https://developer.salesforce.com/tools/vscode/en/)
- **Lightning Web Components**: [LWC Developer Guide](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- **Apex Development**: [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)

## Deploy
```bash
sf project deploy start -o <your-org-alias>
```

If needed, assign permissions:
```bash
sf org assign permset --name DAM_Provider_Instance_Access -o <your-org-alias>
```

## Use
- Open the org and navigate to the `DAM Provider Instance Form` tab
- Fill in the fields. Field-level help explains each input
- Submit to create a `DAM_Provider_Instance_Request__c` record for processing

### DAM Provider Admin app
- Launch the `DAM Provider Admin` app to access tabs for creating and deleting provider instances
- Use the `DAM Provider Instance Form` tab to create instance requests and `DAM Provider Instance Delete` to remove instances

## End-to-End manual test cases
- Open org
  - `sf org open -o <your-org-alias>`
- Access/permissions
  - Assign permission set `DAM_Provider_Instance_Access` to your user if not already assigned
- Create instance request
  - App Launcher → DAM Provider Admin → `DAM Provider Instance Form`
  - Enter: Provider Label (e.g., Unsplash), Instance Name, Instance Key, toggle Default as needed → Submit
  - Verify a `DAM_Provider_Instance_Request__c` record is created with `Status__c` progressing to Succeeded/Failed
- Validate request list
  - In DAM Provider Admin, open `DAM Provider Instance Form` or `DAM_Provider_Instance_Request__c` tab to confirm your request appears with expected status and fields
- Delete flow (optional)
  - Open `DAM Provider Instance Delete` tab → enter a Provider Instance Id → Delete → confirm success or handled error
- Navigate to Salesforce CMS Workspace
  - Open the Workspace -> Click Add Content -> Select News -> Select Add Image-> Click External Tab-> Select the image from the UI on the right -> Click Save
- Troubleshooting
  - If assets do not load, verify CSP Trusted Sites (`unsplash`, `unsplash_audio`, `unsplash_video`) and that your network allows those endpoints
  - ConnectApi operations depend on org configuration; errors are expected in some environments and should surface in `Error_Message__c`

## Notes and Limitations
- This is a sample app. It lacks production-grade error handling, telemetry, profiles/permissions hardening, robust validation, and security reviews
- External dependencies (e.g., Unsplash) may require additional setup and rate-limit considerations
- No SLAs, warranties, or support are provided

## Known issues / Troubleshooting
- Delete errors: If you see an error while deleting a provider instance, ensure related content/media assets are deleted first, then retry. Review the Managed Content delete API docs for details. The delete UI will surface a friendly message plus the underlying error when available.

## Local Testing
- LWC unit tests for `unsplashImagePicker` are included under `lwc/unsplashImagePicker/__tests__`. A full Jest setup is not bundled in this repo; integrate with your preferred tooling if needed

## License / Support
- Provided as-is for educational purposes. Review and adapt before any production use
