# C9-12：Voice 002专属GPT-SoVITS两句WAV技术验收完成，进入C9-13独立运行准备

**日期：2026-11-15。状态：用户已在训练插件内生成两句新测试WAV，技术报告2/2有效；用户主观表示效果可以；Voice Factory脱离插件的单独加载尚未验证。**

## 最新上传证据

用户上传`C9_12_GSV_ACCEPTANCE_SAFE_20261115T135621Z_cf14751d.json`，原始上传JSON SHA-256：

`27994390ccd149ef15ec415be8669fa2931c6e38f1e6ea7bf213d75a830f0543`

状态：`TWO_WAVS_TECHNICALLY_VALID_HUMAN_LISTENING_REQUIRED`，两段均`WAV_PCM_OK`。格式均为32 kHz、16-bit、mono，无数字削顶：

|编号|时长|RMS|峰值|WAV SHA-256|
|---|---:|---:|---:|---|
|GSV_01|5.62 s|-27.28 dBFS|0.34811|`8b0a0ab0051f62b41d5212fd84e7cec9667807ca8126a8b057b7f7810ad5ad24`|
|GSV_02|5.30 s|-26.43 dBFS|0.32346|`7c45e939888c80055c4acf7fbee7d9f5750524833c19b94e4417984c6bcc713f`|

两权重SHA与现有绑定一致：
- SoVITS：`cee4cc6ea119ff06a0ad9b53c0661f9ce28ddfc178a1d6f63962b6181d15d1fd`
- GPT：`9fb91428501effaea21d4677173cbafbf03a17d50332771c0933d43022e00847`

该验收脚本**没有执行推理或训练**，且声明不能独立证明插件当时实际选择的权重、参考录音或文本。用户此前已确认插件内这对权重实际能生成WAV，且试听表示“效果可以”；但未给出每句1–5分及重音/错漏字细节，因此仅标记**初步主观认可 + 技术PCM验证通过**，不可写成双盲音质认证或生产发布。

此前上传的`WAV_TECHNICAL_REVIEW_REQUIRED`报告是音频保存前生成，不再用于代表当前状态。

## C9-13目标：独立运行与可复用模型登记

现在无需追加训练，也无需重复ZIP/CRC静态诊断。下一道目标并不是再次证明插件可以合成，而是：

1. 只读核查VoiceFactory新权重SHA、本机v2Pro源码的实际推理API入口、独立Python运行时和9880/9890/17861服务监听情况；
2. 核实独立进程如何加载专属GPT和SoVITS、是否需参考文本及外部BERT/CNHuBERT模型以及隔离GPU条件；不得直接重配置正在运行的生产服务；
3. 在后续**单独授权**与资源门禁下执行一次VoiceFactory独立进程TTS试验；
4. 成功后把Voice 002写入多声音模型注册库的`candidate`条目，保留回滚，不自动发布到实时Studio。

本轮新增只读环境清点包：`Dahuangs_C9_13_Voice002_Runtime_ReadOnly_Inventory_V1.zip`。SHA-256：
`fbcaa35473181dd8ea94a33751409f04695fa0cf2a00fcf219fb75db2e9bf11c`。

解压后运行`Run_C9_13_ReadOnly_Inventory.cmd`，检查两个权重SHA、源码入口文件/运行时存在性，以及本地已知端口是否监听。生成私有工作区`VoiceFactory/docs/C9_13_RUNTIME_INVENTORY_*.json`，可以回传。**该工具不加载Torch、不运行推理、训练、网络连接或生产操作**。ZIP与清单SHA/Windows CRLF编码完成离线验证，Windows用户实机结果尚未收到，不得将清点成功误写成独立加载成功。

模型权重、训练原音、WAV或私有运行记录没有上传Public仓库。GPT-SoVITS生产模型、OpenClaw/Gateway、9880/9890、已稳定Voice Studio均保持不变。麦克风/STT工作仍按用户决定暂停。
