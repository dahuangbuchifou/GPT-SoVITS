# C9-12：Voice 002专属GPT-SoVITS v2Pro插件内推理成功与两句新文本验收

**日期：2026-11-15。状态：用户确认现有训练插件已能用Voice 002的GPT/SoVITS两份专属权重生成WAV，且主观试听正常；Voice Factory独立进程加载尚未实测。**

## 已有证据等级

- 用户明确确认使用已训练的`dahuang_e8_s200.pth`与`dahuang-e10.ckpt`在训练插件内**真实生成过新WAV、试听正常**；此前13段声音素材来自Voice 002。
- 两份权重的SHA-256已在用户本机核对：SoVITS `cee4cc6ea119ff06a0ad9b53c0661f9ce28ddfc178a1d6f63962b6181d15d1fd`，GPT `9fb91428501effaea21d4677173cbafbf03a17d50332771c0933d43022e00847`。
- 标准ZIP检测SoVITS内部成员时曾报`LOCAL_HEADER_MISMATCH`，并非同一件事的运行时失败证据；当前不再以它直接否定用户已进行的插件推理。若将来在**独立**加载中遇到一致故障，再独立定位。无须因此重训或改写权重。
- 目前没有独立记录插件推理的**准确版本、完整启动命令、参考音频/转写、所用checkpoint实际路径、WAV文件SHA和延迟**，因此仍不能把用户的成功测试等同于Voice Factory自身进程级兼容通过或生产上线批准。

## 本轮交付：离线两句WAV验收工具

包：`Dahuangs_C9_12_Voice002_GPTSoVITS_Plugin_Isolated_WAV_Acceptance_V1.zip`。

包SHA-256：`9d7cbb33c9c2197c05c01a2807a6b865f57929e539967931d6be0f4bfb00ee72`。

1. `Prepare_C9_12_Only.cmd`：只读核对两份权重SHA，建立独立输出目录；不调用TTS，也不加载模型。
2. 用户在**已经实际成功的独立训练插件推理界面**中选择Voice 002的两份专属权重、A03参考音频及其精确文字，使用两条之前未参与训练的新测试句生成`GSV_01.wav`、`GSV_02.wav`。两句分别偏向自然交流与“不是今天、明天下午、再确认”的自然重音。勿直接切换婉儿生产服务的全局权重。
3. 保存到独立VoiceFactory私有测试目录，不替换既有A03/A02 IndexTTS生成文件。
4. `Verify_C9_12_WAVs_Only.cmd`：再次检查权重SHA，解析两条WAV的16-bit PCM格式、时长、RMS、峰值、数字削顶、DC/低电平采样比例、SHA，生成无私有路径/无原声/无文本内容的脱敏JSON `VoiceFactory/docs/C9_12_GSV_ACCEPTANCE_SAFE_*.json`。此工具不调用Torch、模型推理、训练、网络/生产端口；**技术检查通过不等于声音听感通过，也不证明插件实际选择的是预期权重**。
5. 人工听评两句各自像本人程度（1–5）、自然度（1–5）、语气/重音、错字漏字/停顿，评估相对于IndexTTS BASE A03基线的改善。技术检查加人工评价后，方考虑冻结新声音模型版本为候选。

## 离线测试结果与限制

- 使用合成PCM WAV和模拟权重SHA运行6项单元测试：预处理不改权重、两条有效输出、缺WAV、损坏WAV、SHA变更阻断、异常时长标记。
- Windows CMD采用ASCII+CRLF；ZIP成员及manifest SHA逐一验证，实际WAV环境、训练插件执行及文件操作尚待用户实机完成。
- 若插件的推理功能实质通过9880/9890在全局切换权重，**禁止继续**：改用独立进程后再合成，不能为了验收中断/重设生产。
- GPU如与婉儿生产服务共享RTX3070 8GB，需要空闲时段及显存预算；不主动停止生产任务。

## 下一道门槛

用户上传脱敏WAV技术结果并报告人耳评价；如通过，再进行一个**另行授权、生产服务完全隔离**的Voice Factory独立v2Pro加载与推理验收，核实训练插件依赖/版本和模型权重加载逻辑。不能因本轮插件内输出通过就声明独立运行注册与Voice Studio发布完成。麦克风/STT继续暂停。

参考此前C9-12的[首次权重静态检查](C9_12_VOICE002_TRAINED_WEIGHTS_STATIC_CHECK_20261115.md)以及[ZIP兼容性诊断](C9_12_SOVITS_BADZIP_CRC_DIAG_V2_20261115.md)。