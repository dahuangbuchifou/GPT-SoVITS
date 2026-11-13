# C9-06 渐进式朗读与停止控制 V1

**日期：2026-11-13。状态：开发包完成离线验证；Windows实机安装、播放行为及主观体验待用户验收。**

## 交付

- 包名：`Dahuangs_C9_06_Progressive_Narration_Stop_V1.zip`
- ZIP SHA-256：`d47850165b99e98806304058de421d54f8df800be03e7efbb54d659b9e5ce1ff`
- 目标根目录：`E:\E01\VoiceEngine\VoiceFactory`
- 本轮只修改独立开发版的 `app/backend/c9_studio_dev_server.py` 和 `app/frontend/c9_studio_dev.js`。
- 严格要求现有C9-05基线SHA：后端 `b18d79c4ac4fe596372faa16e845e4ba33557fc79a4a0f30895a482e0bd06f26`，前端 `5917c882b0ba31dd946f6516ae22bf536ef4ddd9087bf4e862a2866d58c491b4`。未知本地改动或部分更新安全停止。

## 主要变化

- 保留原先“朗读这条回复”／“朗读输入内容”的**完整单文件WAV模式**。
- 新增“逐段播放”“逐段播放输入”和“停止后续朗读”按钮。界面展示第N/M段生成和播放状态。
- 新增`POST /api/narration/plan`：仅沿用C9-05已验收的文本清理和分段算法生成计划，不调用模型、不写WAV，且仍使用原有Host、Origin及CSRF门禁。
- 每个片段单独调用已有`POST /api/tts`，只在当前音频播放完毕后合成下一段；可以在整个回答尚未完成时先听第一段，但**不是真正的流式声学输出**。
- 停止时暂停浏览器音频并阻止下一片段提交；**已经发出的单次TTS请求不会被强行中断**，可能仍占用上游推理直到结束；原有并发门禁仍有效。
- 逐段模式只下载当前片段WAV；需要完整合并WAV时沿用原有完整朗读按钮。成功片段仍进入独立VoiceFactory历史。
- 浏览器若阻止自动播放，会提示用户手动点击播放器。
- 保留DeepSeek多提供商聊天、GPT-SoVITS合成、C9-05完整朗读的核心后端方法原样；自动朗读AI回复仍按用户明确选择开启，默认关闭。

## 离线验证

1. Python语法与JavaScript语法检查通过。
2. 10项Python测试通过：C9-05文本清理、分段、WAV合并、已有合成与聊天方法AST不变、分段计划限制和本机HTTP请求权限门禁。
3. 3项模拟浏览器测试通过：两段顺序播放、停止不再发送下个片段、无授权时阻止提交。
4. ZIP结构完整性、payload SHA和manifest逐项核验通过；CMD为ASCII+CRLF，PowerShell脚本为UTF-8 BOM+CRLF。
5. **尚未在用户Windows电脑执行该安装器或真实音频请求。** 不得将模拟测试记录为实机验收。

## 实机安装与验收边界

解压ZIP→双击 `Install_C9_06_OneClick.cmd`→预期 `C9_06_INSTALL_OK`→仅重启17861独立开发服务（不停止9880/9890）→Ctrl+F5刷新页面→在AI聊天页面对100–250字回复使用“逐段播放”，观察生成/播放进度和“停止后续朗读”，再验证旧完整WAV按钮仍可用。

安装器验证源文件SHA并备份旧版本，遇到不匹配停止；可使用安装凭证记录的备份恢复两个开发文件。只需验证一条适当长度的已有回复，不需要重复调用DeepSeek或运行训练。

**本补丁不修改生产Gateway、GPT-SoVITS权重、OpenClaw、旧Voice Studio V1.4，也不在Public仓库上传音频、模型权重、密钥或私人配置。**