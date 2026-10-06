$dir = "c:\Users\reetm\Downloads\delhi-aqi-visualisation-main\delhi-aqi-visualisation-main"
$html = Get-Content -Path "$dir\index.html" -Raw
$css = Get-Content -Path "$dir\styles.css" -Raw
$js = Get-Content -Path "$dir\app.js" -Raw

$constants = Get-Content -Path "$dir\others\constants.json" -Raw
$pm25 = Get-Content -Path "$dir\data related shit\delhi_pm25_annual.json" -Raw
$shield = Get-Content -Path "$dir\data related shit\shield_data.json" -Raw
$workers = Get-Content -Path "$dir\data related shit\worker_profiles.json" -Raw
$levers = Get-Content -Path "$dir\others\policy_levers.json" -Raw

# We need to construct the init() replacement
$replacementInit = "async function init() { `n" +
"  appData = { `n" +
"    constants: $constants, `n" +
"    pm25: $pm25, `n" +
"    shield: $shield, `n" +
"    workers: $workers, `n" +
"    levers: $levers `n" +
"  }; `n" +
"  startPhase1(); `n" +
"}"

# Find the exact init function body to replace
$js = $js -replace "(?s)async function init\(\).*?^\}", $replacementInit

$html = $html.Replace('<link rel="stylesheet" href="styles.css">', "<style>`n$css`n</style>")
$html = $html.Replace('<script src="app.js"></script>', "<script>`n$js`n</script>")

# Add the missing Title Screen text to index.html before bundling so it actually makes sense
$titleText = "`n<div class='t-opening' style='margin-bottom: 24px; color: var(--text-primary); text-align: center;'>Air Pollution Privilege Experience</div><div class='t-body' style='text-align: center; margin-bottom: 48px;'>Press Enter to begin</div>"
$html = $html.Replace('id="p1-title-screen" class="content" style="max-width: 1200px;">', "id=`"p1-title-screen`" class=`"content`" style=`"max-width: 1200px;`">$titleText")

Set-Content -Path "$dir\index_bundled.html" -Value $html
