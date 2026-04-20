Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

try {
    $screens = [System.Windows.Forms.Screen]::AllScreens
    if (-not $screens) {
        Write-Host "No monitors detected."
        exit
    }

    $monitor_widths = 0
    $monitor_height = 0

    foreach ($screen in $screens) {
        $deviceName = $screen.DeviceName
        $bounds = $screen.Bounds
        $primary = $screen.Primary

        Write-Host "Monitor: $deviceName"
        Write-Host "  Resolution : $($bounds.Width) x $($bounds.Height)"
        Write-Host "  Position   : X=$($bounds.X), Y=$($bounds.Y)"
        Write-Host "  Primary    : $primary"
        Write-Host "----------------------------------------"
        $monitor_widths += $bounds.Width
        if ($monitor_height -lt $bounds.Height) {
            $monitor_height = $bounds.Height
        }
        $monitor_widths += $bounds.Widths	
    }
        
        try{
            $form = New-Object System.Windows.Forms.Form
            $form.Text = "Mirror Match"
            $form.Size = New-Object System.Drawing.Size($monitor_widths, $monitor_height)
            $form.StartPosition = 'Manual'
            $form.Location = New-Object System.Drawing.Point(0, 0)
            #$form.FormBorderStyle = 'None'
            [void]$form.ShowDialog()
        } catch {
            Write-Error "Error creating form array"
        }
}
catch {
    Write-Error "Error retrieving monitor information: $_"
}