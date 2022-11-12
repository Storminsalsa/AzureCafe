[GETTING STARTED ARTICLE](asp-net-core/asp-net-core.md)

[CUSTOM METRICS](asp-net-core/custom-metrics.md)

# Azure Cafe Application Insights sample application

The Azure Cafe sample application demonstrates the implementation of Application Insights in an ASP.NET Core application.

- [Azure Cafe Application Insights sample application](#azure-cafe-application-insights-sample-application)
  - [Application architecture](#application-architecture)
  - [Prerequisites](#prerequisites)
  - [Deployment of the starter application](#deployment-of-the-starter-application)
    - [Deploy the supporting Azure resources](#deploy-the-supporting-azure-resources)
    - [Download application source code](#download-application-source-code)
    - [Deploy the database project](#deploy-the-database-project)
    - [Deploy the web application project](#deploy-the-web-application-project)
    - [Clean up](#clean-up)

## Application architecture

The Azure Cafe application consists of an ASP.NET Core web application that serves information about local cafes including reviews and menu items. A review consists of a name, rating (on a sale of 1-5), a description, and the option to upload an image. Cafe data is stored in an Azure SQL database and review images are stored in Azure Storage. When submitting a review, the application also interfaces with a Language Service to determine the review sentiment through Sentiment Analysis.

![Azure Cafe application architecture.](./media/azure-cafe-app-insights.png "Azure Cafe application architecture")

## Prerequisites

- [Visual Studio 2022](https://visualstudio.microsoft.com/vs/)
- Visual Studio Workloads: ASP.NET and web development, Data storage and processing, and Azure development
- Azure subscription and user account (with the ability to create and delete resources)

## Deployment of the starter application

Deploy the starter application solution when following the [Application Insights for ASP.NET Core applications](https://docs.microsoft.com/azure/azure-monitor/app/asp-net-core) article.

> [!TIP]
> If you wish to deploy the final version of the source code without running through the steps of the article, proceed with the following steps but utilize the `2 - Completed Application` folder instead.

### Deploy the supporting Azure resources

1. Sign into the [Azure Portal](https://portal.azure.com).

2. In the upper-right of the portal screen, open a cloud shell instance.

   ![The top right menu of the Azure Portal displays with the Cloud Shell icon highlighted.](media/portal_cloud_shell_icon.png "Azure Cloud Shell")

3. Choose **PowerShell** as the language. If prompted, create a cloud shell storage account.

   ![A portion of the cloud shell displays with PowerShell highlighted as the selected language.](media/portal_cloud_shell_powershell_language.png "Select PowerShell as the language")

4. Create a user context by issuing the following command. Follow the prompts to authenticate with your Azure Portal credentials.

    ```powershell
    az login
    ```

5. Optionally, set the Azure Subscription using the following command, replacing SUBSCRIPTION_ID with the desired Azure Subscription ID value.

    ```powershell
    az account set --subscription SUBSCRIPTION_ID
    ```

    ![An Azure Subscription page displays with the Subscription ID value highlighted.](media/azure_subscription_id.png "Azure Subscription ID")

6. Clone the sample repository using the following command.

    ```powershell
    git clone https://github.com/solliancenet/appinsights-azurecafe.git
    ```

7. Navigate to the deployment directory with the following command.

    ```powershell
    cd "appinsights-azurecafe/1 - Starter Application/deployment"
    ```

8. Execute the following command to initiate the deployment.

   ```powershell
   terraform init
   ```

9. Perform the deployment using the following command.

    ```powershell
    terraform apply
    ```

10. When prompted, enter your IP address. You can retrieve this value by visiting [IP Chicken](https://ipchicken.com).

    ![A prompt displays requesting an IP address.](media/ip_address_prompt.png "IP address prompt")

11. When the list of resources to be deployed displays, type `yes` and press <kbd>Enter</kbd> to continue.

    ![A prompt displays asking to perform the deployment actions, yes is typed at the prompt.](media/terraform_prompt_to_deploy.png "Deployment prompt")

12. Deployment will take up to 5 minutes to complete. Once completed, retrieve the Azure SQL password by executing the following command. Record this value for use when deploying the database project.

    ```powershell
    terraform output sql_server_password
    ```

### Download application source code

1. In a web browser, visit the [source code repository page](https://github.com/solliancenet/appinsights-azurecafe) on GitHub.

2. Expand the **Code** button, and select the **Download ZIP** option.

3. Extract the ZIP archive to the desired working directory.

    ![The Code button is expanded with the Download Zip option highlighted.](media/download_zip.png "Download ZIP")

### Deploy the database project

1. Use Visual Studio to open the `\1 - Starter Application\database\AzureCafeSqlDatabase.sln` file from the extracted ZIP. Ensure you are logged into Visual Studio with the same account as your Azure Portal account.

2. In the **Solution Explorer** panel, right-click the **AzureCafeSqlDatabase** project and select **Publish**.

   ![The Visual Studio Solution Explorer panel displays with the context menu showing and the Publish item highlighted.](media/database_project_publish_menu.png "Publish the database project")

3. In the **Publish Database** dialog, select the **Edit** button next to the **Target database connection** field.

    ![The Publish Database dialog displays with the Edit button highlighted next to the Target database connection field.](media/publish_database_edit_target_button.png "Edit Target database connection")

4. In the **Connect** dialog, select the **Browse** tab. Expand the **Azure** section, and locate and select the **AzureCafeSqlDatabase** item. In the bottom panel, enter the password that was recorded when deploying the Azure resources. Select **OK**.

    ![The AzureCafeSqlDatabase is selected with the Password field and OK button highlighted.](media/select_azure_database_connection.png "Select the AzureCafeSqlDatabase")

5. On the **Publish Database** dialog, select the **Publish** button.

    ![The Publish Database dialog displays with the Publish button highlighted.](media/publish_database_dialog_publish_button.png "Publish Database dialog")

6. Wait a few minutes while the database project is deployed. Once completed, close Visual Studio.

    ![The Data Tools Operations panel displays indicating the database was published successfully.](media/database_publish_completed.png "Data Tools Operations panel")

### Deploy the web application project

1. Use Visual Studio to open the `\1 - Starter Application\src\AzureCafe.sln` file from the extracted ZIP. Ensure you are logged into Visual Studio with the same account as your Azure Portal account.

2. In the **Solution Explorer** panel, right-click the **AzureCafe** project and select **Publish**.

    ![The Visual Studio Solution Explorer panel displays with the project context menu expanded and the Publish item selected.](media/azurecafe_web_publish_menu.png "Publish web app")

3. In the **Publish** dialog **Target** step, select **Azure**, then **Next**.

    ![The Publish dialog displays with Azure selected, the Next button is highlighted.](media/publish_target.png "Publish Target")

4. In the **Publish** dialog **Specific target** step, select **Azure App Service (Windows)**. Select **Next**.

    ![The Publish dialog displays with Azure App Service (Windows) selected and the Next button highlighted.](media/publish_specific_target.png "Publish specific target")

5. In the **Publish** dialog **App Service** step, select the **azure-dave-web-{suffix}** item, then select **Finish**.

    ![The publish dialog displays the azure-cafe-web-{suffix} web application selected with the Finish button highlighted.](media/publish_appservice.png "Publish App Service")

6. On the created publish profile, select the **Publish** button.

    ![The publish profile displays with the Publish button highlighted.](media/visualstudio_publishprofile_publish_button.png "Publish profile")

7. Once publishing has succeeded, a browser window displays with the web application.

    ![A browser window displays the Azure Cafe web application.](media/azurecafe_web_application.png "Azure Cafe web application")

8. Return to the [Application Insights for ASP.NET Core applications](https://docs.microsoft.com/azure/azure-monitor/app/asp-net-core) article and learn to implement Application Insights.

### Clean up

When you have completed following along with the article, clean up all deployed resources.

1. Log into the [Azure Portal](https://portal.azure.com), and open a Cloud Shell instance. Select the **PowerShell** language.

2. Establish a user context by executing the following command. Follow the prompts to authenticate.

    ```powershell
    az login
    ```

3. Optionally, set the Azure Subscription using the following command, replacing SUBSCRIPTION_ID with the desired Azure Subscription ID value.

    ```powershell
    az account set --subscription SUBSCRIPTION_ID
    ```

4. Navigate to the deployment directory with the following command.

    ```powershell
    cd "appinsights-azurecafe/1 - Starter Application/deployment"
    ```

5. Remove all deployed resources by executing the following command, when prompted to continue, enter `yes`.

    ```powershell
    terraform destroy
    ```

6. Once completed. Execute the following command 3 times to return to the user directory.

    ```powershell
    cd..
    ```

7. Remove the cloned git repository by issuing the following command.

    ```powershell
    Remove-Item appinsights-azurecafe -recurse -force
    ```
