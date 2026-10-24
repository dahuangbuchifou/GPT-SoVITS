# GPT-SoVITS × OpenClaw 婉儿语音接入 SOP / 权威交接文档

**版本：** V1.0  
**冻结日期：** 2026-10-24  
**状态：** Phase 5E / 5F CLOSED；Windows 整机重启最终验收 PASS

## 1. 目标

- 普通聊天只返回文字；
- 用户明确要求语音时才触发 TTS；
- 主语音使用 Windows 本地 GPT-SoVITS；
- 主链故障自动降级 Edge TTS；
- 语音故障不得拖垮 OpenClaw；
- Windows 重启后完整语音链路自动恢复。

## 2. 正式架构

```text
OpenClaw
→ tts-local-cli
→ waner_provider_v3.py
→ ECS 127.0.0.1:19890
→ Reverse SSH Tunnel
→ Windows 127.0.0.1:9890
→ Waner Gateway
→ Windows 127.0.0.1:9880
→ GPT-SoVITS
→ 婉儿语音
```

故障路径：

```text
Waner / GPT-SoVITS / Reverse SSH 不可用
→ V3.1
→ Edge TTS fallback
```

Cloudflare Tunnel 保留用于公网测试和备用入口，不再作为 OpenClaw 正式 TTS 主数据通道。

## 3. Windows 权威状态

GPT-SoVITS 根目录：

```text
E:\E01\GPT_SoVITS\GPT-SoVITS-v2pro-20250604\GPT-SoVITS-v2pro-20250604
```

模型：

```text
openclaw_use_voice\20260507-e10.ckpt
openclaw_use_voice\20260507_e8_s888.pth
```

服务：

```text
GPT-SoVITS API  http://127.0.0.1:9880
Waner Gateway   http://127.0.0.1:9890
```

健康检查：

```powershell
curl.exe http://127.0.0.1:9890/health
```

预期：

```json
{"status":"ok","gateway":"waner","version":"1.1.0"}
```

计划任务：

```text
Waner TTS Stack
Waner Reverse SSH Tunnel
```

## 4. Waner Gateway 安全行为

- `GET /health`
- `GET /presets`
- `POST /tts`
- Bearer Token 鉴权
- 单进程运行
- Global Busy Gate
- 并发时第二请求立即 HTTP 503 `{"detail":"tts_busy"}`
- busy 请求不排队

## 5. Reverse SSH Tunnel

```text
ECS 127.0.0.1:19890
→ Reverse SSH
→ Windows 127.0.0.1:9890
```

ECS sshd 已确认：

```text
allowtcpforwarding yes
gatewayports no
```

`19890` 必须只绑定 `127.0.0.1`，不得绑定 `0.0.0.0`。

Windows 专用 SSH 私钥：

```text
C:\Users\Administrator\.ssh\waner_tunnel_ed25519
```

**私钥不得提交仓库。**

公钥在 ECS `~/.ssh/authorized_keys` 中限制为：

```text
no-agent-forwarding
no-X11-forwarding
no-pty
permitlisten="127.0.0.1:19890"
```

无人值守认证已通过：

```text
SSH_BATCH_GATE=PASS
```

## 6. Reverse Tunnel Supervisor

生产脚本：

```text
C:\Users\Administrator\Waner\START_WANER_REVERSE_TUNNEL_V1.ps1
```

生产脚本 SHA-256：

```text
8fdb22c09eb5042ced1888eea4fa01ad8e11b85e69069d006d043475807c1b02
```

功能：

- 等待 `127.0.0.1:9890/health`；
- 使用专用 ED25519 key；
- `BatchMode=yes`；
- `ExitOnForwardFailure=yes`；
- `ServerAliveInterval=30`；
- `ServerAliveCountMax=3`；
- SSH 掉线自动重连；
- 5/10/20/30 秒退避；
- 单实例保护；
- 日志写 Downloads。

日志：

```text
C:\Users\Administrator\Downloads\Waner_Reverse_Tunnel_YYYYMMDD.log
```

故障注入验收：主动强杀 `ssh.exe` 后自动恢复，`AUTO_RECONNECT_GATE=PASS`。

## 7. ECS / OpenClaw

OpenClaw：

```text
OpenClaw 2026.5.20
```

Gateway：

```text
openclaw-gateway.service
```

Python：

```text
/usr/bin/python3.11
```

V3 Provider：

```text
~/.openclaw/skills/gpt_sovits_tts_v3/waner_provider_v3.py
```

SHA-256：

```text
9ef8b5ed62f78576d45f89ff5c35cb2192638268f2335f8a9442c9a95f54be1d
```

Edge venv：

```text
~/.openclaw/venvs/waner-tts
```

环境文件：

```text
~/.config/openclaw/waner-tts.env
```

权限：`600`, owner `admin:admin`。

正式 URL：

```text
WANER_TTS_URL=http://127.0.0.1:19890/tts
```

真实 bearer token 只允许保存在生产 env 文件，禁止进入 GitHub、URL、日志或截图。

## 8. OpenClaw TTS 安全状态

正式 provider：

```text
tts-local-cli
```

正式偏好：

```json
{"tts":{"auto":"off"}}
```

检查：

```bash
openclaw infer tts status --json
```

最终应保持：

```text
enabled=false
auto=off
provider=tts-local-cli
configured=true
```

正确使用：

```text
/tts audio <text>   # 单次生成语音
/tts latest         # 单次朗读最近一条 assistant 回复
```

禁止日常使用：

```text
/tts on
/tts chat on
openclaw infer tts enable
```

这些路径会启用 `always` 自动 TTS。

## 9. V3.1 安全策略

```text
hard deadline       30s
connect timeout     ~10s
read timeout        ~25s
failure threshold   3
cooldown            900s
drain               120s
```

HTTP 503 busy：立即 Edge fallback，不增加 failure，不触发 drain/circuit。

普通 Waner timeout/connection failure：记录失败并按 circuit breaker 规则处理，同时 Edge fallback，OpenClaw 保持可用。

Edge voice：

```text
zh-CN-XiaoxiaoNeural
```

## 10. 情绪 Preset

```text
anxiety
calm
happy
ordinary1
ordinary2
soft
```

Alias：

```text
ordinary → ordinary1
daily → ordinary1
```

当前 OpenClaw 默认：`ordinary`。

## 11. 健康检查

Windows：

```powershell
curl.exe http://127.0.0.1:9890/health
```

ECS Reverse Tunnel：

```bash
curl --connect-timeout 2 --max-time 5 -fsS http://127.0.0.1:19890/health
ss -lntp | grep ':19890 '
```

V3：

```bash
~/.openclaw/venvs/waner-tts/bin/python \
  ~/.openclaw/skills/gpt_sovits_tts_v3/waner_provider_v3.py \
  --status
```

健康目标：

```text
consecutive_failures=0
circuit_open=false
draining=false
last_error=""
```

## 12. 快速故障定位

### OpenClaw 文字正常但语音是 Edge

```bash
tail -n 10 ~/.openclaw/logs/waner-tts-v3.log
curl http://127.0.0.1:19890/health
```

### ECS 19890 不存在

优先检查 Windows `Waner Reverse SSH Tunnel` 任务、Supervisor 日志和 Waner `ssh.exe`。

### Windows 9890 不健康

优先检查 `Waner TTS Stack`，不要先修 Reverse SSH。

### 9890 正常但 19890 不正常

集中检查 Windows Reverse SSH Supervisor 与 Windows → ECS SSH。

## 13. Windows 重启后的自动流程

```text
Windows 登录
→ Waner TTS Stack
→ 9880 / 9890
→ 9890 health PASS
→ Waner Reverse SSH Tunnel
→ ECS 127.0.0.1:19890
→ OpenClaw /tts audio
→ 婉儿
```

整机重启最终验收：PASS。

## 14. 不做清单

1. 不把 `9880` 暴露公网。
2. 不把 `19890` 绑定 `0.0.0.0`。
3. 不提交 bearer token 或 SSH 私钥。
4. 不使用 `auto=always` 作为正式模式。
5. 不做无限 Waner 重试。
6. 不取消 Edge fallback。
7. 不为“清零”而手工删除 circuit 状态。
8. 不在没有新证据时重复已通过门禁。
9. 不同时启动多个 Reverse SSH Supervisor。

## 15. 已完成门禁

### Phase 5D
- V3.1 hard deadline PASS
- Edge fallback PASS
- HTTP 503 busy → Edge PASS
- 503 不增加 failure PASS
- Windows Global Busy Gate PASS
- 9890 real concurrency PASS

### Phase 5E
- tts-local-cli contract PASS
- OpenClaw config/restart PASS
- OpenClaw → V3.1 → MP3 PASS
- Waner failure → Edge PASS
- `/tts audio` PASS
- `/tts latest` 支持确认
- `auto=off` 普通聊天不自动语音 PASS

### Phase 5F
- Cloudflare 间歇故障确认
- Reverse SSH health 10/10 PASS
- Bearer `/presets` PASS
- Reverse SSH 真实 Waner TTS PASS
- OpenClaw `/tts audio` → Waner PASS
- Warm TTS ≈ 1.827s
- 专用 ED25519 Key PASS
- BatchMode PASS
- Supervisor 自动重连 PASS
- Windows 计划任务 PASS
- 整机重启最终验收 PASS

## 16. 最终结论

生产主链：

```text
OpenClaw
→ tts-local-cli
→ V3.1
→ ECS localhost:19890
→ Reverse SSH
→ Windows Waner 9890
→ GPT-SoVITS 9880
```

容错：

```text
主链失败 → Edge TTS
```

当前稳定基线冻结。后续动态情绪、persona 映射、运维状态页应作为独立里程碑推进。
