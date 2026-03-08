param(
  [string]$LcovPath = "coverage/lcov.info",
  [string]$OutputHtml = "coverage/coverage_report.html",
  [double]$Threshold = 70.0,
  [string]$IncludeRegex = "",
  [string]$ExcludeRegex = ""
)

if (-not (Test-Path $LcovPath)) {
  Write-Error "LCOV file not found at $LcovPath"
  exit 1
}

$records = @()
$sf = ""
$lf = 0
$lh = 0

Get-Content $LcovPath | ForEach-Object {
  if ($_ -match '^SF:(.+)$') {
    $sf = $matches[1]
    $lf = 0
    $lh = 0
  } elseif ($_ -match '^LF:(\d+)$') {
    $lf = [int]$matches[1]
  } elseif ($_ -match '^LH:(\d+)$') {
    $lh = [int]$matches[1]
  } elseif ($_ -eq 'end_of_record') {
    if ($sf -ne '') {
      $pct = if ($lf -gt 0) { [math]::Round(($lh * 100.0 / $lf), 2) } else { 0 }
      $records += [pscustomobject]@{
        File = $sf
        LinesHit = $lh
        LinesFound = $lf
        Coverage = $pct
      }
    }
  }
}

$totalFound = ($records | Measure-Object -Property LinesFound -Sum).Sum
$totalHit = ($records | Measure-Object -Property LinesHit -Sum).Sum
$totalPct = if ($totalFound -gt 0) { [math]::Round(($totalHit * 100.0 / $totalFound), 2) } else { 0 }
$statusColor = if ($totalPct -ge $Threshold) { "#1b5e20" } else { "#b71c1c" }
$statusText = if ($totalPct -ge $Threshold) { "PASS" } else { "BELOW TARGET" }

$rows = ($records | Sort-Object Coverage, LinesFound | ForEach-Object {
  $rowColor = if ($_.Coverage -ge 70) { "#e8f5e9" } elseif ($_.Coverage -ge 40) { "#fff8e1" } else { "#ffebee" }
  "<tr style='background:$rowColor'><td><code>$($_.File)</code></td><td>$($_.LinesHit)</td><td>$($_.LinesFound)</td><td><b>$($_.Coverage)%</b></td></tr>"
}) -join "`n"

if ($IncludeRegex -ne "") {
  $records = $records | Where-Object { $_.File -match $IncludeRegex }
}

if ($ExcludeRegex -ne "") {
  $records = $records | Where-Object { $_.File -notmatch $ExcludeRegex }
}

$totalFound = ($records | Measure-Object -Property LinesFound -Sum).Sum
$totalHit = ($records | Measure-Object -Property LinesHit -Sum).Sum
$totalPct = if ($totalFound -gt 0) { [math]::Round(($totalHit * 100.0 / $totalFound), 2) } else { 0 }
$statusColor = if ($totalPct -ge $Threshold) { "#1b5e20" } else { "#b71c1c" }
$statusText = if ($totalPct -ge $Threshold) { "PASS" } else { "BELOW TARGET" }

$rows = ($records | Sort-Object Coverage, LinesFound | ForEach-Object {
  $rowColor = if ($_.Coverage -ge 70) { "#e8f5e9" } elseif ($_.Coverage -ge 40) { "#fff8e1" } else { "#ffebee" }
  "<tr style='background:$rowColor'><td><code>$($_.File)</code></td><td>$($_.LinesHit)</td><td>$($_.LinesFound)</td><td><b>$($_.Coverage)%</b></td></tr>"
}) -join "`n"

$html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Flutter Coverage Report</title>
  <style>
    body { font-family: Segoe UI, Arial, sans-serif; margin: 24px; background: #f7f8fa; color: #1f2937; }
    .card { background: white; border-radius: 10px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 16px; }
    h1 { margin-top: 0; }
    table { width: 100%; border-collapse: collapse; font-size: 14px; }
    th, td { border-bottom: 1px solid #e5e7eb; padding: 10px; text-align: left; }
    th { background: #f3f4f6; position: sticky; top: 0; }
    .kpi { font-size: 20px; font-weight: 700; color: $statusColor; }
    .muted { color: #6b7280; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Flutter Coverage Report</h1>
    <p class="muted">Source: <code>$LcovPath</code></p>
    <p class="muted">Include regex: <code>$IncludeRegex</code> | Exclude regex: <code>$ExcludeRegex</code></p>
    <p class="kpi">Overall: $totalPct% ($totalHit/$totalFound) - $statusText (target: $Threshold%)</p>
  </div>
  <div class="card">
    <h2>Per-File Coverage</h2>
    <table>
      <thead>
        <tr><th>File</th><th>Lines Hit</th><th>Lines Found</th><th>Coverage</th></tr>
      </thead>
      <tbody>
        $rows
      </tbody>
    </table>
  </div>
</body>
</html>
"@

$outputDir = Split-Path $OutputHtml -Parent
if ($outputDir -and -not (Test-Path $outputDir)) {
  New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Set-Content -Path $OutputHtml -Value $html -Encoding UTF8
Write-Output "Coverage report generated: $OutputHtml"
Write-Output "Overall coverage: $totalPct% ($totalHit/$totalFound)"
