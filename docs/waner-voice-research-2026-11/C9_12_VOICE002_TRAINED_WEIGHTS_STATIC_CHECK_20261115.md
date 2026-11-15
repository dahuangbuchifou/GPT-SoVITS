# C9-12：Voice 002 专属 GPT-SoVITS 权重已训练完成，待独立加载与质量验收

**记录日期：2026-11-15。状态：用户已确认两份新训练权重来自同一批Voice 002的13段录音；文件大小与SHA已在用户Windows本机列出。此时尚未验证权重内部版本、完整加载、语音质量或继续训练能力。**

## 当前实机证据

用户展示在其独立 VoiceFactory 工作区下新建的两个模型文件：
- 一份SoVITS模型（.pth），约128.69 MiB；
- 一份GPT模型（.ckpt），约148.12 MiB。

用户明确确认二者均使用此前13条Voice 002录音进行训练，训练软件报告其为GPT-SoVITS v2Pro。两份文件的SHA-256在本地PowerShell成功计算，但**尚未对归档内部结构、配套模型版本、训练配置、精确数据切片与转写记录做独立检查**。扩展名、大小和训练器自述不能代替v2Pro加载实测。

当前决定：**优先验收已有的Voice 002专属模型，不再默认重做训练流程**。若两份权重确实兼容v2Pro，则进行与生产隔离的单次模型加载、限定两句试声和人工听评，并与已完成的IndexTTS 2.5 BASE A03/A02样本对照，再决定是否值得继续微调或进入Voice Studio声音库候选。没有新训练/推理的自动授权。

## 非执行静态权重检查包

- 包：`Dahuangs_C9_12_Voice002_Weights_Static_Check_V1.zip`
- SHA-256：`f54db29563327910148f96ba7388acb06e4c51b29870a77b38bbbc81ad5f6471`
- 双击：`Run_C9_12_Static_Model_Check.cmd`
- 输入：固定的独立VoiceFactory模型目录中用户新训练的.pth/.ckpt。
- 输出：`VoiceFactory/docs/C9_12_STATIC_MODEL_CHECK_*.json`，仅输出文件大小、SHA和安全扫描到的PyTorch ZIP元数据token/版本标记；**不包含原始模型内容、录音、密钥、训练集、私人路径**。
- 实现方式：Python标准库哈希+ZIP格式检查+对serialized `data.pkl`进行`pickletools`操作码扫描，**不使用pickle.load/torch.load，也不导入PyTorch、不联网、不加载模型、不运行推理或训练**。
- 测试：Python编译通过；模拟带config/weight/v2Pro标记的归档可识别；合法但未知的旧格式显示UNKNOWN而非执行；包含恶意pickle reduce的模拟归档在扫描中没有执行内容；ZIP结构和清单哈希通过。
- **仍未在用户Windows训练权重上实际运行该包**，故不能声称其结果已通过。

## 下一道门槛

如果静态报告能够找到两个文件，下一步在**与生产9880/9890、OpenClaw和现有婉儿GPT-SoVITS严格隔离**的进程中，验证v2Pro权重的真正版本及config形状匹配（只在确认文件来自受信任训练插件后考虑受控CPU加载）。之后另行限定授权进行Voice 002本地两句合成，优先测同一未见文本、音色相似、自然度、重音与生成资源；不得直接在生产服务切换权重。

不能只凭推理用权重判断一定可以准确“断点续训”：如果训练插件的export不包含优化器和训练状态，需要插件自己的resume机制。任何追加训练都单独请求用户许可。

原IndexTTS A02对照WAV虽已生成，主观评价尚未提供，保留为可选基线。

本次GitHub只记录脱敏状态，不提交.pth/.ckpt、音频、私有路径、个人身份或训练日志。