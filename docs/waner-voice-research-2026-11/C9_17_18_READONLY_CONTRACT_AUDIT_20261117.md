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
