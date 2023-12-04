Copyright (C) 2021 LineageOS
## Twoline Build
```
git clone https://github.com/stuartore/aosp-setup.git && cd aosp-setup

bash aosp.sh -k --auto_build
```
Device configuration for Xiaomi Mi 12X (psyche)
=========================================

The Xiaomi Mi 12X (codenamed _"psyche"_) is a flagship smartphone from Xiaomi.

It was released in December 2021.

## Device specifications

Basic   | Spec Sheet
-------:|:-------------------------
SoC     | Qualcomm SM8250-AC Snapdragon 870 5G (7 nm)
CPU     | Octa-core (1x3.2 GHz Kryo 585 & 3x2.42 GHz Kryo 585 & 4x1.80 GHz Kryo 585)
GPU     | Adreno 650
Memory  | 128GB 8GB RAM, 256GB 8GB RAM, 256GB 12GB RAM
Shipped Android Version | Android 11, MIUI 13
Battery | Li-Po 4500 mAh, non-removable
Display |  	AMOLED, 68B colors, 120Hz, Dolby Vision, HDR10+, 1100 nits (peak)

## Device picture

![Xiaomi Mi 12X](https://fdn2.gsmarena.com/vv/pics/xiaomi/xiaomi-12x-1.jpg "Xiaomi Mi 12X")

### Credit
+ [VoidUI-Devices](https://github.com/VoidUI-devices)
+ [Mesquita](https://github.com/mickaelmendes50)
+ [Monlight4004](https://github.com/moonlight4004）
+ [shine911](https://github.com/shine911)

<details>
  <summary>
    Trouble when building ?
  </summary>
  If you find one or more module loss, the most possible reason is that the ROM organization do not contain it. You could search it on it's related Github profile
<pre><code>
  name: "vendor_vibrator_hal"
</code></pre>
As you find it, copy and paste the hal as well as its defaults code paragraph in "{}" in the related file who occours error, in the most cases, Android.bp

Re-run lunch to see whether error fixed. Once it compelete, you could use aosp-setup to autobuild.
</details>

