# C9-16M M02已完成；M03独立TTS适配器与Voice Factory模型导入V1合同

**2026-11-16，状态：M02用户实机只读进程快照已核对，无明显冲突；VF可复用模型导入工具已制作且20项离线测试通过；M03真实Studio适配器尚未开发/安装/授权执行。**

## 1. 用户的M02实机证据

安全报告`C9_16M_PROCESS_ISOLATION_SAFE_20261116T135100Z.json`：
- 17861开发版监听归`python.exe` PID 10584，父链含`powershell.exe` PID 1716 → `cmd.exe` PID 4812 → explorer；
- 9880/9890分别为`python.exe` PID 22440与1108，报告中两者父PID为25512；
- `dev_and_production_same_pid=false`、`shared_non_system_ancestor_pids=[]`；
- `Start_Studio_With_AI.cmd`、`Start_Studio_With_AI.ps1`、`启动Dahuangs_Studio_开发版.cmd`在浅层关键字检查中未包含生产端口引用或直接终止命令；
- `findings=[NO_OBVIOUS_CONFLICT_IN_SNAPSHOT_NOT_PROOF_OF_ISOLATION]`，报告强调进程快照不能证明Windows关闭CMD窗口的真实影响、可能漏掉间接启动关系；
- 未加载模型、TTS、连接网络或停止服务。

**结论仅限“未发现明显冲突”，并不授权关闭任何正在运行的窗口或重启生产。** 作为C9-16M下一步适配器设计的非阻断证据。

## 2. 新增的可复用模型导入协议VF-06 V1

用户希望以后提供GPT-SoVITS训练插件的`.ckpt/.pth`，尽可能一个CMD完成通用导入，避免重复编写类似C9-09到C9-15的专用代码。

交付：`Dahuangs_VF_GPTSoVITS_Reusable_Model_Import_V1.zip`，SHA-256：
`a580120c3ae2bcc2dd1c65068128f43efb42d1a17d73198f4ef9741db7c4fa78`。

运行入口：`01_Import_New_GPTSoVITS_Model.cmd`，本机冻结`v2Pro/runtime/python.exe`执行Python标准库交互向导。用户填：
- `voice_id`如`voice_003`、显示名、模型版本如`v1`；
- 一份新GPT`.ckpt`、一份SoVITS`.pth`。若放在`VoiceFactory/config/models`，仅输入文件名；否则可粘贴完整路径；
- 可选3–20秒、16-bit单声道PCM参考WAV与准确UTF-8转写TXT（缺少则标记为`needs_reference_and_or_transcript`）；
- 明确确认具备本地处理权利，显示SHA后要求二次输入`IMPORT`，才实际复制。

仅向独立私有入库区`workspace/private_factory_registry/model_intake/<voice_id>/<version>/`放入模型副本、可选参考与本地`intake_manifest.json`。模型SHA复制后复核；重用同版本相同SHA幂等，不同SHA或参考变化阻断。新版本以不同version命名，不覆盖旧资产。

回执仅`VoiceFactory/docs/VF_MODEL_IMPORT_SAFE_*.json`，不输出本地绝对私有路径、录音、转写或密钥。**导入状态`staged_unverified`，不是`candidate`、`approved`、Studio启用或生产部署**；本工具不更新Factory catalog.v1/Studio registry，不加载模型，不运行TTS/训练，不访问9880/9890或网络。将来候选登记仍需真实隔离试声+人工听评+独立批准。

20项离线临时文件合同测试通过：SHA复制、无catalog改写、重复幂等、版本冲突、被篡改权重/参考文本、目录软链、无授权、错误WAV/声道、目录锁、脱敏报告等。ZIP CRC/成员SHA一致，CMD ASCII/Windows CRLF检查通过；**用户Windows实机测试尚未发生**。原`dahuang`的e15_s100已是candidate，不必重新入库，也不要假冒第三个声音进行重复实验。

## 3. C9-16M M03适配器：固定接口与最小实现边界

目标：Voice Studio开发版为声线`voice_002`调用**单独的本地dahuang TTS工作器**，而婉儿仍调用旧授权路径；在新工作器成功完成质量/隔离验收前，dahuang依然`enabled=false`、无执行权限。**本合同不是允许运行模型的授权书。**

### M03接口（下一步实施）

- 请求字段：`request_id`、`voice_id`、`model_id`、`text`、`text_language=zh`、`reference_id`、`format=wav`。只接受精确白名单，文本长度、并发数量有限制。不要在普通日志中保存私聊明文。
- 仅允许经校验的本地Factory私有manifest中已核验的两权重路径、SHA、参考WAV和精确参考文本；不得允许客户端任意指定模型或路径、构造CMD、加载其他声线权重。
- 推理执行：独立子进程、固定`runtime/python.exe`与v2Pro引擎版本、CPU/FP32基线、独立YAML/TMP/HF/Gradio缓存、禁用CUDA可见性，不需要另开公网监听端口，不调用9880/9890换权重。单任务串行队列、超时及有界内存预算；C9-14上一条5.90秒WAV耗时32.67秒，因此不应承诺实时延迟。
- 结果：有效单个16-bit PCM WAV、SHA、时长、RMS/峰值、削顶、有声活动；不能像C9-13 V1那样把0.74秒/-62.84dBFS近静音错误上报READY。失败统一`invalid_audio`、`busy`、`timeout`、`model_hash_changed`等安全状态；不返回损坏WAV供播放。
- 授权：Factory `candidate`注册不自动赋予Studio执行；开发版声线注册表也不得仅靠修改前端按钮绕过后端。需要独立授权后才创建明确DEV-only执行许可及受控代码变更。
- 路由：婉儿原路径保持不变；dahuang失败必须向用户显示错误，**不能悄悄切到婉儿声音**，以免声音身份错乱。失败时保留旧服务可用。
- 测试：在未获得真实模型推理授权时先使用mock WAV和mock进程验证请求解析、权限拒绝、排队/取消等待、失败回滚和质量门禁；真实CPU一次性试声另行获准。M04再做Studio开发版前后端最小适配、M05做重复试声与回归。
- 安全停止：不能清除C9-13/C9-14旧一次性运行锁，不接触production 9880/9890/OpenClaw/Cloudflare，不改生产模型默认。

## 4. 近期共同确认的顺序

1. **M02完成**：本次进程快照无明显冲突，仍禁止盲目关闭CMD。
2. **VF-06 V1交付**：通用模型入库CMD完成离线测试，待真实第三声音模型到手再实机验收；现阶段不阻塞M03。
3. **M03启动开发**：先编码独立TTS工作器的受限请求/结果合同、模拟队列及WAV质量门禁；需获得一次性实际模型加载/合成授权后再验收真实服务。
4. **M04/M05**：Studio开发版路由、授权、回滚与声音质量；通过后再切到VF-05/07/08第三声音完整模块化演练。
5. Cloudflare远程与麦克风/STT继续后置/暂停。

公开GitHub只存此脱敏工程记录及总台账状态，不上传可执行源码、语音、权重、私人台账、API密钥或本机完整路径。
