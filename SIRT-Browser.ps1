Get-Process iexplore -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue -Verbose
$tempInternetFolders = @( "C:\Users\$env:username\Appdata\Local\Temp\Microsoft\Windows\Temporary Internet Files\*", 
                          "C:\Users\$env:username\Appdata\Local\TMicrosoft\Windows\INetCache\*", 
                          "C:\Users\$env:username\Appdata\Local\Microsoft\Windows\Cookies\*"
                        )
Get-ChildItem -Path $tempInternetFolders -Recurse | Remove-Item -force
$t_path_7 = "C:\Users\$env:username\AppData\Local\Microsoft\Windows\Temporary Internet Files"
$c_path_7 = "C:\Users\$env:username\AppData\Local\Microsoft\Windows\Caches"
$temporary_path =  Test-Path $t_path_7
$check_cache =    Test-Path $c_path_7
if($temporary_path -eq $True -And $check_cache -eq $True)
{
    #Delete History
    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
    Get-ChildItem -Path $t_path_7 -Recurse | Remove-Item -force
    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
    #Delete Cache
    Get-ChildItem -Path $c_path_7 -Recurse | Remove-Item -force
}   
Get-Process chrome -ErrorAction SilentlyContinue | Stop-Process -Force -Verbose -ErrorAction SilentlyContinue
$Items = @('Archived History',
        'Cache\*',
        'Cookies',
        'History',
        'Login Data',
        'Top Sites',
        'Visited Links',
        'Web Data')
$Folder = "$($env:LOCALAPPDATA)\Google\Chrome\User Data\Default"
$Items | % { 
    if (Test-Path "$Folder\$_") {
        Get-ChildItem -Path "$Folder\$_" -Recurse | Remove-Item -force
    }
}
Get-Process firefox -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue -Force -Verbose
$LocalDataDir = "C:\Users\$($env:USERNAME)\AppData\Local\Mozilla\Firefox\Profiles"
$RoamingDataDir = "C:\Users\$($env:USERNAME)\AppData\Roaming\Mozilla\Firefox\Profiles\*"
if (ls $LocalDataDir -ErrorAction SilentlyContinue)
{
    Get-ChildItem -Path $LocalDataDir -Recurse | Remove-Item -force
}
if (ls $RoamingDataDir)
{
    $sqlTables = [System.String]::Concat($file.FullName,"\*sqlite")
    foreach ($table in $(ls $sqlTables))
    {   
        Get-ChildItem -Path $table -Recurse | Remove-Item -force
    }
}
