# source directory InputDirectory
# destination directory $OutputDirectory
param (
    $InputDirectory, 
    $OutputDirectory
    )

# find all files types
$FileExtensionArray = (Get-ChildItem $InputDirectory -Recurse -File -Force -ErrorAction SilentlyContinue | sort extension -Unique).Extension | ? {$_.trim() -ne "" } ;

# summarize files with an noextension
$no_ext = "{0:N2}" -f ((Get-ChildItem $InputDirectory  -Recurse -File -Filter '*.' | Measure -property length -sum ).sum/1Mb)

# summarize files with an extension
function sort_data {
  foreach ($f in $FileExtensionArray)
   {
      $FilelSize = (Get-ChildItem $InputDirectory -Force -Recurse -ErrorAction SilentlyContinue -Include "*$f" | Measure -property length -sum);
      $f + " - " + "{0:N2}" -f ($FilelSize.sum / 1MB);
   }
}

# function to union noextension and extension types
function sort_all {
    "no_ext" +  " - "  + $no_ext 
    sort_data
}

# sort types by size, show the top 10 types and write report to file
sort_all | ForEach-Object {
    $Line = $_.Trim() -Split '\s+'
    New-Object -TypeName PSCustomObject -Property @{
        Extension = $Line[0]
        SummaryValue_in_Mb = [float]$Line[2]
    }
} | Sort-Object SummaryValue_in_Mb | Select-Object -First 10 | Format-Table > $OutputDirectory/report.txt