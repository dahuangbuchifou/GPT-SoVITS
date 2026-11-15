# C9-11 第二声音 IndexTTS BASE CPU 推理前只读核验

**日期：2026-11-15；状态：L1非执行工单已在Windows实机生成并提交安全摘要；BASE模型/资源只读门禁工具完成离线验证，Windows实机检查待执行。**

## 用户最新安全工单证据

用户上传 `C9_10_L1_SAFE_PLAN_20261115T034618_489490_d03a04b1.json`。SHA-256：
`58bd8868928ca24c00cd9e00f7b7b4f4140d0a4c617894fecd00def1c0b9ffe3`

检查内容：
- `private_workorder_created=true`；1个声音、1条参考绑定；SHA通过；
- 计划引擎族 `indextts25`；2条试声文本；1个质量提示已按用户确认；
- `all_engines_disabled=true`，`model_inference_or_training_invoked=false`，`production_files_modified=false`；
- 下一门槛明确是 `VERIFY_BASE_MODEL_AND_RESOURCE_BEFORE_SEPARATE_INFERENCE_AUTHORIZATION`。
- 用户在本机确认了本地克隆试验的许可和人工听验，但这些是用户自述，不替代独立的录制者授权文件；**不是实际推理或训练许可**。

## 只读BASE CPU预检交付

包名 `Dahuangs_C9_11_IndexTTS_BASE_ReadOnly_Preflight_V1.zip`，最终包SHA-256：
`8ebcaaf2661e817d3de329b6e9a348ffeb6f255a0067a34bda7af813aa737638`

**不安装到VoiceFactory**；下载并解压任何临时目录，双击 `Run_C9_11_BASE_ReadOnly_Preflight.cmd` 即可。其Python脚本只使用标准库，读取既有固定目录下的BASE权重、源文件、冻结虚拟环境和L1私人工单；只写一份脱敏JSON到 `VoiceFactory/docs/C9_11_BASE_PREFLIGHT_*.json`。不改变私有工单。

与C5已有CPU成功路径对齐的冻结基线：
- 源码 `E:\E01\VoiceEngine\IndexTTS`，commit `d9e41aac89fd00b3d71497fddb287b7f24613712`；
- 既有推理解释器 `E:\E01\VoiceEngine\IndexTTS\.venv\Scripts\python.exe`；
- IndexTTS 2.5 BASE `E:\E01\VoiceEngine\_models\IndexTTS-2.5\gpt.pth`，SHA `43a8f4c30eccdf201958d3b9713511482c19d56dc20b0b1c4ee1e6b080b19d85`；
- `config.yaml` SHA `18adf417be3e8f5e2e48e30f7420c719170a6870619436250f360d626877870e`；
- `codec.pth`存在性（未在此次工具中证明内容SHA），推理源码存在性，历史环境的11项Python包版本匹配；
- 从用户本机最新voice_002 L1私有工单读取A03参考WAV，并重新验算其SHA；要求工作单仍处于`PLAN_ONLY_NOT_EXECUTABLE`，测试文本恰为两条且未授权推理/训练；
- 检查静态可用RAM不少于16GiB、项目磁盘剩余不少于2GiB。

执行进程中不导入PyTorch、不加载BASE模型、不使用CUDA，不尝试CPU推理，不修改环境，不连接网络，不触碰生产服务。9项模拟测试通过：正常静态门禁、参考音频哈希改变、BASE检查点/配置改变、非法工单执行标志、内存不足、依赖环境不匹配、Git不可验证、脱敏报告不泄露路径。ZIP完整性/内容SHA、Windows CMD ASCII+CRLF验证通过。

**注意**：静态PASS只表示冻结BASE模型身份、当前部分环境资源快照满足已核对项目条件，不能证明运行时CUDA隔离、完整模型参数加载成功或生成音质。任何FAIL只报阻断项，**不自动关闭生产进程、修复环境、下载权重或重训**。若没有git.exe而源码commit无法核实则显示阻断项，需人工只读核实，不要求立即安装Git。

## 下一道工作

用户将 `C9_11_BASE_PREFLIGHT_*.json` 脱敏报告回传，按具体阻断项处理。若静态PASS，再针对已确认范围建立独立进程的**一次性两句、BASE CPU/FP32、固定A03参考、不训练、不使用婉儿LoRA150、不碰9880/9890**的推理执行器与单独的明确授权。推理测试不可由此静态检查自动触发。

当前源录音/参考A03、模型权重、私有路径和授权文件未上传Public仓库。
