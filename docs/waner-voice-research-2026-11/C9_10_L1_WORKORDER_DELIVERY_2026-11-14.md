# C9-10安装验收与L1零样本试声工单V1

**日期：2026-11-14；实际状态：C9-10技术预检工具成功安装，L1工单程序离线验证通过、待Windows安装；真实第二声音试声尚未执行。**

## 1. 用户安装凭证

用户提供 `C9_10_INSTALL_RECEIPT_20261114_140048_708.json`（schema `dahuangs.voicefactory.c9_10.install_receipt.v1`），记录：

- `status=INSTALL_OK`；新增5个文件，未覆盖任何现有目标文件。
- `catalog_untouched=true`、`production_modified=false`、`network_or_model_invoked=false`。
- 据此将**C9-10 V2只读WAV预检工具安装**记为已通过；但还没有对获授权的第二个声音做实机音频预检，不能称声源质量门槛已完成最终验收。

## 2. L1零样本试声工单

交付包：`Dahuangs_C9_10_L1_Pilot_WorkOrder_V1.zip`

SHA-256：`9cc256ab03cbbb917ba452792279bf84e626fbe95a2c4dd6fe9a55cfad9e65ef`

代码为Python 3.10+标准库，安装后新增：

- `tools/c9_10_l1_workorder.py`：`status`、`interactive`、`prepare`三个入口；
- `launchers/C9_10_L1_Status.cmd`：无需第二个声音即可读取工厂登记数量；
- `launchers/C9_10_L1_Prepare.cmd`：在已有**C9-09新声音草稿和C9-10私有音频预检报告**基础上生成工单；
- `tests/test_c9_10_l1_workorder.py`：16项离线测试；
- `docs/C9_10_L1_WORKORDER_GUIDE.md`：安装、后续制作、安全约束。

### 工单真实含义

仅为**非执行型的元数据计划**。可选`indextts25_base_cpu`（通用BASE）、`gpt_sovits_generic`（另行核实的通用预训练零样本能力），或者`both`。每个引擎计划最多2条非敏感测试文本；选择`both`不代表必须跑两个引擎。

准备时校验新声音草稿、已登记原声的路径与SHA、C9-10私有预检报告来源和质量告警、人耳审核与本地授权声明。对于C9-09既有`waner`导入项，工单明确要求**新的草稿声音**；不会拿婉儿专属GPT-SoVITS权重或LoRA150权重制作别人声音。

生成文件：
- 私有`workspace/private_factory_registry/c9_10_l1_workorders/C9_10_L1_PRIVATE_WORKORDER_*.json`：含原声本机路径、声音ID、源SHA、待验证引擎与试声文本；**不得上传**。
- 可分享`docs/C9_10_L1_SAFE_PLAN_*.json`：仅包含工程状态和任务数，不含声音ID、路径、原声哈希、录音或密钥。

所有工单固定`status=PLAN_ONLY_NOT_EXECUTABLE`、`execution_authorized=false`、`training_authorized=false`。不读取模型权重、不访问网络、不生成WAV、不运行TTS/训练/LLM、不修改Studio运行注册表或生产链路。

### 验证及限制

- 16项Python离线测试通过：状态读取、双引擎选择、权限和人耳审核确认、声音ID/参考绑定、文件变更和SHA拒绝、预检告警人工确认、私有报告路径门禁、不泄露可分享摘要、无生产台账修改等。
- Python语法检查、ZIP及5个payload SHA核对通过；CMD为ASCII/CRLF、PowerShell脚本UTF-8 BOM/CRLF。**未在用户Windows执行安装，不可声称实机验收已完成。**
- 实际**L1零样本推理执行器尚未建设**；具体泛化模型/版本/权重SHA、环境、算力、并发、测试预算与明确授权需在有新声源后另外确认。既有RTX3070 8GB优先保障生产，IndexTTS CPU/FP32实证慢。

## 3. 下一步

先解压工单ZIP并运行`Install_C9_10_L1.cmd`，预期`C9_10_L1_INSTALL_OK`。然后运行工作区`launchers/C9_10_L1_Status.cmd`，观察`C9_10_L1_STATUS_OK`；**此时无需第二个声音**。

等第二个经合法许可的声源准备好，再创建新声音草稿→运行C9-10参考WAV检查→人工听验→生成L1私有计划。参数建议随具体录音与所选引擎的真实限制而定，不强行以固定时长或音量阈值认定合格。

麦克风/STT、双向对话相关任务按用户决定继续暂停；本轮仅推进多声音标准化主线。
