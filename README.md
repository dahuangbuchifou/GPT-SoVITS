# GPT-SoVITS 集成到 OpenClaw

当前权威状态：**阶段 4 CLOSED（2026-10-15）**  
下一里程碑：**阶段 5 — OpenClaw 正式接入 + Edge TTS fallback / circuit breaker**

## 当前架构

```text
OpenClaw / Alibaba Cloud ECS
        |
        | HTTPS
        | Authorization: Bearer <TOKEN>
        v
tts.dahuangbuchirou.homes
        |
        v
Cloudflare Tunnel
        |
        v
Waner Gateway 127.0.0.1:9890
        |
        v
GPT-SoVITS API 127.0.0.1:9880
        |
        v
RTX 3070 / Waner voice
```

OpenClaw 最终只需要知道 TTS URL、Bearer Token、text 和 emotion；不接触 Windows 路径、模型路径、参考音频路径或 prompt text。

## 里程碑

| 阶段 | 内容 | 状态 |
|---|---|---|
| 0 | 旧资产恢复 | ✅ CLOSED |
| 1 | 婉儿模型 / WebUI 推理恢复 | ✅ CLOSED |
| 2 | 固定 GPT-SoVITS API（9880） | ✅ CLOSED |
| 3 | Waner Gateway / 多情绪 preset（9890） | ✅ CLOSED |
| 4 | 固定域名 + HTTPS + Tunnel + Bearer Token + 自动恢复 | ✅ CLOSED |
| 5 | OpenClaw 正式接入 + Edge TTS fallback | ▶ NEXT |

详细记录：

- [阶段 4 结项](docs/04_STAGE4_CLOSURE.md)
- [阶段 5 计划](docs/05_STAGE5_OPENCLAW_PLAN.md)

## 当前服务基线

- Windows 工程目录：`E:\E01\GPT_SoVITS\GPT-SoVITS-v2pro-20250604\GPT-SoVITS-v2pro-20250604`
- GPU：NVIDIA GeForce RTX 3070 8 GB
- GPT-SoVITS 路线：v2ProPlus
- GPT-SoVITS API：`http://127.0.0.1:9880`
- Waner Gateway：`http://127.0.0.1:9890`
- 公网入口：`https://tts.dahuangbuchirou.homes`
- Gateway：v1.1.0
- Tunnel：`gpt-sovits`

## 情绪 preset

已验证：`anxiety`、`calm`、`happy`、`ordinary1`、`ordinary2`、`soft`。  
别名：`ordinary -> ordinary1`，`daily -> ordinary1`。

## Gateway API

- `GET /health`：公开最小健康信息
- `GET /presets`：Bearer Token
- `POST /tts`：Bearer Token，返回 `audio/wav`
- `/docs`、`/redoc`、`/openapi.json`：关闭

## 自动恢复

Windows 登录后由计划任务 `Waner TTS Stack` 自动恢复：

1. GPT-SoVITS API（9880）
2. Waner Gateway（9890）
3. Cloudflare Tunnel
4. 公网 `/health` 检查

冷启动验收：

```text
PORT_9880=True
PORT_9890=True
PUBLIC_HEALTH_HTTP=200
Waner TTS Stack=Ready
```

## 安全与稳定性约束

- 公网只暴露 Gateway，不直接暴露 9880。
- `/tts`、`/presets` 必须 Bearer Token。
- Token、Cloudflare credentials、模型权重不得提交到公开仓库。
- OpenClaw TTS 必须保持 `on-demand`；禁止 `auto: always`。
- 不允许无限重试。
- 阶段 5 必须保留 Edge TTS fallback。
- Linux/OpenClaw 不保存 Windows 路径、参考音频或 base64 音频。

最后更新：2026-10-15
