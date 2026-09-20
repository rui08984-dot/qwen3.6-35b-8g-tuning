@echo off
rem ================================================================
rem  Qwen3.6-35B-A3B UD-Q4_K_XL (Chinese writing / chat, ORIGINAL
rem  Qwen behavior - no distill) on Thetom TQP v0.3.0 engine
rem  2026-09-18 FINAL: migrated from TurboQuant fork (PP 102) to TQP
rem  MEASURED: PP 802 cold / 923.8 @19K (9x), TG 31.7. Same TQP
rem  config as start-Ornith.bat (see that file for full notes):
rem  - --fit auto-balances GPU layers on 8G (no manual ncmoe)
rem  - turbo4 KV (auto-upgrades K to q8_0 on GQA 8:1 layers)
rem  - MTP off (negative with CPU-offloaded experts)
rem  - --no-mmproj-offload keeps vision tower on CPU (upzhu's own
rem    advice: without it an image OOMs the 8G card)
rem  - sleep-idle 600 KEPT (Ornith bat uses -1 resident; BOTH
rem    resident at once would exceed 32G RAM - run one at a time)
rem  ================================================================
cd /d D:\llm\bin\atomic-b10269\pkg\build\bin
llama-server.exe ^
  -m "D:\lmstudio-models\mudler\Qwen3.6-35B-A3B-APEX-I-Compact.gguf" ^
  --mmproj "D:\lmstudio-models\mudler\mmproj-qwen36-apex.gguf" ^
  --no-mmproj-offload ^
  -c 131072 -np 1 -fa on ^
  -ctk turbo4 -ctv turbo4 ^
  -b 2816 -ub 2816 ^
  --threads 24 --threads-batch 12 ^
  --cache-prompt --ctx-checkpoints 8 ^
  --no-mmap --mlock --spec-type none ^
  --reasoning off --jinja --reasoning-format deepseek ^
  --host 127.0.0.1 --port 24551
pause
