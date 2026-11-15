# C9-12 Voice 002 权重静态检查：SoVITS ZIP异常需进一步定性

**日期：2026-11-15。状态：原模型文件存在且SHA记录完成；v2Pro兼容及实际加载尚未验证。**

## 用户提供的只读检查报告

`C9_12_STATIC_MODEL_CHECK_20261115T110756Z.json` 上传文件本身SHA256：
`291fba9c7ca5093a6b3581ff2d202e6b45405e5c08d26c0e710c6b7fbc1e10a2`

- GPT候选 `dahuang-e10.ckpt`，155,312,438 bytes，SHA256：`9fb91428501effaea21d4677173cbafbf03a17d50332771c0933d43022e00847`。ZIP归档可读，`data.pkl` 中出现config/weight键标记；内部v2Pro版本未证明。
- SoVITS候选 `dahuang_e8_s200.pth`，134,945,589 bytes，SHA256：`cee4cc6ea119ff06a0ad9b53c0661f9ce28ddfc178a1d6f63962b6181d15d1fd`。ZIP格式检测通过，但读取其中 `data.pkl` 时，上一版检查器只记录`ARCHIVE_INSPECTION_ERROR_BadZipFile`，且没有区分CRC、ZIP成员局部头及压缩数据问题。
- `structural_headers_detected=false`、`v2pro_runtime_compatibility_verified=false`、`full_state_dict_loaded=false`。
- `no_model_inference_or_training_invoked=true`、`production_files_modified_by_checker=false`。

**不得把`BadZipFile`直接解释为模型损坏。** PyTorch官方文档指出关闭保存时CRC32计算可能使Python ZIP解包报错，而`torch.load`仍可能成功；不过本机尚未证明就是这个原因，也不能据此跳过完整性检查或直接加载生产系统。

参考：https://docs.pytorch.org/docs/stable/notes/serialization/ （PyTorch序列化说明、set_crc32_options）。

## 新的无执行专项诊断

交付包 `Dahuangs_C9_12_Archive_CRC_Diagnostic_V2.zip`，SHA256：
`d4f5808858cb645efc2c2f331476e6fd098ae892311ff9403bb57da9923cd960`。

解压后运行 `Run_C9_12_Archive_CRC_Diagnosis.cmd`。固定读取已记录的两份Voice 002权重，先复核文件SHA，再检查ZIP目录、`data.pkl`、ZIP读取阶段错误类型和CRC32；仅当归档数据存储方式允许时，从本地ZIP成员原始位置读取序列化操作码作**非执行性诊断**。不会调用`torch.load`、`pickle.load`、模型推理、训练或网络，不修改文件。

安全报告 `VoiceFactory/docs/C9_12_ARCHIVE_CRC_DIAG_*.json` 只包含两份权重的SHA/体积、数据完整性分类和是否检出config/weight等字段，不包含录音、音频转写、私人路径、密钥或二进制数据。

离线测试：正常ZIP归档、CRC元数据破坏、SHA变化、缺失文件、ZIP尾部截断五类场景通过。ZIP结构、文件SHA清单与CMD Windows CRLF已验证。Windows真实模型检查**尚未执行**。

### 后续门槛

1. 优先确认是否仅`data.pkl` CRC不一致；如是，则进入另行批准的隔离信任环境、`weights_only=True`和`map_location='cpu'`载入验证，并核查张量结构与v2Pro推理代码，注意部分旧权重格式可能需要额外安全评估，不自动切换`weights_only=False`。
2. 如果ZIP目录/数据结构确实损坏，再考虑在用户已有训练插件中安全重新导出，**不能未经确认要求重训**。
3. 不自动导入生产9880/9890、Gateway、OpenClaw或Voice Studio；无新的训练或TTS执行授权。

本次Public GitHub只归档脱敏分析与检查方案，不上传任何.pth/.ckpt或程序代码。