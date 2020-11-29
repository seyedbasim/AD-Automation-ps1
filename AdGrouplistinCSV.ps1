$Users = Get-ADUser -Filter * -SearchBase "OU=LKA,OU=MidasSafety,DC=midassafety,DC=com"
Add-Content -Path C:\GroupDetails.csv  -Value '"Name","Groups"'
foreach($user in $users){
  $Groups = Get-ADPrincipalGroupMembership -Identity $user.SID
      $hash = @{
                 "Name" = $user.Name
                 "Groups" = "-"
                 }
      $newRow = New-Object PsObject -Property $hash
      Export-Csv C:\GroupDetails.csv -inputobject $newrow -append -Force
  foreach($Group in $Groups){
      $hash = @{
             "Name" = ""
             "Groups" = $Group.name
             }
      $newRow = New-Object PsObject -Property $hash
      Export-Csv C:\GroupDetails.csv -inputobject $newrow -append -Force
  }
}