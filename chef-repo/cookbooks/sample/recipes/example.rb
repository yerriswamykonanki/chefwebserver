#
# Cookbook Name:: sample
# Recipe:: example
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#h = {'a' => 81}
#
#for i in node['sample']['hashvalue']
#dsc_script 'sample5' do
#  code <<-EOH
#    Script first
#     {
#        SetScript = {
#           mkdir C:\\#{i.a}
#             }
#        TestScript = {
#                  $false
#             }
#        
#        GetScript = {          
#            }
 #      }  
      
#EOH
#end
#end
template "c:\\sample\\New folder\\Web.config" do
  source "default.erb"
  variables({
      :name => node[:sample][:name],
      :passwod => node[:sample][:pass]})
end
