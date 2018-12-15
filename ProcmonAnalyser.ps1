# Outputs pre-defined filters from procmon log file (logfile.csv)
$promon_log = "logfile.csv"

function insertHeaders
{
    param($filepath)
    $headers = "Time of Day","Process Name","PID","Operation","Path","Result","Detail"
    if((Test-Path -Path $filepath) -ne $True)
    {
        $headers >> $filepath
    }
}

function sortCsv
{
    param($filename)
    # sort by processname & path
    $headers = "Time of Day","Process Name","PID","Operation","Path","Result","Detail"
    $temp = Import-Csv $filename -header $headers  | sort 'Process Name','Path' -Unique | sort "Time of Day"
    $temp | Export-csv -Path $filename -notypeinformation
}

function sortCsvDetail
{
    param($filename)
    # sort by detail & path
    $headers = "Time of Day","Process Name","PID","Operation","Path","Result","Detail"
    $temp =  Import-Csv $filename -header $headers | sort 'Path','Detail' -Unique | sort "Time of Day"
    $temp| Export-csv -Path $filename -notypeinformation
}

$longLine = ''
$prev = ''
# Not reading the whole file at once because it's really bad for your RAM
foreach($line in [System.IO.File]::ReadLines($promon_log))
{
       if($line[0] -eq ";"){ # takes care of unusual lines
            if($longLine){
                 $longLine += $prev
            }
            $longLine += $line
            continue
       }
       $prev = $line

       if($longLine){
            $line = $longLine
            $longLine = ''
       }
       
       $members= $line.Split(",")
       $operation = $members[3].Trim('\"')
       $path = $members[4].Trim('\"')
       $ProcessName = $members[1].Trim('\"')
       $detail = $members[6].Trim('\"')
       
       if($operation -eq "WriteFile")
       {
            $line>> "writeFile.csv" 
       }

       if($operation -eq "Process Create")
       {
            $line >> "Process Create.csv" 
       }

       if(($operation -eq "load Image") -and ($ProcessName -eq "Explorer.exe"))
       {
       # filter for detecting dll injection to explorer.exe (can be applied to any other process..)
            $line >> "explorerInjection.csv" 
       }

       if($operation -eq "RegSetValue")
       {
            $line >> "RegSetValue.csv" 
             if( $Detail -like "*http*"){
                    # Some malware like to persist in the registry with URLs, to download further goods
                    $line  >> "HTTPRegSetValue.csv" 
             }
           
       }
       
       if($Detail -like "*action=allow*")
       {
            $line >> "firewallActions.csv" 
       }

       if($path -like "*AppData\Local\Microsoft\Windows\INetCache*")
       {
            $line >> "tempInternetFiles.csv" 
       }

       if($path -like "*.txt*")
       {
            $line >> "txt.csv" 
       }

       if($path -like "*.js*")
       {
            $line >> "js.csv" 
       }

       if($path -like "*.lnk*")
       {
            $line >> "lnk.csv" 
       }

       if($path -like "*.db*")
       {
            $line >> "db.csv" 
       }

       if($path -like "*internet explorer*")
       {
            $line >> "internet explorer.csv" 
       }

       if(($Detail -like "*.exe*") -or ($Detail -like "*.dll*") -or ($Detail -like "*C:*"))
       {
            $line >> "exes-dlls.csv" 
       }

       else{}
}

$filters = "writeFile.csv","explorerInjection.csv","txt.csv","js.csv","db.csv","lnk.csv","firefox.csv","internet explorer.csv","tempInternetFiles.csv"
$filtersDetail = "RegSetValue.csv","exes-dlls.csv","firewallActions.csv"

# Eliminate all duplicates from the outputed files, and sort by time
foreach($filter in $filters){
    sortCsv -filename $filter
}

foreach($filter in $filtersDetail){
    sortCsvDetail -filename $filter
}