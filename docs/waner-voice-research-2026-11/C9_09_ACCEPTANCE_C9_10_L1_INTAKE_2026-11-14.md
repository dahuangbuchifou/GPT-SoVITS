# C9-09实机核验与C9-10参考音频准入交付

**日期：2026-11-14。状态：C9-09基础注册功能通过受控摘要核验；C9-10预检工具离线通过，Windows安装与第二声音检验待完成。**

## C9-09提交的实机摘要

用户上传 `C9_09_SAFE_SUMMARY_20261114_213344_949408.json`，该文件字节SHA-256为：

`a748aad11de006c7c72fdef4f9fd8b9c6dfed626bb3b63ca31dccc613b760112`

证据内容（安全摘要，不包含原音频或私有路径）：

- `voice_count=1`；声音ID `waner`，阶段 `existing_import`。
- `reference_count=1`；模型ID `waner_gsv_stable`、`waner_lora150_research`，`model_count=2`。
- `all_execution_disabled=true`：该工厂台账仅用于管理；不赋予模型运行或部署权限。
- `no_tts_or_training_invoked=true`、`production_registry_unchanged_by_tool=true`、`contains_audio_or_keys_or_paths=false`。

据此将**C9-09的现有婉儿元数据导入/独立台账初始化**标记通过。证据仅来自本机工具的安全报告；不能代替独立实机磁盘检查、权重身份审计，也不能声称新声音已完成试制。

## C9-10 L1技术预检工具

交付：`Dahuangs_C9_10_Reference_Intake_QualityGate_V1.zip`

最终ZIP SHA-256：

`5bdc6cc28e3f9904a5c8bcec67b78b1cc981ba3e71c3e1351cc5efff0cea731a`

主要能力：

1. 在**已有C9-09私有台账**中验证给定`voice_id`和WAV一致；拒绝未登记声音、SHA不匹配或不受支持的格式。
2. 只读检查未压缩RIFF PCM WAV：采样率、声道、位深、时长、RMS、峰值、近静音采样比例、数字削顶与DC偏置。
3. 标准化输出 `PRELIMINARY_PASS_HUMAN_REVIEW_REQUIRED`或`REVIEW_REQUIRED`；阈值只是工程预检提示，**不是音质、授权、人物身份、东北口音或音色相似度验收**。
4. 明确要求用户自述有权做本地质量评估。此自述不构成独立授权审计，不可推出可公开传播、训练或生产部署。
5. 私有报告存放`workspace/private_factory_registry/c9_10_intake/`，包含本机源WAV真实路径与SHA；仅`docs/C9_10_SAFE_INTAKE_*.json`为无声源路径、无声音ID、无SHA、无密钥的上传摘要。
6. 本包**不调用AI/音频生成、不重采样、不拷贝或删除原WAV、不修改现有工厂或Studio运行台账、不改生产服务**。
7. 当前不含L1真实试声、L2评估、L3训练。第2个合法授权声音的试制与多声音Studio发布仍待独立验收。

### 离线验证

- Python语法检查通过，18项基于**合成测试波形**的标准库单元测试通过，包括WAV 8/16/24/32位PCM、权限前置、台账绑定/哈希、无覆盖、质量警告、私人路径防泄露。
- ZIP 9个文件，包内5个预定写入文件的SHA由manifest校验；Windows CMD与PowerShell脚本为ASCII/CRLF。
- 仍然**没有在用户Windows环境实机安装C9-10**，不能把离线测试当成真实新声音处理通过。

### 下一步

可先只安装工具，暂时不要求上传第二声音。等用户准备好获许可的参考WAV：用C9-09`C9_09_Add_New_Voice.cmd`创建草稿，再运行`C9_10_Check_Reference_WAV.cmd`生成`C9_10_SAFE_INTAKE_*.json`用于审核。**不要上传原始WAV或私有报告**，除非有独立明确需要并确定适当隐私许可。

后续C9-10下一子阶段将设计有审批门禁的L1真实试声（独立运行、一次性小样本，不自动训练），随后C9-11通过第二声音证明模块可复用。

麦克风/STT、双向语音按用户决定暂停，后续不得再作为主线阻塞项。