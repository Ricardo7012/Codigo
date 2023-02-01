If ( -not (Test-Path -Path "C:\Program Files (x86)\HSPDBUpgradeUtility\prjHSPDBUpgradeUtility.exe")){
    Write-Host "Missing upgrade app. Need to install it."
    Return
}


$upgrade_jobs = @()
                     #Server    DB        SA    
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_RT',  'hsp_rt_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_IT_SB2', 'hsp_it_sb2_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_DEMO', 'hsp_demo_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_TRN', 'hsp_trn_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_RPT', 'hsp_rpt_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_CV',  'hsp_cv_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_SB',  'hsp_sb_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_CT',  'hsp_ct_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_IT',  'hsp_it_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_CFG_1', 'hsp_cfg_1_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_CFG_2', 'hsp_cfg_2_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_CFG_3', 'hsp_cfg_3_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_CFG_4', 'hsp_cfg_4_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_IT_SB', 'hsp_it_sb_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_IT_SB3', 'hsp_it_sb3_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_IT_SB4', 'hsp_it_sb4_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_QA1',  'hsp_qa1_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'HSP_QA2',  'hsp_qa2_sa')
#$upgrade_jobs += ,@('HSP3S1A', 'hsp_test3', 'hsp_test3_sa')
#$upgrade_jobs += ,@('HSP2S1A', 'hsp_mo',   'hsp_dbo')
#$upgrade_jobs += ,@('HSP1S1A', 'hsp',      'hsp_dbo')
#$upgrade_jobs += ,@('HSP2S1A', 'hsp_prime',   'hsp_dbo')

Write-Host "Release the Kraken" 

foreach($job in $upgrade_jobs)  
    { 
    
    #Write-Host "Upgrading" $job[1] "on server" $job[0] ", SA" $job[2]
    #Write-Host "Installing the SQL_OptionPack..."
    #Start-Process "C:\Program Files (x86)\HSPDBUpgradeUtility\HSP_OptionPack\setup.exe" -Wait

    Write-Host "Installing the DBUpgradeFile..."
    Start-Process 'C:\Program Files (x86)\HSPDBUpgradeUtility\prjHSPDBUpgradeUtility.exe /s "hsp2s1a" /d "hsp_mo" /u "hsp_dbo" /p "<InsertPassword>" /o "Jon C" /c "Upgrade" /f "C:\Program Files (x86)\HSPDBUpgradeUtility\InstallInfo.INI"' -wait
    Write-Host "Job Complete"

    }  

$upgrade_jobs.Clear()

