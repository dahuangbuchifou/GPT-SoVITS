# C9-13：Voice 002 GPT-SoVITS v2Pro 独立CPU模型加载成功

**日期：2026-11-15。状态：Voice Factory独立进程完成GPT+SoVITS权重的CPU/FP32实际初始化；尚未独立合成WAV、启动模型服务、训练或注册为Studio正式声线。**

## 用户实机结果（来自独立加载安全报告与CMD截图）

报告：`C9_13_LOAD_RESULT_SAFE_20261115T143027609838Z.json`

| 实际字段 | 结果 |
|---|---|
|`status`|`C9_13_INDEPENDENT_CPU_LOAD_OK_NO_TTS`|
|`voice_id`|`voice_002`|
|`model_sha_pair_matches`|`true`|
|`loaded_gpt`|`true`|
|`loaded_sovits`|`true`|
|`device`|`cpu`|
|`precision`|`float32`|
|`wall_clock_seconds`|11.88|
|`cuda_initialized_after`|`false`|
|`speech_inference`、`training`、`server_started`|均`false`|
|`production_ports_modified_by_this_tool`|`false`（执行工具自报，不等于全系统完整文件审计）|

CMD结束符为`C9_13_INDEPENDENT_CPU_LOAD_OK_NO_TTS`，`C9_13_LOAD_EXIT_CODE=0`。参考v2Pro源文件和Python环境来自此前只读门禁，权重身份与冻结的Voice 002专属GPT/SoVITS双权重SHA一致。

### 已解决的问题

之前标准ZIP工具报告SoVITS PTH `LOCAL_HEADER_MISMATCH`，不能当成模型损坏的决定性证据；现在**该对权重已在独立v2Pro CPU进程中完成真实初始化**，无需重训或重新导出。

### 不能越界的结论

- **独立模型加载PASS ≠ 独立TTS生成PASS**：尚无Voice Factory独立生成的语音文件，也未验证真实延迟、音色和设备稳定性。
- **模型加载PASS ≠ 生产服务已切换**：没有在9880/9890运行新模型，也没有启动独立API或发布Studio。
- 训练插件里的`GSV_01.wav`、`GSV_02.wav`两句此前已技术检查通过且用户主观认可；这些WAV不能替代当前独立进程的TTS验收。

## 接下来：C9-13独立单句TTS + 候选注册

1. **另行取得本次TTS执行授权**：仅Voice 002、专属v2Pro GPT+SoVITS已校验权重、A03参考及准确转写、固定一条未参与训练的中文测试句、CPU/FP32独立进程、一个新WAV，不训练、不起服务、不改9880/9890；新独立私有run目录、执行结果SHA、失败不自动重试。
2. 使用专属独立配置副本、分离的HF/Gradio临时缓存，继续防止官方TTS载入器的`save_configs()`重写生产`tts_infer.yaml`；不要将权重切换指令发送到既有生产API。
3. 在单句实际合成与技术校验、人工听评通过后，才把Voice 002登记为Voice Factory的`candidate`模型（以两权重SHA、v2Pro环境、参考片段、授权用途、测试回执、加载与回滚策略做版本锁定）；**候选模型注册不等于发布Studio正式运行**。
4. 后续用统一多声音适配接口实现按Voice ID选择引擎/模型和安全切换；先在Voice Studio开发版试用，再计划正式生产接入。

当前GitHub只归档公开安全工程状态，没有上传原WAV、合成WAV、权重、private工作区、个人隐私数据或密钥。麦克风/STT按用户决定仍暂停。
