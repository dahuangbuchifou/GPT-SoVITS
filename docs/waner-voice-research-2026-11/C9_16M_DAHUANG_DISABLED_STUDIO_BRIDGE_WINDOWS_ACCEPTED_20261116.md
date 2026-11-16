# C9-16M：dahuang开发版声音库禁用候选桥接实机通过

**2026-11-16。用户本机实机回执与网页截图确认第一阶段PASS。**

## 事实依据

报告 `C9_16M_UI_BRIDGE_SAFE_VERIFY_20261116T132943_0fbc104d.json`：
- `status=C9_16M_STUDIO_DAHUANG_VISIBLE_DISABLED_VERIFIED`；
- `voice_id=voice_002`、`display_name=dahuang`、`candidate_id=voice_002_gsv_e15_s100`；
- Studio voice数由1升至2，候选可见、不可执行；
- `studio_default_unchanged=true`、`production_registry_modified=false`、`backend_frontend_files_modified=false`；
- `models_loaded=false`、`tts_invoked=false`、`training_invoked=false`、`api_server_started=false`、`network_calls=false`；
- `voice_002_authorized=false`、`tts_route_guarded=true`、`models_enabled_for_dahuang=0`。

用户的 `http://127.0.0.1:17861` 开发版浏览器截图中“声音模型库”真实显示婉儿与dahuang两张声线卡，dahuang标签为GPT-SoVITS研究版未启用，且界面说明仅展示Voice Registry元数据。这是**实际网页显示成功的直接证据**，而不只是JSON自报。

用户截图标出了 `Start_Studio_With_AI.cmd` 文件；该文件**可能是**当前Studio启动入口，但没有检查启动脚本内容或Windows进程树，所以不能据截图断言它确实拥有17861端口或与生产服务相互独立。当前页面已经工作，无需盲目重启；如确需重启，先确认该启动CMD及子进程与9880/9890的隔离，避免用户此前关闭窗口时连带停止生产实例。

## 已完成与未完成

**完成：** dahuang e15_s100 Factory私有candidate模型登记、禁用状态Studio开发版声音库展示、婉儿原条目保留、默认/生产配置不变（由工具报告声明）。

**未完成：** dahuang在Studio开发版实际TTS路由、多声音运行进程/资源调度、模型加载互斥/延迟与回滚、生产发布。候选仍禁用，不允许通过现有生产9880/9890热切换或绕过执行权限。

## 下一步：C9-16M 第二阶段

先确认Studio启动方式及当前配置的开发版隔离边界，继续以**独立dahuang TTS适配器**为目标：
- 保留Factory candidate和Studio registry两层权限门禁；
- 使用独立进程及独立配置/缓存，不影响婉儿生产GPU；
- 明确GPU/CPU资源预算、串行单次TTS、失败回滚、有效WAV QC；
- 将dahuang在开发版界面的“禁用展示”与“经过授权可用的TTS”分阶段推进，新的执行许可须另行明确。

麦克风/STT、远程安全访问仍独立暂停/规划。GitHub Public只保存脱敏技术记录；不上传任何原声、权重、私有registry、密钥或启动脚本。