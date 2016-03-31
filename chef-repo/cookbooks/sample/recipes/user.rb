#
# Cookbook Name:: sample
# Recipe:: user
#
# Copyright (c) 2016 The Authors, All Rights Reserved.



dsc_script 'user' do
  code <<-EOH
    Script changeadminname
    {
      SetScript = {
        $user = Get-WMIObject Win32_UserAccount -Filter "Name='#{node['sample']['oldname']}'"
        $result = $user.Rename(#{node['sample']['newname']})
        $user = [ADSI]"WinNT://./#{node['sample']['newname']},user"      
        $user.SetPassword(#{node['sample']['password']})
        }
      TestScript = {
        $user = Get-WMIObject Win32_UserAccount -Filter "Name='#{node['sample']['oldname']}'"
        if($user -eq $null)
        {
         "entered user is not existed."
         $true
        }
        else
        {
          
          if(#{node['sample']['newname']} -eq $user)
           {
             "entered name is same as administrator name."
              $true
           }
          else
          {
            $false
          }
        }
            }
       GetScript = {
            }
    }
    Scriptchangemachinename
    {
     SetScript = { 
        Rename-Computer -NewName #{node['sample']['computername']}
        "computer name is changed successfully."
       }
     TestScript = {
        
       $var=$env:COMPUTERNAME
       if($var -eq #{node['sample']['computername']})
       {
         "computer name is same as u entered name"
          $true
       }
       else
       {
         $false
       }
      }
     GetScript = {
       }
    } 
  EOH
end
