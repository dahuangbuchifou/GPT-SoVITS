# C9-15本地候选注册完成，C9-16M Studio多声音桥接只读清点

**2026-11-16。状态：C9-15实机候选登记及复核通过；C9-16M只读检查工具完成离线测试但尚未在用户Windows实机执行；开发版Studio尚未启用dahuang。**

## 已确认的用户回执

用户提供的 `C9_15_CANDIDATE_SAFE_20261116T130823610212Z_fc7585.json`：
- `status=C9_15_CANDIDATE_REGISTERED_VERIFIED_NO_CHANGE`
- `voice_id=voice_002`，显示名 `dahuang`
- `model_id=voice_002_gsv_e15_s100`，`model_version=e15_s100`，`candidate_status=candidate`
- GPT SHA：`b60a10efe7b15bdde8c9e9f4dc04cfeaff3fd95235c8f68451f0baae00098a3b`
- SoVITS SHA：`50b616c16e57b7ea2c28bc22dc2a2dda7eb32bac2f1a1a7539758f836d58ee21`
- 独立测试WAV SHA：`70b94c28974b3c4b299f4851cc2214d2ec7953c5536ecf9654784c80df5e7f25`；技术时长5.90秒，用户像本人5/5、自然度5/5（仅一条试听）
- `catalog_v1_compatible=true`、`local_registration_present=true`
- `production_registry_modified=false`、`studio_published=false`、`catalog_execution_allowed=false`、`default_model_changed=false`、`model_loading=false`、`tts=false`、`training=false`

结论：Factory私有候选注册已通过，并未改变Studio/婉儿生产服务。原Factory `catalog.v1`生命周期为`research`、禁止执行；独立版本manifest为`candidate`。不得把`candidate`理解为生产approved。

## C9-16M：Studio多声音接入准备，避免阶段名冲突

早期路线图已用**C9-16**标注“安全远程网页/Cloudflare”，故本轮开发版多声音接入专用子编号改为**C9-16M**。原C9-16远程安全任务留待后续独立开展，不合并到本次工作。

C9-16M设计目标：**先在开发版Voice Studio只读显示工厂候选dahuang及旧婉儿声音，候选仍禁用TTS；然后通过明确授权、安全的独立本地模型适配服务和受控单句验证，才考虑启用声线选择，不热切换生产9880/9890。**

必须先核实当前本机Studio受多轮C9-02/03/04/05/06/07补丁影响后的实际代码与Registry，不能用最初C9-dev原型的文件直接覆盖当前版本。开发版原型中 `registry/voice_registry.local.json` 与工厂私有`factory_catalog.local.json`是**不同schema**；候选不能直接把Factory JSON当Studio registry使用。现有WebUI是否能正常渲染和切换，需要Windows实机检查，不能凭早期源码断言。

### 单键只读桥接检查包

包名：`Dahuangs_C9_16M_Studio_MultiVoice_ReadOnly_Inventory_V1.zip`

ZIP SHA-256：`755c920a16d24b70a37b373f19478f626d177dc823d8a4f7e5021193d3dd33e3`

执行入口：`Run_C9_16M_Studio_ReadOnly_Check.cmd`。只需解压双击，读取固定VoiceFactory路径中的：
- C9-15本地工厂catalog与`e15_s100`私有candidate manifest、两份已有权重（重新计算SHA）；
- 开发版Studio的后端Python、前端JS/HTML、`config/c9_studio_dev.local.json`（**只读取schema标识，不输出API endpoint/key**）；
- Studio`registry/voice_registry.local.json`（存在时优先）或演示example（只提取数量/候选voice标识/是否启用，不输出敏感内容）；
- 前后端源文件SHA与入口/声音选择器存在性。

只写脱敏报告`VoiceFactory/docs/C9_16M_STUDIO_READONLY_*.json`，报告不含私有本机路径、endpoint、录音/文本、密钥。程序仅标准库、不导入Torch，不加载权重、不执行TTS/训练、不连接网络端口，不修改Factory目录、Studio注册表或任何服务。

报告可能显示：
- `C9_16M_STUDIO_READONLY_READY_FOR_BRIDGE_DESIGN`
- `C9_16M_FACTORY_INTEGRITY_REVIEW_REQUIRED`
- `C9_16M_STUDIO_LAYOUT_REVIEW_REQUIRED`

上述结果只证明静态结构，为后续**独立模型注册表桥接设计**提供事实；不证明能实际切换运行引擎。

5项模拟/契约测试通过，涵盖缺少Studio、存在私人密钥但报告脱敏、Registry结构异常、拒绝符号链接权重、只读检测不修改既有源码。ZIP CRC/成员SHA、Python语法、CMD Windows CRLF完成验证。**Windows实机未运行，不提前声称成功。**

## 下一步

待用户回传C9-16M只读报告：若Factory与Studio结构都存在且安全，交付只修改**开发版**声线列表、强制候选disabled的最小补丁（先UI只读渲染）；任何真实dahuang模型服务启用需新授权、独立进程和明确的资源预算/回滚方案。麦克风/STT仍暂停。Public只存脱敏状态，不上传模型/音频/私有台账/密钥/执行代码。