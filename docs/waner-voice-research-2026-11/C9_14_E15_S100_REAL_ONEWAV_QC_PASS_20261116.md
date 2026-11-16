# C9-14：dahuang新权重e15+s100独立CPU单句试声技术PASS（待人耳听评）

**实机结果时间：2026-11-16。状态：新模型组合在Voice Factory独立CPU/FP32进程成功生成技术有效WAV；人工相似度、韵律、字词准确度和稳定性尚未最终验收，未注册Studio生产声线。**

## 预检实证

`C9_14_NEWPAIR_GATE_SAFE_20261116T124601788894Z.json`：
- `status=C9_14_NEWPAIR_GATE_READY_NO_MODEL_LOADED`；
- `voice_id=voice_002`、显示名`dahuang`、版本候选`e15_s100`；
- GPT新权重SHA256 `b60a10efe7b15bdde8c9e9f4dc04cfeaff3fd95235c8f68451f0baae00098a3b`；
- SoVITS新权重SHA256 `50b616c16e57b7ea2c28bc22dc2a2dda7eb32bac2f1a1a7539758f836d58ee21`；
- 源码版本匹配、A03参考SHA匹配、可用RAM快照18.96 GiB、零阻断项；预检时无TTS/模型加载/训练/API启动。

## 真正独立单句推理

`C9_14_NEWPAIR_TTS_RESULT_SAFE_20261116T124701638764Z.json`：
- `status=C9_14_NEWPAIR_ONE_WAV_VALID_HUMAN_REVIEW_REQUIRED`；
- `model_sha_pair_matches_precheck=true`；
- CPU / float32，1个输出，1个技术质量有效；
- 32 kHz、5.90秒，RMS **-27.50 dBFS**，峰值0.38028、有声活动估计3.45秒；
- 时长、RMS、峰值、有声活动、无数字削顶五项质量检查全通过；
- 输出WAV SHA256 `70b94c28974b3c4b299f4851cc2214d2ec7953c5536ecf9654784c80df5e7f25`；
- 一次执行耗时32.67秒；
- 报告显示`training=false`、`api_server_started=false`、`production_api_called=false`。这是工作器自报的执行范围，未做独立全系统资源/文件审计。

## 对比与结论

此前C9-13旧权重`e10+e8_s200`单句相同文本、参考与参数仅生成0.74秒、RMS -62.84 dBFS的近静音WAV，且旧V1错误标记为READY（已纠正）。

本轮`e15+s100`在同一固定文本、参考A03、随机种子和配置下，生成5.90秒、RMS -27.50 dBFS的技术有效输出，**说明新模型组合在本次独立试验中明显改善了“极短/近静音”的结果，证明完整独立TTS技术链首次达到本轮质量门禁。** 但一次样本不能证明长期稳定、音色优于旧版或判明旧版失败的唯一成因。

## 下一道门槛

**用户本机人工试听此次新WAV**，给出像本人程度（1–5）、自然度（1–5）、语气重音、错/漏字与是否明显噪声；不要求再进行重复推理。若主观质量认可：
1. 冻结`voice_002`显示名`dahuang`的`e15_s100`双SHA、A03身份、实验结果与回滚标记，拟在独立Voice Factory注册为`candidate`；
2. 先以只读方式审计现有私有工厂台账/版本注册schema和Studio开发版模型切换接口，再做范围受限注册；**不会直接接入运行中的9880/9890、不会把候选等同生产发布**；
3. 如需进一步测稳定性、GPU性能和实时对话延迟，另行设计实验/授权，不自动重跑已经使用的一次性试声工具。

旧模型文件与C9-13失败run/lock保留。生产婉儿、OpenClaw、Gateway、麦克风/STT任务状态不变。

Public GitHub只保存脱敏工程记录，不含WAV、训练音频、用户私有目录、原始文本、API密钥和模型文件。