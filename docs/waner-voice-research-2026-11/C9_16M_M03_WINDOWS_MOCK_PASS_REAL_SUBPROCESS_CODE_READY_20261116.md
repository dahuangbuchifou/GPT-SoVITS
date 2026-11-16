# C9-16M M03：真实隔离CPU子进程执行器代码完成，Windows验收与实机推理待授权

**记录日期：2026-11-16。证据层级：M03上一版Mock已在用户Windows上运行PASS；本轮新增真实GPT-SoVITS子进程代码只在离线模拟测试通过，没有在用户Windows上调用真实模型。**

## 一、用户本次实机回执

`C9_16M_M03_MOCK_SAFE_20261116T143247Z_6f81e052.json`：
- `status=C9_16M_M03_MOCK_CONTRACT_PASS_NO_MODEL`；
- `test_count=21`、`test_passed=21`、`test_failed_names=[]`；
- `voice_id=voice_002`、`model_id=voice_002_gsv_e15_s100`；
- Factory和Studio候选仍均禁用、模型GPT/SoVITS SHA一致，开发版声线数量2；
- 明确`model_loaded=false`、`tts_executed=false`、`api_started=false`、`ports_contacted=false`、`production_files_modified=false`、`studio_files_modified=false`。

**结论：M03模拟合同的Windows实机验收PASS，但不是M03真实TTS适配器或Studio音频切换PASS。**

## 二、本轮新交付

包：`Dahuangs_C9_16M_M03_Real_CPU_Subprocess_Worker_Gate_V1.zip`。

SHA256：`bb488efd957da57e757910f70318c107d129a11ca8681d1ca2bd7859251c4b1c`

- **当前允许的一键入口**：`00_OneClick_M03_Precheck_And_Subprocess_Mock.cmd`。先只读验证冻结的v2Pro入口源码SHA、Python运行时、`voice_002`/dahuang`e15_s100`双权重、A03参考SHA、Factory私有candidate与Studio research/disabled状态、RAM快照≥12GiB、尚未发生本阶段真实一次性执行；再在临时目录新启动Python子进程生成数学模拟测试音，父进程检查其退出状态与WAV质控，不加载模型、不调用TTS、不使用GPU/网络/端口。
- **真正的独立CPU工作器代码已实现但未获新真实执行授权**：`M03_Real_CPU_Subprocess_Gate_V1.py`。预留`Z_DO_NOT_RUN_YET_LIVE_CPU_AFTER_SEPARATE_APPROVAL.cmd`，需要用户未来针对**这一轮**独立明确批准后才允许实机执行。固定e15+s100、A03、准确参考转写、固定GSV_02目标句，CPU/FP32、Transformers离线模式和私有TMP/HF/Torch/Gradio缓存及`tts_infer_private.yaml`，独立Python子进程一次性模型加载+最多一条WAV。禁止调用9880/9890、启动HTTP/API、训练、覆盖旧模型或自动重试。
- 控制逻辑：父进程独立等待最多300秒、超时只终止自身启动的子进程；单次尝试独立锁不覆盖C9-13/14历史锁；子进程私有日志、PCM32kHz/16bit/mono WAV严格质控（2–30秒、RMS ≥-42 dBFS、峰值≥0.03、至少0.5秒活动、削顶≤0.1%），后验模型/参考SHA，不合格必须返回FAIL而非READY；脱敏安全JSON写入Factory/docs。
- **不是**当前可调用的常驻API服务、也不是Studio路由补丁；没有将dahuang从research/disabled提升为执行态。已有内存队列合同测试通过，但真实跨请求服务队列仍未实现。

## 三、离线验证

- 新增15项单元/合同测试通过：正常独立进程模拟音通过、0.74秒近静音拦截、子进程非零退出、超时终止、一次性锁禁止重复、错误模型身份和权限门禁阻断、回执脱敏、已有21项mock合同复核；
- 原21项M03请求与WAV mock合同再次PASS；
- Python脚本编译通过、ZIP CRC与10个成员SHA一致、CMD ASCII/CRLF一致；
- **未在Windows实机运行新版**, 不能断言真正v2Pro子进程能够加载/合成、资源可靠性或延迟表现；
- 真实CPU合成涉及受信任用户本地训练权重，不属于OS级沙箱；CPU资源仍可能影响其他运行服务。将来需要另行授权及本机试声验收。

## 四、下一门槛

1. 用户解压新包并只运行`00_OneClick_M03_Precheck_And_Subprocess_Mock.cmd`，回传最新两份`C9_16M_M03_CPU_SAFE_*.json`，确认Windows实机新父子进程与本地模型门禁。
2. 若通过，取得**新的单次Voice 002/dahuang CPU/FP32独立GSV_02语音合成执行授权**，然后才运行真实入口；不启动Studio路由、不触碰婉儿生产。
3. 实际TTS通过且用户试听认可后再实施M04 Studio开发版双声线路由与最小的DEV-only执行许可，并做M05回归；不得仅靠更改前端标志绕过原有权限控制。

GitHub Public仓库仅归档脱敏工程状态，不上传可执行代码、模型权重、音频、私有台账或密钥。