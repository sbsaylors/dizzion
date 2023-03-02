
#---------------------------------------------------------------------------------------------------------------------------#
#
# Create automation to remove snapshots from VMs older than 30 days. The automation should
# send a report via email on the operations it performed. 
#
# Rules: 
# 1.      Please complete within 4 days 
# 2.      Should be done in standalone code without the use of orchestration or automation
#         suites like vRA or vRO 
# 3.      You can use PowerShell or Python
# 4.      Please store publically with us on GitHub or Bitbucket, (or any public repo) and
#         be prepared to demo if needed
#
#---------------------------------------------------------------------------------------------------------------------------#
#
 
# start app
# get date and time
# has a new day happened?
#     if so send email of log of events
# 
# get time
# get second
# if second is odd show a ♥ after time.
# if second is even show a · after time.
# display date & time & special character


#--------------------------------------------------------------------------------#
#--- FUNCTIONS ------------------------------------------------------------------#
#--------------------------------------------------------------------------------#


#-------------------------------------------------------------#
function f_CheckForOldVM
    {

     $WillDeleteDate=$CurrentDate.adddays(-02).ToString("yyyy-MM-dd") #-- get date to compare

     $vmSnapshots=Get-VM -computername localhost | Get-VMSnapshot     #-- list our vms

     foreach ($SnapName in $vmSnapshots)                              #-- loop through vms
        {
         $VMbirthday=$SnapName.CreationTime.Date.ToString("yyyy-MM-dd")
         $SnapName.name

         if ($VMbirthday -lt $WillDeleteDate)                         #-- if date is to old
            {                                                         #-- remove the vm
             Remove-VMSnapshot -VMname $SnapName.vmname -name  $SnapName.name
             $emailbodyinfo=$SnapName.name +" Checkpoint deleted on VM of " +$SnapName.vmname +" because it was over 30 days old." 
             $emailbodyinfo                                           #-- show info on console
            
             f_sendgmail($emailbodyinfo)                              #-- send email 
             Start-Sleep -Seconds 2                                   #-- pause to let folks read
            }
        }
    }


#-------------------------------------------------------------#
function f_showVMinfo
    {
     $d=Get-VM -computername localhost | Get-VMSnapshot

     #$d.ComputerName
     #$d.ParentSnapshotName
     $d.Name
     #d.CreationTime.Date.DateTime

    }


#-------------------------------------------------------------#

function f_sendgmail($emailbody)
    {
    $emailbody
     $From = "sbsaylors@dizzion.com"
     $To = "sbsaylors@dizzion.com"
     $Cc = "teamfolder@dizzion.com"
     #$Attachment = "C:file.txt"
     $Subject = "VM Snapshot to old - deleted"
     $Body = $emailbody
     $SMTPServer = "smtp.dizzion.com"
     $SMTPPort = "587"
     Send-MailMessage -From $From -to $To -Cc $Cc -Subject $Subject `
     -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
     -Credential (Get-Credential) # -Attachments $Attachment
    }



#--------------------------------------------------------------------------------#
#--- Variables ------------------------------------------------------------------#
#--------------------------------------------------------------------------------#

$ImAliveChar="/―\|"        #-- chars for "running" automation in right corner
$ImAliveCharpart=0         #-- which char will show in the "running" automation
$letsexit=0                #-- do loop value - used to see if user wants to exit

$CheckSecondChange         #-- remember what last second was as trigger for action
$CheckMinuteChange         #-- used to remember last minute

$emailbody                 #-- hold log info to send in email



#--------------------------------------------------------------------------------#
#--- Start ----------------------------------------------------------------------#
#--------------------------------------------------------------------------------#



do
{
    #--- check for user input -----------------------#

    if ([Console]::KeyAvailable)                     #- Keypress?
       {
        $keyInfo = [Console]::ReadKey($true)         #- if so read key info
        if ($keyInfo.KeyChar -eq 'q')                #- if 'q' trigger exit loop
           {$letsexit =1}                            #- by setting value to true

        if ($keyInfo.KeyChar -eq 'r')                #- if 'r' trigger refresh of snapshots
           {
            
           }
       }



     #--- updates our timers ------------------------#

     $CurrentDate=get-date 
     $CurrentSecond=(Get-Date).Second


     #--- check our timer ---------------------------#
     if($CheckSecondChange -ne $CurrentSecond)
        {
         Clear-Host;
         '{0} {1} {2}' -f $ImAliveChar[$ImAliveCharpart], $currentdate.ToString("yyyy-MM-dd"),"<-[Current Date]"
         $AncientVM=$CurrentDate.adddays(-3)
         '{0} {1} {2}' -f "°", $AncientVM.ToString("yyyy-MM-dd"), "<-[Delete VM's or older]"
         " "
         " --= Press 'q' to quick anytime =--"
         " " 

         $ImAliveCharpart=$ImAliveCharpart+1
         if ($ImAliveCharpart -ge 4) { $ImAliveCharpart=0 }
                
         f_CheckForOldVM                             #-- Lets see if we have old Vms
        }

     $CheckSecondChange=$CurrentSecond               #-- to remember last second.

 } while ($letsexit -ne '1')

 "Bye!"



 


 #################### adding rem ################
f_showVMinfo