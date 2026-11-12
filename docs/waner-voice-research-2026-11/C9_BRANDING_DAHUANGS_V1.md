# C9 品牌与命名规范 V1 — Dahuang's Voice Factory

**制定日期：2026-11-12。状态：已确认产品命名；界面实现待 C9-02/C9-03。**

## 正式名称

| 范围 | 正式展示名称 | 中文说明 |
|---|---|---|
| 总项目、生产系统 | **Dahuang's Voice Factory** | 大黄声音工厂 |
| 使用者网页工作台 | **Dahuang's Voice Studio** | 大黄语音工作台 |
| 声音管理页面 | **Dahuang's Voice Library** | 多声音/模型版本库 |
| 音色试验与试听页面 | **Dahuang's Voice Lab** | 声音实验室 |
| 聊天功能页 | **AI Chat**（位于 Dahuang's Voice Studio 内） | AI 对话 |
| 文字转语音功能页 | **Text to Speech**（位于 Dahuang's Voice Studio 内） | 文字转语音 |

产品标识统一使用 ASCII 撇号 `Dahuang's`；UI可使用字体排版的弯撇号 `Dahuang’s`。不在每一个普通控件、技术模块名称或日志键名中重复冗长前缀。

## 与技术名称的区分

- GPT-SoVITS、IndexTTS 2.5、LoRA150 是第三方引擎/模型标识，保持原名，不能冒称是自研引擎。
- `voice_id`、`model_id`、`engine`、`registry`、`api`、文件 SHA 等技术标识保持稳定；品牌不改变其含义。
- 本地工作区物理路径继续为 `E:\E01\VoiceEngine\VoiceFactory`；已经生成的文件夹/文件和脚本路径保持不变，**不要因为显示名称改变而批量重命名**。
- 现有Waner's Voice Studio V1.4是历史稳定应用；下一阶段在隔离的新工作台实现品牌界面，不覆盖原V1.4。
- GitHub仓库 `GPT-SoVITS` 保留现有名称和历史；未来新的独立私有开发仓库名称应在建仓时确定，不擅自改变已公开URL。

## 首批界面信息架构

```text
Dahuang's Voice Studio
  ├─ AI Chat / AI对话（文字聊天，可选TTS朗读回复）
  ├─ Text to Speech / 文字转语音（声音→引擎→参数→生成→试听）
  ├─ Voice Library / 声音模型库（音色与版本管理）
  ├─ Audio History / 历史音频
  └─ Settings / 系统设置与资源状态

Dahuang's Voice Factory（后续管理）
  ├─ Voice Lab / 音色测试、匿名评价
  ├─ Data Intake / 授权数据导入与预检
  ├─ Model Build / 受控试声、必要时另授权训练
  └─ Quality Gate / 审核、版本发布和回滚
```

## 安全与实施状态

本次只确定产品命名及未来UI结构，未重命名用户磁盘文件、未修改生产Gateway/模型/音频，也未启动任何TTS或训练。C9的最终页面呈现和功能开关将在独立开发环境验收后上线。

参见 [C9-01注册与Studio方案](C9_01_VOICE_REGISTRY_AND_STUDIO_PLAN_V1.md) 与 [C9交接](C9_VOICE_FACTORY_HANDOFF_V1.md)。
