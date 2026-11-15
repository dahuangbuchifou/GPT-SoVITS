# C9-13：Voice 002显示名改为dahuang，单句隔离CPU试声包交付

**日期：2026-11-15。状态：用户明确同意一次独立Voice 002 CPU/FP32单句TTS，并要求把Voice 002改名为`dahuang`。工具包已交付；用户Windows更名与真实TTS尚未验收。**

## 冻结身份与命名

- 保留长期内部ID `voice_002`，避免打断C9-09参考绑定、历史run、C9-10审核、C9-11基线及训练权重SHA。
- 仅将Voice Factory独立私有工厂台账`factory_catalog.local.json`中该草稿声音的`display_name`设为`dahuang`；不触碰Studio正在使用的声音注册库。改名前先备份、锁定台账并检验C9-09结构，原音频、权重、文件夹和voice_id不重命名。
- 当前模型仍为候选方向，未取得Voice Studio正式发布批准；此次更名仅为Factory元数据更改，不代表当前WebUI已经切换。

## 首次独立TTS的本轮执行许可

用户同意：仅专属GPT-SoVITS v2Pro的Voice 002权重配对、A03参考与准确转写、之前用于GSV_01的固定新文本，**一次**CPU/FP32真实独立推理、最多一条WAV、独立新实验目录、不训练、不使用GPU、不启动API、不调用或修改9880/9890，不自动重试。

此前C9-13单次CPU模型加载已由`C9_13_INDEPENDENT_CPU_LOAD_OK_NO_TTS`实机验证：双权重加载PASS、11.88秒、无CUDA初始化。这**不是新一条WAV实际生成通过**，本次须再以Windows新报告验收。

## 本轮交付包

`Dahuangs_C9_13_Dahuang_One_WAV_Independent_CPU_V1.zip`

**包SHA-256：`ffddb90ff3b4e7575809ae1c7b9835b29847c8cb2f07da0a247791ceff2a8403`**

解压后按顺序：

1. `01_Set_Dahuang_Display_Name.cmd`：只修改Factory私人台账中`voice_002.display_name`，有原始完整备份，支持幂等重复查看；成功`C9_13_DAHUANG_DISPLAY_RENAME_OK`或`C9_13_DAHUANG_DISPLAY_ALREADY_SET`。
2. `02_Check_Dahuang_One_WAV.cmd`：只读检查解释器路径、冻结源码SHA、GPT/SoVITS权重SHA、catalog→A03参考WAV SHA、独立模型加载成功回执、可用RAM不低于12GiB和一次性锁状态；成功`C9_13_DAHUANG_TTS_GATE_PASS_NO_MODEL_LOADED`。
3. `03_Run_Dahuang_One_WAV_Authorized.cmd`：再次做同样的检查，且必须人工输入`AUTHORIZE_C9_13_DAHUANG_ONE_CPU_WAV`才创建一次性锁并进入真正模型导入与`TTS.run()`。运行中固定CPU/FP32、关闭CUDA可见性、关闭Transformers在线下载、私有缓存、独立配置yaml、非流式单句输出。失败保持锁和原始错误，仅提供安全摘要，不允许自动重试。

生成一条WAV时，报告状态为`C9_13_DAHUANG_ONE_WAV_READY_HUMAN_REVIEW_REQUIRED`。其私有新run目录为`workspace/private_factory_registry/c9_13_dahuang_one_wav/run_*`，音频名称`DAHUANG_C9_13_01.wav`。安全摘要仅保存在`VoiceFactory/docs/C9_13_DAHUANG_TTS_RESULT_SAFE_*.json`，**不含原始WAV、绝对私有路径或完整测试文本**。生成完成后仍需人工试听，模型不自动发布。

程序只在`TTS_Config`和`TTS`中采用此前独立加载PASS时验证过的API，显式把`cfg.configs_path`设为隔离私人YAML，以避免官方loader把模型切换信息保存到既有生产`tts_infer.yaml`。该过程是独立进程但不是OS级完全文件系统沙箱，不能百分百保证第三方库没有其他附带文件写入。

## 验证覆盖和未验证项

- Python语法检查通过；
- 15项合成波形及mock模型安全断言通过：工厂草稿display更名/幂等、锁及备份、只读门禁、模型和A03参考SHA不一致阻断、授权口令错误阻断、单个WAV生成成功、旧run不可覆盖、失败后拒绝重试、分享报告不含原始参考及测试文本；
- 3个CMD文件ASCII+Windows CRLF；ZIP内文件SHA和压缩包完整性均验；
- **尚未在用户Windows真实运行，不能提前声称dahuang已更名成功或Voice Factory独立WAV已生成**。

**下一步**：取得用户本机`C9_13_DAHUANG_RENAME_SAFE_*.json`、`C9_13_DAHUANG_TTS_GATE_SAFE_*.json`及`C9_13_DAHUANG_TTS_RESULT_SAFE_*.json`，并由用户试听新WAV与插件GSV_01的差别；真实通过后再把两权重按SHA登记为Factory`candidate`模型、推进Studio开发版的多声音选择。麦克风/STT及远程访问方向继续暂停。没有训练或生产配置修改。

## Public GitHub安全边界

Public仓库仅保存该脱敏工程说明和主路线状态；不提交用户声音文件、权重、private台账、推理包源代码、访问密钥或生产服务配置。