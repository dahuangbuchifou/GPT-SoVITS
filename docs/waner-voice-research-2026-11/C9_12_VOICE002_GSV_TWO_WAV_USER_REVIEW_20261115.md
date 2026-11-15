# C9-12：Voice 002 GPT-SoVITS专属模型双句WAV已生成，用户初步试听认可

**记录日期：2026-11-15。状态：两条WAV已由用户本机截图确认存在，用户评价“效果可以”；技术报告、独立文件内容和Voice Factory独立运行仍待验收。**

## 本机证据

用户截图展示私有实验目录 `VoiceFactory/workspace/private_factory_registry/c9_12_voice002_gsv_acceptance/wavs` 中：

|文件名|Windows资源管理器显示大小|证据级别|
|---|---:|---|
|`GSV_01.wav`|352 KB|文件存在；仅截图|
|`GSV_02.wav`|332 KB|文件存在；仅截图|

用户确认此次重新合成成功，并表示音质“效果我认为可以的了”。此结论是用户**初步主观认可**，并非盲评量化评分，不能推断新输出已通过独立声纹相似度/断句/重音测试。

## 报告状态

前一份`C9_12_GSV_ACCEPTANCE_SAFE_20261115T113215Z_9fcbfacd.json`报告`WAV_TECHNICAL_REVIEW_REQUIRED`、当时两条片段`MISSING_OR_SYMLINK`，系这次新WAV生成之前的检查状态；新截图**不自动改写旧报告**。

现在需要用户**只运行既有的**`Verify_C9_12_WAVs_Only.cmd`，输出一份新`C9_12_GSV_ACCEPTANCE_SAFE_*.json`。核对WAV真实格式/时长/RMS/peak/clipping/SHA和权重身份；不要覆盖或重新生成音频。

## 正确的里程碑

- Voice 002专属GPT-SoVITS v2Pro训练插件生成音频：用户验证成功，双句新WAV现已存在。
- 听感：用户初步认可，但无逐句分数/错读及重音详细评价；尚不能声称质量高于IndexTTS BASE。
- 独立模型加载：**尚未证明**。插件内推理成功不代表Voice Factory独立进程已加载成功。
- Voice Factory Registry/Voice Studio发布：未进行，需额外隔离/兼容/资源门禁；不得碰现有婉儿生产9880/9890服务。
- 无新训练、无模型替换；本轮仅保存脱敏项目证据。

后续流程：新WAV安全技术报告→记录两句简要主观评分/评价→冻结Voice 002候选模型版本及SHA→另行授权的独立进程加载/推理测试→通过后才考虑开发版Studio接入。
