<#
Updated Variables for Policies and Profiles
#>
$sshKeyNew = "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAEjNtg6YwV8zyHcz5PA91aSUvyPiIPVRi1sTKdsdeFFKmyvBK9yBXJBqIPi1FTikEK3WFN/J6H7O0tzTZUhweJ4tACAC4DBWckWHWn1ZgWqc2nfBA26xY/0ilU9ptwUsevH+u0zQoWIhQe+DAwOxPNoB3LA76ck1BkW55quzFelak0fIg== sandkum5@SANDKUM5-M-WLMC"

# Load Balancer Settings
$lbCountNew = 2

# Control Plane Node Group
# Working Values: D=3,Min=2,Max=3 | D=1,Min=1,Max=2 | D=3,Min=2,Max=4
$cpDesiredsizeNew = 3 # Options: 1 or 3
$cpMinsizeNew     = 2 # Values: >0
$cpMaxsizeNew     = 3 # Values: >1

# Worker Node Group
# Working Values: D=2,Min=2,Max=3
$wDesiredsizeNew = 2 # Values: >0
$wMinsizeNew     = 2 # Values: >0
$wMaxsizeNew     = 3 # Values: >1

Write-Output $sshKeyNew $lbCountNew $cpDesiredSizeNew $cpMinSizeNew $cpMaxSizeNew $wDesiredSizeNew $wMinSizeNew $wMaxSizeNew | Out-Null
