# C9-13：dahuang独立单句推理产生近乎静音短WAV，旧执行器错误判定成功

**日期：2026-11-15。状态：dahuang显示更名成功；独立模型加载通过；第一次独立单句真实TTS输出无效，须停止重试并修复验收门禁。**

## 用户实机证据

用户上传两份最新JSON与文件截图：
- `C9_13_DAHUANG_RENAME_SAFE_20261115T144326453746Z.json`：`voice_id=voice_002`，`display_name=dahuang`，`only_private_factory_catalog_changed=true`，`production_registry_untouched=true`。
- `C9_13_DAHUANG_TTS_RESULT_SAFE_20261115T144429521226Z.json`：`status=C9_13_DAHUANG_ONE_WAV_READY_HUMAN_REVIEW_REQUIRED`，但实际WAV`output_duration_s=0.74`、`output_rms_dbfs=-62.84`、`output_peak_normalized=0.00403`、`output_sample_rate_hz=32000`；user playback reports no audible voice and Windows Explorer may not show duration. `output_sha256=d0033aca9d66831cce7f4b814a660ec27291db404592941a91381b53732f10a3`。报告称模型SHA匹配、CPU/FP32、CUDA未初始化、训练/API均未运行，推理耗时25.8秒。
- 文件截图见新run文件`DAHUANG_C9_13_01.wav`，约47 KB，符合0.74s 32kHz 16-bit mono的短片；不应说“没有WAV”，而是“已写出但音质不合格”。

此前插件内用同一组专属权重合成的新WAV技术有效：`GSV_01` 5.62s、`GSV_02` 5.30s，且用户主观满意，独立**模型加载**也已实机通过。因此没有充分证据推断训练权重已经坏掉或需要重训。

## 对已交付V1包的源码审查：已确认验收漏洞

直接检查此前交付`Dahuangs_C9_13_Dahuang_One_WAV_Independent_CPU_V1.zip`中的`C9_13_Dahuang_Alias_And_One_WAV.py`：

- `model.run(request)`返回第一个`(sample_rate, audio)`后写入WAV，接着尝试再次`next(seq)`确认**没有第二个音频块**，因此没有观察到“仅取第一块、丢掉后续块”问题（但真实上游返回状态仍需日志）。
- 脚本使用固定`seed=2026111501`，`text_split_method=cut0`，`parallel_infer=False`，`top_k=15`、`top_p=1`、`temperature=1`；这些不一定与训练插件内成功的推理设置一致，**不能将静音原因确定归咎于任意单一参数**。
- 验收条件过宽：仅要求`0.3 <= sec <= 60`、`fullpeak != 0`且int16域`rms>=5`，因此**0.74s/-62.84dBFS几乎静音WAV可被错误归类为READY**。既有15项离线mock测试只用正常的2秒合成WAV，没有覆盖此低能量短音频边界。此处是确定存在的程序质量门禁缺陷。
- WAV写入使用Python标准库16-bit PCM，报告`32kHz`时长`0.74`足以说明文件已有有效时长信息；资源管理器不显示时长并不能独立证明文件缺失元数据。
- 参考`A03.wav`和参考逐字文本仍需同成功插件界面实际设置核对。已知插件此前曾有`TEMP/gradio`只读文件问题，**本次静音并非同一报错**；无需反复清理缓存。

## 决策及后续最小修复

1. **本轮独立合成质量判定FAIL**；不变的是`voice_002`/dahuang显示名和双权重独立加载PASS。不要因旧报告字符串READY而宣布独立TTS通过或开始Studio注册。
2. 禁止再次运行V1单次授权CMD；保留`ONE_SHOT_ATTEMPTED.lock`和该失败WAV、私人执行报告。不要删除锁/覆盖旧run或重训练。
3. 在不调用任何模型的前提下对照**插件已成功生成GSV_01的完整配置**（模型双权重、A03参考/精确转写、文本处理与语言模式、推理seed、top_k/p/temperature、并行推理/切句参数），判断与V1执行器有无差异。尤其排查固定种子/文本分割/参考文本错误引发的过短mute音频；目前只列候选，不作确诊。
4. 新执行器V2必须增强结果门禁：非空且非静音、合理语音时长（此句的基线约5.62秒，但模型变化时不能简单锁死绝对时长）、有效音强/RMS、峰值、WAV PCM可解码、SHA复核；若质量不足标记`C9_13_DAHUANG_TTS_INVALID_AUDIO_REVIEW_REQUIRED`并返回非零退出码，不要再报READY。应增加模拟0.74s/-62.84dBFS静音用例。
5. **如需再次合成，必须取得新的单句限定授权并创建独立新run根目录**，绝不能绕过/删除旧锁。优先修复验收与配置一致性后只新增1条，不自动重试、不训练、不修改9880/9890。
6. Public仓库仅记载脱敏失败事实与修复验收要求，不上传音频/训练源/私有路径/权重/API密钥或自动执行脚本。

下一步最有价值的输入：用户在训练插件中曾成功合成GSV_01时的推理参数截图或文字参数。若无现成截图，可让用户只读检查该插件的历史配置，不要求重新生成声音。