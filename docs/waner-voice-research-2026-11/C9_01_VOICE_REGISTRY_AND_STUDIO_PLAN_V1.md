# C9-01 Voice Registry与Voice Studio渐进接入（V1）

**状态：数据契约与本地原型已准备；未接入Studio V1.4、未执行实际引擎调用；日期：2026-11-12。**

## 目标：一个Studio，多个声音与引擎

现有婉儿Voice Studio V1.4继续保留为稳定基线。未来在**独立实验版**中实现：

1. 选择声音（Voice ID，例如婉儿；以后支持第二个获授权声音）；
2. 选择该声音可用的引擎/权重版本（GPT-SoVITS稳定版、IndexTTS LoRA150研究版）；
3. 输入文字，按该引擎的实际能力选择参考/情绪参数；
4. 提交合成任务，查看状态，试听/下载/管理历史WAV；
5. 将新声音的数据与声音身份纳入注册库，而不是复制整套应用。

声音、模型、参考音频和应用接口分离；**注册一个模型不代表允许生成、不代表授予声音使用权或上线许可**。

## 阶段效果与验收

|阶段|用户可以看到/做到|边界|
|---|---|---|
|C9-01 声音注册|系统能查询婉儿的稳定模型与LoRA150候选；界面目前不变|仅注册与校验元数据，不加载模型|
|C9-02 Engine Adapter|隔离调用既有GPT-SoVITS接口、IndexTTS CPU离线推理|不热切换现有生产模型，不抢占生产GPU|
|C9-03 Studio实验版|声音/引擎选择、任务队列、试听、保存与历史记录|保持原V1.4原样可用、可回退|
|C9-04 第二声音|经授权的参考音频进入相同制作/试听流程|新增声音不直接复用婉儿权重或授权|
|C9-05 发布验收|通过质量/许可/资源/回滚门槛后按需发布|生产切换仍需单独批准|

## C9-01元数据契约（首版）

- `voice_id`和`display_name`：稳定声音身份；
- `authorization_status`：仅登记可核验状态，不替代授权证明；
- `reference_id`、`sha256`、`storage_ref_id`：参考资产的匿名化元数据，**真实存储路径不放Public仓库**；
- `model_id`、`engine`、`weight_ref_id`：引擎及其具体模型版本的分离；
- `lifecycle`：`existing_production` / `research` / `approved` / `deprecated`；
- `execution_tier`：`realtime_existing` / `offline_cpu` / `disabled`；
- `default_model_id`：指向现有生产或已批准版本，不得指向研究/废弃版；
- `enabled`：模型是否在未来经过批准的实验运行层开放；**仅有元数据不能触发推理**。

本地已准备只读校验原型（Python 3.10标准库、JSON Schema与示例）并通过1项有效样本和8项拒绝样本测试，且通过JSON Schema 2020-12格式校验。**尚未在用户Windows机器执行或集成到Studio。** 示例中两个模型均`enabled=false`，未包含权重、录音、地址、令牌或授权文件，不能直接投入生产。

## Studio V1.4的保护措施

- 不改变GPT-SoVITS现有API、Gateway、OpenClaw、Cloudflare、参考音频、模型权重和生产配置。
- Studio V1.4历史WAV已迁移E盘并验收可播放；实验版不得覆盖或迁移这些原始资产。
- IndexTTS C7 CPU/FP32六条推理的平均RTF约17.645，当前仅作为离线候选；界面应支持异步状态和任务排队，不承诺实时。
- `soft`情绪之前听感不佳，保持隐藏/禁用；其他情绪由适配器实际支持能力决定，不做跨引擎参数等价假设。
- 持久化语音数据、授权、模型/参考音频真实路径应保留在受控存储，新研发代码建议使用Private VoiceFactory仓库。

## 下一项输入与实施门禁

在修改Studio前只需要V1.4的**只读源文件清单、真实入口与历史WAV读取逻辑**，不上传录音、权重或密钥。对照现有源码做最小差异方案，先在独立副本实施C9-02/03；只有验证启动/停止、历史读取、错误回滚、资源隔离后才讨论是否发布。

参阅 [C8最终决策](C8_FINAL_TECHNICAL_DECISION_2026-11-12.md) 和 [C9交接](C9_VOICE_FACTORY_HANDOFF_V1.md)。