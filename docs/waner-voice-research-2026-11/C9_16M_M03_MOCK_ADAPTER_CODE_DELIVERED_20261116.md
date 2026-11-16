# C9-16M M03 独立TTS适配器模拟合同 V1 已完成（未接入真实推理）

**2026-11-16。状态：可运行的离线Mock适配器、任务队列、严格WAV质控及当前私有候选门禁代码完成；Windows用户尚未运行。真实TTS、Studio后端路由与dahuang执行许可仍未实现/授权。**

## 来自既有项目的事实

- C9-15 `voice_002 / dahuang`的`e15_s100` GPT-SoVITS v2Pro模型已完成私有非执行candidate登记，GPT SHA `b60a10efe7b15bdde8c9e9f4dc04cfeaff3fd95235c8f68451f0baae00098a3b`，SoVITS SHA `50b616c16e57b7ea2c28bc22dc2a2dda7eb32bac2f1a1a7539758f836d58ee21`。
- C9-14独立CPU单句真实合成5.90秒WAV技术质量PASS，用户对声音相似度/自然度均评分5/5；但历史C9-13旧模型组合独立单句曾返回0.74秒/-62.84dBFS近静音。
- C9-16M开发版Studio 17861已显示Wan'er与dahuang，但dahuang仍`research / disabled`；当前后端`Runtime.tts_request`只允许经授权、enabled、production/approved lifecycle、realtime_existing tier的模型走原GPT-SoVITS HTTP API。**不能仅通过修改前端或registry标志绕过此边界。**
- M02进程只读快照未发现17861与9880/9890明显同PID/祖先冲突，但不证明关闭任何CMD窗口绝对安全。

## 本轮实际代码交付

包：`Dahuangs_C9_16M_M03_Independent_TTS_Mock_Contract_V1.zip`

ZIP SHA-256：`397183340747f24787f6046fe12799bb862ce45096f207db8966bb30be349cf3`

主入口：`Run_C9_16M_M03_Mock_Only.cmd`。使用已安装GPT-SoVITS v2Pro `runtime/python.exe`的Python标准库，在运行Mock测试前**只读**核对：
1. Factory catalog的`voice_002`仍为`draft`，`e15_s100`记录`research/disabled/catalog_can_execute=false`；
2. Factory私有candidate manifest仍为candidate/not-executable，冻结的GPT/SoVITS两权重实际SHA完全一致；
3. A03原始参考WAV文件SHA与Factory和candidate manifest一致；
4. Studio本地registry中dahuang仍`research/disabled/enabled=false`，未获审批；婉儿记录存在。

Mock代码完成：
- 严格请求白名单：仅`request_id`、`voice_id=voice_002`、`model_id=voice_002_gsv_e15_s100`、`reference_id=voice_002_ref01`、`text`(1–160字符)、`text_language=zh`、`format=wav`；
- 不允许任意模型路径或其他请求字段，拒绝重复任务；内存级单任务队列（最多等待1个）、取消未开始任务；
- WAV PCM32kHz/16bit/mono检查：2–30秒，RMS >= -42dBFS、peak >=0.03、>=0.5秒有声活动、削顶<=0.1%；历史近静音/极短故障被可靠拒绝；
- 合成测试用**临时数学正弦音**，完成后删除。测试音绝非语音，也不属于模型推理成功；
- 生成脱敏`VoiceFactory/docs/C9_16M_M03_MOCK_SAFE_*.json`回执，不含参考原声、权重、私有路径/转写/密钥。

验证：**21项独立Mock合同测试PASS**，另3项构造私有Factory/Studio目录合成场景PASS（正常通过、Studio意外enabled阻断、A03篡改阻断）；Python编译通过，ZIP成员SHA与CRC通过，CMD ASCII/CRLF验证通过。**尚未在用户真实Windows上运行**，不能把本轮称作M03完整TTS适配器完成或Studio可直接合成dahuang声音。

安全边界：不导入torch，不加载模型、不执行TTS、不启动API/监听端口/网络、不修改Factory/Studio台账、不碰生产9880/9890、不训练。实际运行仅写一份安全回执；不用管理员权限、不需要停止Studio。

## 下一步真实实现门槛

1. 用户Windows运行Mock并回传PASS安全报告。
2. M03下一小版本将封装真实GPT-SoVITS独立子进程：固定已验收权重/A03/参考文字、独立YAML/TMP/HF缓存、CPU/FP32优先，单请求异步队列与超时/资源控制、无效WAV拒绝、失败回滚；禁止直接调用9880/9890或切换婉儿权重。
3. **实际模型加载/合成仍须新的明确限定授权**；真实工作器通过后，M04才讨论更新开发版后端路由和第二声线执行许可，不把Factory candidate/Studio禁用展示当成授权。
4. 通用GPT-SoVITS新模型导入V1已另行交付：今后统一`.pth + .ckpt`入库为`staged_unverified`，真实质量验收、candidate注册与执行仍为后续标准化模块。

Public GitHub只存此脱敏工程记录与台账更新，不上传可执行ZIP/原声/模型/私有JSON/密钥。