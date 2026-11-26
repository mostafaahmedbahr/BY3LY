#!/usr/bin/env python3
"""
BY3LY store mockup generator.

Inputs : the 9 iPhone simulator screenshots on the Desktop (see SOURCES below)
Outputs: ready-to-upload assets inside play_store_screenshots/

  google_play/feature_graphic.png      1024 x 500 (JPEG/PNG, no alpha)
  google_play/phone_*.png              1080 x 1920 (9:16) branded mockups
  google_play/clean/phone_*.png        1080 x 1920 plain screenshots
  app_store/iphone_69/*.png            1320 x 2868 branded mockups
  app_store/iphone_69/clean/*.png      1320 x 2868 plain screenshots
  app_store/iphone_65/*.png            1284 x 2778 (scaled set)
  real_app/*.png                       original screenshots, untouched

Requirements: pip install Pillow arabic-reshaper python-bidi
"""

from pathlib import Path
import shutil

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import arabic_reshaper
from bidi.algorithm import get_display

ROOT = Path(__file__).resolve().parent
DESKTOP = Path("/Users/macbook/Desktop")
# SF Arabic is much crisp at store-listing sizes; fall back to the bundled Cairo font.
SF_FONT = Path("/System/Library/Fonts/SFArabic.ttf")
CAIRO_FONT = ROOT.parent / "assets/fonts/cairo/Cairo-VariableFont_slnt,wght.ttf"
FONT_PATH = SF_FONT if SF_FONT.exists() else CAIRO_FONT
# SF Arabic has no Latin glyphs, so "BY3LY" must use a real Latin font.
LATIN_FONT = Path("/System/Library/Fonts/Supplemental/Arial Bold.ttf")

# ---------------------------------------------------------------- brand colors
DEEP = (5, 30, 23)
MID = (14, 133, 101)
MINT = (52, 211, 153)
WHITE = (255, 255, 255)
SOFT = (215, 240, 231)

# ------------------------------------------------------------ source screenshots
SOURCES = [
    ("16.42.48", "onboarding"),
    ("16.42.53", "login"),
    ("16.43.22", "home"),
    ("16.43.27", "chats"),
    ("16.43.36", "my_ads"),
    ("16.43.41", "account"),
    ("16.44.08", "product"),
    ("16.44.19", "report"),
    ("16.44.25", "categories"),
]

# Store order: show the strongest screens first.
STORE_ORDER = [
    ("home", ["اكتشف كل اللي محتاجه", "في مكان واحد"], "سيارات، موبايلات، عقارات وأكثر. بيعلي بيجمع كل الفئات"),
    ("product", ["شوف التفاصيل", "قبل ما تقرر"], "السعر، المشاهدات، الموقع، وتواصل مباشر مع البائع"),
    ("categories", ["تصفّح حسب الفئة", "بكل سهولة"], "عقارات، سيارات، إلكترونيات، أثاث وأزياء وغيرها"),
    ("chats", ["atkلم مع البائع", "مباشرة"], "محادثاتك وصور الإعلانات كلها في مكان واحد"),
    ("my_ads", ["إعلاناتك وباقاتك", "تحت السيطرة"], "تابع إعلاناتك النشطة، المبيعات، والإحصائيات"),
    ("account", ["حسابك وإعداداتك", "في مكان واحد"], "المفضلة، الدفع والرصيد، الإشعارات، اللغة والمظهر"),
    ("report", ["مجتمع آمن", "وموثوق"], "بلّغ عن أي إعلان مزيف أو غير مناسب في ثوانٍ"),
    ("onboarding", ["متبيع وتلاقي", "كل حاجة"], "تجربة تسوق آمنة وموثوقة مع ضمان أفضل الأسعار"),
    ("login", ["ادخل وابدأ", "البيع والشراء"], "تسجيل الدخول، حساب جديد، أو الدخول كزائر"),
]

# Fix the accidental latin word in the chats headline (kept explicit for clarity).
STORE_ORDER[3] = ("chats", ["اتكلم مع البائع", "مباشرة"], "محادثاتك وصور الإعلانات كلها في مكان واحد")


def load_sources():
    out = {}
    real = ROOT / "real_app"
    real.mkdir(parents=True, exist_ok=True)
    for stamp, name in SOURCES:
        src = DESKTOP / f"Simulator Screenshot - iPhone 16 Pro - 2026-11-26 at {stamp}.png"
        if not src.exists():
            raise FileNotFoundError(src)
        img = Image.open(src).convert("RGBA")
        out[name] = img
        dst = real / f"{name}.png"
        if not dst.exists():
            shutil.copy2(src, dst)
    return out


def font(size, weight="Regular"):
    f = ImageFont.truetype(str(FONT_PATH), size)
    if weight != "Regular":
        for candidate in (weight, "Semibold" if FONT_PATH == SF_FONT else "SemiBold", "Bold"):
            try:
                f.set_variation_by_name(candidate)
                break
            except Exception:
                continue
    return f


def ar(text):
    return get_display(arabic_reshaper.reshape(text))


def draw_ar(d, xy, text, f, fill, anchor="ra"):
    d.text(xy, ar(text), font=f, fill=fill, anchor=anchor)


def gradient(size, top=DEEP, bottom=MID):
    w, h = size
    img = Image.new("RGB", (w, h))
    px = img.load()
    for y in range(h):
        t = y / max(1, h - 1)
        # ease the gradient a little so the top stays deep
        t = t ** 1.35
        c = tuple(round(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
        for x in range(w):
            px[x, y] = c
    return img


def add_glow(base, box, color=MINT, blur=120, alpha=46):
    w, h = base.size
    glow = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse(box, fill=(*color, alpha))
    glow = glow.filter(ImageFilter.GaussianBlur(blur))
    base.alpha_composite(glow)


def paste_device(base, shot, cx, top, height, radius_ratio=0.085):
    """Draw a subtle device frame with the real screenshot inside it."""
    width = round(height * shot.width / shot.height)
    left, right = cx - width // 2, cx + width // 2 - 1
    bottom = top + height - 1
    r = max(18, round(width * radius_ratio))
    br = r + 10

    # shadow
    shadow = Image.new("RGBA", base.size, (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.rounded_rectangle((left - 12 + 6, top + 16, right + 12 + 6, bottom + 12 + 16),
                         radius=br + 6, fill=(0, 0, 0, 150))
    shadow = shadow.filter(ImageFilter.GaussianBlur(28))
    base.alpha_composite(shadow)

    # frame
    d = ImageDraw.Draw(base)
    d.rounded_rectangle((left - 12, top - 12, right + 12, bottom + 12),
                        radius=br, fill=(3, 22, 17, 255))

    # screenshot with rounded corners
    ss = shot.resize((width, height), Image.Resampling.LANCZOS).convert("RGBA")
    mask = Image.new("L", (width, height), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, width - 1, height - 1), radius=r, fill=255)
    base.paste(ss, (left, top), mask)
    return width


def wordmark(d, x, y, scale=1.0, anchor="ra"):
    d.text((x, y), "BY3LY", font=ImageFont.truetype(str(LATIN_FONT), round(56 * scale)),
           fill=WHITE, anchor=anchor)
    draw_ar(d, (x, y + round(82 * scale)), "بيعلي", font(round(38 * scale), "Bold"), MINT, anchor)


def caption_panel(d, box):
    """Dark backing panel so every word stays readable on any background."""
    d.rounded_rectangle(box, radius=34, fill=(2, 22, 17, 214))


def store_mockup(shot, title_lines, subtitle, size, out):
    w, h = size
    base = gradient(size).convert("RGBA")
    add_glow(base, (w // 2 - 480, h // 2 - 100, w // 2 + 480, h), blur=180, alpha=34)
    d = ImageDraw.Draw(base)

    if h > 2400:  # App Store 6.9"
        rx = w - 80
        caption_panel(d, (56, 64, w - 56, 630))
        wordmark(d, rx, 88, 1.0)
        tf = font(100, "Bold")
        lh = 126
        ty = 280
        for line in title_lines:
            draw_ar(d, (rx, ty), line, tf, WHITE)
            ty += lh
        draw_ar(d, (rx, ty + 8), subtitle, font(48, "Semibold"), SOFT)
        device_top = 700
        device_h = h - device_top - 110
    else:  # Google Play 9:16
        rx = w - 56
        caption_panel(d, (28, 24, w - 28, 450))
        wordmark(d, rx, 50, 0.79)
        tf = font(72, "Bold")
        lh = 90
        ty = 196
        for line in title_lines:
            draw_ar(d, (rx, ty), line, tf, WHITE)
            ty += lh
        draw_ar(d, (rx, ty + 4), subtitle, font(36, "Semibold"), SOFT)
        device_top = 480
        device_h = h - device_top - 62

    dvw = paste_device(base, shot, w // 2, device_top, device_h)

    out.parent.mkdir(parents=True, exist_ok=True)
    base.convert("RGB").save(out, "PNG", optimize=True)
    return dvw


def clean_shot(shot, size, out, bg=DEEP):
    """Plain screenshot fitted into the required canvas, no branding."""
    w, h = size
    canvas = Image.new("RGB", size, bg)
    scale = min(w / shot.width, h / shot.height)
    nw, nh = round(shot.width * scale), round(shot.height * scale)
    ss = shot.resize((nw, nh), Image.Resampling.LANCZOS).convert("RGB")
    canvas.paste(ss, ((w - nw) // 2, (h - nh) // 2))
    out.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(out, "PNG", optimize=True)


def feature_graphic(screens, out):
    W, H = 1024, 500
    base = gradient((W, H), (4, 26, 20), (10, 92, 70)).convert("RGBA")
    add_glow(base, (430, 10, 1024, 500), blur=120, alpha=44)
    d = ImageDraw.Draw(base)

    # headline block (left side, RTL text still starts at the given x)
    d.rounded_rectangle((34, 26, 580, 400), radius=30, fill=(2, 22, 17, 196))
    d.text((68, 48), "BY3LY", font=ImageFont.truetype(str(LATIN_FONT), 92),
           fill=WHITE, anchor="la")
    draw_ar(d, (70, 164), "بيعلي، سوق إعلانات مبوبة مصري", font(36, "Semibold"), MINT, "la")
    draw_ar(d, (68, 236), "متبيع وتلاقي كل حاجة", font(50, "Bold"), WHITE, "la")
    draw_ar(d, (70, 324), "بيع واشترِ في مصر بكل سهولة وأمان", font(30, "Semibold"), SOFT, "la")

    # three overlapping devices, real screenshots
    for name, cx, top, height in [
        ("home", 690, 66, 366),
        ("product", 818, 40, 420),
        ("chats", 946, 18, 462),
    ]:
        paste_device(base, screens[name], cx, top, height, radius_ratio=0.075)

    out.parent.mkdir(parents=True, exist_ok=True)
    base.convert("RGB").save(out, "PNG", optimize=True)


def main():
    screens = load_sources()

    # Google Play ------------------------------------------------------------
    gp = ROOT / "google_play"
    for i, (name, title, sub) in enumerate(STORE_ORDER[:8], start=1):
        store_mockup(screens[name], title, sub, (1080, 1920), gp / f"{i:02d}.png")
        clean_shot(screens[name], (1080, 1920), gp / "clean" / f"{i:02d}.png")
    feature_graphic(screens, gp / "feature.png")

    # App Store --------------------------------------------------------------
    ap = ROOT / "app_store"
    for i, (name, title, sub) in enumerate(STORE_ORDER, start=1):
        store_mockup(screens[name], title, sub, (1320, 2868),
                     ap / "iphone_69" / f"{i:02d}.png")
        clean_shot(screens[name], (1320, 2868),
                   ap / "iphone_69" / "clean" / f"{i:02d}.png")

        # 6.5" fallback set (same artwork, scaled to the required pixel size)
        src = ap / "iphone_69" / f"{i:02d}.png"
        dst = ap / "iphone_65" / f"{i:02d}.png"
        dst.parent.mkdir(parents=True, exist_ok=True)
        Image.open(src).resize((1284, 2778), Image.Resampling.LANCZOS).save(dst, "PNG", optimize=True)

    print("Done. Outputs in", ROOT)


if __name__ == "__main__":
    main()
