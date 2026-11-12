# C9-03：Dahuang's Voice Studio 对话与语音联动 V1

**记录日期：2026-11-12；状态：独立开发版前端补丁完成离线测试，Windows实际安装/浏览器验收尚待确认。**

## 关联的C9-02实机证据

用户于2026-11-12提交C9-02 V3安装成功画面，其中含`C9_02_INSTALL_OK`、`PRODUCTION_9880_TCP=OPEN`、`PRODUCTION_9890_TCP=OPEN`、`DEV_STUDIO_STARTED http://127.0.0.1:17861`。工作台截图显示婉儿稳定GPT-SoVITS模型可生成、播放并下载WAV；用户确认试听正常。**这是独立开发版GPT-SoVITS语音接入的现场验收，而非原生产服务长期性能SLA证明。**

## 本次新增能力（前端开发补丁）

开发包：`Dahuangs_C9_03_Chat_Voice_Link_V1.zip`；SHA-256：

`573db99949027293d15e29aac0c99c4e83a3aa4299ea9db3c5b27ed647255521`

仅更改：`VoiceFactory/app/frontend/c9_studio_dev.js`（从原SHA `50f49131392988de6ae4f101d100a4a44c764036d84397ae4332ae481a61e0ee` 到新SHA `d19218dd6399f68c19c7cf72c2a8639260ef0681256dd433960f8e3c63ee49c4`）。

- AI对话页新增“**朗读输入内容**”；无需LLM模型，用户主动点击后复用当前已授权的本机`/api/tts`接口，生成可播放及下载的WAV。
- 一旦LLM以后通过受控配置接入，助手消息可逐条点击“朗读这条回复”；“自动朗读AI回复”默认关闭、需明确勾选。
- 仍受现有Voice Registry授权、模型生命周期、参考SHA、单任务并发、500字上限、单机HTTP门禁约束；超过500字明确拒绝，不自动截断。
- 不修改后端Python、配置文件、GPT-SoVITS引擎及生产Gateway/9890/9880/OpenClaw，不启动额外模型或训练。
- 通过Windows PowerShell 5.1兼容的ASCII+CRLF批处理和PowerShell安装器执行，校验前端原SHA，备份旧文件、检查新SHA，安装异常尝试回滚，同版本重复执行保持幂等。
- **大语言模型尚未连接**，不把“可朗读手动输入文本”称为已接入真实AI对话。下一项需要确定实际LLM端点、模型和授权，不能默认为ChatGPT API或OpenClaw可直接调用。

## 验证与局限

- 通过Node.js语法检查；
- 模拟DOM和网络验证：LLM仍禁用、手动朗读会调用本机`/api/tts`、生成音频播放器、超过500字符的文本被拒绝；
- ZIP完整性、内嵌SHA匹配、Windows CMD/PS脚本ASCII与CRLF检查通过；
- **未在用户Windows环境实际安装，也未运行真实LLM**。此项只有收到安装回执及浏览器测试后才可判定实机验收。
- 仍仅将脱敏技术说明上传Public仓库，开发源码应归档于未来独立Private VoiceFactory工程仓库。

## 最短本机测试

解压ZIP→双击`Install_C9_03_ChatVoice.cmd`→看到`C9_03_INSTALL_OK`→刷新`http://127.0.0.1:17861`（Ctrl+F5）→在AI对话输入不超过500字测试句并点击“朗读输入内容”。此功能使用既有TTS能力，不要求现在先找到大语言模型提供商。