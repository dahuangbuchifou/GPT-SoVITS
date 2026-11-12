# C9 开发版程序交付记录：Dahuang's Voice Studio C9-dev-0.1

**日期：2026-11-12；状态：独立开发程序已交付，本机Windows安装及实际引擎接入待验证。**

## 实际成果

独立开发包名称：`Dahuangs_Voice_Studio_C9_Dev_V01.zip`；包SHA-256：

`87a05c11a8da9d4846f4dd361a272577258eb9fd1f4e825abc5dca33eb609894`

开发版为本地Python 3.10+标准库HTTP服务，包含：

1. **Dahuang's Voice Studio** 前端：AI对话、文字转语音、声音模型库、音频历史四个页面；
2. 本机API：`/api/health`、`/api/session`、`/api/registry`、`/api/chat`、`/api/tts`、`/api/history`及历史音频读取；
3. Chat OpenAI兼容**本地端点**适配器、GPT-SoVITS本地`/tts`适配器。**均默认禁用**，未验证当前生产API的实际合同，不自动启动模型或产生音频；
4. Voice Registry读取、声音/模型生命周期显示、授权与SHA执行门禁、低风险WAV归档；
5. 安装器只允许新建预定路径，遇到内容冲突停止，不覆盖用户已有文件，二次执行同版本安全保留；
6. HTTP安全边界：绑定127.0.0.1、Host/Origin检查、会话令牌、无CORS、上游仅localhost端点、禁止代理与重定向、响应体积限制、TTS单并发。

## 验证证据及限制

- Python语法检查与前端JavaScript语法检查通过；
- 6项自动化集成测试通过：默认禁用、网页和Registry读取、Origin/CSRF/Host校验、URI权限、模拟本机LLM/TTS的聊天与WAV保存、未获授权的研究模型阻断、参考音频SHA阻断；
- ZIP结构完整性检查通过（11个文件）；
- **尚未在用户Windows实机安装或验证浏览器页面**；无头Chromium在隔离测试环境启动超时，因此不标记视觉验收通过；
- **未调用任何真实大语言模型或生产/实验TTS模型**；未修改原Waner Voice Studio V1.4、生产Gateway、OpenClaw或权重；
- 本次Github只归档研发状态，不将本地开发包、服务端源码或带路径的用户配置上传Public仓库。代码应在后续Private VoiceFactory仓库中版本化。

## 开发版安装目标

已建立的E盘工作区：`E:\E01\VoiceEngine\VoiceFactory`；安装程序将新增`app/backend/c9_studio_dev_server.py`、`app/frontend/c9_studio_dev.*`等隔离文件，并生成`config/c9_studio_dev.local.json`，所有模型开关默认`false`。程序在`http://127.0.0.1:17861`运行，无公网监听。

## 下一步实际门禁

1. 实机安装后确认`INSTALL_OK`、`DAHUANGS_STUDIO_DEV_READY`以及四个页面可显示；
2. 对原Studio V1.4做**只读源码定位**，校验实际API参数/参考音频/历史路径，保留原V1.4可回退；
3. 单独确认有权使用的声音和运行时资源，再以独立开发版逐项启用真实Adapter；
4. 建立Private VoiceFactory工程仓库、持续测试与资源监控；仅在确认后讨论生产部署。

**本文件不将C9-02或C9-03标记为已完成真实引擎接入。**