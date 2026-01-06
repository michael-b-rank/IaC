# 🚀 Azure DevOps Pipelines: The Complete YAML Cheatsheet

### 0. Parameter Types
| DataType | Description | Usage Context | Example Syntax |
| :--- | :--- | :--- | :--- |
| `string` |	A single line of text (default type). Can be restricted to specific values using the `values` keyword.| General configuration,names,paths.| `- name: imageName`|
| `boolean` |	A true/false value.|	Conditional logic, toggles (e.g., `runCleanup: true`).|	`- name: runCleanup`|
| `number` |Any numeric value.|Versions, counts, sizes.|	`- name: buildCount`|
| `object` |	Any complex YAML structure (nested keys/values, lists).|Passing complex configurations or lists of items. Use this instead of `stringList` in templates.|`- name: vmList`|
| `step` |	Defines a single pipeline step/task|Passing a single, custom step definition to a template.|`- name: customStep`|
| `stepList` |	A sequence of one or more steps.|Passing a list of steps to run sequentially within a job/stage.|`- name: customSteps`|
| `job` |	A single pipeline job definition.|	Passing a custom job definition to an extending template.|`- name: customJob`|
| `jobList` |	A sequence of one or more jobs.|Passing a list of jobs to an extending template for execution|`- name: customJobs`|
| `stage` |	A single pipeline stage definition.|Passing a custom stage definition to an extending template.|`- name: customStage`|
| `stageList` |	A sequence of one or more stages.|Passing a list of stages to an extending template.|`- name: customStages`|

#### General Parameter Syntax
Parameters are always defined using the `parameters`: keyword in the YAML file.
```yaml
# In a template or main pipeline file
parameters:
  - name: paramName
    type: DataType
    default: defaultValue # Parameters require a default value or user input in the UI.
    # Use 'values' for string/number types to restrict choices
    # values:
    #   - value1
    #   - value2
```

#### General Parameter Syntax
Access parameter values using the template expression syntax `${{ parameters.paramName }}` within your pipeline code.
```yaml
steps:
- script: echo "The image name is ${{ parameters.imageName }}"
  displayName: 'Run script with version: ${{ parameters.buildCount }}'
```


#### Example: Using object to pass a list
The `stringList` type is not available in templates, so the `object` type is used to pass lists and is iterated using the `${{ each }}` expression.

```yaml
# templates/my-template.yml
parameters:
  - name: environments
    type: object
    default: []

jobs:
# Iterate through the object list named 'environments'
- ${{ each env in parameters.environments }}: 
  - job: DeployTo${{ env }}
    steps:
    - script: echo "Deploying to ${{ env }}"

# --- Main azure-pipelines.yml file that calls the template ---
extends:
  template: templates/my-template.yml
  parameters:
    environments:
      - Dev
      - QA
      - Prod
```


### 1. Core Pipeline Structure & Global Keywords

A pipeline is composed of stages, which contain jobs, which contain steps. 

| Keyword | Level | Description | Example Syntax |
| :--- | :--- | :--- | :--- |
| `name` | Pipeline | Defines the unique name/format for the pipeline run (supports runtime variables). | `name: $(date:yyyyMMdd).$(Rev:r)_$(Build.SourceBranchName)` |
| `trigger` | Pipeline | Continuous Integration (CI) trigger. Specifies branch pushes that start a run. | `trigger: \n  branches: \n    include: \n      - main \n      - feature/*` |
| `pr` | Pipeline | Pull Request (PR) trigger. Specifies branches that run a validation build. | `pr: \n  branches: \n    include: \n      - main \n  autoCancel: true` |
| `schedules` | Pipeline | Triggers a run based on a cron schedule. | `schedules: \n  - cron: "0 0 * * *" \n    displayName: Daily Build \n    branches: \n      include: [main]` |
| `resources` | Pipeline | References external resources like other repos, pipelines, or containers. | `resources: \n  repositories: \n    - repository: common-repo \n      type: git \n      name: MyProject/CommonCode` |
| `variables` | Pipeline/Stage/Job | Defines key-value pairs, parameter references, or variable groups. | `variables: \n  - name: config \n    value: 'Release' \n  - group: Shared-Secrets` |
| `parameters` | Pipeline/Template | Defines input parameters for the pipeline or template. **Compile-time access.** | `parameters: \n  - name: environment \n    type: string \n    default: 'Dev'` |
| `stages` | Pipeline | A collection of stages that execute sequentially by default. | `stages: \n  - stage: Build \n  - stage: Deploy` |
| `extends` | Pipeline | Extends a base template to inherit structure/jobs (Best for governance). | `extends: \n  template: governance-template.yml \n  parameters: \n    env: 'Prod'` |

---

### 2. Stages, Jobs, and Execution Strategy

| Keyword | Level | Sub-Option | Description | Example Syntax |
| :--- | :--- | :--- | :--- | :--- |
| `stage` | Pipeline | `dependsOn` | Specifies stages that must complete before this one starts. | `stage: Deploy \n  dependsOn: [BuildStage, TestsStage]` |
| | | `condition` | Runtime expression controlling stage execution. | `condition: and(succeeded(), eq(variables['Build.SourceBranchName'], 'main'))` |
| `jobs` | Stage | `job` | Defines a unit of work that executes on an agent. | `jobs: \n  - job: Run_Tests \n    displayName: Unit and Integration Tests` |
| `job` | Stage | `pool` | Selects the agent pool and image for the job. | `pool: \n  vmImage: 'windows-latest'` |
| | | `container` | Specifies a container image to execute the job within. | `container: common-repo/node:18` |
| | | `strategy` | Defines a matrix or parallel execution for the job. | `strategy: \n  matrix: \n    Win_Test: {OS: windows-latest, Config: Release}` |
| `strategy` | Job | `matrix` | Defines key-value pairs to create parallel job instances. | `matrix: \n  tf_dev: {tfPath: 'infra/dev'} \n  tf_prod: {tfPath: 'infra/prod'}` |
| | | `maxParallel` | Limits the number of concurrent matrix jobs. | `maxParallel: 3` |

---

### 3. Steps and Tasks

| Keyword | Level | Description | Example Syntax |
| :--- | :--- | :--- | :--- |
| `steps` | Job | Defines a sequence of execution tasks. | `steps: \n  - template: build-steps.yml` |
| `task` | Job | Executes a specific built-in Azure DevOps or marketplace task. | `- task: DotNetCoreCLI@2 \n  inputs: \n    command: 'build' \n    projects: '**/*.csproj'` |
| `script` | Job | Runs a multi-line inline script using the agent's default shell. | `- script: | \n    echo "Running build: $(Build.BuildNumber)" \n    npm install` |
| `bash`, `powershell`, `cmd` | Job | Explicitly runs an inline script using the specified shell. | `- bash: ./deploy.sh $(appName) \n  displayName: 'Run Deployment Script'` |
| `template` | Job | Inserts steps from a separate template file (Inclusion). | `- template: security-scan-steps.yml \n  parameters: \n    folder: 'src'` |
| `condition` | Step | Runtime expression controlling step execution. | `condition: failed()` (e.g., Run only to send failure notification) |

---

### 4. Variable Syntax and Expressions (CRITICAL)

This section shows how to access the variable `myVar` with the value `100`.

| Syntax | Type | Evaluation Time | Level | Example Syntax | Common Use Case |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`$(myVar)`** | **Macro** | **Runtime** (Just before step execution) | Job, Step, Task | `- script: echo $(myVar)` | Passing values to scripts and task inputs. **Best for changing values.** |
| **`$[variables.myVar]`** | **Runtime Expression** | **Runtime** (Before Stage/Job starts) | Stage, Job, Step | `condition: $[eq(variables.myVar, '100')]` | Conditional checks within `condition:` blocks. |
| **`${{ variables.myVar }}`** | **Compile-Time Expression** | **Compile-Time** (YAML parsing) | Pipeline, Stage, Job, Template | `pool: \n  vmImage: ${{ variables.osImage }}` | Setting static values (like pool images) or used in template insertion logic. **Best for static values.** |
| **`${{ parameters.myParam }}`** | **Parameter Reference** | **Compile-Time** (YAML parsing) | Pipeline, Stage, Job, Template | `pool: \n  vmImage: ${{ parameters.osImage }}` | Accessing parameters passed into a template or run. |
| **`$[stageDependencies.S.J.outputs['N.V']]`** | **Output Variable Reference** | **Runtime** | Stage, Job | `variables: \n  webUrl: $[stageDependencies.BuildStage.BuildJob.outputs['DeployStep.WebUrl']]` | Passing output variables between jobs/stages. |

## Variable Groups (Standard Practice for Secrets & Environment Variables)

It is common practice and highly recommended by Microsoft to use variable groups, particularly when integrating with Azure Key Vault for secrets management.

*   **Secrets Management:** This is the primary use case. Variable groups provide a secure mechanism (UI-based, encrypted, access control via library security) to store sensitive data like connection strings and passwords.
*   **Environment Specificity:** They are excellent for storing values that change between environments (Dev, QA, Prod) but are constant across different pipelines *within the same project* (e.g., resource group names, subscription IDs).
*   **Decoupling:** Changes to variable values do not require a code commit, making environment configuration management simpler.



## Templates for Variables (Common for Non-Secret, Versioned Configuration)

It is also common to use YAML templates for variables, but generally for non-sensitive, configuration-as-code values.

*   **Configuration as Code:** Because YAML templates are stored in Git, they are version-controlled, documented, and reviewed via standard pull requests.
*   **Cross-Project Sharing:** Variable groups are project-scoped, meaning you cannot share a single variable group across multiple Azure DevOps projects without duplicating it. YAML templates stored in a central Git repository can be consumed by pipelines in any project, making them ideal for enterprise-wide defaults or shared paths.
*   **Compile-Time Expansion:** Variables defined in YAML templates can sometimes be expanded earlier (at compile time/parse time) than variable groups (runtime), which can be necessary for certain advanced pipeline logic.

***


| Scenario | Recommended | Reason |
| :--- | :--- | :--- |
|Secrets (Passwords, Keys)	|Variable Groups + Key Vault	|Security, encryption, access control|
|Environment-Specific Non-Secrets (URLs, RG names)	|Variable Groups	|Decoupled from code commits, easy UI updates.|
|Shared Defaults/Configuration (Tool versions, common paths)	|YAML Variable Templates	|Version control, documentation, cross-project sharing.|
---

### 5. Best Practice Expression Functions (Conditions)

These functions are used within the `condition:` block, often combined with variables (e.g., `variables['Build.SourceBranch']`).

| Function | Level | Description | Example Syntax |
| :--- | :--- | :--- | :--- |
| `succeeded()` | Stage, Job, Step | True if all immediate dependencies succeeded. | `condition: succeeded()` |
| `failed()` | Stage, Job, Step | True if any immediate dependency failed. | `condition: failed()` (Good for rollback jobs) |
| `succeededOrFailed()` | Stage, Job, Step | True if dependencies finished, regardless of status. | `condition: succeededOrFailed()` |
| `eq(a, b)` | Stage, Job, Step | Checks if $a$ equals $b$. | `condition: eq(variables['Build.SourceBranch'], 'refs/heads/main')` |
| `contains(a, b)` | Stage, Job, Step | Checks if string $a$ contains string $b$. | `condition: contains(variables['Build.SourceBranch'], 'hotfix')` |
| `and(c1, c2)` | Stage, Job, Step | Logical AND: Both conditions must be true. | `condition: and(succeeded(), eq(variables['Environment'], 'Prod'))` |

---

## 🏗️ Reusable Templates & Governance

Templates enforce standards using parameters for flexibility and `extends` for governance. 

### 6. Template Parameters and Structure

| Parameter Detail | Purpose | Example in Template File (`template.yml`) | Access Syntax |
| :--- | :--- | :--- | :--- |
| **Parameters Block** | Defines inputs expected by the template. | `parameters: \n  - name: targetEnv \n    type: string` | N/A |
| **Type Restriction** | Ensures inputs are of the correct type. | `type: string` **OR** `type: object` | N/A |
| **Default/Allowed** | Provides a fallback or restricts choices. | `default: 'QA' \nvalues: [Dev, QA, Prod]` | N/A |
| **Access Value** | Accesses the value (Compile-Time). | `- script: echo 'Deploying to ${{ parameters.targetEnv }}'` | `${{ parameters.targetEnv }}` |

### 7. Advanced: The `object` Parameter Type

The `object` type is used for passing complex, structured data (e.g., dynamic lists of deployment targets).

**Example: Looping through deployment targets defined as an object**

```yaml
# In Caller Pipeline Variables
variables:
  targetList: |
    - environmentName: 'Dev'
      resourceGroupName: 'rg-app-dev-001'
    - environmentName: 'QA'
      resourceGroupName: 'rg-app-qa-001'

# In Template File (deploy-targets.yml)
parameters:
  - name: deploymentTargets
    type: object
    default: []
    
jobs:
- ${{ each target in parameters.deploymentTargets }}: # Compile-Time Loop
  - job: Deploy_${{ target.environmentName }}
    steps:
    - script: |
        # Accessing sub-properties via compile-time syntax
        echo "Deploying to ${{ target.resourceGroupName }}"
```

### 8. Template Usage Types

| Template Type | Purpose & Level | Example Syntax (Caller Pipeline) |
| :--- | :--- | :--- |
| **Inclusion** (`template:`) | **Steps** or **Jobs**. Used for common, modular tasks. | `steps: \n  - template: common-build-steps.yml \n    parameters: \n      artifactName: 'frontend'` |
| **Extension** (`extends:`) | **Stages** or **Pipeline**. Enforces structure and governance. | `extends: \n  template: /governance/base-pipeline.yml \n  parameters: \n    appName: 'API-Service'` |

### 9. Common Logic and Loops in YAML Templates

| Type | Scenario | Example Syntax | Level | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Simple `if`** | Conditionally include steps or jobs based on a boolean parameter. | ```yaml\n${{ if eq(parameters.isProduction, true) }}:\n- task: ManualValidation@0\n``` | Stage, Job, Step | If the parameter `isProduction` is true, the validation step is added. |
| **`if/else`** | Choosing between two different pools based on the target environment. | ```yaml\n${{ if contains(parameters.env, 'Prod') }}:\npool: my-private-pool\n${{ else }}:\npool: vmImage: 'ubuntu-latest'\n``` | Job | If the environment contains 'Prod', use the private pool; otherwise, use Ubuntu. |
| **`each` Loop (Simple)** | Iterating over a list of strings (e.g., configurations) to create multiple jobs. | ```yaml\nparameters:\n- name: buildConfigs\n  type: string \n  default: ['Debug', 'Release']\njobs:\n  ${{ each config in parameters.buildConfigs }}:\n  - job: Build_${{ config }}\n    steps: ...\n``` | Stage, Job, Step | Generates two distinct jobs: `Build_Debug` and `Build_Release`. |

---

### 10. Common Expression Functions for Compile-Time Logic

| Function | Description | Example (Controlling Structure) | Notes |
| :--- | :--- | :--- | :--- |
| **`eq(a, b)`** | Checks if $a$ equals $b$. | ```yaml\n${{ if eq(parameters.isProd, true) }}:\n  - job: DeployProd\n``` | Most common for parameter checks. |
| **`contains(a, b)`** | Checks if string $a$ contains string $b$. | ```yaml\n${{ if contains(variables['Build.SourceBranch'], 'hotfix/') }}:\n  - script: notify-security\n``` | Excellent for partial matching on branches or tags. |
| **`and(c1, c2)`** | Logical AND. Both conditions must be true. | ```yaml\n${{ if and(eq(parameters.env, 'Prod'), notin(variables['Build.Reason'], 'Manual')) }}:\n  - job: Error\n``` | Used to enforce multiple strict rules simultaneously. |

# A. Pipeline Triggers and Resources Example
This example sets up Continuous Integration (CI) on specific branches/paths and defines an external repository for templates.
```yaml
name: 1.0.0.$(Rev:r)

# CI Trigger: Only run on pushes to 'main' or feature branches under 'app/'
trigger:
  branches:
    include:
      - main
      - feature/*
  paths:
    include:
      - src/app/**
    exclude:
      - docs/* # Changes here won't trigger the pipeline

# PR Trigger: Run validation only on PRs targeting 'main'
pr:
  branches:
    include:
      - main
  autoCancel: true # Cancel redundant builds if a new commit is pushed

# External Resources: Define where templates or dependent code reside
resources:
  repositories:
    - repository: Templates
      type: git
      name: CommonProject/PipelineTemplates # Reference to another repository
      ref: refs/heads/release
```

# B. Variable Definition and Syntax Example
This example shows how to define variables at the pipeline level, use a variable group for secrets, and demonstrate the three syntax types: Compile-Time `${{ }}`, Runtime `$()`, and Runtime Expression `$[ ]`.

# 1. Pipeline-Level Variables (Accessed at Compile or Runtime)
```yaml
variables:
  - name: imageOS
    value: 'ubuntu-latest' # Compile-Time variable for pool definition
  - name: releaseChannel
    value: 'Beta' # Runtime variable for scripts
  - group: Azure-Key-Vault-Secrets # Variable Group for secrets

stages:
- stage: Setup
  variables:
    # 2. Stage-level variable override
    - name: releaseChannel
      value: 'Alpha' 
  jobs:
  - job: EnvironmentSetup
    # 3. Compile-Time Access: Setting the pool image
    pool:
      vmImage: ${{ variables.imageOS }}
    steps:
    - script: |
        # 4. Runtime Access: Reading variables in a script
        echo "Release channel is: $(releaseChannel)"
        echo "The secret is: $(MySecretVariable)" # From Variable Group
      displayName: 'Print Runtime Variables'
    
    # 5. Runtime Expression Access (Used in Conditions/Dependencies)
    - script: echo "Final Step"
      condition: $[and(succeeded(), eq(variables['releaseChannel'], 'Alpha'))]
```

# C. Stages, Jobs, and Conditional Execution Example
This example demonstrates sequencing stages, setting dependencies, and using conditions based on success/failure and environment checks.
```yaml
stages:
# 1. Stage 1: Build the code
- stage: Build
  displayName: 'CI Build and Unit Tests'
  jobs:
  - job: RunTests
    pool:
      vmImage: 'ubuntu-latest'
    steps:
    - script: echo "Running tests..."
      # Assume this task might fail

# 2. Stage 2: Deploy to Dev (Depends on Build success)
- stage: DeployDev
  displayName: 'Deploy to Development'
  dependsOn: Build
  condition: succeeded() # Only runs if the 'Build' stage succeeded
  jobs:
  - job: DeployWeb
    steps:
    - script: echo "Deploying to Dev..."

# 3. Stage 3: Cleanup/Notification (Runs even if previous stages failed)
- stage: NotifyFailure
  displayName: 'Failure Notification'
  dependsOn: DeployDev
  condition: failed() # Only runs if the 'DeployDev' stage failed
  jobs:
  - job: SendAlert
    steps:
    - script: echo "Deployment failed! Sending alert..."

# 4. Stage 4: Deploy to Prod (Manual Gate + Specific Branch Check)
- stage: DeployProd
  displayName: 'Deploy to Production'
  dependsOn: DeployDev
  # Condition: Must succeed AND must be running on the 'main' branch
  condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
  jobs:
  - deployment: ProdDeploy
    environment: 'Production' # Manual validation can be required here in the UI
    strategy:
      runOnce:
        deploy:
          steps:
          - script: echo "Deploying to Production!"
```

# D. Matrix Strategy Example (e.g., Multi-Version Testing)
This example uses the `strategy: matrix` block to run the same job multiple times in parallel, injecting different variables for each run (e.g., testing against different Python versions or environment paths).
```yaml
jobs:
- job: MultiTarget_Tests
  displayName: 'Run Tests Across Configurations'
  strategy:
    matrix:
      # Matrix Instance 1: Python 3.8 on Linux
      Py38_Linux:
        PYTHON_VERSION: '3.8'
        IMAGE_NAME: 'ubuntu-latest'
      # Matrix Instance 2: Python 3.10 on Windows
      Py310_Windows:
        PYTHON_VERSION: '3.10'
        IMAGE_NAME: 'windows-latest'
      # Matrix Instance 3: Custom IaC Path (Terraform)
      Infra_Dev:
        TF_PATH: 'infra/dev'
        IMAGE_NAME: 'ubuntu-latest'
    maxParallel: 2 # Limit to 2 concurrent jobs
    
  pool:
    vmImage: $(IMAGE_NAME) # IMAGE_NAME is set by the matrix
    
  steps:
  - script: |
      # Accessing Python matrix variable
      if [ -n "$(PYTHON_VERSION)" ]; then
        echo "Running Python tests version $(PYTHON_VERSION)"
      fi
      # Accessing Terraform matrix variable
      if [ -n "$(TF_PATH)" ]; then
        echo "Running IaC plan for path $(TF_PATH)"
        terraform plan -var-file="$(TF_PATH)/vars.tfvars"
      fi
    displayName: 'Execute Matrix-Specific Logic'
```

# E. Template Extension Example (Governance)
This example shows the syntax for using an Extension Template (extends:) to ensure every pipeline inherits a baseline structure (e.g., mandatory security scan).

Caller Pipeline (`azure-pipeline.yml`):

This line imports the entire structure (stages/jobs/pool policy) 
defined in the base template.
```yaml
extends:
  template: /templates/governance/base-build-template.yml
  parameters:
    appName: 'MyWebApp'
    # Pass parameters defined in the template
    requiredChecks: true
```

Base Template (`/templates/governance/base-build-template.yml`):
```yaml
# Template File Definition
parameters:
  - name: appName
    type: string
  - name: requiredChecks
    type: boolean
    default: true

stages:
- stage: Setup
  jobs:
  - job: Prep
    steps:
    - script: echo "App name is ${{ parameters.appName }}"

# Mandatory Stage (always included for governance)
- stage: SecurityScan
  displayName: 'Mandatory Security Gate'
  jobs:
  - job: Scanner
    # Conditionally include steps based on parameter
    ${{ if eq(parameters.requiredChecks, true) }}:
      steps:
      - script: echo "Running full code analysis."
    ${{ else }}:
      steps:
      - script: echo "Skipping checks as requested."
```

# F. Conditional Logic and Object Parameter Example
This example demonstrates advanced compile-time logic `${{ }}` using `if/else` and the `each` loop to generate structure based on complex object parameters.
```yaml
parameters:
  - name: environment
    type: string
    default: 'Test'
  - name: deploymentTargets
    type: object
    default: [] # List of structured targets

jobs:
# 1. Compile-Time Conditional Inclusion (if/else)
${{ if eq(parameters.environment, 'Prod') }}:
- job: ProdGate
  steps:
  - task: ManualValidation@0 # Only include manual gate for Prod
    inputs:
      instructions: 'Approve deployment to Production.'

${{ else }}:
- job: Test_Deployment
  steps:
  - script: echo "Non-Prod deployment started."
  
# 2. Compile-Time Iteration (Each Loop) over the Object Parameter
- ${{ each target in parameters.deploymentTargets }}:
  - job: Deploy_${{ target.name }}
    pool:
      # Accessing object properties to set job definition
      vmImage: ${{ target.image }} 
    steps:
    - script: |
        echo "Deploying ${{ target.path }} to ${{ target.name }}"
        # Accessing another property (e.g., a secret name)
        echo "Using key: $(Key_${{ target.name }})" 
      displayName: 'Deploy ${{ target.name }}'
```