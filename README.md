# Qwen3.6-35B-A3B · 8GB 笔记本实测基线（llama.cpp turbo4 KV）

> EN: Qwen3.6-35B-A3B baseline on 8GB laptop: production config and measured depth curves with turbo4 KV.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**硬件**：RTX 4060 Laptop 8GB · 32GB DDR5 双通道 · Windows 11 · llama.cpp 系 fork

**量化**：APEX I-Compact（16.1 GB, mudler imatrix）

**引擎**：**AtomicBot b10269-1.6.0**（与 Ornith/KAT 同款参数族）

## 生产配置（start.bat 即仓库内同名文件，零漂移）

```bat
-ctk turbo4 -ctv turbo4 -b 2816 -ub 2816 --threads 24 --no-mmap --mlock --spec-type none --reasoning off --jinja
```

## 实测结果（服务端真实长提示口径）

| 深度 | PP (tok/s) | TG (tok/s) |
|---|---|---|
| ~19K | 924-1139 | 31.7 |
| ~57K | 938 | — |
| 118K 深度 | — | ~19.4 |

## 关键发现

- 与 Ornith/KAT 同架构同引擎，参数族完全互通（三模型互为对照）。
- 中文 RP 实测输给同尺寸的中文标定模型（见姊妹仓 zhrp），本仓保留其基线数据供对照。

## 复现

```bash
python tools/depth_probe_atomic.py <模型.gguf> <端口> <标签> --depths 0,32768,65536,98304,118784 -ctk turbo4 -ctv turbo4 -b 2816 -ub 2816 --threads 24
python tools/test_engines.py
```

## data/ 与 tools/

`data/` 是全部实测数据（summary_*.txt 为权威深度/预填/矩阵总表，每行带时间戳，可复现）。
`tools/` 是探针与判分脚本（服务端真实长提示口径；llama-bench pp512 在本机与真实负载差 2.8 倍，仅作参考）。

## 姊妹仓库（同机同方法论）

- [ornith-1.5-35b-8g-tuning](https://github.com/rui08984-dot/ornith-1.5-35b-8g-tuning)
- [kat-coder-35b-8g-tuning](https://github.com/rui08984-dot/kat-coder-35b-8g-tuning)
- [bonsai2-27b-8g-tuning](https://github.com/rui08984-dot/bonsai2-27b-8g-tuning)
- [zhrp-gemma4-26b-8g-tuning](https://github.com/rui08984-dot/zhrp-gemma4-26b-8g-tuning)
- [ornith-9b-kvmem-8g-tuning](https://github.com/rui08984-dot/ornith-9b-kvmem-8g-tuning)

## 致谢

- [ggml-org/llama.cpp](https://github.com/ggml-org/llama.cpp) — 本体
- [TheTom/llama-cpp-turboquant](https://github.com/TheTom/llama-cpp-turboquant) — turbo4 KV 原始 fork
- [AtomicBot-ai/atomic-llama-cpp-turboquant](https://github.com/AtomicBot-ai/atomic-llama-cpp-turboquant) — 现用构建
- [PrismML](https://huggingface.co/PrismML) — Bonsai 三值 QAT
- KVMem — KV-in-RAM 超长上下文引擎

## License

MIT。模型权重遵循各自发布页许可。
