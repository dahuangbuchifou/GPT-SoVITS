# C9-17/18 只读契约审计回执与 C9-16M 主线衔接（2026-11-17）

**证据状态：用户 Windows 实机运行只读审计，`AUDIT_COMPLETE`；仅通过静态/配置契约检查，不表示新增模型已可运行或 Studio 已完成切换。**

## 本次实机证据

证据文件（仅本地保留，不将原始报告上传 Public）：`contract_report_v2.json`

- 工具版本：`C9-17-18-v2.0`
- 报告生成时间：`2026-11-17T13:38:34Z`（UTC，按报告记录）
- 操作模式：`READ_ONLY_LOCAL_CONTRACT_AUDIT`
- 结果：`AUDIT_COMPLETE`
- 后端文件存在，Python 语法有效；读取本地 voice registry，缺失时允许回退 example registry；包含权限、引擎校验。
- Registry v1.0 本地有效，`demo_only=false`，共两个声音：
  - `waner`：`waner_gsv_stable` 为 `gpt_sovits / existing_production / realtime_existing / enabled=true`；`waner_lora150_research` 为研究候选、禁用。
  - `voice_002`（显示名 dahuang）：`voice_002_gsv_e15_s100` 为 `gpt_sovits / research / disabled / enabled=false`，在 Studio Registry 中未登记可执行授权。
- Studio DEV 本地端口 17861，配置为通过本机 9880 使用 GPT-SoVITS HTTP TTS；全局参考 ID/文件及 prompt 配置存在。
- 重要边界：后端请求未包含各模型权重路径；使用全局 TTS endpoint 和全局参考音频；`runtime_model_switch_authorized=false`；`candidate_registry_present=false`（指本轮工具自己的候选注册表，不应据此否定已有 Factory 私有 candidate）。
- `production_modified=false`。未进行模型加载、音频推理、独立工作器调用或生产端口控制。
- 主要警告：`REGISTRY_SELECTS_METADATA_ONLY_NOT_RUNTIME_WEIGHTS`。

**判定：C9-17/18 v2 只读契约审计的 Windows 实机门槛 PASS；候选导入、真实模型加载、声音身份与推理输出绑定、Studio 多声音路由均未据此获得 PASS。**

## 与已存在的权威路线图衔接

请继续以 [C9_MASTER_ROADMAP_V2_20261116.md](C9_MASTER_ROADMAP_V2_20261116.md) 为当前权威路线图，并以 [C9-16M M03 独立 CPU 子进程工作器记录](C9_16M_M03_WINDOWS_MOCK_PASS_REAL_SUBPROCESS_CODE_READY_20261116.md) 为技术前提，不把 C9-17/18 辅助审计当成新路线取代 M03/M04/M05。

已完成的事实包括：此前 M03 Windows mock 21/21 PASS，真实 CPU 子进程代码已做离线测试；补充 mock-only 35 项回归是非阻断附加证据。此前已有 VF-06 通用权重导入工具 V1 离线交付，后续应复用，不重复实现第二套实际导入机制。

下一实机门槛：优先使用已有 M03 包的 `00_OneClick_M03_Precheck_And_Subprocess_Mock.cmd`，仅执行只读预检与独立子进程数学音模拟；取得 Windows 回执后，再按原门禁决定是否申请新的一次性 dahuang CPU/FP32 真实合成授权。不得直接运行标记 `Z_DO_NOT_RUN_YET_LIVE_CPU_AFTER_SEPARATE_APPROVAL.cmd` 的入口。

之后 M04 才开发 Studio DEV-only 独立 dahuang 路由；婉儿仍使用既有路径。dahuang 失败不得回退冒充婉儿，也不得仅修改注册表的 enabled 状态绕过权限门禁。M05 必须检查音频 QC、队列/取消、资源隔离和回滚。

## 操作便利性与公开资料边界

用户确认后续优先采用“下载 ZIP → 解压 → 双击 CMD → 自动建目录/生成脱敏 JSON 回执 → 上传回执验收”的低操作负担方式，避免重复手动输入 PowerShell；第三个声音继续暂缓，远程访问及 STT 后置。

Public 仓库只放本脱敏摘要及证据索引；不上传原始报告中的私有绝对路径、私有配置、权重、录音、转写、聊天明文、令牌或可执行私有工作器代码。此文档只归档工程状态，不包含模型执行授权。

## 2026-11-17 M03 延续回执（补充）

用户 Windows 端后续上传三份脱敏报告（报告原件仅留本地，不提交 Public）：

- `C9_16M_M03_REISSUE_SAFE_20261117T140802Z.json`：重新制作的 **mock-only** 替代包，`M03_REISSUE_MOCK_ONLY_PASS`；独立子进程成功退出，合成数学测试音 3.0 秒、32kHz/16-bit 单声道、QC PASS。未运行真实模型、未验证原版完整门禁，不能等同原 M03 真实执行器。
- `M03_ASSET_SHA_SAFE_20261117T141238Z.json`：`M03_FROZEN_WEIGHT_PAIR_AND_CANDIDATE_PASS`；大黄 e15+s100 两份权重 SHA 与 C9-15 冻结值一致，Factory 私有候选证据存在，Studio 模型仍 research/disabled；未加载模型、未执行 TTS。
- `M03_SOURCE_A03_DISCOVERY_SAFE_20261117T143225Z.json`：`LOCAL_REFERENCE_AND_HISTORICAL_ENGINE_MATCH_NEEDS_FREEZE_APPROVAL`；A03 实际文件 SHA 与本地候选清单一致，发现引擎源码 SHA 与历史回执一致；**但 A03 尚未与独立冻结回执验证、引擎也未获独立冻结值确认，`original_m03_full_gate_pass=false`**。不得将“历史一致性”当作审批通过。

**后续范围**：上述证据补强了静态身份和离线隔离合同，未恢复或替代原 `Dahuangs_C9_16M_M03_Real_CPU_Subprocess_Worker_Gate_V1.zip` 的真实工作器代码。真实 CPU/FP32 TTS 仍需恢复/重新审核受信任执行器、冻结引擎与参考、取得新的单次明确许可。

## M04 离线路由合同首版（不部署）

本轮另制作 `Dahuangs_C9_16M_M04_Offline_Route_Contract_OneClick_V1.zip`，离线合成注册表下 17/17 合同测试通过（**非用户 Windows 实机验收**）。

- 仅读取现有 DEV 后端哈希与 Studio 本地注册表，规划（不调用）婉儿现有路由；
- 大黄即便被手工将 `enabled` 改为 true，仍因缺少 DEV 独立工作器执行许可被明确拒绝；
- 非法模型、声线串用、权限缺失被拒绝，不作婉儿回退冒名；
- 仅在 `tools/C9_M04_Route_Offline` 复制独立测试文件、写入 `artifacts/c9_multivoice/M04_ROUTE_OFFLINE_SAFE_*.json`；
- **不修改原后端、Studio Registry、生产或 DEV 运行服务**，不访问网络、API、模型，也不意味着 M04 实时切换完成。

下一步：用户 Windows 双击 `00_OneClick_M04_Offline_Route_Check.cmd`，回传脱敏 JSON 验证合同；并行推进 M03 真实工作器恢复/重新审核与独立执行许可，不再重复已经通过的 mock 或模型双权重校验。

## 2026-11-17 M04 Windows 离线路由合同验收与 DEV 候选补丁

用户 Windows 回执：`M04_ROUTE_OFFLINE_SAFE_20261117T143713Z.json`（私有原件不上传 Public）。

- `status=M04_OFFLINE_CONTRACT_PASS_NOT_DEPLOYED`，`test_count=17`、`test_passed=17`、无失败项。
- 后端仍与冻结的 C9-17/18 基线匹配；Registry 有效；`waner_plan_ok=true`，`dahuang_denied=true`，非法声线/模型组合被拒绝。
- 证据明确 `tts_called=false`、`model_loaded=false`、`route_patch_deployed=false`、`real_worker_installed=false`、`runtime_switch_authorized=false`；此结果**不是 Studio 双声线实际可执行切换**。

据此制作新的**M04 DEV 后端候选补丁生成包**：`Dahuangs_C9_16M_M04_Guarded_DEV_Backend_Stage_OneClick_V1.zip`。其一键入口：`00_OneClick_M04_Create_Guarded_DEV_Patch.cmd`。

- 仅当本机未修改 DEV 后端 SHA 与 research/disabled 的 Voice 002 Registry 均匹配时，从用户本机源码生成带强制身份隔离的 Python 后端**候选副本**，并保存到独立 `tools/C9_M04_DEV_Guarded_Staging`；原后端不被替换。
- 对 `voice_002` 请求，在访问全局婉儿 HTTP TTS 前执行硬拒绝；即便只修改 Registry 元数据为 enabled/approved，也仍不允许落入婉儿接口；独立工作器未安装时只返回明确错误。
- 18/18 项纯离线候选代码合同测试通过；本地临时根目录模拟了成功生成、重复运行幂等和后端 SHA 漂移阻断；ZIP CRC、成员 SHA、CMD CRLF 检查通过。**尚未在用户 Windows 上运行新包。**
- 此包**不包含**原 M03 真实子进程工作器，不启动任何模型/网络/端口，不修改运行中的 17861 服务或生产 9880/9890、OpenClaw，未赋予执行授权。
- M03 真正 CPU 独立 worker 仍需可审核的实现及单次真实试声许可；在此之前 M04 实际路由、M05 回归均保持待验。

本轮 ZIP SHA-256：`5567f14e773632495a180a76b0866b223994a7b040a06fc5d15bd62d6377fcc4`。只在私有用户会话交付 ZIP；Public 仓库继续仅保存本脱敏状态记录。
