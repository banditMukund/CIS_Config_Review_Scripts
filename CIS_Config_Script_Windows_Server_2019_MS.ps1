if (!(Test-Path -Path C:\temp )) { New-Item -ItemType directory -Path C:\temp };secedit /export /cfg C:\temp\secpol.cfg;
Write-Output '====';
Write-Output 'Windows Server 2019'
Write-Output '====';
[System.Net.Dns]::GetHostName();

Write-Output '====';
$testcase = "1.1.1 (L1) Ensure 'Enforce password history' is set to '24 or more password(s)'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'PasswordHistorySize =';
Write-Output '====';
$testcase = "1.1.2 (L1) Ensure 'Maximum password age' is set to '365 or fewer days, but not 0'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'MaximumPasswordAge =';
Write-Output '====';
$testcase = "1.1.3 (L1) Ensure 'Minimum password age' is set to '1 or more day(s)'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'MinimumPasswordAge =';
Write-Output '====';
$testcase = "1.1.4 (L1) Ensure 'Minimum password length' is set to '14 or more character(s)'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'MinimumPasswordLength =';
Write-Output '====';
$testcase = "1.1.5 (L1) Ensure 'Password must meet complexity requirements' is set to 'Enabled'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'PasswordComplexity =';
Write-Output '====';
$testcase = "1.1.6 (L1) Ensure 'Store passwords using reversible encryption' is set to 'Disabled'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'ClearTextPassword =';
Write-Output '====';

$testcase = "1.2.1 (L1) Ensure 'Account lockout duration' is set to '15 or more minute(s)'"
Write-Output "$testcase"
net accounts | select-string -pattern 'Lockout duration';
Write-Output '====';
$testcase = "1.2.2 (L1) Ensure 'Account lockout threshold' is set to '5 or fewer invalid logon attempt(s), but not 0'"
Write-Output "$testcase"
net accounts | select-string -pattern 'Lockout threshold';
Write-Output '====';
$testcase = "1.2.3 (L1) Ensure 'Allow Administrator account lockout' is set to 'Enabled' (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'AllowAdminAccountLockout';
Write-Output '====';
$testcase = "1.2.4 (L1) Ensure 'Reset account lockout counter after' is set to '15 or more minute(s)'"
Select-String -Path C:\temp\secpol.cfg -Pattern "ResetLockoutCount"
Write-Output '====';
$testcase = "2.2.1 (L1) Ensure 'Access Credential Manager as a trusted caller' is set to 'No One'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeTrustedCredManAccessPrivilege';
Write-Output '====';
$testcase = "2.2.3 (L1) Ensure 'Access this computer from the network'  is set to 'Administrators, Authenticated Users' (MS only)"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeNetworkLogonRight';
Write-Output '====';
$testcase = "2.2.4 (L1) Ensure 'Act as part of the operating system' is set to 'No One'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeTcbPrivilege';
Write-Output '====';
$testcase = "2.2.6 (L1) Ensure 'Adjust memory quotas for a process' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeIncreaseQuotaPrivilege';
Write-Output '====';
$testcase = "2.2.8 (L1) Ensure 'Allow log on locally' is set to 'Administrators' (MS only)"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeInteractiveLogonRight';
Write-Output '====';
$testcase = "2.2.10 (L1) Ensure 'Allow log on through Remote Desktop Services' is set to 'Administrators, Remote Desktop Users' (MS only)"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeRemoteInteractiveLogonRight';
Write-Output '====';
$testcase = "2.2.11 (L1) Ensure 'Back up files and directories' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeBackupPrivilege';
Write-Output '====';
$testcase = "2.2.12 (L1) Ensure 'Change the system time' is set to 'Administrators, LOCAL SERVICE'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeSystemTimePrivilege';
Write-Output '====';
$testcase = "2.2.13 (L1) Ensure 'Change the time zone' is set to 'Administrators, LOCAL SERVICE'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeTimeZonePrivilege';
Write-Output '====';
$testcase = "2.2.14 (L1) Ensure 'Create a pagefile' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeCreatePagefilePrivilege';
Write-Output '====';
$testcase = "2.2.15 (L1) Ensure 'Create a token object' is set to 'No One'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeCreateTokenPrivilege';
Write-Output '====';
$testcase = "2.2.16 (L1) Ensure 'Create global objects' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeCreateGlobalPrivilege';
Write-Output '====';
$testcase = "2.2.17 (L1) Ensure 'Create permanent shared objects' is set to 'No One'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeCreatePermanentPrivilege';
Write-Output '====';
$testcase = "2.2.19 (L1) Ensure 'Create symbolic links' is set to 'Administrators, NT VIRTUAL MACHINE\Virtual Machines' (MS only)"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeCreateSymbolicLinkPrivilege';
Write-Output '====';
$testcase = "2.2.20 (L1) Ensure 'Debug programs' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeDebugPrivilege';
Write-Output '====';
$testcase = "2.2.22 (L1) Ensure 'Deny access to this computer from the network' to include 'Guests, Local account and member of Administrators group' (MS only)"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeDenyNetworkLogonRight';
Write-Output '====';
$testcase = "2.2.23 (L1) Ensure 'Deny log on as a batch job' to include 'Guests'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeDenyBatchLogonRight';
Write-Output '====';
$testcase = "2.2.24 (L1) Ensure 'Deny log on as a service' to include 'Guests'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeDenyServiceLogonRight';
Write-Output '====';
$testcase = "2.2.25 (L1) Ensure 'Deny log on locally' to include 'Guests'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeDenyInteractiveLogonRight';
Write-Output '====';
$testcase = "2.2.27 (L1) Ensure 'Deny log on through Remote Desktop Services' is set to 'Guests, Local account' (MS only)"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeDenyRemoteInteractiveLogonRight';
Write-Output '====';
$testcase = "2.2.29 (L1) Ensure 'Enable computer and user accounts to be trusted for delegation' is set to 'No One' (MS only)"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeEnableDelegationPrivilege';
Write-Output '====';
$testcase = "2.2.30 (L1) Ensure 'Force shutdown from a remote system' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeRemoteShutdownPrivilege';
Write-Output '====';
$testcase = "2.2.31 (L1) Ensure 'Generate security audits' is set to 'LOCAL SERVICE, NETWORK SERVICE'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeAuditPrivilege';
Write-Output '====';
$testcase = "2.2.33 (L1) Ensure 'Impersonate a client after authentication' is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE' and (when the Web Server (IIS) Role with Web Services Role Service is installed) 'IIS_IUSRS' (MS only)"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeImpersonatePrivilege';
Write-Output '====';
$testcase = "2.2.34 (L1) Ensure 'Increase scheduling priority' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeIncreaseBasePriorityPrivilege';
Write-Output '====';
$testcase = "2.2.35 (L1) Ensure 'Load and unload device drivers' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeLoadDriverPrivilege';
Write-Output '====';
$testcase = "2.2.36 (L1) Ensure 'Lock pages in memory' is set to 'No One'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeLockMemoryPrivilege';
Write-Output '====';
$testcase = "2.2.39 (L1) Ensure 'Manage auditing and security log' is set to 'Administrators' (MS only)"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeSecurityPrivilege';
Write-Output '====';
$testcase = "2.2.40 (L1) Ensure 'Modify an object label' is set to 'No One'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeReLabelPrivilege';
Write-Output '====';
$testcase = "2.2.41 (L1) Ensure 'Modify firmware environment values' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeSystemEnvironmentPrivilege';
Write-Output '====';
$testcase = "2.2.42 (L1) Ensure 'Perform volume maintenance tasks' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeManageVolumePrivilege';
Write-Output '====';
$testcase = "2.2.43 (L1) Ensure 'Profile single process' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeProfileSingleProcessPrivilege';
Write-Output '====';
$testcase = "2.2.44 (L1) Ensure 'Profile system performance' is set to 'Administrators, NT SERVICE\WdiServiceHost'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeSystemProfilePrivilege';
Write-Output '====';
$testcase = "2.2.45 (L1) Ensure 'Replace a process level token' is set to 'LOCAL SERVICE, NETWORK SERVICE'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeAssignPrimaryTokenPrivilege';
Write-Output '====';
$testcase = "2.2.46 (L1) Ensure 'Restore files and directories' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeRestorePrivilege';
Write-Output '====';
$testcase = "2.2.47 (L1) Ensure 'Shut down the system' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeShutdownPrivilege';
Write-Output '====';
$testcase = "2.2.49 (L1) Ensure 'Take ownership of files or other objects' is set to 'Administrators'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'SeTakeOwnershipPrivilege';
Write-Output '====';
$testcase = "2.3.1.1 (L1) Ensure 'Accounts: Block Microsoft accounts' is set to 'Users can't add or log on with Microsoft accounts'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'NoConnectedUser';
Write-Output '====';
$testcase = "2.3.1.2 (L1) Ensure 'Accounts: Guest account status' is set to 'Disabled' (MS only)"
Write-Output "$testcase"
net user guest | select-string -pattern 'Account active';
Get-LocalUser -Name Guest | Select-Object -Property Name, Enabled
Write-Output '====';
$testcase = "2.3.1.3 (L1) Ensure 'Accounts: Limit local account use of blank passwords to console logon only' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name 'LimitBlankPasswordUse';
Write-Output '====';
$testcase = "2.3.1.4 (L1) Configure 'Accounts: Rename administrator account'"
Write-Output "$testcase"
Get-LocalUser | Where-Object { $_.SID -like 'S-1-5-*-500' } | Select-Object Name
Write-Output '====';
$testcase = "2.3.1.5 (L1) Configure 'Accounts: Rename guest account'"
Write-Output "$testcase"
Get-LocalUser | Where-Object { $_.SID -like 'S-1-5-*-501' } | Select-Object Name
Write-Output '====';
$testcase = "2.3.2.1 (L1) Ensure 'Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name 'SCENoApplyLegacyAuditPolicy';
Write-Output '====';
$testcase = "2.3.2.2 (L1) Ensure 'Audit: Shut down system immediately if unable to log security audits' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\LSA' -Name 'CrashOnAuditFail';
Write-Output '====';
$testcase = "2.3.4.1 (L1) Ensure 'Devices: Prevent users from installing printer drivers' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers' -Name 'AddPrinterDrivers';
Write-Output '====';
$testcase = "2.3.6.1 (L1) Ensure 'Domain member: Digitally encrypt or sign secure channel data (always)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name 'RequireSignOrSeal';
Write-Output '====';
$testcase = "2.3.6.2 (L1) Ensure 'Domain member: Digitally encrypt secure channel data (when possible)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name 'SealSecureChannel';
Write-Output '====';
$testcase = "2.3.6.3 (L1) Ensure 'Domain member: Digitally sign secure channel data (when possible)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name 'SignSecureChannel';
Write-Output '====';
$testcase = "2.3.6.4 (L1) Ensure 'Domain member: Disable machine account password changes' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name 'DisablePasswordChange';
Write-Output '====';
$testcase = "2.3.6.5 (L1) Ensure 'Domain member: Maximum machine account password age' is set to '30 or fewer days, but not 0'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name 'MaximumPasswordAge';
Write-Output '====';
$testcase = "2.3.6.6 (L1) Ensure 'Domain member: Require strong (Windows 2000 or later) session key' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\Netlogon\Parameters' -Name 'RequireStrongKey';
Write-Output '====';
$testcase = "2.3.7.1 (L1) Ensure 'Interactive logon: Do not display last user name' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\Currentversion\Policies\System' -Name 'DontDisplayLastUserName';
Write-Output '====';
$testcase = "2.3.7.2 (L1) Ensure 'Interactive logon: Do not require CTRL+ALT+DEL' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableCAD';
Write-Output '====';
$testcase = "2.3.7.3 (L1) Ensure 'Interactive logon: Machine inactivity limit' is set to '900 or fewer second(s), but not 0'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'InactivityTimeoutSecs';
Write-Output '====';
$testcase = "2.3.7.4 (L1) Configure 'Interactive logon: Message text for users attempting to log on'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'LegalNoticeText';
Write-Output '====';
$testcase = "2.3.7.5 (L1) Configure 'Interactive logon: Message title for users attempting to log on'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\Currentversion\Policies\System' -Name 'LegalNoticeCaption';
Write-Output '====';
$testcase = "2.3.7.7 (L1) Ensure 'Interactive logon: Prompt user to change password before expiration' is set to 'between 5 and 14 days'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'PasswordExpiryWarning';
Write-Output '====';
$testcase = "2.3.7.8 (L1) Ensure 'Interactive logon: Require Domain Controller Authentication to unlock workstation' is set to 'Enabled' (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'ForceUnlockLogon';
Write-Output '====';
$testcase = "2.3.7.9 (L1) Ensure 'Interactive logon: Smart card removal behavior' is set to 'Lock Workstation' or higher"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'ScRemoveOption';
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AllocateDASD';
Write-Output '====';
$testcase = "2.3.8.1 (L1) Ensure 'Microsoft network client: Digitally sign communications (always)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'RequireSecuritySignature';
Write-Output '====';
$testcase = "2.3.8.2 (L1) Ensure 'Microsoft network client: Digitally sign communications (if server agrees)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'EnableSecuritySignature';
Write-Output '====';
$testcase = "2.3.8.3 (L1) Ensure 'Microsoft network client: Send unencrypted password to third-party SMB servers' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'EnablePlainTextPassword';
Write-Output '====';
$testcase = "2.3.9.1 (L1) Ensure 'Microsoft network server: Amount of idle time required before suspending session' is set to '15 or fewer minute(s)'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters' -Name 'AutoDisconnect';
Write-Output '====';
$testcase = "2.3.9.2 (L1) Ensure 'Microsoft network server: Digitally sign communications (always)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters' -Name 'RequireSecuritySignature';
Write-Output '====';
$testcase = "2.3.9.3 (L1) Ensure 'Microsoft network server: Digitally sign communications (if client agrees)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters' -Name 'EnableSecuritySignature';
Write-Output '====';
$testcase = "2.3.9.4 (L1) Ensure 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters' -Name 'enableforcedlogoff';
Write-Output '====';
$testcase = "2.3.9.5 (L1) Ensure 'Microsoft network server: Server SPN target name validation level' is set to 'Accept if provided by client' or higher (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters' -Name 'SMBServerNameHardeningLevel';
Write-Output '====';
$testcase = "2.3.10.1 (L1) Ensure 'Network access: Allow anonymous SID/Name translation' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name 'TurnOffAnonymousBlock';
Write-Output '====';
$testcase = "2.3.10.2 (L1) Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts' is set to 'Enabled' (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name 'RestrictAnonymousSAM';
Write-Output '====';
$testcase = "2.3.10.3 (L1) Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts and shares' is set to 'Enabled' (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name 'RestrictAnonymous';
Write-Output '====';
$testcase = "2.3.10.5 (L1) Ensure 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name 'EveryoneIncludesAnonymous';
Write-Output '====';
$testcase = "2.3.10.7 (L1) Configure 'Network access: Named Pipes that can be accessed anonymously' (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -Name 'NullSessionPipes';
Write-Output '====';
$testcase = "2.3.10.8 (L1) Configure 'Network access: Remotely accessible registry paths' is configured"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths' -Name 'Machine';
Write-Output '====';
$testcase = "2.3.10.9 (L1) Configure 'Network access: Remotely accessible registry paths and sub-paths' is configured"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedPaths' -Name 'Machine';
Write-Output '====';
$testcase = "2.3.10.10 (L1) Ensure 'Network access: Restrict anonymous access to Named Pipes and Shares' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters' -Name 'RestrictNullSessAccess';
Write-Output '====';
$testcase = "2.3.10.11 (L1) Ensure 'Network access: Restrict clients allowed to make remote calls to SAM' is set to 'Administrators: Remote Access: Allow' (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'restrictremotesam';
Write-Output '====';
$testcase = "2.3.10.12 (L1) Ensure 'Network access: Shares that can be accessed anonymously' is set to 'None'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\LanManServer\Parameters' -Name 'NullSessionShares';
Write-Output '====';
$testcase = "2.3.10.13 (L1) Ensure 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name 'ForceGuest';
Write-Output '====';

$testcase = "2.3.11.1 (L1) Ensure 'Network security: Allow Local System to use computer identity for NTLM' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name 'UseMachineId';
Write-Output '====';
$testcase = "2.3.11.2 (L1) Ensure 'Network security: Allow LocalSystem NULL session fallback' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0' -Name 'AllowNullSessionFallback';
Write-Output '====';
$testcase = "2.3.11.3 (L1) Ensure 'Network Security: Allow PKU2U authentication requests to this computer to use online identities' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa\pku2u' -Name 'AllowOnlineID';
Write-Output '====';
$testcase = "2.3.11.4 (L1) Ensure 'Network security: Configure encryption types allowed for Kerberos' is set to 'AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters' -Name 'SupportedEncryptionTypes';
Write-Output '====';
$testcase = "2.3.11.5 (L1) Ensure 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name 'NoLMHash';
Write-Output '====';
$testcase = "2.3.11.6 (L1) Ensure 'Network security: Force logoff when logon hours expire' is set to 'Enabled'"
Write-Output "$testcase"
Get-Content -Path C:\temp\secpol.cfg | Select-String -Pattern 'ForceLogoffWhenHourExpire =';
Write-Output '====';
$testcase = "2.3.11.7 (L1) Ensure 'Network security: LAN Manager authentication level' is set to 'Send NTLMv2 response only. Refuse LM & NTLM'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa' -Name 'LMCompatibilityLevel';
Write-Output '====';
$testcase = "2.3.11.8 (L1) Ensure 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\LDAP' -Name 'LDAPClientIntegrity';
Write-Output '====';
$testcase = "2.3.11.9 (L1) Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) clients' is set to 'Require NTLMv2 session security, Require 128-bit encryption'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0' -Name 'NTLMMinClientSec';
Write-Output '====';
$testcase = "2.3.11.10 (L1) Ensure 'Network security: Minimum session security for NTLM SSP based (including secure RPC) servers' is set to 'Require NTLMv2 session security, Require 128-bit encryption'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0' -Name 'NTLMMinServerSec';
Write-Output '====';
$testcase = "2.3.11.11 (L1) Ensure 'Network security: Restrict NTLM: Audit Incoming NTLM Traffic' is set to 'Enable auditing for all accounts'"
Write-Output "$testcase"
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name "AuditReceivingNTLMTraffic"
Write-Output '====';
$testcase = "2.3.11.13 (L1) Ensure 'Network security: Restrict NTLM: Outgoing NTLM traffic to remote servers' is set to 'Audit all' or higher"
Write-Output "$testcase"
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" -Name "AuditSendingNTLMTraffic"
Write-Output '====';
$testcase = "2.3.13.1 (L1) Ensure 'Shutdown: Allow system to be shut down without having to log on' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'ShutdownWithoutLogon';
Write-Output '====';
$testcase = "2.3.15.1 (L1) Ensure 'System objects: Require case insensitivity for non-Windows subsystems' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\Kernel' -Name 'ObCaseInsensitive';
Write-Output '====';
$testcase = "2.3.15.2 (L1) Ensure 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager' -Name 'ProtectionMode';
Write-Output '====';
$testcase = "2.3.17.1 (L1) Ensure 'User Account Control: Admin Approval Mode for the Built-in Administrator account' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'FilterAdministratorToken';
Write-Output '====';
$testcase = "2.3.17.2 (L1) Ensure 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode' is set to 'Prompt for consent on the secure desktop' or higher"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'ConsentPromptBehaviorAdmin';
Write-Output '====';
$testcase = "2.3.17.3 (L1) Ensure 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'ConsentPromptBehaviorUser';
Write-Output '====';
$testcase = "2.3.17.4 (L1) Ensure 'User Account Control: Detect application installations and prompt for elevation' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableInstallerDetection';
Write-Output '====';
$testcase = "2.3.17.5 (L1) Ensure 'User Account Control: Only elevate UIAccess applications that are installed in secure locations' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableSecureUIAPaths';
Write-Output '====';
$testcase = "2.3.17.6 (L1) Ensure 'User Account Control: Run all administrators in Admin Approval Mode' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA';
Write-Output '====';
$testcase = "2.3.17.7 (L1) Ensure 'User Account Control: Switch to the secure desktop when prompting for elevation' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'PromptOnSecureDesktop';
Write-Output '====';
$testcase = "2.3.17.8 (L1) Ensure 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableVirtualization';
Write-Output '====';

$testcase = "9.1.1 (L1) Ensure 'Windows Firewall: Domain: Firewall state' is set to 'On (recommended)'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name 'EnableFirewall';
Write-Output '====';
$testcase = "9.1.2 (L1) Ensure 'Windows Firewall: Domain: Inbound connections' is set to 'Block (default)'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name 'DefaultInboundAction';
Write-Output '====';
#Write-Output "$testcase"
#Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name 'DefaultOutboundAction';
$testcase = "9.1.3 (L1) Ensure 'Windows Firewall: Domain: Settings: Display a notification' is set to 'No'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile' -Name 'DisableNotifications';
Write-Output '====';
$testcase = "9.1.4 (L1) Ensure 'Windows Firewall: Domain: Logging: Name' is set to '%SystemRoot%\System32\logfiles\firewall\domainfw.log'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging' -Name 'LogFilePath';
Write-Output '====';
$testcase = "9.1.5 (L1) Ensure 'Windows Firewall: Domain: Logging: Size limit (KB)' is set to '16,384 KB or greater'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging' -Name 'LogFileSize';
Write-Output '====';
$testcase = "9.1.6 (L1) Ensure 'Windows Firewall: Domain: Logging: Log dropped packets' is set to 'Yes'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging' -Name 'LogDroppedPackets';
Write-Output '====';
$testcase = "9.1.7 (L1) Ensure 'Windows Firewall: Domain: Logging: Log successful connections' is set to 'Yes'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging' -Name 'LogSuccessfulConnections';
Write-Output '====';
$testcase = "9.2.1 (L1) Ensure 'Windows Firewall: Private: Firewall state' is set to 'On (recommended)'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile' -Name 'EnableFirewall';
Write-Output '====';
$testcase = "9.2.2 (L1) Ensure 'Windows Firewall: Private: Inbound connections' is set to 'Block (default)'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile' -Name 'DefaultInboundAction';
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile' -Name 'DefaultOutboundAction';
Write-Output '====';
$testcase = "9.2.3 (L1) Ensure 'Windows Firewall: Private: Settings: Display a notification' is set to 'No'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile' -Name 'DisableNotifications';
Write-Output '====';
$testcase = "9.2.4 (L1) Ensure 'Windows Firewall: Private: Logging: Name' is set to '%SystemRoot%\System32\logfiles\firewall\privatefw.log'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging' -Name 'LogFilePath';
Write-Output '====';
$testcase = "9.2.5 (L1) Ensure 'Windows Firewall: Private: Logging: Size limit (KB)' is set to '16,384 KB or greater'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging' -Name 'LogFileSize';
Write-Output '====';
$testcase = "9.2.6 (L1) Ensure 'Windows Firewall: Private: Logging: Log dropped packets' is set to 'Yes'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging' -Name 'LogDroppedPackets';
Write-Output '====';
$testcase = "9.2.7 (L1) Ensure 'Windows Firewall: Private: Logging: Log successful connections' is set to 'Yes'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging' -Name 'LogSuccessfulConnections';
Write-Output '====';
$testcase = "9.3.1 (L1) Ensure 'Windows Firewall: Public: Firewall state' is set to 'On (recommended)'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name 'EnableFirewall';
Write-Output '====';
$testcase = "9.3.2 (L1) Ensure 'Windows Firewall: Public: Inbound connections' is set to 'Block (default)'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name 'DefaultInboundAction';
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name 'DefaultOutboundAction';
Write-Output '====';
$testcase = "9.3.3 (L1) Ensure 'Windows Firewall: Public: Settings: Display a notification' is set to 'No'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name 'DisableNotifications';
Write-Output '====';
$testcase = "9.3.4 (L1) Ensure 'Windows Firewall: Public: Settings: Apply local firewall rules' is set to 'No'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name 'AllowLocalPolicyMerge';
Write-Output '====';
$testcase = "9.3.5 (L1) Ensure 'Windows Firewall: Public: Settings: Apply local connection security rules' is set to 'No'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile' -Name 'AllowLocalIPsecPolicyMerge';
Write-Output '====';
$testcase = "9.3.6 (L1) Ensure 'Windows Firewall: Public: Logging: Name' is set to '%SystemRoot%\System32\logfiles\firewall\publicfw.log'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -Name 'LogFilePath';
Write-Output '====';
$testcase = "9.3.7 (L1) Ensure 'Windows Firewall: Public: Logging: Size limit (KB)' is set to '16,384 KB or greater'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -Name 'LogFileSize';
Write-Output '====';
$testcase = "9.3.8 (L1) Ensure 'Windows Firewall: Public: Logging: Log dropped packets' is set to 'Yes'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -Name 'LogDroppedPackets';
Write-Output '====';
$testcase = "9.3.9 (L1) Ensure 'Windows Firewall: Public: Logging: Log successful connections' is set to 'Yes'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging' -Name 'LogSuccessfulConnections';
Write-Output '====';
$testcase = "17.1.1 (L1) Ensure 'Audit Credential Validation' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:'Credential Validation' | select-string -pattern 'Credential Validation';
Write-Output '====';
$testcase = "17.2.1 (L1) Ensure 'Audit Application Group Management' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:'Application Group Management' | select-string -pattern 'Application Group Management';
Write-Output '====';
$testcase = "17.2.5 (L1) Ensure 'Audit Security Group Management' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:'Security Group Management' | select-string -pattern 'Security Group Management';
Write-Output '====';
$testcase = "17.2.6 (L1) Ensure 'Audit User Account Management' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:'User Account Management' | select-string -pattern 'User Account Management';
Write-Output '====';
$testcase = "17.3.1 (L1) Ensure 'Audit PNP Activity' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:"Plug and Play Events"
Write-Output '====';
$testcase = "17.3.2 (L1) Ensure 'Audit Process Creation' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:'Process Creation' | select-string -pattern 'Process Creation';
Write-Output '====';
$testcase = "17.5.1 (L1) Ensure 'Audit Account Lockout' is set to include 'Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:'Account Lockout' | select-string -pattern 'Account Lockout';
Write-Output '====';
$testcase = "17.5.2 (L1) Ensure 'Audit Group Membership' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:'Group Membership' | select-string -pattern 'Group Membership';
Write-Output '====';
$testcase = "17.5.3 (L1) Ensure 'Audit Logoff' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:"Logoff"
Write-Output '====';
$testcase = "17.5.4 (L1) Ensure 'Audit Logon' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:"Logon"
Write-Output '====';
$testcase = "17.5.5 (L1) Ensure 'Audit Other Logon/Logoff Events' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:"Other Logon/Logoff Events"
Write-Output '====';
$testcase = "17.5.6 (L1) Ensure 'Audit Special Logon' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:"Special Logon"
Write-Output '====';
$testcase = "17.6.1 (L1) Ensure 'Audit Detailed File Share' is set to include 'Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:"Detailed File Share"
Write-Output '====';
$testcase = "17.6.2 (L1) Ensure 'Audit File Share' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:"File Share"
Write-Output '====';
$testcase = "17.6.3 (L1) Ensure 'Audit Other Object Access Events' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:"Other Object Access Events"
Write-Output '====';
$testcase = "17.6.4 (L1) Ensure 'Audit Removable Storage' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:"Removable Storage"
Write-Output '====';
$testcase = "17.7.1 (L1) Ensure 'Audit Audit Policy Change' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:'Audit Policy Change' | select-string -pattern 'Audit Policy Change';
Write-Output '====';
$testcase = "17.7.2 (L1) Ensure 'Audit Authentication Policy Change' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:'Authentication Policy Change' | select-string -pattern 'Authentication Policy Change';
Write-Output '====';
$testcase = "17.7.3 (L1) Ensure 'Audit Authorization Policy Change' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:'Authorization Policy Change' | select-string -pattern 'Authorization Policy Change';
Write-Output '====';
$testcase = "17.7.4 (L1) Ensure 'Audit MPSSVC Rule-Level Policy Change' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:'MPSSVC Rule-Level Policy Change' | select-string -pattern 'MPSSVC Rule-Level Policy Change';
Write-Output '====';
$testcase = "17.7.5 (L1) Ensure 'Audit Other Policy Change Events' is set to include 'Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:'Other Policy Change Events' | select-string -pattern 'Other Policy Change Events';
Write-Output '====';
$testcase = "17.8.1 (L1) Ensure 'Audit Sensitive Privilege Use' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:'Sensitive Privilege Use' | select-string -pattern 'Sensitive Privilege Use';
Write-Output '====';
$testcase = "17.9.1 (L1) Ensure 'Audit IPsec Driver' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:'IPsec Driver' | select-string -pattern 'IPsec Driver';
Write-Output '====';
$testcase = "17.9.2 (L1) Ensure 'Audit Other System Events' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:'Other System Events' | select-string -pattern 'Other System Events';
Write-Output '====';
$testcase = "17.9.3 (L1) Ensure 'Audit Security State Change' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:'Security State Change' | select-string -pattern 'Security State Change';
Write-Output '====';
$testcase = "17.9.4 (L1) Ensure 'Audit Security System Extension' is set to include 'Success'"
Write-Output "$testcase"
auditpol /get /subcategory:'Security System Extension' | select-string -pattern 'Security System Extension';
Write-Output '====';
$testcase = "17.9.5 (L1) Ensure 'Audit System Integrity' is set to 'Success and Failure'"
Write-Output "$testcase"
auditpol /get /subcategory:'System Integrity' | select-string -pattern 'System Integrity';
Write-Output '====';
$testcase = "18.1.1.1 (L1) Ensure 'Prevent enabling lock screen camera' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Personalization' -Name 'NoLockScreenCamera';
Write-Output '====';
$testcase = "18.1.1.2 (L1) Ensure 'Prevent enabling lock screen slide show' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Personalization' -Name 'NoLockScreenSlideshow';
Write-Output '====';
$testcase = "18.1.2.2 (L1) Ensure 'Allow users to enable online speech recognition services' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization' -Name 'AllowInputPersonalization';
Write-Output '====';

$testcase = "18.4.1 (L1) Ensure 'Apply UAC restrictions to local accounts on network logons' is set to 'Enabled' (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'LocalAccountTokenFilterPolicy';
Write-Output '====';
$testcase = "18.4.2 (L1) Ensure 'Configure RPC packet level privacy setting for incoming connections' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Print' -Name 'RpcAuthnLevelPrivacyEnabled';
Write-Output '====';
$testcase = "18.4.3 (L1) Ensure 'Configure SMB v1 client driver' is set to 'Enabled: Disable driver (recommended)'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\mrxsmb10' -Name 'Start';
Write-Output '====';
$testcase = "18.4.4 (L1) Ensure 'Configure SMB v1 server' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'SMB1';
Write-Output '====';
$testcase = "18.4.5 (L1) Ensure 'Enable Certificate Padding' is set to 'Enabled'"
Write-Output '====';
$testcase = "18.4.6 (L1) Ensure 'Enable Structured Exception Handling Overwrite Protection (SEHOP)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel' -Name 'DisableExceptionChainValidation';
Write-Output '====';
$testcase = "18.4.7 (L1) Ensure 'LSA Protection' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa' -Name 'RunAsPPL';
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint' -Name 'RestrictDriverInstallationToAdministrators';
Write-Output '====';
$testcase = "18.4.8 (L1) Ensure 'NetBT NodeType configuration' is set to 'Enabled: P-node (recommended)'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Netbt\Parameters' -Name 'NodeType';
Write-Output '====';
$testcase = "18.4.9 (L1) Ensure 'WDigest Authentication' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest' -Name 'UseLogonCredential';
Write-Output '====';
$testcase = "18.5.1 (L1) Ensure 'MSS: (AutoAdminLogon) Enable Automatic Logon' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon';
Write-Output '====';
$testcase = "18.5.2 (L1) Ensure 'MSS: (DisableIPSourceRouting IPv6) IP source routing protection level' is set to 'Enabled: Highest protection, source routing is completely disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip6\Parameters' -Name 'DisableIPSourceRouting';
Write-Output '====';
$testcase = "18.5.3 (L1) Ensure 'MSS: (DisableIPSourceRouting) IP source routing protection level' is set to 'Enabled: Highest protection, source routing is completely disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'DisableIPSourceRouting';
Write-Output '====';
$testcase = "18.5.4 (L1) Ensure 'MSS: (EnableICMPRedirect) Allow ICMP redirects to override OSPF generated routes' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\Tcpip\Parameters' -Name 'EnableICMPRedirect';
Write-Output '====';
$testcase = "18.5.6 (L1) Ensure 'MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Services\NetBT\Parameters' -Name 'nonamereleaseondemand';
Write-Output '====';
$testcase = "18.5.8 (L1) Ensure 'MSS: (SafeDllSearchMode) Enable Safe DLL search mode' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'SafeDllSearchMode';
Write-Output '====';
$testcase = "18.5.9 (L1) Ensure 'MSS: (ScreenSaverGracePeriod) The time in seconds before the screen saver grace period expires' is set to 'Enabled: 5 or fewer seconds'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'ScreenSaverGracePeriod';
Write-Output '====';
$testcase = "18.5.12 (L1) Ensure 'MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning' is set to 'Enabled: 90% or less'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Eventlog\Security' -Name 'WarningLevel';
Write-Output '====';
$testcase = "18.6.4.1 (L1) Ensure 'Configure NetBIOS settings' is set to 'Enabled: Disable NetBIOS name resolution on public networks'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient' -Name 'EnableNetbios';
Write-Output '====';
$testcase = "18.6.4.2 (L1) Ensure 'Turn off multicast name resolution' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient' -Name 'EnableMulticast';
Write-Output '====';
$testcase = "18.6.8.1 (L1) Ensure 'Enable insecure guest logons' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation' -Name 'AllowInsecureGuestAuth';
Write-Output '====';
$testcase = "18.6.11.2 (L1) Ensure 'Prohibit installation and configuration of Network Bridge on your DNS domain network' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections' -Name 'NC_AllowNetBridge_NLA';
Write-Output '====';
$testcase = "18.6.11.3 (L1) Ensure 'Prohibit use of Internet Connection Sharing on your DNS domain network' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections' -Name 'NC_ShowSharedAccessUI';
Write-Output '====';
$testcase = "18.6.11.4 (L1) Ensure 'Require domain users to elevate when setting a network's location' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Network Connections' -Name 'NC_StdDomainUserSetLocation';
Write-Output '====';
$testcase = "18.6.14.1 (L1) Ensure 'Hardened UNC Paths' is set to 'Enabled, with 'Require Mutual Authentication', 'Require Integrity', and 'Require Privacy' set for all NETLOGON and SYSVOL shares'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths' -Name '\\*\NETLOGON';
Write-Output '====';
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths' -Name '\\*\SYSVOL';
Write-Output '====';
$testcase = "18.6.21.1 (L1) Ensure 'Minimize the number of simultaneous connections to the Internet or a Windows Domain' is set to 'Enabled: 1 = Minimize simultaneous connections'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\WcmSvc\GroupPolicy' -Name 'fMinimizeConnections';
Write-Output '====';
$testcase = "18.7.2 (L1) Ensure 'Configure Redirection Guard' is set to 'Enabled: Redirection Guard Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers' -Name 'RedirectionGuardPolicy';
Write-Output '====';
$testcase = "18.7.3 (L1) Ensure 'Configure RPC connection settings: Protocol to use for outgoing RPC connections' is set to 'Enabled: RPC over TCP'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\RPC' -Name 'RpcUseNamedPipeProtocol';
Write-Output '====';
$testcase = "18.7.4 (L1) Ensure 'Configure RPC connection settings: Use authentication for outgoing RPC connections' is set to 'Enabled: Default'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\RPC' -Name 'RpcAuthentication';
Write-Output '====';
$testcase = "18.7.5 (L1) Ensure 'Configure RPC listener settings: Protocols to allow for incoming RPC connections' is set to 'Enabled: RPC over TCP'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\RPC' -Name 'RpcProtocols';
Write-Output '====';
$testcase = "18.7.6 (L1) Ensure 'Configure RPC listener settings: Authentication protocol to use for incoming RPC connections:' is set to 'Enabled: Negotiate' or higher"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\RPC' -Name 'ForceKerberosForRpc';
Write-Output '====';
$testcase = "18.7.7 (L1) Ensure 'Configure RPC over TCP port' is set to 'Enabled: 0'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\RPC' -Name 'RpcTcpPort';
Write-Output '====';
$testcase = "18.7.8 (L1) Ensure 'Limits print driver installation to Administrators' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint' -Name 'RestrictDriverInstallationToAdministrators';
Write-Output '====';
$testcase = "18.7.9 (L1) Ensure 'Manage processing of Queue-specific files' is set to 'Enabled: Limit Queue-specific files to Color profiles'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers' -Name 'CopyFilesPolicy';
Write-Output '====';
$testcase = "18.7.10 (L1) Ensure 'Point and Print Restrictions: When installing drivers for a new connection' is set to 'Enabled: Show warning and elevation prompt'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint' -Name 'NoWarningNoElevationOnInstall';
Write-Output '====';
$testcase = "18.7.11 (L1) Ensure 'Point and Print Restrictions: When updating drivers for an existing connection' is set to 'Enabled: Show warning and elevation prompt'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint' -Name 'UpdatePromptSettings';
Write-Output '====';
$testcase = "18.9.3.1 (L1) Ensure 'Include command line in process creation events' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\Currentversion\Policies\System\Audit' -Name 'ProcessCreationIncludeCmdLine_Enabled';
Write-Output '====';
$testcase = "18.9.4.1 (L1) Ensure 'Encryption Oracle Remediation' is set to 'Enabled: Force Updated Clients'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters' -Name 'AllowEncryptionOracle';
Write-Output '====';
$testcase = "18.9.4.2 (L1) Ensure 'Remote host allows delegation of non-exportable credentials' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation' -Name 'AllowProtectedCreds';
Write-Output '====';
$testcase = "18.9.7.2 (L1) Ensure 'Prevent device metadata retrieval from the Internet' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Device Metadata' -Name 'PreventDeviceMetadataFromNetwork';
Write-Output '====';
$testcase = "18.9.13.1 (L1) Ensure 'Boot-Start Driver Initialization Policy' is set to 'Enabled: Good, unknown and bad but critical'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\System\CurrentControlSet\Policies\EarlyLaunch' -Name 'DriverLoadPolicy';
Write-Output '====';
$testcase = "18.9.19.2 (L1) Ensure 'Configure registry policy processing: Do not apply during periodic background processing' is set to 'Enabled: FALSE'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}' -Name 'NoBackgroundPolicy';
Write-Output '====';
$testcase = "18.9.19.3 (L1) Ensure 'Configure registry policy processing: Process even if the Group Policy objects have not changed' is set to 'Enabled: TRUE'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}' -Name 'NoGPOListChanges';
Write-Output '====';
$testcase = "18.9.19.4 (L1) Ensure 'Configure security policy processing: Do not apply during periodic background processing' is set to 'Enabled: FALSE'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{827D319E-6EAC-11D2-A4EA-00C04F79F83A}' -Name 'NoBackgroundPolicy';
Write-Output '====';
$testcase = "18.9.19.5 (L1) Ensure 'Configure security policy processing: Process even if the Group Policy objects have not changed' is set to 'Enabled: TRUE'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{827D319E-6EAC-11D2-A4EA-00C04F79F83A}' -Name 'NoGPOListChanges';
Write-Output '====';
$testcase = "18.9.19.6 (L1) Ensure 'Continue experiences on this device' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'EnableCdp';
Write-Output '====';
$testcase = "18.9.19.7 (L1) Ensure 'Turn off background refresh of Group Policy' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'DisableBkGndGroupPolicy';
Write-Output '====';
$testcase = "18.9.20.1.1 Ensure 'Turn off downloading of print drivers over HTTP' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers' -Name 'DisableWebPnPDownload';
Write-Output '====';
$testcase = "18.9.20.1.5 Ensure 'Turn off Internet download for Web publishing and online ordering wizards' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoWebServices';
Write-Output '====';
$testcase = "18.9.24.1 (L1) Ensure 'Enumeration policy for external devices incompatible with Kernel DMA Protection' is set to 'Enabled: Block All'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Kernal DMA Protection' -Name 'DeviceEnumerationPolicy';
Write-Output '====';
$testcase = "18.9.25.1 (L1) Ensure 'Configure password backup directory' is set to 'Enabled: Active Directory' or 'Enabled: Azure Active Directory'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\LAPS' -Name 'BackupDirectory';
Write-Output '====';
$testcase = "18.9.25.2 (L1) Ensure 'Do not allow password expiration time longer than required by policy' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\LAPS' -Name 'PwdExpirationProtectionEnabled';
Write-Output '====';
$testcase = "18.9.25.3 (L1) Ensure 'Enable password encryption' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\LAPS' -Name 'ADPasswordEncryptionEnabled';
Write-Output '====';
$testcase = "18.9.25.4 (L1) Ensure 'Password Settings: Password Complexity' is set to 'Enabled: Large letters + small letters + numbers + special characters'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\LAPS' -Name 'PasswordComplexity';
Write-Output '====';
$testcase = "18.9.25.5 (L1) Ensure 'Password Settings: Password Length' is set to 'Enabled: 15 or more'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\LAPS' -Name 'PasswordLength';
Write-Output '====';
$testcase = "18.9.25.6 (L1) Ensure 'Password Settings: Password Age (Days)' is set to 'Enabled: 30 or fewer'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\LAPS' -Name 'PasswordAgeDays';
Write-Output '====';
$testcase = "18.9.25.7 (L1) Ensure 'Post-authentication actions: Grace period (hours)' is set to 'Enabled: 8 or fewer hours, but not 0'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\LAPS' -Name 'PostAuthenticationResetDelay';
Write-Output '====';
$testcase = "18.9.25.8 (L1) Ensure 'Post-authentication actions: Actions' is set to 'Enabled: Reset the password and logoff the managed account' or higher"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\LAPS' -Name 'PostAuthenticationActions';
Write-Output '====';
$testcase = "18.9.28.1 (L1) Ensure 'Block user from showing account details on sign-in' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'BlockUserFromShowingAccountDetailsOnSignin';
Write-Output '====';
$testcase = "18.9.28.2 (L1) Ensure 'Do not display network selection UI' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'DontDisplayNetworkSelectionUI';
Write-Output '====';
$testcase = "18.9.28.3 Ensure 'Do not enumerate connected users on domain-joined computers' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'DontEnumerateConnectedUsers';
Write-Output '====';
$testcase = "18.9.28.4 (L1) Ensure 'Enumerate local users on domain-joined computers' is set to 'Disabled' (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'EnumerateLocalUsers';
Write-Output '====';
$testcase = "18.9.28.5 (L1) Ensure 'Turn off app notifications on the lock screen' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'DisableLockScreenAppNotifications';
Write-Output '====';
$testcase = "18.9.28.6 (L1) Ensure 'Turn off picture password sign-in' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'BlockDomainPicturePassword';
Write-Output '====';
$testcase = "18.9.28.7 (L1) Ensure 'Turn on convenience PIN sign-in' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'AllowDomainPINLogon';
Write-Output '====';
$testcase = "18.9.33.6.3 (L1) Ensure 'Require a password when a computer wakes (on battery)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51' -Name 'DCSettingIndex';
Write-Output '====';
$testcase = "18.9.33.6.4 (L1) Ensure 'Require a password when a computer wakes (plugged in)' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51' -Name 'ACSettingIndex';
Write-Output '====';
$testcase = "18.9.35.1 (L1) Ensure 'Configure Offer Remote Assistance' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services' -Name 'fAllowUnsolicited';
Write-Output '====';
$testcase = "18.9.35.2 (L1) Ensure 'Configure Solicited Remote Assistance' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\policies\Microsoft\Windows NT\Terminal Services' -Name 'fAllowToGetHelp';
Write-Output '====';
$testcase = "18.9.36.1 (L1) Ensure 'Enable RPC Endpoint Mapper Client Authentication' is set to 'Enabled' (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Rpc' -Name 'EnableAuthEpResolution';
Write-Output '====';
$testcase = "18.9.51.1.1 (L1) Ensure 'Enable Windows NTP Client' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Windows\W32Time\TimeProviders\NtpClient' -Name 'Enabled';
Write-Output '====';
$testcase = "18.9.51.1.2 (L1) Ensure 'Enable Windows NTP Server' is set to 'Disabled' (MS only)"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Windows\W32Time\TimeProviders\NtpServer' -Name 'Enabled';
Write-Output '====';
$testcase = "18.10.5.1 (L1) Ensure 'Allow Microsoft accounts to be optional' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'MSAOptional';
Write-Output '====';
$testcase = "18.10.7.1 (L1) Ensure 'Disallow Autoplay for non-volume devices' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name 'NoAutoplayfornonVolume';
Write-Output '====';
$testcase = "18.10.7.2 (L1) Ensure 'Set the default behavior for AutoRun' is set to 'Enabled: Do not execute any autorun commands'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoAutorun';
Write-Output '====';
$testcase = "18.10.7.3 (L1) Ensure 'Turn off Autoplay' is set to 'Enabled: All drives'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoDriveTypeAutoRun';
Write-Output '====';
$testcase = "18.10.8.1.1 (L1) Ensure 'Configure enhanced anti-spoofing' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Biometrics\FacialFeatures' -Name 'EnhancedAntiSpoofing';
Write-Output '====';
$testcase = "18.10.12.1 (L1) Ensure 'Turn off cloud consumer account state content' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableConsumerAccountStateContent';
Write-Output '====';
$testcase = "18.10.12.2 (L1) Ensure 'Turn off Microsoft consumer experiences' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures';
Write-Output '====';
$testcase = "18.10.13.1 (L1) Ensure 'Require pin for pairing' is set to 'Enabled: First Time' OR 'Enabled: Always'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Connect' -Name 'RequirePinForPairing';
Write-Output '====';
$testcase = "18.10.14.1 (L1) Ensure 'Do not display the password reveal button' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\CredUI' -Name 'DisablePasswordReveal';
Write-Output '====';
$testcase = "18.10.14.2 (L1) Ensure 'Enumerate administrator accounts on elevation' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\CredUI' -Name 'EnumerateAdministrators';
Write-Output '====';
$testcase = "18.10.15.1 (L1) Ensure 'Allow Diagnostic Data' is set to 'Enabled: Diagnostic data off (not recommended)' or 'Enabled: Send required diagnostic data'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry';
Write-Output '====';
$testcase = "18.10.15.3 (L1) Ensure 'Disable OneSettings Downloads' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'DisableOneSettingsDownloads';
Write-Output '====';
$testcase = "18.10.15.4 (L1) Ensure 'Do not show feedback notifications' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'DoNotShowFeedbackNotifications';
Write-Output '====';
$testcase = "18.10.15.5 (L1) Ensure 'Enable OneSettings Auditing' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Datacollection' -Name 'EnableOneSettingsAuditing';
Write-Output '====';
$testcase = "18.10.15.6 (L1) Ensure 'Limit Diagnostic Log Collection' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Datacollection' -Name 'LimitDiagnosticLogCollection';
Write-Output '====';
$testcase = "18.10.15.7 (L1) Ensure 'Limit Dump Collection' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Datacollection' -Name 'LimitDumpCollection';
Write-Output '====';
$testcase = "18.10.15.8 (L1) Ensure 'Toggle user control over Insider builds' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds' -Name 'AllowBuildPreview';
Write-Output '====';

$testcase = "18.10.17.1 (L1) Ensure 'Enable App Installer' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppInstaller' -Name 'EnableAppInstaller';
Write-Output '====';
$testcase = "18.10.17.2 (L1) Ensure 'Enable App Installer Experimental Features' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppInstaller' -Name 'EnableExperimentalFeatures';
Write-Output '====';
$testcase = "18.10.17.3 (L1) Ensure 'Enable App Installer Hash Override' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppInstaller' -Name 'EnableHashOverride';
Write-Output '====';
$testcase = "18.10.17.4 (L1) Ensure 'Enable App Installer ms-appinstaller protocol' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppInstaller' -Name 'EnableMSAppInstallerProtocol';
Write-Output '====';
$testcase = "18.10.25.1.1 (L1) Ensure 'Application: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application' -Name 'Retention';
Write-Output '====';
$testcase = "18.10.25.1.2 (L1) Ensure 'Application: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Application' -Name 'MaxSize';
Write-Output '====';
$testcase = "18.10.25.2.1 (L1) Ensure 'Security: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security' -Name 'Retention';
Write-Output '====';
$testcase = "18.10.25.2.2 (L1) Ensure 'Security: Specify the maximum log file size (KB)' is set to 'Enabled: 196,608 or greater'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Security' -Name 'MaxSize';
Write-Output '====';
$testcase = "18.10.25.3.1 (L1) Ensure 'Setup: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup' -Name 'Retention';
Write-Output '====';
$testcase = "18.10.25.3.2 (L1) Ensure 'Setup: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\Setup' -Name 'MaxSize';
Write-Output '====';
$testcase = "18.10.25.4.1 (L1) Ensure 'System: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\System' -Name 'Retention';
Write-Output '====';
$testcase = "18.10.25.4.2 (L1) Ensure 'System: Specify the maximum log file size (KB)' is set to 'Enabled: 32,768 or greater'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\EventLog\System' -Name 'MaxSize';
Write-Output '====';
$testcase = "18.10.28.2 (L1) Ensure 'Turn off Data Execution Prevention for Explorer' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name 'NoDataExecutionPrevention';
Write-Output '====';
$testcase = "18.10.28.3 (L1) Ensure 'Turn off heap termination on corruption' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name 'NoHeapTerminationOnCorruption';
Write-Output '====';
$testcase = "18.10.28.4 (L1) Ensure 'Turn off shell protocol protected mode' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'PreXPSP2ShellProtocolBehavior';
Write-Output '====';
$testcase = "18.10.41.1 (L1) Ensure 'Block all consumer Microsoft account user authentication' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftAccount' -Name 'DisableUserAuth';
Write-Output '====';
$testcase = "18.10.42.5.1 (L1) Ensure 'Configure local setting override for reporting to Microsoft MAPS' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet' -Name 'LocalSettingOverrideSpynetReporting';
Write-Output '====';
$testcase = "18.10.42.6.1.1 (L1) Ensure 'Configure Attack Surface Reduction rules' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR' -Name 'ExploitGuard_ASR_Rules';
Write-Output '====';
$testcase = "18.10.42.6.1.2 (L1) Ensure 'Configure Attack Surface Reduction rules: Set the state for each ASR rule' is configured"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules' -Name '26190899-1602-49e8-8b27-eb1d0a1ce869';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules' -Name '3b576869-a4ec-4529-8536-b80a7769e899';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules' -Name '56a863a9-875e-4185-98a7-b882c64b5ce5';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules' -Name '5beb7efe-fd9a-4556-801d-275e5ffc04cc';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules' -Name '75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules' -Name '7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules' -Name '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules' -Name 'b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules' -Name 'be9ba2d9-53ea-4cdc-84e5-9b1eeee46550';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules' -Name 'd4f940ab-401b-4efc-aadc-ad5f3c50688a';
Write-Output '====';

$testcase = "18.10.42.6.3.1 (L1) Ensure 'Prevent users and apps from accessing dangerous websites' is set to 'Enabled: Block'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection' -Name 'EnableNetworkProtection';
Write-Output '====';
$testcase = "18.10.42.7.1 (L1) Ensure 'Enable file hash computation feature' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows Defender\MpEngine' -Name 'EnableFileHashComputation';
Write-Output '====';
$testcase = "18.10.42.10.1 (L1) Ensure 'Scan all downloaded files and attachments' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows Defender\Real-Time Protection' -Name 'DisableIOAVProtection';
Write-Output '====';
$testcase = "18.10.42.10.2 (L1) Ensure 'Turn off real-time protection' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows Defender\Real-Time Protection' -Name 'DisableRealtimeMonitoring';
Write-Output '====';
$testcase = "18.10.42.10.3 (L1) Ensure 'Turn on behavior monitoring' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' -Name 'DisableBehaviorMonitoring';
Write-Output '====';
$testcase = "18.10.42.10.4 (L1) Ensure 'Turn on script scanning' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection' -Name 'DisableScriptScanning';
Write-Output '====';
$testcase = "18.10.42.13.1 (L1) Ensure 'Scan packed executables' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan' -Name 'DisablePackedExeScanning';
Write-Output '====';
$testcase = "18.10.42.13.2 (L1) Ensure 'Scan removable drives' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan' -Name 'DisableRemovableDriveScanning';
Write-Output '====';
$testcase = "18.10.42.13.3 (L1) Ensure 'Turn on e-mail scanning' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan' -Name 'DisableEmailScanning';
Write-Output '====';
$testcase = "18.10.42.16 (L1) Ensure 'Configure detection for potentially unwanted applications' is set to 'Enabled: Block'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'PUAProtection';
Write-Output '====';
$testcase = "18.10.42.17 (L1) Ensure 'Turn off Microsoft Defender AntiVirus' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender' -Name 'DisableAntiSpyware';
Write-Output '====';
$testcase = "18.10.50.1 (L1) Ensure 'Prevent the usage of OneDrive for file storage' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\OneDrive' -Name 'DisableFileSyncNGSC';
Write-Output '====';
$testcase = "18.10.56.2.2 (L1) Ensure 'Do not allow passwords to be saved' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'DisablePasswordSaving';
Write-Output '====';
$testcase = "18.10.56.3.3.2 (L1) Ensure 'Do not allow drive redirection' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'fDisableCdm';
Write-Output '====';
$testcase = "18.10.56.3.9.1 (L1) Ensure 'Always prompt for password upon connection' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'fPromptForPassword';
Write-Output '====';
$testcase = "18.10.56.3.9.2 (L1) Ensure 'Require secure RPC communication' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services' -Name 'fEncryptRPCTraffic';
Write-Output '====';
$testcase = "18.10.56.3.9.3 (L1) Ensure 'Require use of specific security layer for remote (RDP) connections' is set to 'Enabled: SSL'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'SecurityLayer';
Write-Output '====';
$testcase = "18.10.56.3.9.4 (L1) Ensure 'Require user authentication for remote connections by using Network Level Authentication' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'UserAuthentication';
Write-Output '====';
$testcase = "18.10.56.3.9.5 (L1) Ensure 'Set client connection encryption level' is set to 'Enabled: High Level'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'MinEncryptionLevel';
Write-Output '====';
$testcase = "18.10.56.3.11.1 (L1) Ensure 'Do not delete temp folders upon exit' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'DeleteTempDirsOnExit';
Write-Output '====';
$testcase = "18.10.56.3.11.2 (L1) Ensure 'Do not use temporary folders per session' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Terminal Services' -Name 'PerSessionTempDir';
Write-Output '====';
$testcase = "18.10.57.1 (L1) Ensure 'Prevent downloading of enclosures' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds' -Name 'DisableEnclosureDownload';
Write-Output '====';
$testcase = "18.10.58.3 (L1) Ensure 'Allow indexing of encrypted files' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowIndexingEncryptedStoresOrItems';
Write-Output '====';
$testcase = "18.10.75.2.1 (L1) Ensure 'Configure Windows Defender SmartScreen' is set to 'Enabled: Warn and prevent bypass'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'EnableSmartScreen';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'ShellSmartScreenLevel';
Write-Output '====';
$testcase = "18.10.79.2 (L1) Ensure 'Allow Windows Ink Workspace' is set to 'Enabled: On, but disallow access above lock' OR 'Enabled: Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace' -Name 'AllowWindowsInkWorkspace';
Write-Output '====';
$testcase = "18.10.80.1 (L1) Ensure 'Allow user control over installs' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Installer' -Name 'EnableUserControl';
Write-Output '====';
$testcase = "18.10.80.2 (L1) Ensure 'Always install with elevated privileges' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Installer' -Name 'AlwaysInstallElevated';
Write-Output '====';
$testcase = "18.10.81.1 (L1) Ensure 'Sign-in and lock last interactive user automatically after a restart' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\policies\system' -Name 'DisableAutomaticRestartSignOn';
Write-Output '====';
$testcase = "18.10.88.1.1 (L1) Ensure 'Allow Basic authentication' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client' -Name 'AllowBasic';
Write-Output '====';
$testcase = "18.10.88.1.2 (L1) Ensure 'Allow unencrypted traffic' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client' -Name 'AllowUnencryptedTraffic';
Write-Output '====';
$testcase = "18.10.88.1.3 (L1) Ensure 'Disallow Digest authentication' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Client' -Name 'AllowDigest';
Write-Output '====';
$testcase = "18.10.88.2.1 (L1) Ensure 'Allow Basic authentication' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service' -Name 'AllowBasic';
Write-Output '====';
$testcase = "18.10.88.2.3 (L1) Ensure 'Allow unencrypted traffic' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service' -Name 'AllowUnencryptedTraffic';
Write-Output '====';
$testcase = "18.10.88.2.4 (L1) Ensure 'Disallow WinRM from storing RunAs credentials' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\WinRM\Service' -Name 'DisableRunAs';
Write-Output '====';
$testcase = "18.10.91.2.1 (L1) Ensure 'Prevent users from modifying settings' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection' -Name 'DisallowExploitProtectionOverride';
Write-Output '====';
$testcase = "18.10.92.1.1 (L1) Ensure 'No auto-restart with logged on users for scheduled automatic updates installations' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoRebootWithLoggedOnUsers';
Write-Output '====';
$testcase = "18.10.92.2.1 (L1) Ensure 'Configure Automatic Updates' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoUpdate';
Write-Output '====';
$testcase = "18.10.92.2.2 (L1) Ensure 'Configure Automatic Updates: Scheduled install day' is set to '0 - Every day'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'ScheduledInstallDay';
Write-Output '====';
$testcase = "18.10.92.4.1 (L1) Ensure 'Manage preview builds' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name 'ManagePreviewBuildsPolicyValue';
Write-Output '====';
$testcase = "18.10.92.4.2 (L1) Ensure 'Select when Preview Builds and Feature Updates are received' is set to 'Enabled: 180 or more days'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name 'DeferFeatureUpdates';
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windowsupdate' -Name 'DeferFeatureUpdatesPeriodInDays';
Write-Output '====';
$testcase = "18.10.92.4.3 (L1) Ensure 'Select when Quality Updates are received' is set to 'Enabled: 0 days'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name 'DeferQualityUpdates';
Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' -Name 'DeferQualityUpdatesPeriodInDays';
Write-Output '====';
$testcase = "19.5.1.1 (L1) Ensure 'Turn off toast notifications on the lock screen' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKU:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'NoToastApplicationNotificationOnLockScreen';
Write-Output '====';
$testcase = "19.7.5.1 (L1) Ensure 'Do not preserve zone information in file attachments' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments' -Name 'SaveZoneInformation';
Write-Output '====';
$testcase = "19.7.5.2 (L1) Ensure 'Notify antivirus programs when opening attachments' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments' -Name 'ScanWithAntiVirus';
Write-Output '====';
$testcase = "19.7.8.1 (L1) Ensure 'Configure Windows spotlight on lock screen' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKU:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'ConfigureWindowsSpotlight';
Write-Output '====';
$testcase = "19.7.8.2 (L1) Ensure 'Do not suggest third-party content in Windows spotlight' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKU:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableThirdPartySuggestions';
Write-Output '====';
$testcase = "19.7.8.5 (L1) Ensure 'Turn off Spotlight collection on Desktop' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKU:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSpotlightCollectionOnDesktop';
Write-Output '====';
$testcase = "19.7.26.1 (L1) Ensure 'Prevent users from sharing files within their profile.' is set to 'Enabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoInplaceSharing';
Write-Output '====';
$testcase = "19.7.42.1 (L1) Ensure 'Always install with elevated privileges' is set to 'Disabled'"
Write-Output "$testcase"
Get-ItemPropertyValue -Path 'HKLM:\Software\Policies\Microsoft\Windows\Installer' -Name 'AlwaysInstallElevated';
Write-Output '====';



