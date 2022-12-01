
param (
    $InputDirectory, 
    $OutputDirectory
    )

$FileExtensionArray = (Get-ChildItem $InputDirectory -Recurse -File -Force -ErrorAction SilentlyContinue | sort extension -Unique).Extension | ? {$_.trim() -ne "" } ;
$no_ext = "{0:N2}" -f ((Get-ChildItem $InputDirectory  -Recurse -File -Filter '*.' | Measure -property length -sum ).sum/1Mb)

function sort_data {
  foreach ($f in $FileExtensionArray)
   {
      $FilelSize = (Get-ChildItem $InputDirectory -Force -Recurse -ErrorAction SilentlyContinue -Include "*$f" | Measure -property length -sum);
      $f + " - " + "{0:N2}" -f ($FilelSize.sum / 1MB);
   }
}

function sort_all {
    "no_ext" +  " - "  + $no_ext 
    sort_data
}

sort_all | ForEach-Object {
    $Line = $_.Trim() -Split '\s+'
    New-Object -TypeName PSCustomObject -Property @{
        Extension = $Line[0]
        SummaryValue_in_Mb = [float]$Line[2]
    }
} | Sort-Object SummaryValue_in_Mb | Select-Object -First 10 | Format-Table > $OutputDirectory/report.txt