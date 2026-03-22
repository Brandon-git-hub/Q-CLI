# FPGA 專案

## Bug

### **WSL 執行 Windows 執行檔報錯：Exec format error**

* **問題現象**：在 WSL 中執行 `.exe`（如 `quartus_sh.exe`）時出現 `Exec format error`，且 `/proc/sys/fs/binfmt_misc/WSLInterop` 遺失。
* **錯誤原因**：WSL 更新或開啟 `systemd` 後，導致核心的 **Interop (互通性)** 註冊失效，無法辨識 Windows PE 格式。
* **立即修復**：
    ```bash
    # 手動掛載並重新註冊攔截器
    sudo mount -t binfmt_misc binfmt_misc /proc/sys/fs/binfmt_misc
    sudo sh -c 'echo ":WSLInterop:M::MZ::/init:PF" > /proc/sys/fs/binfmt_misc/register'
    ```
* **長期對策**：
    1.  檢查 `/etc/wsl.conf` 是否包含 `[interop] enabled=true`。
    2.  在 Windows 關閉「接收其他 Microsoft 產品的更新」以避免環境變動。
    3.  若持續發生，可將修復指令加入 `.bashrc` 自動執行。
