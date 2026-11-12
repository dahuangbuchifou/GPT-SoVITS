# C9-02：Dahuang's Voice Studio GPT-SoVITS POST/JSON适配补丁

**记录时间：2026-11-12；状态：补丁模拟集成测试通过，Windows实际安装与真实TTS验收待确认。**

## 接入前只读证据

收到`dahuangs.c9_02.readonly_integration_preflight.v1`报告：实验网页服务本机17861和GPT-SoVITS API 9880、Gateway 9890的TCP连接均可建立；C6已经验证的推理协议是`POST /tts`加JSON；`ordinary1.wav`参考文件SHA-256为`442284e20d8b746a4a3ed187b5409c8bb1b6caf06402dc82b94ae52eaf3e8765`，与先前C6基线一致。端口探测**不证明**运行中的权重身份、API路由可用或端到端推理成功。

开发版后端原始SHA-256：`bb13b25e0a5e20d35d139997b2eab01c0b8702b47dce5ace905e568277e00029`；当前旧版TTS适配为GET查询参数，与C6接口不一致。

## 本轮研发交付

开发包`Dahuangs_C9_02_GPTSoVITS_POST_Adapter_V1.zip` SHA-256：

`4ca82fd16d0d37571b0b217e5ceccfa09fdfd57d96e893e59e97de11b9919266`

补丁只面向用户本机**隔离开发版**，一次性检查并修改：

- `app/backend/c9_studio_dev_server.py`：将GPT-SoVITS适配器由GET改为POST JSON，发送`text`、`text_lang`、`prompt_lang`、`ref_audio_path`、`prompt_text`、`media_type=wav`、`streaming_mode=false`；避免把合成文本及参考路径放进URL。
- `config/c9_studio_dev.local.json`：仅按当前已验证本机端口与参考预设启用开发版TTS；保持LLM未接入。
- `registry/voice_registry.local.json`：基于示例创建本地登记，允许经所有者明确确认的婉儿本地合成；IndexTTS LoRA150维持禁用。

**安装不调用TTS、LLM或训练**；要求先关闭实验网页进程，要求用户明确确认本地合法使用声音，校验现有后端SHA、生产预设、网关静态字段、参考音频SHA和本地配置；有未知修改即停止。原配置、后端保留备份，写入失败尝试回滚。不会改生产Gateway、权重、OpenClaw或旧Studio。

## 模拟验收

在本地隔离环境完成：Python语法检查、原后端SHA匹配、模拟安装成功、重复安装安全拒绝、模拟本机POST /tts JSON请求及WAV保存、LoRA研究模型执行阻断、篡改参考SHA被阻断。补丁后端SHA：`a1cae9727e839e75a0c7949e8d460963d8f0de1f08d820285472cb1f544606f4`。

**真实Windows安装和真实GPT-SoVITS推理尚未执行。** 本轮不视为生产API新版本验收，不声称排除运行期模型热切换。首次测试仅允许用户主动提交一条短文本，观察WAV是否正确生成，并提交脱敏安装凭证与页面结果。

## 公有仓库边界

本仓库只保留脱敏归档，不上传补丁源码、原始声音、转写文本、私人预设、权重、私人日志或完整调用参数值。C9工程源码后续进入Private VoiceFactory仓库管理。
