# C9-04 Dahuang's Voice Studio：DeepSeek与多提供商API适配器 V1

**日期：2026-11-12。状态：本地增量安装包已完成模拟验证，Windows与真实DeepSeek联通尚未验收。**

## 目标与接口契约

在C9-03已通过的婉儿TTS联动基础上，将AI对话从`openai_compatible_local`单端点方案扩展为**OpenAI Chat Completions兼容提供商注册表**：

`Voice Studio AI Chat → Provider Registry（默认DeepSeek） → POST /chat/completions → 文本回复 → 可选婉儿TTS`

默认提供商：DeepSeek。官方在2026-11文档中列出`https://api.deepseek.com/chat/completions`与`deepseek-flash`模型ID。当前默认非思考模式、`max_tokens=512`。其他兼容API按`provider_id`、显示名、实际模型ID、HTTPS endpoint、启用状态和本机Key切换；协议不兼容者仍需独立Adapter。

## 交付包与完整性

包名：`Dahuangs_C9_04_DeepSeek_MultiAPI_Adapter_V1.zip`

SHA-256：`2bcae0fd2cb6915cad3d84f4445006350cd914b9ad5ab567607801d5403730b6`

安装前验收的现有开发版身份：
- C9-02后端SHA：`a1cae9727e839e75a0c7949e8d460963d8f0de1f08d820285472cb1f544606f4`
- C9-03前端SHA：`d19218dd6399f68c19c7cf72c2a8639260ef0681256dd433960f8e3c63ee49c4`

仅精确匹配该组合才允许增量安装；其他代码版本安全停止。备份修改前的独立开发后端、前端、聊天配置；保留原已验证TTS、模型权重、Gateway、OpenClaw与旧Studio V1.4。

## 模块化设计

- `config/llm_providers.local.json`是**本机配置**：可增加/调整OpenAI兼容提供商，无需改聊天页面与TTS；
- 前端AI对话页有模型提供商选择，切换提供商时清空旧聊天上下文，避免将上一提供商的历史意外发送给另一提供商；
- 后端独立校验提供商ID、HTTPS可信主机名单、路径、端口和请求大小；本机HTTP仅允许明确的127.0.0.1/localhost，禁用重定向和代理；
- Web前端从不接触API Key，不存储、回显、传输密钥；本机PowerShell `Read-Host -AsSecureString`+Windows DPAPI在`%LOCALAPPDATA%\DahuangsVoiceFactory\keys`保存用户Key，启动器只通过本地子进程环境变量传递；
- 未设置Key时提供商不可用；自动朗读AI回复默认关闭。用户主动提交消息才向选定API发送对话上下文并产生可能的付费请求；
- 不上传原声、语音权重、聊天内容、Key或私人配置至Public GitHub。

## 验证范围

- Python与Node.js语法检查通过；
- 6项离线集成测试通过（模拟两提供商、Key不存在拒绝、远程HTTPS白名单、伪造提供商、未经授权的HTTP外网阻断、真正本地API处理路径）；
- AST核查`Runtime.tts_request`在本次改造前后**完全一致**；
- ZIP完整性、manifest逐项SHA、Windows CMD/PS脚本ASCII及CRLF检查通过；
- **尚未在用户Windows实机安装，也未请求真实DeepSeek或触发TTS。** PowerShell 5.1安装/DPAPI行为仍需本机验收，不据此声称已全面连通。

## 用户验证流程

1. 解压ZIP，运行`Install_C9_04.cmd`，预期`C9_04_INSTALL_OK`。
2. 在VoiceFactory根目录运行`Save_AI_API_Key.cmd`，本机隐藏输入DeepSeek API Key，预期`KEY_SAVED_DPAPI`。
3. 仅停止开发版17861窗口，不停止9880/9890；运行`Start_Studio_With_AI.cmd`。
4. 浏览器`http://127.0.0.1:17861`，在AI对话页选择DeepSeek Flash，主动发送一条短消息确认回复，再按需选择婉儿朗读。

本阶段属于C9-04待实机验收，不改变已通过的C9-02/C9-03状态。