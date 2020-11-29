$computers = Import-Csv "C:\Users\Basim\Desktop\removeAD\list.csv"
$computers | ForEach-Object{
    $computer = $_
    Get-ADComputer -Identity $computer.PCName | Remove-ADObject -Confirm:$false -Recursive
}