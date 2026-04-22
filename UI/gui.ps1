Add-Type -AssemblyName System.Windows.Forms
try{
    $screens = [System.Windows.Forms.Screen]::AllScreens
    $screens = [System.Windows.Forms.Screen]::AllScreens
    if (-not $screens) {
        Write-Host "No monitors detected."
        exit
    }
    $minX = ($screens | ForEach-Object { $_.Bounds.X }) | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $minY = ($screens | ForEach-Object { $_.Bounds.Y }) | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
    $maxX = ($screens | ForEach-Object { $_.Bounds.Right }) | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $maxY = ($screens | ForEach-Object { $_.Bounds.Bottom }) | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum

    $totalWidth  = $maxX - $minX
    $totalHeight = $maxY - $minY
    try{
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Mirror Match"
        $form.Size = New-Object System.Drawing.Size($totalWidth, $totalHeight)
        $form.StartPosition = 'Manual'
        $form.Location = New-Object System.Drawing.Point(0, 0)

        try{
            $browser = New-Object System.Windows.Forms.WebBrowser
            $browser.Dock = 'Fill' 
            $browser.ScriptErrorsSuppressed = $true  # Suppress script errors

            $browser.Navigate("https://www.bing.com")

            # Add the browser to the form
            $form.Controls.Add($browser)
        } catch {
            Write-Error "Error creating browser"
        }
        #$form.FormBorderStyle = 'None'
        [void]$form.ShowDialog()
    } catch {
        Write-Error "Error creating form array"
    }
} catch {
    Write-Error "Error retrieving monitor information: $_"
}
