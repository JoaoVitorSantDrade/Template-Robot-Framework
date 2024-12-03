
*** Settings ***

### BuiltIn libraries ####
Library         String
Library         Collections
Library         OperatingSystem
Library         DateTime
Library         SeleniumLibrary
Resource        ../modules/acme.robot
Resource        ../modules/acme_gherk.robot

#### Constantes ####
Variables       ../variables/config.py
#### Keywords RPA ####