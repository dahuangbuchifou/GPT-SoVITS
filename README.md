# 🎙️ GPT-SoVITS 集成到 OpenClaw

_目标：让婉儿拥有自己的声音，通过 TTS 输出语音消息_

---

## 📋 需求

| 场景 | 频率 | 要求 |
|------|------|------|
| 日程提醒 | 每日数次 | 短文本，清晰 |
| 天气汇报 | 每日 1 次 | 短文本，自然 |
| 闲聊对话 | 不定期 | 长文本，情感丰富 |
| 故事/内容朗读 | 不定期 | 长文本，表现力 |

**约束：**
- 服务器无 GPU（阿里云 ECS，1.8GB 内存）
- 本地电脑有 GPT-SoVITS 环境和已训练模型
- 需要集成到 OpenClaw TTS 流程
- 成本敏感（优先免费）

---

## 🏗️ 架构

```
OpenClaw 服务器 ──HTTP──▶ Cloudflare Tunnel ──▶ 本地电脑 GPT-SoVITS API
```

- **本地电脑**：运行 GPT-SoVITS 模型 + API 服务（需要 GPU）
- **Cloudflare Tunnel**：内网穿透，把本地 API 暴露给公网
- **OpenClaw 服务器**：通过 tunnel URL 调用 TTS API

---

## 📅 进度记录

### 2026-05-05 → 05-06：首次尝试（远程桌面）

**操作：** 在大黄台式机（Windows）上启动 GPT-SoVITS API

**环境信息：**
- GPT-SoVITS 位置：`F:\GPT_SoVITS\GPT-SoVITS-v2pro-20250604\GPT-SoVITS-v2pro-20250604`
- Python 3.10.11（系统环境）
- 项目自带 Python：`runtime\python.exe`（独立环境）

**遇到的问题及解决：**
1. ❌ `jieba`、`matplotlib` 缺失 → ✅ 已装
2. ❌ `pyopenjtalk` 编译失败（日语库，中文不需要）→ ✅ 跳过
3. ❌ `x_transformers` 缺失 → ✅ 已装
4. ❌ `peft` 版本冲突 → ✅ 已装
5. ❌ `torchaudio 2.7.1` vs `torch 2.11.0` 版本不匹配 → ✅ 降级 torch 到 2.7.1
6. ❌ `split_lang` 模块找不到 → ✅ 发现需要用项目自带的 `runtime\python.exe` 运行
7. ❌ `ref_audio_path` 参数缺失 → ✅ 补充参考音频路径

**关键发现：**
- GPT-SoVITS v2pro 使用**独立 Python 环境**（`runtime\python.exe`），不是系统 Python
- 模型文件在：`SoVITS_weights_v2ProPlus\`
- 参考音频在：`output\slicer_opt\`

**✅ 最终成果：**
- API 服务成功启动：`http://127.0.0.1:9880`
- Cloudflare Tunnel 临时隧道已创建
- TTS 端点测试成功，能听到声音！
- API 端点：`/tts?text=xxx&text_lang=zh&prompt_lang=zh&ref_audio_path=xxx.wav`

**下一步：** 配置 Cloudflare 持久隧道（固定域名），集成到 OpenClaw

---

## 🎯 最终方案（2026-05-06 确认）

**Edge TTS 为主 + 本地 GPT-SoVITS 为辅**

**切换逻辑：**
1. 每次需要 TTS 时，先尝试调用 GPT-SoVITS API（超时 3 秒）
2. 成功 → 用婉儿声音
3. 失败 → 自动降级到 Edge TTS

**不需要心跳检测**，按需探测即可。

**后续优化（可选）：**
- 缓存在线状态（30 分钟内不重复探测）
- 切换时通知大黄

---

## 🔧 待办

- [x] 排查本地电脑依赖问题
- [x] 本地电脑成功启动 GPT-SoVITS API
- [x] 测试 TTS 端点（能听到声音）
- [ ] 配置 Cloudflare 持久隧道（固定域名）
- [ ] OpenClaw 服务器测试调用 API
- [ ] 实现自动切换逻辑（GPT-SoVITS → Edge TTS 降级）
- [ ] 集成到钉钉/飞书/语音消息

---

## 📝 参考

- 方案对比报告：`memory/tts-voice-cloning-comparison.md`
- GPT-SoVITS GitHub：https://github.com/RVC-Boss/GPT-SoVITS

---

_最后更新：2026-05-06 22:19_
