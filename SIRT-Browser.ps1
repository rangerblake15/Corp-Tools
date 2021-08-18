Get-Process iexplore -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue -Verbose
$tempInternetFolders = @( "C:\Users\$env:username\Appdata\Local\Temp\Microsoft\Windows\Temporary Internet Files\*", 
                          "C:\Users\$env:username\Appdata\Local\TMicrosoft\Windows\INetCache\*", 
                          "C:\Users\$env:username\Appdata\Local\Microsoft\Windows\Cookies\*"
                        )
Remove-Item $tempInternetFolders -Force -Recurse -Verbose -ErrorAction SilentlyContinue
$t_path_7 = "C:\Users\$env:username\AppData\Local\Microsoft\Windows\Temporary Internet Files"
$c_path_7 = "C:\Users\$env:username\AppData\Local\Microsoft\Windows\Caches"
$temporary_path =  Test-Path $t_path_7
$check_cache =    Test-Path $c_path_7
if($temporary_path -eq $True -And $check_cache -eq $True)
{
    #Delete History
    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1

    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
    
    Remove-Item $t_path_7\* -Force -Recurse -ErrorAction SilentlyContinue
    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2

    #Delete Cache
    Remove-Item $c_path_7\* -Force -Recurse -ErrorAction SilentlyContinue

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
        Remove-Item "$Folder\$_" 
    }
}
Get-Process firefox -ErrorAction SilentlyContinue | Stop-Process -ErrorAction SilentlyContinue -Force -Verbose
$LocalDataDir = "C:\Users\$($env:USERNAME)\AppData\Local\Mozilla\Firefox\Profiles"
$RoamingDataDir = "C:\Users\$($env:USERNAME)\AppData\Roaming\Mozilla\Firefox\Profiles\*"
if (ls $LocalDataDir -ErrorAction SilentlyContinue)
{
    Remove-Item -Path $LocalDataDir -Recurse -Force -Confirm:$False -Verbose
}
if (ls $RoamingDataDir)
{
    $sqlTables = [System.String]::Concat($file.FullName,"\*sqlite")
    foreach ($table in $(ls $sqlTables))
    {   
        Remove-Item -Path $table -Force -Confirm:$False -Verbose 
    }
}

