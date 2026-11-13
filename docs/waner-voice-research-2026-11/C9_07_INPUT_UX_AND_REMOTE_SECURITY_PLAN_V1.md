# C9-07：Dahuang's Voice Studio 输入体验优化与远程访问设计

**日期：2026-11-13。状态：独立前端UX增量补丁已离线测试；本机Windows安装、麦克风实际识别和公网访问均未验收。**

## C9-06验收证据边界

用户最新截图显示DeepSeek对话成功，并可播放一条合成10段、总长度约2分22秒的完整WAV，页面有“逐段播放”按钮。此证据支持C9-05完整WAV继续正常工作及C9-06升级界面存在，但**不足以证明**“逐段播放提前开声”和“停止后续提交”已实际验收；这两项仍需单独测试。

## 已准备的C9-07开发补丁

包名：`Dahuangs_C9_07_Chat_Input_Mic_UX_V1.zip`

包SHA256：`aa3f5e3df19a197fb110513c402eb7886bf2a01397fd0189af4191b26d4be846`

唯一修改目标：`E:\E01\VoiceEngine\VoiceFactory\app\frontend\c9_studio_dev.js`。原C9-06文件SHA `0df71254027d71f8f0ef29423d5ddeebd92393c7c5beecbe938d44432b78e0c1`；更新后SHA `2b1ad1f4bf7fdb39cb0f87f52b1ad3c19ca462dc3de3f22115b77fd50a862302`。未知代码版本则安全停止。

新增功能：
- 聊天输入框**Enter发送、Shift+Enter换行**；中文输入法候选确认期间不发送；无内容/按钮禁用不发送。
- 实验性**浏览器语音识别**按钮：在浏览器支持SpeechRecognition且页面为安全上下文（localhost或HTTPS）时才可启用。用户点击同意可能使用浏览器厂商在线识别，并另行授权麦克风；结果只写回输入框供确认，不自动发给DeepSeek。此功能不录制音频保存到VoiceFactory，但浏览器/供应商可能接收音频。浏览器不支持时禁用，不阻断文本输入。
- 新页面加载将AI回复自动朗读重置为关闭。
- 安装器ASCII/CRLF，SHA核对、原文件备份与回滚、重复安装幂等；不修改后端、LLM配置、生产Gateway、模型权重、OpenClaw、旧Studio V1.4，也不会调用推理。
- 本地Node.js语法检查通过；9项模拟交互检查通过（Enter、Shift+Enter、中文IME、空输入、禁用按钮、识别写回不自动提交、录音停止、不支持浏览器/隐私拒绝）。

**限制：** Web Speech API不是本机离线STT，也不是稳定跨浏览器保证。未来可加独立STT适配器（本地或经授权的云端），替代浏览器实验路径。

## 远程访问：尚未上线，必须独立安全门禁

历史生产文档确认已有`cloudflared`/Cloudflare Tunnel用于公网备用测试；正式OpenClaw生产TTS主链是Windows本地9890→反向SSH→ECS本地19890，**不能复用生产TTS主入口暴露Studio**。当前独立开发服务只接受本机`127.0.0.1:17861`，并包含Host/Origin/CSRF的本机门禁；直接配置Cloudflare公网hostname可能出现拒绝或安全风险。

目标架构：

```text
手机/远端浏览器 --HTTPS--> Cloudflare Access（身份验证/MFA）
   --Cloudflare Tunnel 独立受保护站点--> localhost:17861 专用网关/应用层鉴权
   --> Voice Studio API --> DeepSeek（配置的LLM） / GPT-SoVITS 9880（内网）
```

发布前必须：
1. 核对现有Cloudflare域名、隧道所处主机、现有公开route，不读取/上传隧道密钥；选独立子域名，避免覆盖既有TTS hostname。
2. 先为新hostname启用Cloudflare Access的身份准入、MFA，**Protect with Access/JWT验证**或等效源站认证；仅限明确授权使用者，并验证无授权请求被拒绝。
3. 将本机开发服务升级为远程安全版本，明确可信hostname、Origin、CSRF、会话Cookie、安全响应头、权限/频率/金额限制；不能用`0.0.0.0`直接暴露9880/9890/17861。
4. 语音录音网页需要HTTPS及浏览器麦克风许可；不同浏览器识别支持不同。
5. 已观测完整WAV约142秒；Cloudflare普通代理默认约125秒可能报524，远程长语音需要**后台任务/状态轮询+音频下载**而不是持续同步等待。要求失败/超时不产生重复的计费或TTS任务。
6. 公网发布必须经用户单独确认后才创建路由，不在本次C9-07本地UX补丁中自动开启。

尚未核实可使用的确切公网主机名，故不能虚构现有域名或声称公网网页已上线。相关官方资料：https://developers.cloudflare.com/tunnel/get-started/ 、https://developers.cloudflare.com/cloudflare-one/access-controls/applications/http-apps/self-hosted-public-app/ 、https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia 、https://developers.cloudflare.com/support/troubleshooting/http-status-codes/cloudflare-5xx-errors/error-524/ 。
