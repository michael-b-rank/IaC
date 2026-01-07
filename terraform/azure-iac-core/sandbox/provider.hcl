# providers.hcl

# This generates a temporary file named 'provider.tf' in the working directory
# which contains the configuration for the azurerm provider.
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF

# Required providers block (from the original providers.tf)
terraform {
  required_providers {
    # Cloud Infrastructure
    aws = {       source = "hashicorp/aws" }
    azurerm   = { source = "hashicorp/azurerm"}
    
    # VMware VCF Ecosystem
    vsphere = {      source = "vmware/vsphere"    }     
    avi = {      source = "vmware/avi"    }
    vcf = {      source = "vmware/vcf"    }
    nsxt = {      source = "vmware/nsxt"    }
    tanzu-tkg = { source = "vmware/tanzu-mission-control"   }
    # vra       = { source = "vmware/vra" }
    # vro       = { source = "vmware/vro" }

    # Microsoft SaaS & Identity
    azuredevops = { source = "microsoft/azuredevops" }
    azuread     = { source = "hashicorp/azuread" }
    msgraph     = { source = "microsoft/msgraph" }

    # Logging & Monitoring
    swo         = { source = "solarwinds/swo" }

    # DevSecOps Utilities
    random      = { source = "hashicorp/random" }
    null        = { source = "hashicorp/null" }

    # Cisco Networking Providers    
    # NX-OS (Nexus Switches)
    nxos = {      source = "CiscoDevNet/nxos"    }

    # IOS XE (Routers and Catalyst Switches)    
    iosxe = {      source = "CiscoDevNet/iosxe"    }

    # Intersight (UCS and HyperFlex management)
    intersight = {      source = "CiscoDevNet/intersight"    }
    
    # Palo Alto Networks Providers
    # PAN-OS (Physical, VM-Series, and Panorama configuration)
    panos = {      source = "PaloAltoNetworks/panos"    }
    
    # Cloud NGFW for AWS
    cloudngfwaws = {      source = "PaloAltoNetworks/cloudngfwaws"    }

    # Strata Cloud Manager
    scm = {      source = "PaloAltoNetworks/scm"    }

  }
}

# The azurerm provider configuration (from the original providers.tf)
provider "azurerm" {    
  subscription_id = "find_and_replace"
  resource_provider_registrations = "none"
  features {}
}
EOF
}
