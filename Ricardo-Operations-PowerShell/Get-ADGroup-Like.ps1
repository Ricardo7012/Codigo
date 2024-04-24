
Get-ADGroup -filter {name -like 'ReportUsers_*'} | Select name

#OLD GROUPS- DESCRIPTION: Reports.iehp.local-PBI-EDW
#----                                  
ReportUsers_BH                        
ReportUsers_BHCare_Management         
ReportUsers_Claims                    
ReportUsers_Claims_Management         
ReportUsers_Compliance                
ReportUsers_EEServices                
ReportUsers_Finance                   
ReportUsers_GrievanceAndAppeals       
ReportUsers_HCI                       
ReportUsers_Marketing                 
ReportUsers_MemberServices            
ReportUsers_MSManagment               
ReportUsers_Pharmacy                  
ReportUsers_ProviderContracting       
ReportUsers_ProviderContractingService
ReportUsers_ProviderServices          
ReportUsers_UM                        

# SECURITY GROUPS - GLOBAL or UNIVERSAL 
## OU: iehp.local--GroupAccounts

# 1. CREATE "NEW GROUPS" 
# 2. COPY MEMBERS FROM OLD GROUPS TO NEW GROUPS
# 3. INCLUDE MANAGED BY: iehp.local/Group Accounts/DataSciTeam_GPMgr
# 4. ADD DESCRIPTION: Reports.iehp.local-PBI-EDW

#NEW GROUPS - DESCRIPTION: Reports.iehp.local-PBI-EDW                             
#----                                  
Reports_BH                        
Reports_BHCare_Mgmt       
Reports_Claims                    
Reports_Claims_Mgmt         
Reports_Compliance                
Reports_EEServices                
Reports_Finance                   
Reports_GAndA       
Reports_HCI                       
Reports_Marketing                 
Reports_MemberServices            
Reports_MSMgmt               
Reports_Pharmacy                  
Reports_ProviderContracting       
Reports_ProviderContractingService
Reports_ProviderServices          
Reports_UM
Reports_EDI                        

#5. NEW GROUPS 2 EMPTY MEMBERS FOR NOW
#6. DECRIPTION: Reports-D.iehp.local-PBI
#7. INCLUDE MANAGED BY: iehp.local/Group Accounts/DataSciTeam_GPMgr
Reports_BH_CMgr                        
Reports_BHCare_Mgmt_CMgr       
Reports_Claims_CMgr                    
Reports_Claims_Mgmt_CMgr         
Reports_Compliance_CMgr                
Reports_EEServices_CMgr                
Reports_Finance_CMgr                   
Reports_GAndA_CMgr       
Reports_HCI_CMgr                       
Reports_Marketing_CMgr                 
Reports_MemberServices_CMgr            
Reports_MSMgmt_CMgr               
Reports_Pharmacy_CMgr                  
Reports_ProviderContracting_CMgr       
Reports_ProviderContractingService_CMgr
Reports_ProviderServices_CMgr          
Reports_UM_CMgr 
Reports_EDI_CMgr
