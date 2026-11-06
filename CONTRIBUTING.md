# Contributing to DEOmorph FPGA

Thank you for your interest in contributing to the DEOmorph FPGA architecture and zero-trust AI routing framework. 

## Guidelines for Contributions
1. **No Proprietary Code in PRs:** Ensure any sample configurations, mock scripts, or pull requests contain strictly generic, open-source-safe dummy data. Do not commit real corporate schemas, internal API endpoints, or production credentials.
2. **Context Blinding Compliance:** When testing or documenting new model providers or routing strategies for OmniRoute, verify that the payload definitions do not implicitly leak system metadata or absolute file paths.
3. **Open-Source Licensing:** All contributions submitted to this repository will be released under the Apache License 2.0.

## How to Submit a Pull Request
* Fork the repository and create a feature branch (`feat/new-lut-provider` or `docs/update-compliance`).
* Test your `omniroute.json` routing matrices locally before pushing.
* Open a detailed pull request explaining how your contribution enhances the routing matrix or improves prompt shredding efficiency.
