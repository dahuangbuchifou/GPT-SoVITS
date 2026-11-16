# C9-16M：dahuang候选模型开发版Studio禁用展示桥接包

**日期：2026-11-16。状态：C9-16M只读报告通过；开发版Studio只读展示桥接包已完成18项离线测试，尚未在用户Windows实机安装。**

## 1. 用户真实只读报告与现有系统

用户上传`C9_16M_STUDIO_READONLY_20261116T131526732063Z.json`：

- `status=C9_16M_STUDIO_READONLY_READY_FOR_BRIDGE_DESIGN`
- Factory：私有dahuang候选模型`voice_002_gsv_e15_s100`有效，Factory仍然research/disabled、manifest仍是candidate/not published，两权重SHA匹配。
- Studio：`registry_source=local`、`registry_version=1.0`、`total_voice_count=1`、`voice_002_present=false`；前后端、配置均存在，前端选择器及后端registry/TTS API存在，但尚无Factory bridge。
- 源码sha：后端 `39a7e48ee8f690fb1c0de7c8e1ffed304644112f21e5c6dc1de2858ca744b63c`，前端 `2b1ad1f4bf7fdb39cb0f87f52b1ad3c19ca462dc3de3f22115b77fd50a862302`。
- 报告确认只读、未加载模型、未TTS、未训练、未连接端口、生产注册表未修改。

**重要实现依据**：本机报告中的后端SHA与此前交付的C9-06后端文件逐字节匹配，前端SHA与C9-07前端文件逐字节匹配。已复核该实际代码：`Runtime.public()`枚举本地Studio registry的`voices`作为网页声线选择器数据；`Runtime.tts_request()`独立执行authorizations、`enabled`、`lifecycle`和execution tier拒绝门禁。故本阶段无需盲目覆写后端/前端文件。

## 2. 新交付包：只更新开发版局部registry的一个禁用条目

`Dahuangs_C9_16M_Dahuang_Dev_Studio_Disabled_Bridge_V1.zip`

ZIP SHA-256：`fdce1b09786612eedcc10e3b651594de568c3626f78f237fb416ada4d91821d4`

包包含：
- `C9_16M_Install_Disabled_Dahuang.py`：纯Python标准库入口；
- `01_Check_C9_16M_Dev_Studio.cmd`（预检查，不修改现有注册表）；
- `02_Install_C9_16M_Disabled_Dahuang.cmd`（再检查、精确口令授权、备份并且原子写入、自动验证）；
- `03_Verify_C9_16M_Dev_Studio.cmd`（只读复核）；
- `04_Rollback_C9_16M_Dev_Studio.cmd`（受控回滚，仅目标SHA一致可恢复原始字节）；
- `README_FIRST.txt`、`test_offline_contract.py`、`MANIFEST_SHA256.json`。

## 3. 安全数据映射和行为

- 唯一允许修改的现有文件是**开发版专用**`VoiceFactory/registry/voice_registry.local.json`，而不是Factory私有catalog、权重、生产注册表、现有前端/后端源码、生产网关或运行中的9880/9890。
- 将`voice_002`显示名`dahuang`追加为第二个Studio声音；模型ID `voice_002_gsv_e15_s100`，`engine=gpt_sovits`、`lifecycle=research`、`execution_tier=disabled`、`enabled=false`、`authorization_status=not_recorded_in_registry`。同时使用A03参考SHA和固定标识元数据，不复制音频/权重。
- 依照既有Studio API的前端选择器会展示`dahuang`，但其TTS按钮和聊天朗读必须禁用；既有后端的`/api/tts`和`/api/narrate`不授权此voice/model。**不能因为出现菜单项就把模型视为已可执行。**
- 不更改`registry_version`、`demo_only`、婉儿的原有voice/model配置、已有Studio默认音色；只追加一个disabled候选。
- 从Factory C9-15私有manifest、catalog和实际GPT/SoVITS/A03文件重新验证身份、SHA、candidate且不可执行标志；验证当前Studio前后端源SHA精确匹配已知文件版本，否则安全停止。
- 使用专用私有操作锁和注册表原始字节备份，事务式写入，保持成功时幂等、旧条目不变。回滚时仅允许注册表仍等于安装后SHA才恢复字节，拒绝覆盖后续第三方更改。
- 所有输出安全报告保存在`VoiceFactory/docs/C9_16M_UI_BRIDGE_SAFE_*.json`，不输出隐私路径、原声、密钥或原始转写；完整备份和事务回执保持在独立私有工作区，不上传Public。
- **这不是动态实时Factory同步桥，也不是新模型适配器**：只在开发版Studio显示一个已有candidate的静态安全快照。Dev Studio服务如已在运行，需仅重启开发版进程以重新加载本地registry；不能关闭与9880/9890同窗或共进程的生产服务。

## 4. 离线验证与实际局限

18项合成/Mock测试已通过，包括：
- 原婉儿注册条目及默认模型逐字段不变；
- 候选不可执行/无TTS权限，直接用与本机SHA匹配的历史后端`Runtime.tts_request`模拟请求得403；
- 新模型权重变更、参考hash变更、Factory候选被意外启用、Studio源SHA变更均阻断；
- 已存在未知voice_002、运行时改写原注册表、缺少精确安装口令的阻断；
- 精确原字节备份/回滚、重复安装幂等、报告脱敏。
- ZIP内manifest SHA、CRC校验、4个CMD的Windows CRLF验证通过。

**尚未在用户Windows上运行**，因此当前只声称交付完成，不声称开发版已显示第二个声音。用户回传最新安全JSON和开发版浏览器实际页面后，再验收C9-16M第一阶段；随后另行准备多模型CPU/GPU隔离TTS适配器和资源门禁，必须另获实际执行授权。

Public GitHub仅保留脱敏工程记录，不提交脚本源代码、私人注册表、WAV、权重、密码、API Key或模型服务配置。远程网页任务沿用原C9-16编号，不与C9-16M混淆。