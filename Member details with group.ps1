$Pathe = "C:\ADuserDetailsGa.csv"
Add-Content -Path $Pathe  -Value '"Name","Username","Email","Account created date","Account status","Dates to expire password","Password last reset date","Last log on date","Account expiration date","Account deactivated date","Groups"'
$users = Get-ADUser -Filter * -Properties *
foreach($user in $users){
    $d0 = $user.Name
    $dun = $user.userprincipalname
    $demail = $user.emailaddress
    $d1 = $user.whencreated
    $d2 = $user.Enabled
    if($d2 -eq $true){
        $d2 = "Enabled"
    }else{
        $d2 = "Disabled" #if null
    }
    $d3 = $user.AccountExpirationDate
    if($d3 -eq $null){
        $d3 = "No Expiration"
    }
    $d4 = $user.passwordlastset
    if($user.lastlogon -eq $null){
        $d5 = ""
    }else{
        $d5 = [datetime]::FromFileTime($user.lastlogon)
    }
    #Account Expiration Date
    $PasswordExpire = (Get-ADUser -Filter {PasswordNeverExpires -eq $False -and Name -eq $user.name} -Properties "msDS-UserPasswordExpiryTimeComputed")."msDS-UserPasswordExpiryTimeComputed"
        if($PasswordExpire -eq $null){
        $d6 = "Password Never Expire"
    }else{
        $d6 = [datetime]::FromFileTime($PasswordExpire) #if null
    }
    #Account Deactivated Date
    if($user.Enabled -eq $false){
     $d7 = $user.whenchanged
    }else{
     $d7 = "Currently in Activated State"
    }
    #Member Group of
    $dom = "DC=h1lab,DC=club"

    $groups = $user.MemberOf -split $dom
    $groupsf= $null
    foreach($group in $groups){
       if($group.length -gt 0){
          $grouptemp = $group.split("=")[1] 
          $groupsf = $groupsf + $grouptemp.split(",")[0] + ","
       }
    }
    
     $hash = @{
                 "Name" = $d0
                 "Username" = $dun
                 "Email" = $demail
                 "Account created date" = $d1
                 "Account status" = $d2 
                 "Dates to expire password" = $d6  
                 "Password last reset date" = $d4
                 "Last log on date" = $d5
                 "Account expiration date" = $d3
                 "Account deactivated date" = $d7
                 "Groups" = $groupsf
                 }
    $newRow = New-Object PsObject -Property $hash
    Export-Csv $Pathe -inputobject $newrow -append -Force
}
