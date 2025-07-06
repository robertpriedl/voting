# Hilfsfunktion zum Senden der Stimme
function Invoke-Vote {
    # Liste mit verschiedenen User-Agent-Strings
    $userAgents = @(
        # Windows 10 mit Edge
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0",
        
        # Android 13 auf Pixel 5 mit Chrome
        "Mozilla/5.0 (Linux; Android 13; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36",

        # macOS mit Safari
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 13_5_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Safari/605.1.15",

        # iPhone mit Safari
        "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",

        # Android Samsung Browser
        "Mozilla/5.0 (Linux; Android 12; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/20.0 Chrome/124.0.0.0 Mobile Safari/537.36"
    )
    # create timestamp
    $timestamp = [long]::Parse((Get-Date -UFormat %s)) * 1000 + [int](Get-Date).Millisecond
    
    $httpClientHandler = [System.Net.Http.HttpClientHandler]::new()
    $httpClient = [System.Net.Http.HttpClient]::new($httpClientHandler)

    # Formulardaten vorbereiten
    $formData = [System.Collections.Generic.Dictionary[string, string]]::new()
    $formData.Add("voteItem", "467024")
    $formData.Add("votingId", "1323")
    $formData.Add("playerOneUp", "Abstimmen")

    # Formulardaten kodieren
    $content = [System.Net.Http.FormUrlEncodedContent]::new($formData)

    # Header setzen (ev. Cookie anpassen!)
    # Zufälligen User-Agent wählen
    $userAgent = Get-Random -InputObject $userAgents
    $httpClient.DefaultRequestHeaders.Add("User-Agent", $userAgent)
    $httpClient.DefaultRequestHeaders.Referrer = [System.Uri]::new("https://ticker.ligaportal.at/playerVoting/showVoting/1323?hideFooter=true&t=$timestamp")

    # Request senden
    try {
        $response = $httpClient.PostAsync("https://ticker.ligaportal.at/playerVoting/playerOneUp", $content).Result
        $html = $response.Content.ReadAsStringAsync().Result

        if ($html -match 'Vielen Dank für Deine Stimme!') {
            Write-Host "✅ Erfolg: Stimme wurde gezählt."
        } else {
            if( $html -match 'Du hast bereits abgestimmt, versuche es später wieder!'){
                Write-Host "⚠️ Warnung: Du hast bereits abgestimmt, versuche es später wieder!"
            } else {
                Write-Host "❌ Keine Bestätigung gefunden. Inhalt:"
                $html -split "`n" | Select-Object -First 60 | ForEach-Object { $_.Trim() } | ForEach-Object { Write-Output $_ }
        
            }
        }
    } catch {
        Write-Host "$(Get-Date -Format u): ⚠️ Fehler beim Senden: $_"
    }

    $httpClient.Dispose()
}

#$vpnConfig = "/Users/robertpriedl/Library/Application Support/OpenVPN Connect/profiles/1709661473394.ovpn"
# Start OpenVPN (als Hintergrundprozess)
#Write-Host "🔌 Verbinde VPN..."
#$vpnProcess = Start-Process "openvpn" -ArgumentList "--config $vpnConfig" -PassThru

# Endlosschleife mit zufälligem Intervall
while ($true) {
    Invoke-Vote

    # Wartezeit zwischen 11 und 15 Minuten (in Sekunden)
    $minutes = Get-Random -Minimum 11 -Maximum 16
    $time = Get-Date -Format "HH:mm:ss"
    Write-Host "⏳ $time - Warten auf nächsten Durchlauf: $minutes Minuten..."
    Start-Sleep -Seconds ($minutes * 60)
}
