# Azure Cowrie Deployment with Terraform

![Azure Cowrie Honeypot](assets/dashboard_view.png)

> [!NOTE]
> This project demonstrates the deployment of a Cowrie honeypot on Azure using Terraform, with a focus on modern log collection and analysis techniques. It includes a custom Azure Workbook for visualizing attack data.


## 🚀 Key Features

- **Infrastructure-as-Code**: Entirely provisioned via Terraform for repeatable deployments.

- Modern Log Pipeline: Replaced legacy agents with Azure Monitor Agent (AMA) and granular Data Collection Rules (DCR) for JSON log ingestion.

- Advanced KQL Analytics: Custom Kusto queries to parse Cowrie's JSON output into actionable security metrics.

- **Live Threat Mapping**: Integrated Azure Workbook with heatmaps showing global attacker locations.

## Architecture
![Architecture Diagram](assets/architecture_diagram.drawio.png)

## 🛠️ Technical Challenges & Solutions

- DCR Schema Validation: Solved "Invalid Payload" errors by strictly aligning stream_declarations with the expected Log Analytics custom table schema and implementing precise KQL transformations.

- Race Condition Management: Handled dpkg frontend lock conflicts between cloud-init and VM Extensions by implementing orchestrated delays (time_sleep) in the Terraform workflow.

## Disclaimer

This project is provided for educational purposes only. The author assumes no liability for any damages, financial loss, or legal consequences resulting from the use, misuse, or deployment of this infrastructure. Users are solely responsible for ensuring compliance with local laws and Azure’s Acceptable Use Policy. Deployment is at your own risk.

## License 
[MIT](LICENSE)