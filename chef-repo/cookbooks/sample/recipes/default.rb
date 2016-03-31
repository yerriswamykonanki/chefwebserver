#
# Cookbook Name:: sample
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'sample::iis'
include_recipe 'sample::web'
include_recipe 'sample::example'
