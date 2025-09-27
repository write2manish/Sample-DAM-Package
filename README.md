# Merged DAM Package (Sample)

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

## Notes and Limitations
- This is a sample app. It lacks production-grade error handling, telemetry, profiles/permissions hardening, robust validation, and security reviews
- External dependencies (e.g., Unsplash) may require additional setup and rate-limit considerations
- No SLAs, warranties, or support are provided

## Local Testing
- LWC unit tests for `unsplashImagePicker` are included under `lwc/unsplashImagePicker/__tests__`. A full Jest setup is not bundled in this repo; integrate with your preferred tooling if needed

## License / Support
- Provided as-is for educational purposes. Review and adapt before any production use
