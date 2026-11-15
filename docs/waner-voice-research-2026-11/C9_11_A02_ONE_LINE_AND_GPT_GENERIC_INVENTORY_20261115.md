# C9-11 A02单句对照与GPT-SoVITS通用预训练权重静态准备

**记录日期：2026-11-15。状态：执行包已完成离线模拟测试；A02真实Windows对照与GPT-SoVITS本机文件清点均待运行。**

## 本轮新的用户授权

用户明确要求“好，再来一条吧，另外GPT-SoVITS我也建议准备着”。项目将此次解释为**新增一次Voice 002 A02参考、IndexTTS 2.5 BASE CPU/FP32、仅原L1_01文本的一条零样本合成授权**，不能扩大为两句、训练、音色发布或GPT-SoVITS推理授权。初始A03两个WAV的旧授权已使用完毕，旧执行器及run目录不得重复使用/删除。

## 交付包

`Dahuangs_C9_11_A02_OneLine_Control_and_GPTSoVITS_Generic_Preflight_V1.zip`

SHA-256：
`55236239e9fe3e6d08c105e306348b350b1687579d887f387a3a3ea74912c1d8`

内有：
- `C9_11_Voice002_A02_OneLine_Control.py`
- `Run_C9_11_A02_Static_Check.cmd`（不加载模型）
- `Run_C9_11_A02_One_WAV_After_Approval.cmd`（需要交互式精确确认口令）
- `C9_11_GPTSoVITS_Generic_ReadOnly_Inventory.py`
- `Run_C9_11_GPT_Generic_ReadOnly_Inventory.cmd`（不加载模型）
- 文字说明、12项离线模拟检查脚本、逐文件SHA清单。

### A02试声对照的关键技术约束

1. 新执行器读取用户本机已有C9-09声音草稿、A03参考SHA与C9-10工作单（仍`PLAN_ONLY_NOT_EXECUTABLE`），另从C9-11早期私有13条批量质量报告验算`A02.wav`的SHA，确保属于同一录音批次。
2. 使用原第一次A03成功run的`RESULT_PRIVATE.json`及`L1_01.wav`，核对旧生成音频SHA、固定第一句中文文本SHA、`SEEDS[0]=2026111501`。新实验**只替换参考WAV**A03→A02，保持同一IndexTTS BASE冻结GPT/config/source身份、CPU/FP32和原generation参数（do_sample、top_k/p、temperature、beams、静音及其它项）。
3. 独立新run根目录：`VoiceFactory/workspace/private_factory_registry/c9_11_a02_control_runs/`。旧A03工单/音频/台账不写入、不覆盖。已有任何A02 run或新锁时停止；被中断后也不允许重跑。
4. 控制台二次要求`AUTHORIZE_C9_11_VOICE002_A02_ONE_BASE_CPU_WAV`；未满足则不能调用模型。GPU设备隐藏，基于此前C5/C7验证的原生CPU/FP32模型加载及严格BASE权重检查。
5. 成功仅生成一条`L1_01.wav`，可分享的脱敏结果写入`VoiceFactory/docs/C9_11_A02_CONTROL_SAFE_RESULT_*.json`。实际声音相似度是否提升仍须人耳试听，固定种子不保证完全控制随机性。
6. 原生运行失败时，保留现场run目录，不自动重试/重安装/覆盖。用户应只提交控制台错误码和脱敏报告，不上传原始WAV、私有工单或私人路径。

### GPT-SoVITS并行准备（非推理）

`Run_C9_11_GPT_Generic_ReadOnly_Inventory.cmd`使用既有冻结Python解释器运行**标准库只读清点**，限定检查用户本机GPT-SoVITS v2Pro-20250604安装树的`GPT_SoVITS/pretrained_models`中官方常见候选通用权重文件名、文件长度、SHA与推理入口是否存在。

- 清点程序不导入torch、不加载任何模型、不开WebUI、不发HTTP请求、不修改/重启生产9880/9890、OpenClaw、旧Studio和任何权重或配置。
- **通用文件存在不等于模型官方身份、权重兼容性、zero-shot支持或推理运行通过。** 报告会明确标记上游哈希/许可/版本未独立核对、模型运行未验证。
- 脱敏结果`VoiceFactory/docs/C9_11_GPT_GENERIC_INVENTORY_*.json`只列标准通用候选相对路径、大小、摘要和文件检查状态，不含原始声音、私有数据和密钥。
- 后续要做真实GPT-SoVITS Voice 002对照，仍须独立核实模型/版本/资源/隔离，并另行授权，绝不使用婉儿专属微调权重冒充通用预训练模型。

## 测试及当前局限

- Python两份代码语法检查通过；
- 使用**合成WAV、临时私有报告及伪造baseline元数据**进行12项离线检查，覆盖A02 SHA改动、旧A03合成结果改动、旧种子变化、重复原run/批量报告、参考采样率变化、执行/检查CMD隔离等；
- 3个CMD文件为ASCII+Windows CRLF；8个包内工作文件与manifest SHA一致，ZIP完整性通过；
- **未在用户Windows机器运行该包，不证明真实A02 Wav已生成**；静态模式也不证明上游库运行无一切副作用。
- `GPT-SoVITS`准备工作仅清点目录与预训练文件，不做实际对照或生产发布。

下一步用户可分别运行A02静态检查→获本轮限定批准的一次性A02试声→GPT-SoVITS只读清点，并回传两份脱敏JSON。用户此前要求暂停麦克风/STT和双向语音，此状态继续保持。