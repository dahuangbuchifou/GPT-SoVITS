# C9-14：dahuang 新权重对（e15 / s100）独立单句试声准备

**日期：2026-11-16。状态：新版本试声包已完成离线模拟测试，Windows真实推理结果尚未收到。不得当作音质通过或Voice Studio已注册。**

## 模型选择与身份

用户在本机 `VoiceFactory/config/models` 目录截图显示四份训练权重，并明确要求改用后两份试验：
- **新GPT**：`dahuang-e15.ckpt`
- **新SoVITS**：`dahuang_s100.pth`
- **旧GPT保留**：`dahuang-e10.ckpt`
- **旧SoVITS保留**：`dahuang_e8_s200.pth`

Voice Factory显示名称继续为`dahuang`，内部唯一ID继续`voice_002`；不修改旧两份权重、原实验目录及一次性锁，也不自动切换婉儿生产9880/9890。

**边界**：截图证明候选文件存在，但尚无新两份模型的本地SHA-256或实际加载记录；检查工具须在Windows首次运行时计算SHA、确认文件不是已冻结的旧权重，再以同一SHA锁定当次尝试。显示文件名不能独立证明v2Pro兼容性或声音质量。

## 上一轮C9-13已知故障

原独立TTS的V1执行器曾对`0.74 s / -62.84 dBFS / peak 0.00403`的近静音WAV错误报READY。此为音频验收门槛缺陷；独立GPT/SoVITS权重加载此前确已完成，但**独立语音合成尚未质量验收通过**。不允许把V1的READY字符串作独立TTS成功证据。

## C9-14 单句受控对照交付

包：`Dahuangs_C9_14_Dahuang_E15_S100_OneWAV_SafeV2.zip`

ZIP SHA-256：`55be7a7fc9633e8db895ce4a8c918b06bffbba12757456e92c656e5d3adc6081`

包含：
1. `01_Check_Dahuang_E15_S100.cmd`：仅标准库只读检查（用户本机实际路径、TTS.py冻结SHA、两份新权重存在/大小/SHA不等于旧模型、Factory别名、A03参考与私有台账SHA一致、内存快照>=12GiB、未使用C9-14一次性锁）。输出 `VoiceFactory/docs/C9_14_NEWPAIR_GATE_SAFE_*.json`。不加载模型或生成音频。
2. `02_Run_Dahuang_E15_S100_OneWAV.cmd`：用户本轮批准新模型一条对照试声；须通过同样门禁并输入交互确认词`AUTHORIZE_DAHUANG_E15_S100_ONE_CPU_WAV`，之后只尝试**一次**独立CPU/FP32 TTS。输出新实验`workspace/private_factory_registry/c9_14_dahuang_e15_s100_one_wav/run_*/DAHUANG_E15_S100_01.wav`及脱敏安全报告 `VoiceFactory/docs/C9_14_NEWPAIR_TTS_RESULT_SAFE_*.json`。
3. Python独立执行器、README、18项合成/Mock离线合同测试、文件SHA manifest。

本轮保持**与上一轮C9-13完全相同**的A03参考及参考转写、目标单句GSV_01、固定种子`2026111501`、`cut0`、`parallel_infer=False`等生成参数。**唯一有意的算法变量是模型权重对**。固定设置不代表最优参数，若再出现短音仍需比较训练插件成功时的实际参数、参考转写和种子。

新版输出质量门禁独立检查：PCM可解码/时长2–30秒/RMS至少-42dBFS/peak至少0.03/至少0.5秒可听活动/无明显削顶；不达标即`C9_14_NEWPAIR_INVALID_AUDIO_REVIEW_REQUIRED`，非零退出码，即使已经写出WAV也不记为成功。生成质量合格后仍需人耳评价，不自动注册candidate/Studio。

独立CPU进程设置CUDA不可见、HF离线模式、独立TMP/HF_HOME/TORCH_HOME、独立`tts_infer_private.yaml`配置副本，避免调用或热切换生产API。运行插件或第三方代码并非操作系统级安全沙箱；仅加载用户本人信任的训练导出文件。新的一次性锁被创建后，不允许删除锁或重复尝试；失败保留私有报告，另行分析。

## 验证边界

18项纯合成/Mock测试通过，包括旧静音0.74秒回归、正常5秒PCM、缺/改模型、参考SHA变更、内存不足、旧权重保留、未授权拒绝、试声一次性阻断、错误质量标记。Python语法检查、ZIP与SHA manifest核对和CMD Windows CRLF编码完成。

**没有在用户Windows机器运行该新版本**；实际加载与独立合成是否成功尚待用户的安全JSON和听评。GitHub只存放此脱敏说明，不上传权重、声音、私有台账、执行源码或密钥。