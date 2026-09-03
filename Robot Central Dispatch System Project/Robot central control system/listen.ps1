$port = 8765
$endpoint = new-object System.Net.IPEndPoint([IPAddress]::Any, $port)
$listener = new-object System.Net.Sockets.TcpListener $endpoint
$listener.Start()

Write-Host "Listening on port $port..."

while($true) {
    if ($listener.Pending()) {
        $client = $listener.AcceptTcpClient()
        $stream = $client.GetStream()
        
        $buffer = new-object byte[] 1024
        $bytesRead = $stream.Read($buffer, 0, 1024)
        
        $hexString = [System.BitConverter]::ToString($buffer, 0, $bytesRead)
        $asciiString = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead)
        
        Write-Host "Received bytes from Callbox:"
        Write-Host "Hex: $hexString"
        Write-Host "ASCII: $asciiString"
        
        $client.Close()
        break
    }
    Start-Sleep -Milliseconds 100
}

$listener.Stop()
