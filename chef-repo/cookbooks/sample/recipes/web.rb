#
# Cookbook Name:: sample
# Recipe:: web
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

for i in node['sample']['ports']
dsc_script 'port' do
  code <<-EOH
    Script portconfiguration
          {
           SetScript = {
               New-NetFirewallRule -DisplayName "#{i.portname}" -Direction Inbound -LocalPort #{i.port} -Protocol TCP

            }
           TestScript = {
             $temp =Show-NetFirewallRule | Where-Object {$_.LocalPort -eq #{i.port}}
             if($temp -eq $null)
             {
               
               $false
             }
             else
             {
               $true
             }
            }
           GETScript = {
            }
          }
EOH
end
end

directory "#{node['sample']['directorypath']}" do
  action :create
end

remote_file "#{node['sample']['zippath']}" do
  source 'https://s3-ap-northeast-1.amazonaws.com/swamykonanki/New+folder.zip'
  action :create
end

dsc_script 'Unzip' do
    code <<-EOH
      Archive Download {
        Ensure = "Present"
        Path = "#{node['sample']['zippath']}"
        Destination = "#{node['sample']['destinationpath']}"
      }
    EOH
  end

#directory "c:\\sample\\download.zip" do
#   action :delete
#end



dsc_script 'apppool' do
  code <<-EOH
    Script 'apppoolcreation'
         {
           SetScript = {
             import-module WebAdministration
             $apppool = new-item iis:\\AppPools\\"#{node['sample']['apppoolname']}"
             $apppool | set-itemproperty -name "manageruntimeversion" -value "#{node['sample']['dotnetversion']}"
                }
           TestScript = {
               import-module WebAdministration
               if((Test-Path iis:\\AppPools\\"#{node['sample']['apppoolname']}" -pathType container))
               {
                $true}
               else{$false}
             }
           GetScript = {
             }
         }
EOH
end
dsc_script 'web' do
  code <<-EOH
   Script 'webconfiguration'
      {
         SetScript = {
           import-module WebAdministration
           $varible=New-Item IIS:\\Sites\\DemoSite -physicalPath c:\\sample\\ -bindings @{protocol="http";bindingInformation=":8081:"} -Force
           $varible | Set-ItemProperty IIS:\\Sites\\DemoSite -name applicationPool -value iis:\\AppPools\\"#{node['sample']['apppoolname']}"
           Start-WebSite 'DemoSite'
          }
         TestScript = {
                   $false
          }
         GetScript = {
          }
      }
EOH
end









