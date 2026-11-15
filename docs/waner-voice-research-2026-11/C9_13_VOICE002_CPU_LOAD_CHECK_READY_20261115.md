# C9-13：Voice 002独立CPU加载只读门禁通过，真正加载仍待单独授权

**日期：2026-11-15。状态：用户完成`Check_C9_13_Load_Only.cmd`，尚未加载模型、训练或推理。**

## 用户实际回传的报告

- 报告：`C9_13_LOAD_GATE_SAFE_20261115T140847835135Z.json`
- `schema=dahuangs.c9_13.voice002.cpu_load_gate.v1`
- `status=GATE_READY_NO_MODEL_LOADED`；`voice_id=voice_002`
- `model_sha_pair_matches=true`，`engine_v2pro_code_token=true`，`runtime_matches_install=true`；
- `engine_source_sha256=9c7d119f2773cda143c62a00f3977ab0d4e9daaffa01e7c26538ac92cc06313e`
- `ram_gib_snapshot=14.96`，`blockers=[]`；
- `training=false`，`tts=false`，`model_loading=false`，`network=false`。

**边界说明**：该报告只确认静态门禁和当时的可用RAM快照，不保证真实CPU加载所需内存一定充足，也不证明SoVITS .pth在独立v2Pro进程中已经成功解析。原插件内确曾由用户生成两句WAV且技术验收2/2有效，但仍不能把插件内加载成功等同于VoiceFactory独立进程加载成功。

## 已交付执行包、后续受控授权

用户本机已经使用 `Dahuangs_C9_13_Voice002_Isolated_CPU_Load_Gate_V1.zip` 的 **check-only**入口。对交付ZIP内源代码作静态复核，载入入口 `Run_C9_13_Load_Only_After_Approval.cmd`：
- 重新复核模型SHA、环境、资产目录、可用RAM；
- 要求用户在控制台输入精确口令`AUTHORIZE_C9_13_VOICE002_CPU_LOAD_ONLY`；
- 仅尝试一次Voice 002配对权重的官方v2Pro TTS对象CPU/FP32初始化，不执行`run`或TTS，不启动API/新端口；
- 设置`CUDA_VISIBLE_DEVICES=-1`，独立TMP/TEMP/HF_HOME/GRADIO_TEMP_DIR；
- 特别处理官方TTS loader会`save_configs()`的问题，把`cfg.configs_path`改指到VoiceFactory独立私有YAML，以避免直接写原生产`tts_infer.yaml`；
- 一次性锁位于`workspace/private_factory_registry/c9_13_voice002_cpu_load_once`，即使加载失败也不得自动重跑；
- 脱敏结果写入`VoiceFactory/docs/C9_13_LOAD_RESULT_SAFE_*.json`，内部异常信息仅保留私有目录；
- 使用已安装的本地训练/推理环境及PyTorch权重反序列化，**只应载入有信任来源的自训文件**。该方案不是OS级沙箱，可能存在第三方库的偶发IO/缓存行为，不能保证完全没有任何非预期文件副作用。

**当前未收到用户对“本次模型加载”的明确授权，不能把上传静态报告视为自动授权。** 需要询问用户是否同意Voice 002、现有两权重、一次独立CPU/FP32仅加载、不生成WAV、不训练、不启动API、原有9880/9890不更改；用户明确同意后才允许运行真实入口。

## 后续主线

实机`C9_13_INDEPENDENT_CPU_LOAD_OK_NO_TTS`才算“独立加载”验收通过；再单独申请一次有界的VoiceFactory独立TTS合成与候选模型登记，不应立即发布到Voice Studio或热切换婉儿服务。麦克风/STT暂缓。