# C9-09：Dahuang's Voice Factory 多声音台账 V1 交付记录

**日期：2026-11-14。状态：代码与离线测试完成；用户Windows实机安装及结果待验收。**

## 本轮主线说明

用户明确要求**暂停麦克风/STT及双向语音相关工作**，返回最初的Voice Factory建设主线。C9-09当前聚焦多声音身份、参考音频SHA、模型版本和可追溯的草稿管理，暂不做语音合成、训练、远程网页或生产部署。

## 交付物

压缩包：`Dahuangs_C9_09_Factory_Registry_Installer_V1.zip`

ZIP SHA-256：`3022fcc906c73758985062641c5e1a73c14930f8bf4ef8f8c1b671ef1f22f354`

- Python 3.10标准库工具：`VoiceFactory/tools/factory_catalog_v1.py`。
- 安装器：`Install_C9_09.cmd`＋`Install_C9_09.ps1`，Windows ASCII/CRLF，逐文件SHA预检查，**已有不一致文件一律停止，不覆盖**。
- 用户入口：`C9_09_Show_Catalog.cmd`、`C9_09_Add_New_Voice.cmd`、`C9_09_Add_Model_Draft.cmd`。
- 新增独立私有台账：`workspace/private_factory_registry/factory_catalog.local.json`，不代替或修改当前Studio运行时注册表。
- 摘要报告：`docs/C9_09_SAFE_SUMMARY_*.json`，不包含录音、原文、密钥、权重文件路径、源WAV路径或显示名称，可用于远程核验。
- 文档：`docs/C9_09_FACTORY_REGISTRY_README.md`。

## 实现边界与可复用性

1. 首次运行只读导入 `registry/voice_registry.local.json` （不存在则选择旧示例文件）的婉儿及对应GPT-SoVITS/IndexTTS模型关系，复制的是**元数据，不是权重或音频**；导入目标为独立台账。
2. 新声音通过 `voice_id`、展示名和一个获合法使用授权的本机PCM WAV登记为**draft**。验证RIFF/WAVE、采样率/声道/帧数及SHA-256，不修改/复制原始WAV。真实路径只存本地私人台账。
3. 新模型仅能建立 `unverified` + `disabled` 草稿。工厂台账对所有模型强制 `catalog_can_execute=false`，不赋予训练、语音生成、发布、声音权利或生产热切换授权。
4. 已有婉儿本地使用确认仅保留为**历史作用域声明**，不会自动推广成新声音、云端传播或新的使用许可。
5. 每次写台账先验证交叉引用和唯一ID，保存独立时间戳备份，通过临时文件和原子替换写入；并发锁冲突则停止。录音资产可以重新计算SHA以发现意外变化。
6. 运行时 `registry/voice_registry.local.json`、17861开发版、9880/9890生产语音服务、Gateway、OpenClaw、原Studio V1.4、DeepSeek及Cloudflare配置均不修改。

## 验证结果与待确认事项

- **17项标准库单元测试通过**（模拟既有婉儿导入、重复初始化、草稿新增与重复ID拦截、非法ID/非WAV、资产损坏/缺失检测、模型注册约束、权限状态限制、私有路径在摘要中脱敏、原运行注册表SHA不变等）。
- Python语法检查通过。
- ZIP内8个目标文件SHA一致，压缩包完整性检查通过；CMD/PowerShell脚本均为ASCII+Windows CRLF。
- **尚未在用户Windows设备上运行安装器；尚未与运行中的Voice Studio网页交互；尚未实际试制第二声音。** 不能据此声明C9-09端到端完成，也不能称C9-10/C9-11已经完成。

## 本机单次验收步骤

解压ZIP→双击 `Install_C9_09.cmd`→预期 `C9_09_INSTALL_OK`，并生成 `VoiceFactory/docs/C9_09_SAFE_SUMMARY_*.json`。

将该**摘要JSON**上传用于检查；不要上传私有 `factory_catalog.local.json`、实际原声/权重、训练集或任何API Key。

随后C9-10推进标准化声音数据准入与L1快速试声；C9-11再以第二个获得适当授权的声音证明复用。**安装模块不等于批准模型生成。**

参见 [主任务台账](C9_MASTER_ROADMAP_AND_UX_BACKLOG_V1.md) 与 [C9整体交接](C9_VOICE_FACTORY_HANDOFF_V1.md)。
