Get-ExecutionPolicy
Set-ExecutionPolicy Unrestricted -Force
Get-ExecutionPolicy

New-Item -ItemType Directory -Force -Path E:\Backup
New-Item -ItemType Directory -Force -Path E:\Data
New-Item -ItemType Directory -Force -Path L:\Log
New-Item -ItemType Directory -Force -Path I:\System
New-Item -ItemType Directory -Force -Path T:\TempDB
New-Item -ItemType Directory -Force -Path E:\Trace
New-Item -ItemType Directory -Force -Path E:\Audit

Get-Host
