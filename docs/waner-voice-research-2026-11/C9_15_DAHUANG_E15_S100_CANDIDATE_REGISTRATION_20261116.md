# C9-15 dahuang 专属GPT-SoVITS候选模型验收及私人注册交付

**记录日期：2026-11-16。状态：C9-14独立TTS技术PASS + 用户人工听评5/5、5/5；C9-15候选注册工具完成离线验证，但用户Windows本地台账尚未运行本轮注册。**

## 1. 已锁定人工试听证据

用户对Voice 002（显示名 **dahuang**）的C9-14新模型单句`DAHUANG_E15_S100_01.wav`反馈：
- **像本人程度 5/5**；
- **自然度 5/5**；
- 无额外异常补充。

此前用户上报C9-14两份安全报告已验证新训练权重`dahuang-e15.ckpt`+ `dahuang_s100.pth`可在独立CPU/FP32推理一次，输出5.90秒/32kHz/RMS -27.50dBFS、无数字削顶，全部5项技术质量门禁通过；输出SHA：`70b94c28974b3c4b299f4851cc2214d2ec7953c5536ecf9654784c80df5e7f25`。

**评价范围仅一条新句、一次人工主观评定。** 足以支持工程上的非执行`candidate`登记，但尚不代表生产发布、长句/情绪/重复推理/声纹客观测评通过。

## 2. 候选冻结

|属性|值|
|---|---|
|固定声音ID|`voice_002`|
|显示名|`dahuang`|
|候选模型ID|`voice_002_gsv_e15_s100`|
|人类版本标签|`e15_s100`|
|引擎|`gpt_sovits` / `v2Pro`|
|GPT权重|`dahuang-e15.ckpt`，SHA`b60a10efe7b15bdde8c9e9f4dc04cfeaff3fd95235c8f68451f0baae00098a3b`|
|SoVITS权重|`dahuang_s100.pth`，SHA`50b616c16e57b7ea2c28bc22dc2a2dda7eb32bac2f1a1a7539758f836d58ee21`|
|参考音频|本机已绑定`A03.wav`，注册脚本复验原台账SHA|
|原插件与旧权重|保留，不覆盖|
|发布及执行权限|均不授予；禁止把候选当成默认生产模型|

## 3. C9-09 v1台账兼容策略

本机Factory源台账`dahuangs.voicefactory.catalog.v1`的模型生命周期**没有**文字值`candidate`，只接受`existing_production/approved/research/deprecated/unverified`。

为避免任意更改既有基础schema，本轮采用双记录：
1. 在**独立私有工厂目录**`factory_catalog.local.json`的`voice_002.models`新增一条`engine=gpt_sovits`、`lifecycle=research`、`execution_tier=disabled`、`catalog_can_execute=false`模型；`voice.stage=draft`、`default_model_id=null`均不改变。
2. 另存私有版本清单`model_versions/voice_002_gsv_e15_s100.candidate.json`，其中明确`status=candidate`，记录完整本地路径、两权重SHA、参考SHA、已验收单句WAV SHA及用户5/5评分、严格禁止发布标记。

该私有manifest与台账**不得上传Public GitHub**，也不得直接替换正在使用的`registry/voice_registry.local.json`；用户问的“候选模型注册”不是Studio模型热切换。

## 4. 已交付注册包

包名：`Dahuangs_C9_15_Dahuang_E15_S100_Candidate_Registry_V1.zip`

ZIP SHA-256：
`3d586224491d3cc463e86dc1748501eb3f2d84b64d55a44257d4e717c02b8199`

执行顺序：
- `01_Check_Dahuang_Candidate.cmd`：只读核验模型两个SHA、A03源音SHA、现有C9-14回执、私有一条输出WAV及SHA/PCM指标、台账结构与是否已登记；不会加载Torch/TTS。
- `02_Register_Dahuang_Candidate.cmd`：按提示确认`REGISTER_DAHUANG_E15_S100_CANDIDATE`，且门禁通过才以一次性Catalog锁保护、台账完整备份、临时文件+原子替换方式写入两条私有候选数据；已有相同候选则幂等返回，不增加重复条目。
- `03_Verify_Dahuang_Candidate.cmd`：只读验证候选关联、私有manifest与冻结文件SHA，供Windows实机验收。

只分享`VoiceFactory/docs/C9_15_CANDIDATE_SAFE_*.json`，不分享私有完整台账或manifest。程序遇到资产变动、目录锁、未知catalog字段、已存在部分登记等即停止，不自动修复或删除锁。

使用Python标准库，不导入Torch、不调用模型、不训练、不生成WAV、不启动API/网络，不碰9880、9890、OpenClaw、Cloudflare及Studio运行注册表。候选包以**已存在的真实本地权重**为只读输入；对已生成WAV及旧一次性lock做核验，不重复C9-14执行器。

## 5. 离线测试与限制

**22项模拟/合同测试PASS**：授权短语错误时无改动、成功登记、幂等复核、GPT与SoVITS SHA改变、A03引用改变、近静音WAV阻断、短WAV阻断、WAV SHA改变、报告质量FAIL、已存在冲突ID、Catalog锁、重复run、私有manifest篡改、敏感路径不泄露、婉儿生产记录逐字节不变，以及**直接用C9-09官方旧台账验证器复核候选条目**。ZIP CRC与成员SHA、Windows CMD ASCII+CRLF校验通过。

测试依赖合成录音和mock权重，**没有在用户Windows真实台账上执行本轮写入**。实际注册通过须用户本机返回`C9_15_CANDIDATE_REGISTERED_NON_EXECUTABLE`及最新安全JSON。

## 6. 下一道阶段

本机候选注册成功后，进入**C9-16 Studio开发版多声线架构设计/隔离适配器**：先只读对接Factory版本清单，校验模型路径与SHA、审批选择流程、模型加载/显存预算/冷启动、互斥切换和明确回滚；再在开发版验证对话和TTS切换。需要发布/生产操作时仍另行授权，不能因本次5/5评分而启动多声线热切换。麦克风/STT保持暂停。