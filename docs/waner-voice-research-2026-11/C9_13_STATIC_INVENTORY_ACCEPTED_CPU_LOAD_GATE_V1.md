# C9-13：Voice 002 独立运行基础已静态核验，CPU隔离加载工具待Windows门禁

**日期：2026-11-15。状态：用户Windows静态检查PASS（实际为`STATIC_INVENTORY_ONLY_NOT_LOADED`），独立CPU模型加载尚未发生。**

## 用户报告证据

报告：`C9_13_RUNTIME_INVENTORY_20261115T140200Z_66c1b7f1.json`；原上传资料由用户提供，schema `dahuangs.voicefactory.c9_13.runtime_inventory.safe.v1`。

- `voice_id=voice_002`。
- GPT权重 `dahuang-e10.ckpt`，155312438字节，SHA-256：`9fb91428501effaea21d4677173cbafbf03a17d50332771c0933d43022e00847`；SoVITS权重 `dahuang_e8_s200.pth`，134945589字节，SHA-256：`cee4cc6ea119ff06a0ad9b53c0661f9ce28ddfc178a1d6f63962b6181d15d1fd`。均为普通文件，SHA与已确认模型对匹配。
- 安装的v2Pro源码入口`api_v2.py`、`api.py`、`webui.py`、`TTS_infer_pack/TTS.py`和推理webui均存在；解释器`runtime/python.exe`存在，另外两个解释器候选不存在（并非故障）。
- 端口9880/9890为`LISTENING`，因此不得在该端口上运行Voice 002模型；17861`NOT_DETECTED`，但不是本轮阻断项。
- `independent_v2pro_model_loading_verified=false`、`no_torch_load_no_llm_no_tts_no_training=true`、`no_production_service_or_file_changes_by_checker=true`。

**此检查只证实静态身份与可用组件，不代表模型在Voice Factory独立加载成功。** C9-12在训练插件内的两条WAV技术质量已通过，用户主观初步认可；不安排重复训练或ZIP诊断。

## 即将测试的独立进程：只加载，不合成

交付：`Dahuangs_C9_13_Voice002_Isolated_CPU_Load_Gate_V1.zip`，包SHA-256：

`3543d4193875e0e5eca8ac513810a009ff8e7b007509e92ce1610b0c4d7c1368`

包含5个脚本/说明/测试源文件和SHA manifest。10项**离线模拟**单元测试通过，ZIP成员SHA一致，CMD采用Windows CRLF。尚未在用户真实Windows推理环境运行，不能宣称实机模型加载成功。

- 当前阶段仅允许双击 `Check_C9_13_Load_Only.cmd`，它以既有`runtime/python.exe`执行Python标准库的只读校验（新旧模型SHA、v2Pro源码标记、BERT/Hubert目录、RAM >=12GiB快照、解释器路径），输出 `VoiceFactory/docs/C9_13_LOAD_GATE_SAFE_*.json`；**不导入Torch，不加载模型，不执行TTS**。
- `Run_C9_13_Load_Only_After_Approval.cmd` **尚未授权，不得运行**。如果后续用户独立明确许可，该入口在重新完成只读门禁后、人工输入`AUTHORIZE_C9_13_VOICE002_CPU_LOAD_ONLY`方尝试一次CPU/FP32的受信任本机模型权重加载；绝不生成WAV、不启动API服务、不绑定端口、不训练。
- 真实加载使用已安装本机官方TTS`TTS_Config`/`TTS`类，构造独立自定义配置，显式将`cfg.configs_path`指向VoiceFactory私人目录，以避免官方`save_configs()`覆盖引擎中的生产`tts_infer.yaml`。启动时设`CUDA_VISIBLE_DEVICES=-1`、Transformers/HF离线模式与专用TMP/TEMP/GRADIO_TEMP_DIR/HF_HOME/TORCH_HOME。模型文件和GPT-SoVITS安装路径作为只读输入，但**这不是操作系统级文件系统沙箱**，不能保证第三方库完全不产生其他文件副作用；使用已获信任的用户本人训练文件，绝不加载不明来源模型。
- 运行记录采用`ONE_SHOT_ATTEMPTED.lock`且禁止自动重试；结果安全报告仅含状态、耗时、CPU设备和简明错误类型，不含音频或个人信息，真实错误详情只在私人实验目录。
- 这里选择CPU是为了不给已在9880/9890运行的婉儿GPU生产服务制造显存冲突；CPU加载依然占用较多系统RAM，12GiB是保守初步运行门槛，不构成运行成功保证，建议在生产空闲时段执行后续获批准的加载。

## Next gate

用户先运行仅静态门禁，上传`C9_13_LOAD_GATE_SAFE_*.json`；如通过，再取得**此次单独模型加载**的明确授权，尝试一次独立CPU加载。随后再有单独范围控制地做真正的Voice Factory语音合成与candidate注册，既不热切换婉儿模型，也不重启生产服务。Voice Studio 17861当前未监听无需强制启动。

已暂停的麦克风/STT/远程访问功能仍不作为本轮主线。Public仓库只保存本脱敏记录与台账，不上传个人音频、模型权重、私人工单、API密钥或执行源码。