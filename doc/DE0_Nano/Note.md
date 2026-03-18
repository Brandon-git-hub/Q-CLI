# DE0-Nano

## Board Devices

### Clock
Y1
50MHz
上面應該是寫 "MEC AD4LB"
應該是 MEC (Megastar Electronics Corp) 生產的 SPXO (標準時鐘振盪器)

### LED
LED0~7

### Button
KEY0, KEY1
TACK_SW_RA
TACT (或 TACK)： 代表 Tactile Switch（輕觸開關 / 按鍵開關）。
SW： Switch（開關）的縮寫。
RA： Right Angle（側按 / 側插 / 彎角）。

其與SN74AUC17搭配。
具有施密特觸發器輸入的 6 通道、0.8-V 至 2.7-V 高速緩衝器。
與普通緩衝器（如 7407）最大的不同點在於它是 Schmitt-Trigger Input。
抗雜訊： 它可以處理上升/下降沿緩慢的訊號，並將其轉換為乾淨的方波。
遲滯電壓： 利用遲滯特性（Hysteresis），能有效過濾掉輸入訊號上的微小波動或雜訊，避免產生錯誤的觸發。

### Dip Switch
SW1
SW-DIP8
搭配RN3，是 Resistor Network（排阻）
103 -> 10K

### SDRAM
U5
32MB

"ISSI IS42S16160 0J-7 TLI"
"BWA355000X 2314"

這是一顆由 **ISSI (Integrated Silicon Solution Inc.)** 生產的高速 **SDRAM**。

* **IS42S：** 代表 3.3V 工作電壓的 SDRAM 系列。
* **16160J：** 代表容量與設計版本。
    * **16 Meg x 16：** 總容量為 **256 Mb** (Megabits)，由 16 Meg 字組 (Words) 乘以 16 位元 (Bits) 組成。
    * **J：** 代表該產品的設計修訂版本 (Revision J)。
* **-7：** 代表速度等級。這顆是 **143 MHz** (時鐘週期 7ns)，符合 PC133 標準。
* **T：** 封裝類型，**TSOP II (54-pin)**。
* **L：** 代表 **無鉛 (Lead-free / RoHS)** 封裝。
* **I：** 代表 **工業級溫度範圍 (Industrial)**，工作環境可承受 **-40°C 至 +85°C**。


### EEPROM
U6

Microchip 24LC02B 2KB
"224 438 1H"
PDIP, MSOP 8 pin package


### ADC
U4
ADC128S022CIMTX


### EPCS (Erasable Programmable Configurable Serial)
U10 
IS25LP064A-JBLE
64MB 3V SERIAL FLASH MEMORY WITH 133MHZ MULTI I/O SPI & QUAD 
I/O QPI DTR INTERFACE


### Accelerometer
U3
ADXL345
Analog Devices (ADI) 生產的經典 3 軸數位加速度計 (3-Axis Digital Accelerometer)。
這是一顆由 **Analog Devices (ADI)** 生產的經典 **3 軸數位加速度計 (3-Axis Digital Accelerometer)**。

這顆晶片之所以受歡迎，是因為它內建了多個硬體中斷功能，不需要 MCU 頻繁運算：
* **Tap / Double Tap 偵測：** 偵測單次或雙次敲擊（可用於喚醒系統）。
* **Activity / Inactivity 偵測：** 偵測設備是否正在移動。
* **Free-Fall 偵測：** 偵測設備是否處於墜落狀態。
* **FIFO 緩衝區：** 內建 32 級的 FIFO，可減輕主控 MCU 的負擔。


### Pin Header
JP3
2x13

### GPIO-0 Header, GPIO-1 Header
JP1, JP2
**2x20 (40-pin) 的排針座**

* **None：** 不對此 Header 進行任何預設配置。所有的 Pin 會保持為一般 I/O，不會自動帶入特定模組的命名或電壓約束。
* **GPIO Default：** 最通用的設定。將 40 根針腳全部定義為通用的輸入/輸出腳位（如 `GPIO_0[0]` 到 `GPIO_0[35]`），不綁定特定功能。
* **D5M - 5M Pixel Camera：** * **對象：** 友晶科技的 500 萬畫素攝像頭模組。
    * **作用：** 選取後，系統會自動將腳位命名為資料線（D0-D11）、時脈（PIXCLK）、$I^2C$ 控制線（SCLK/SDAT）等，方便你直接在 Verilog 程式碼中呼叫。
* **LTM - 4.3" LCD and Touch：**
    * **對象：** 4.3 吋的觸控液晶螢幕模組。
    * **作用：** 自動配置顯示資料線（RGB）、背光控制、觸控面板的 SPI/$I^2C$ 通訊腳位。
* **MTL - Multi-Touch LCD Panel：**
    * **對象：** 支援多點觸控的液晶顯示面板。
    * **作用：** 類似 LTM，但針對多點觸控協議（通常是較新的介面或解析度）進行腳位優化。

