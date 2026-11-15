# C9-11：IndexTTS 2.5 BASE静态门禁通过与一次性试声执行包就绪

**记录日期：2026-11-15；状态：只读静态门禁通过，执行器仅完成离线模拟测试；尚未真实运行推理，需用户明确、独立、限定范围授权。**

## 1. 本机静态核验

收到用户的`C9_11_BASE_PREFLIGHT_20261115T035735_4618edc7.json`及终端截图。

- 报告SHA-256：`8060913374d050232c02a9d3a0fe40ffc6194e2da9c63926b584766f94fd30e9`。
- `result=BASE_PREFLIGHT_PASS_NO_INFERENCE`，`blockers=[]`。
- Base GPT权重、config SHA匹配，源码commit、依赖包版本、codec文件存在性、A03参考SHA及L1工单均通过静态检查。
- 可用RAM快照17.97GiB；工作盘空闲约2417.78GiB。不能由静态快照推出推理过程中不会发生RAM竞争。
- `inference_authorized=false`，`training_authorized=false`，`cpu_only_runtime_to_be_verified_at_execution=true`；该回执**不是实际运行许可**。

## 2. 分离的受控试声执行包

生成`Dahuangs_C9_11_Voice002_IndexTTS_BASE_Pilot_Ready_V1.zip`

ZIP SHA-256：
`b70c75d9fc76cbae9f9188458daf832fb58924adbe584c5cb8acbbf9f0ba3ed1`

内部包含：
- `Check_C9_11_Pilot_Only.cmd`：再次执行静态验证，**不导入Torch、不加载模型**。
- `Run_C9_11_Pilot_After_Approval.cmd`：与预检完全分离，必须在另行获得用户的**明确一次性推理授权**后才能使用，且控制台要求输入`AUTHORIZE_C9_11_TWO_BASE_CPU_WAVS`。
- `C9_11_IndexTTS_BASE_TwoLine_Pilot.py`：复用C5/C7成功验证过的原生IndexTTS2 CPU/FP32模型构造和生成合同。
- `test_pilot_mock.py`：纯模拟验证，不使用真实Torch模型或用户录音。
- `README_FIRST.txt`、`MANIFEST_SHA256.json`：范围说明和逐文件摘要。

**不可突破的范围**：
1. 仅`voice_002`、原始A03 WAV、本机已验证的IndexTTS 2.5 **通用BASE** GPT权重与原始config（不是婉儿LoRA150或专属GPT-SoVITS）。
2. 最多一次进程运行、固定2条中文短测试文本、固定2个种子、CPU/float32、2线程，无训练/反向传播、不自动重试。
3. 逐次复验工单状态、克隆用途本机确认、A03 SHA、私人准入报告SHA、工厂台账绑定和禁用执行标记、BASE及配置SHA、git commit、Python依赖版本、内存与磁盘门槛。
4. GPU可见性设置为`-1`、运行时验证无CUDA初始化、所有相关模型模块保持CPU/FP32；缓存和临时文件被限制在独立实验run目录，不重写原录音、模型权重或生产代码。
5. 私有WAV及内部执行回执仅写入`workspace/private_factory_registry/c9_11_l1_runs`新建的唯一目录，可分享脱敏报告仅写到`docs/C9_11_PILOT_SAFE_RESULT_*.json`。
6. 运行异常或人工停止时保留原有run记录，不重新执行、不覆盖任何结果；如果有任一已有run目录或者lock就拒绝再次启动，需要人工复核。
7. 不调用GPT-SoVITS生产Gateway/9880/9890、不修改OpenClaw/Cloudflare/原Studio V1.4，也不复制音频至Public GitHub。

## 3. 测试证据与限制

- 19项纯模拟/合成波形安全测试通过：无授权拒绝、普通预检不加载模型、两项模型/配置SHA变化、参考SHA改变、私有准入变化、工单执行标记变化、使用授权/质量告警缺失、工厂台账路径/执行权限变化、内存不足、GPU环境暴露、重复工单、已有run和锁保护、WAV完整性检查。
- Python语法检查通过；6个ZIP成员完整，清单SHA核对通过；CMD使用ASCII+CRLF。
- **实际Windows进程启动、IndexTTS BASE模型加载、两条真实语音生成及听感均未验证**。不能声称执行器在Windows已运行成功，也不能宣称消除第三方模型依赖库所有潜在IO行为。
- 此执行包只交付给用户下载，不上传Public Git仓库；Public只保留脱敏技术记录和阶段状态。

## 4. 下一道门槛

下一步须用户明确确认同意：**仅在自己电脑、仅Voice 002的A03录音、IndexTTS 2.5 BASE通用模型、CPU/FP32、一次性两句话零样本推理，生成两条本地WAV，不训练、不替换生产模型**。用户确认后方可运行真正推理启动器；运行过程中如资源或身份检查失败，应停止并检查错误报告，不自动重试。

参阅[主台账](C9_MASTER_ROADMAP_AND_UX_BACKLOG_V1.md)及[静态门禁设计](C9_11_BASE_CPU_PREFLIGHT_AND_L1_WORKORDER_2026-11-15.md)。麦克风/STT仍按用户决定暂停。
