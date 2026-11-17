# C9-16M M03：dahuang独立TTS适配器MOCK V1已开发并离线验收

**记录日期：2026-11-17。状态：M03受控请求/队列/WAV质量门禁的模拟工作器已完成真实代码交付并通过35项离线测试；用户Windows实机尚未运行。真实GPT-SoVITS推理、Studio路由、启用权限均未发生。**

## 用户最新方向

用户要求：继续推进当前双声音Studio接入，第三声音模型暂缓，不需为第三声音提前测试权重。多声音工厂V1可复用导入工具保留，等新模型到手再用，无需将现有dahuang数据冒充第三声音。

## 交付包

`Dahuangs_C9_16M_M03_Dahuang_Isolated_TTS_Adapter_Mock_V1.zip`

SHA-256：
`f5f8f64fa1677ee566f384ccb034f2ee2fdc7502384e8f186cec03e5b7a1f740`

文件包括：
- `Run_C9_16M_M03_OneClick_Mock.cmd`：Windows双击一次依次进行只读根目录检查、模拟合成与35项离线合同测试。
- `Check_C9_16M_M03_Only.cmd`：只读预检查和脱敏JSON；
- `Test_C9_16M_M03_Only.cmd`：仅运行35项mock合同测试；
- `M03_Dahuang_Adapter_Mock.py`：**不含真实TTS后端**的队列+权限+WAV质量实现，未导入Torch、未连接API或任何端口。
- `M03_INTERFACE_V1.json`：未来DEV Studio→dahuang worker请求协议固定字段与质量门槛。
- `test_m03_mock_contract.py`、`README_FIRST.txt`、`MANIFEST_SHA256.json`。

### 关键合同

仅接受请求字段`request_id`、`voice_id`、`model_id`、`text`、`text_language`、`reference_id`、`format`，拒绝未知字段、非法ID、任意路径/endpoint、错误声线或参考。版本身份固定：
`voice_002`/`voice_002_gsv_e15_s100`/`A03`；中文、WAV，文本最多300字符。当前**默认无模型执行授权**，仅在显式`mock_approval=True`的测试调用里执行合成测试音。

待处理队列容量1，模拟工作器单线程执行；拒绝重复请求、已满任务，允许取消**未运行**任务。当前mock超时是调用等待超时，**不能强杀正在运行的真实引擎**；未来必须改为可管理的独立子进程、明确超时终止策略。

WAV技术QC以标准库解析PCM（16-bit mono，允许特定常规采样率）；检查2–30秒、RMS不低于-42dBFS、峰值不低于0.03、有声活动>=0.5秒、削顶比例<1%；不合格返回`invalid_audio`，**不会写出被误认为合格的音频**。以前C9-13的0.74秒/-62.84dBFS失败案例已被模拟回归测试拒绝。

此模拟器只会在私有目录`workspace/private_factory_registry/c9_16m_m03_mock_only/mock_*`生成名为`MOCK_SYNTHETIC_TONE_NOT_A_VOICE_SAMPLE.wav`的正弦波，并在`VoiceFactory/docs/C9_16M_M03_MOCK_SAFE_*.json`生成无转写/密钥/本机私有路径的安全回执。**这不是真人声音、不能用来进行音质试听**。

## 离线验证

使用Python标准库在工作容器执行`python -m unittest -v test_m03_mock_contract.py`：**35/35通过**。覆盖严格输入白名单、固定声线、无授权拒绝、路径注入字段拒绝、近静音/纯静音/短音/错误WAV/多声道/削顶、队列满、重复ID、排队取消、异常脱敏、无执行与只读预检、模拟文件只写私有目录、Studio registry原样不变、报告不泄漏测试文本和完整路径。ZIP CRC与每成员SHA验证PASS；3个CMD采用ASCII和Windows CRLF；Python语法编译PASS。

**尚未在用户Windows实机运行，不能宣称已接入17861开发版或完成真实CPU TTS。** 真正TTS仍须另行限定授权（固定VOICE/版本/参考/文本、CPU/FP32、独立配置/缓存/进程、无9880/9890、无自动重试）；不得取消Factory candidate/Studio research disabled状态。

## 下一步实施

1. 用户双击`Run_C9_16M_M03_OneClick_Mock.cmd`，回传最新`C9_16M_M03_MOCK_SAFE_*.json`；只关注`C9_16M_M03_MOCK_CONTRACT_PASS_NO_REAL_TTS`及35项离线结果，不提交模拟WAV。
2. M03-Real：固定模型SHA/Factory候选元数据与受控可中止子进程，真实GPT-SoVITS接口仅对本地DEV验证开放，单次合成另行授权；达到真实WAV质量门槛。
3. M04：在开发版Studio注册单独dahuang后端路由，保留婉儿旧服务和双层授权；不能把候选研究状态自动升级生产。
4. M05：多次回归、崩溃/取消、源模型变化和回滚，再讨论DEV启用。
5. VF第三声音保持暂缓，原C9-16公网和STT都不加入当前工作。

Public GitHub只记录本脱敏研发证据，不上传可执行源码、权重、录音、私有Registry、API Key、音频、聊天文本或本机私人工作目录。