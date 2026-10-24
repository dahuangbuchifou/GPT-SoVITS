param(
    [string]$EcsHost = 'YOUR_ECS_PUBLIC_IPV4',
    [string]$EcsUser = 'admin',
    [int]$RemotePort = 19890,
    [int]$LocalPort = 9890,
    [int]$InitialGatewayWaitSeconds = 360
)

$ErrorActionPreference = 'Stop'

$ReleaseId = 'WANER_REVERSE_SSH_TUNNEL_V1'
$SshExe = Join-Path $env:WINDIR 'System32\OpenSSH\ssh.exe'
$KeyPath = Join-Path $env:USERPROFILE '.ssh\waner_tunnel_ed25519'
$LogDir = Join-Path $env:USERPROFILE 'Downloads'
$LogPath = Join-Path $LogDir ("Waner_Reverse_Tunnel_{0}.log" -f (Get-Date -Format 'yyyyMMdd'))
$LocalHealthUrl = "http://127.0.0.1:$LocalPort/health"

function Write-Log {
    param([string]$Message,[switch]$Console)
    $line = '{0} {1}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'), $Message
    Add-Content -LiteralPath $LogPath -Value $line -Encoding UTF8
    if ($Console) { Write-Host $Message }
}

function Test-LocalGateway {
    try {
        $body = & curl.exe --silent --show-error --connect-timeout 2 --max-time 4 $LocalHealthUrl 2>$null
        if ($LASTEXITCODE -ne 0) { return $false }
        return ($body -match '"status"\s*:\s*"ok"')
    } catch { return $false }
}

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
Write-Log "=== $ReleaseId START ===" -Console
Write-Log "LOG_PATH=$LogPath" -Console

if (-not (Test-Path -LiteralPath $SshExe -PathType Leaf)) { Write-Log "SSH_EXE_GATE=FAIL PATH=$SshExe" -Console; exit 10 }
if (-not (Test-Path -LiteralPath $KeyPath -PathType Leaf)) { Write-Log "SSH_KEY_GATE=FAIL PATH=$KeyPath" -Console; exit 11 }

$createdNew = $false
$mutex = [System.Threading.Mutex]::new($true,'Local\WanerReverseTunnelV1',[ref]$createdNew)
if (-not $createdNew) { Write-Log 'SINGLE_INSTANCE_GATE=FAIL REASON=already_running' -Console; exit 12 }

try {
    Write-Log "WAIT_LOCAL_GATEWAY_BEGIN URL=$LocalHealthUrl TIMEOUT=${InitialGatewayWaitSeconds}s" -Console
    $deadline = (Get-Date).AddSeconds($InitialGatewayWaitSeconds)
    while (-not (Test-LocalGateway)) {
        if ((Get-Date) -ge $deadline) {
            Write-Log "LOCAL_GATEWAY_GATE=WAITING AFTER_INITIAL_TIMEOUT=${InitialGatewayWaitSeconds}s" -Console
            $deadline = (Get-Date).AddSeconds(60)
        }
        Start-Sleep -Seconds 5
    }
    Write-Log 'LOCAL_GATEWAY_GATE=PASS' -Console

    $retrySeconds = 5
    while ($true) {
        while (-not (Test-LocalGateway)) { Write-Log 'LOCAL_GATEWAY_STATE=DOWN RETRY_IN=5s'; Start-Sleep -Seconds 5 }

        $sshArgs = @(
            '-i',$KeyPath,
            '-o','IdentitiesOnly=yes',
            '-o','BatchMode=yes',
            '-o','StrictHostKeyChecking=yes',
            '-o','ExitOnForwardFailure=yes',
            '-o','ServerAliveInterval=30',
            '-o','ServerAliveCountMax=3',
            '-o','TCPKeepAlive=yes',
            '-o','ConnectTimeout=8',
            '-N','-T',
            '-R',"127.0.0.1:${RemotePort}:127.0.0.1:${LocalPort}",
            "${EcsUser}@${EcsHost}"
        )

        Write-Log "SSH_TUNNEL_CONNECT_BEGIN ECS=$EcsHost REMOTE=127.0.0.1:$RemotePort LOCAL=127.0.0.1:$LocalPort" -Console
        $started = Get-Date
        try {
            & $SshExe @sshArgs 2>&1 | ForEach-Object { Write-Log "SSH: $_" }
            $rc = $LASTEXITCODE
        } catch {
            $rc = 255
            Write-Log "SSH_EXCEPTION=$($_.Exception.Message)"
        }

        $duration = [int]((Get-Date)-$started).TotalSeconds
        $sleepSeconds = $retrySeconds
        Write-Log "SSH_TUNNEL_EXIT RC=$rc SESSION_SECONDS=$duration RETRY_IN=${sleepSeconds}s" -Console
        Start-Sleep -Seconds $sleepSeconds
        if ($duration -ge 60) { $retrySeconds = 5 } else { $retrySeconds = [Math]::Min($retrySeconds*2,30) }
    }
}
finally {
    if ($mutex) { try { $mutex.ReleaseMutex() } catch {}; $mutex.Dispose() }
    Write-Log "=== $ReleaseId STOP ==="
}
