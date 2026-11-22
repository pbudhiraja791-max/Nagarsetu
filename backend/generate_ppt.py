import os
import sys
import cv2
import numpy as np
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN
from pptx.enum.shapes import MSO_SHAPE

def prepare_background_images(source_img_path, output_dir):
    """
    Cleans placeholder text from the front page without cutting the photo,
    and creates the subtle faded background for slides 2-8 as shown in the template.
    """
    os.makedirs(output_dir, exist_ok=True)
    img = cv2.imread(source_img_path)
    if img is None:
        raise FileNotFoundError(f"Could not load image from {source_img_path}")
    h, w, _ = img.shape

    # 1. Slide 1 Clean Background (Keep full photo, remove only placeholder text)
    # [PROJECT NAME], [One-line...], [TEAM NAME], [TEAM MEMBERS] in y: 175-430, x: 25-530
    mask1 = np.zeros((h, w), dtype=np.uint8)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    roi1 = (slice(175, 430), slice(25, 530))
    mask1[roi1] = np.where(gray[roi1] > 60, 255, 0).astype(np.uint8)
    kernel = np.ones((3, 3), np.uint8)
    mask1 = cv2.dilate(mask1, kernel, iterations=2)
    bg_slide1 = cv2.inpaint(img, mask1, inpaintRadius=5, flags=cv2.INPAINT_TELEA)

    # 2. Slides 2-8 Faded Background:
    # Remove ALL text on the left (y: 30-440, x: 25-530) and bottom-right '01 / 07'
    mask2 = np.zeros((h, w), dtype=np.uint8)
    roi_left = (slice(30, 440), slice(25, 530))
    mask2[roi_left] = np.where(gray[roi_left] > 55, 255, 0).astype(np.uint8)
    roi_br = (slice(int(h * 0.93), h), slice(int(w * 0.88), w))
    mask2[roi_br] = np.where(gray[roi_br] > 60, 255, 0).astype(np.uint8)
    mask2 = cv2.dilate(mask2, kernel, iterations=2)
    clean_for_fade = cv2.inpaint(img, mask2, inpaintRadius=5, flags=cv2.INPAINT_TELEA)

    # Blend with deep dark charcoal base color RGB(14, 16, 21) -> BGR(21, 16, 14)
    base_dark = np.full_like(clean_for_fade, (21, 16, 14))
    # 38% clean image + 62% dark base gives the exact faded atmospheric look from the PDF
    bg_faded = cv2.addWeighted(clean_for_fade, 0.38, base_dark, 0.62, 0)

    p1 = os.path.join(output_dir, "bg_slide1.png")
    p2 = os.path.join(output_dir, "bg_faded.png")
    cv2.imwrite(p1, bg_slide1)
    cv2.imwrite(p2, bg_faded)
    return p1, p2

def create_nagarsetu_presentation(output_path="NagarSetu_The_Builders_Theory_Presentation.pptx"):
    prs = Presentation()
    # 16:9 Widescreen dimensions
    prs.slide_width = Inches(13.333)
    prs.slide_height = Inches(7.5)
    blank_layout = prs.slide_layouts[6]

    # Color Palette from The Builder's Theory 1.0 template
    COLOR_ACCENT = RGBColor(190, 242, 60)       # Lime / Cyber Green (#BEF23C)
    COLOR_WHITE = RGBColor(255, 255, 255)       # Crisp White
    COLOR_MUTED = RGBColor(156, 163, 175)       # Neutral Light Gray (#9CA3AF)
    COLOR_DARK_TEXT = RGBColor(17, 24, 39)      # Charcoal Text (#111827)
    COLOR_CARD_BG = RGBColor(255, 255, 255)     # Clean White Card
    COLOR_CARD_BORDER = RGBColor(229, 231, 235) # Light Border
    COLOR_SECONDARY_DARK = RGBColor(20, 24, 33) # Translucent Dark Card

    # Source image paths
    raw_img_path = r"C:/Users/Lenovo/.gemini/antigravity/brain/49e74d0b-6dee-4cf6-a19b-2d0de5549c1d/.user_uploaded/media_1794847149639_01e82f39.jpg"
    out_dir = os.path.dirname(os.path.abspath(__file__))
    bg_slide1_path, bg_faded_path = prepare_background_images(raw_img_path, out_dir)

    def add_faded_slide_shell(slide, slide_num_str, total_slides_str="07", title_text="", subtitle_text=""):
        # Faded Background Image covering entire slide without cutting
        slide.shapes.add_picture(bg_faded_path, 0, 0, width=prs.slide_width, height=prs.slide_height)

        # Top Right Event Brand: HACKERS   NEXERA
        brand_box = slide.shapes.add_textbox(Inches(9.2), Inches(0.35), Inches(3.6), Inches(0.5))
        tf = brand_box.text_frame
        tf.word_wrap = True
        p = tf.paragraphs[0]
        p.alignment = PP_ALIGN.RIGHT
        run = p.add_run()
        run.text = "HACKERS   NEXERA"
        run.font.name = "Arial Black"
        run.font.size = Pt(13)
        run.font.bold = True
        run.font.color.rgb = COLOR_WHITE

        # Footer Line
        footer_line = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, Inches(0.8), Inches(7.05), Inches(11.733), Inches(0.015))
        footer_line.fill.solid()
        footer_line.fill.fore_color.rgb = RGBColor(55, 60, 72)
        footer_line.line.fill.background()

        # Footer Left: THE BUILDER'S THEORY 1.0
        foot_left = slide.shapes.add_textbox(Inches(0.8), Inches(7.1), Inches(4.0), Inches(0.3))
        tf_fl = foot_left.text_frame
        p_fl = tf_fl.paragraphs[0]
        run_fl = p_fl.add_run()
        run_fl.text = "THE BUILDER'S THEORY 1.0"
        run_fl.font.name = "Arial"
        run_fl.font.size = Pt(8.5)
        run_fl.font.color.rgb = COLOR_MUTED

        # Footer Right: Slide Number
        foot_right = slide.shapes.add_textbox(Inches(10.5), Inches(7.1), Inches(2.033), Inches(0.3))
        tf_fr = foot_right.text_frame
        p_fr = tf_fr.paragraphs[0]
        p_fr.alignment = PP_ALIGN.RIGHT
        run_fr = p_fr.add_run()
        run_fr.text = f"{slide_num_str} / {total_slides_str}"
        run_fr.font.name = "Arial"
        run_fr.font.size = Pt(8.5)
        run_fr.font.color.rgb = COLOR_MUTED

        # Title & Subtitle
        if title_text:
            tb = slide.shapes.add_textbox(Inches(0.8), Inches(0.48), Inches(8.5), Inches(0.7))
            tf = tb.text_frame
            tf.word_wrap = True
            p = tf.paragraphs[0]
            run = p.add_run()
            run.text = title_text
            run.font.name = "Trebuchet MS"
            run.font.size = Pt(28)
            run.font.bold = True
            run.font.color.rgb = COLOR_WHITE

            # Accent Underline Bar
            acc_bar = slide.shapes.add_shape(MSO_SHAPE.RECTANGLE, Inches(0.82), Inches(1.20), Inches(0.65), Inches(0.05))
            acc_bar.fill.solid()
            acc_bar.fill.fore_color.rgb = COLOR_ACCENT
            acc_bar.line.fill.background()

        if subtitle_text:
            stb = slide.shapes.add_textbox(Inches(0.8), Inches(1.32), Inches(10.5), Inches(0.45))
            tf_s = stb.text_frame
            tf_s.word_wrap = True
            p_s = tf_s.paragraphs[0]
            run_s = p_s.add_run()
            run_s.text = subtitle_text
            run_s.font.name = "Arial"
            run_s.font.size = Pt(12)
            run_s.font.color.rgb = COLOR_MUTED

    # =========================================================================
    # SLIDE 1: COVER / TITLE (Front page with intact photo & cleaned placeholders)
    # =========================================================================
    slide1 = prs.slides.add_slide(blank_layout)
    # 1. Full photo on front page (NOT cut, full 16:9 stretch)
    slide1.shapes.add_picture(bg_slide1_path, 0, 0, width=prs.slide_width, height=prs.slide_height)

    # 2. Crisp overlay text in place of removed placeholders:
    # Project Title
    tb_proj = slide1.shapes.add_textbox(Inches(0.75), Inches(2.70), Inches(6.8), Inches(1.2))
    tf_p = tb_proj.text_frame
    tf_p.word_wrap = True
    p_p = tf_p.paragraphs[0]
    r_p = p_p.add_run()
    r_p.text = "NagarSetu"
    r_p.font.name = "Arial Black"
    r_p.font.size = Pt(44)
    r_p.font.bold = True
    r_p.font.color.rgb = COLOR_WHITE

    p_p2 = tf_p.add_paragraph()
    r_p2 = p_p2.add_run()
    r_p2.text = "नागरिकों और प्रशासन के बीच एक सेतु  |  Bridging Citizens. Empowering Cities."
    r_p2.font.name = "Segoe UI"
    r_p2.font.size = Pt(13)
    r_p2.font.color.rgb = COLOR_ACCENT

    # One-line value proposition in place of removed placeholder
    tb_vp = slide1.shapes.add_textbox(Inches(0.75), Inches(4.00), Inches(6.5), Inches(1.1))
    tf_vp = tb_vp.text_frame
    tf_vp.word_wrap = True
    p_vp = tf_vp.paragraphs[0]
    r_vp = p_vp.add_run()
    r_vp.text = "AI-Powered Civic Intelligence, Public Infrastructure Monitoring & Citizen-Verified Municipal Accountability Platform."
    r_vp.font.name = "Arial"
    r_vp.font.size = Pt(13.5)
    r_vp.font.color.rgb = RGBColor(225, 230, 240)

    # Team Name & Members in place of removed placeholder
    tb_team = slide1.shapes.add_textbox(Inches(0.75), Inches(5.35), Inches(6.5), Inches(1.1))
    tf_t = tb_team.text_frame
    p_t1 = tf_t.paragraphs[0]
    r_t1 = p_t1.add_run()
    r_t1.text = "TEAM: NAGARSETU INNOVATORS\n"
    r_t1.font.name = "Arial"
    r_t1.font.size = Pt(11)
    r_t1.font.bold = True
    r_t1.font.color.rgb = COLOR_WHITE

    p_t2 = tf_t.add_paragraph()
    r_t2 = p_t2.add_run()
    r_t2.text = "Full-Stack AI Engineering & Smart City Civic Infrastructure\nTrack: AI for Governance & Urban Accountability"
    r_t2.font.name = "Arial"
    r_t2.font.size = Pt(10)
    r_t2.font.color.rgb = COLOR_MUTED

    # =========================================================================
    # SLIDE 2: 02 THE PROBLEM (With Faded Background)
    # =========================================================================
    slide2 = prs.slides.add_slide(blank_layout)
    add_faded_slide_shell(
        slide2, "02", "08",
        title_text="02  The Problem",
        subtitle_text="Define the real-world challenge. Make the urgency clear and support it with evidence."
    )

    card2 = slide2.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(1.2), Inches(1.9), Inches(10.9), Inches(4.8))
    card2.fill.solid()
    card2.fill.fore_color.rgb = COLOR_CARD_BG
    card2.line.color.rgb = COLOR_CARD_BORDER

    sec1 = slide2.shapes.add_textbox(Inches(1.6), Inches(2.1), Inches(10.1), Inches(1.3))
    tf_s1 = sec1.text_frame
    tf_s1.word_wrap = True
    p1 = tf_s1.paragraphs[0]
    r1 = p1.add_run()
    r1.text = "The Core Problem: The Civic Grievance 'Black Hole' & Lack of Ground-Truth"
    r1.font.name = "Arial"
    r1.font.size = Pt(14)
    r1.font.bold = True
    r1.font.color.rgb = COLOR_DARK_TEXT

    p1_sub = tf_s1.add_paragraph()
    r1_sub = p1_sub.add_run()
    r1_sub.text = "Every year, millions of critical civic defects—potholes, waterlogging, exposed high-voltage wiring, overflowing garbage—are reported across Indian cities. Yet 4,000+ citizens die annually from road potholes alone. The system fails because complaints vanish into opaque municipal queues without automated severity triage, duplicate grouping, or verifiable ground-truth resolution proofs."
    r1_sub.font.name = "Arial"
    r1_sub.font.size = Pt(11)
    r1_sub.font.color.rgb = RGBColor(75, 85, 99)

    sec2 = slide2.shapes.add_textbox(Inches(1.6), Inches(3.55), Inches(10.1), Inches(1.3))
    tf_s2 = sec2.text_frame
    tf_s2.word_wrap = True
    p2 = tf_s2.paragraphs[0]
    r2 = p2.add_run()
    r2.text = "Who is Affected?"
    r2.font.name = "Arial"
    r2.font.size = Pt(14)
    r2.font.bold = True
    r2.font.color.rgb = COLOR_DARK_TEXT

    p2_sub = tf_s2.add_paragraph()
    r2_sub = p2_sub.add_run()
    r2_sub.text = "• Citizens & Commuters: Suffer vehicle damage, daily hazards, and civic helplessness with zero visibility.\n• Department Field Officers: Flooded with duplicate tickets, false alarms, and vague complaints lacking GPS or images.\n• City Administrators & ULBs: Lack real-time geographic failure heatmaps and have no way to audit contractor repairs."
    r2_sub.font.name = "Arial"
    r2_sub.font.size = Pt(11)
    r2_sub.font.color.rgb = RGBColor(75, 85, 99)

    sec3 = slide2.shapes.add_textbox(Inches(1.6), Inches(5.1), Inches(10.1), Inches(1.4))
    tf_s3 = sec3.text_frame
    tf_s3.word_wrap = True
    p3 = tf_s3.paragraphs[0]
    r3 = p3.add_run()
    r3.text = "Why Current Options Fall Short"
    r3.font.name = "Arial"
    r3.font.size = Pt(14)
    r3.font.bold = True
    r3.font.color.rgb = COLOR_DARK_TEXT

    p3_sub = tf_s3.add_paragraph()
    r3_sub = p3_sub.add_run()
    r3_sub.text = "Traditional portals (CPGRAMS, Swachhata apps) act as passive digital suggestion boxes. They lack computer vision verification, suffer from duplicate ticket flooding (the same pothole reported 50 times creates 50 tickets), assign arbitrary priority, and allow authorities to falsely mark tickets 'Closed' without citizen consent or photo audit proofs."
    r3_sub.font.name = "Arial"
    r3_sub.font.size = Pt(11)
    r3_sub.font.color.rgb = RGBColor(75, 85, 99)

    strip = slide2.shapes.add_shape(MSO_SHAPE.RECTANGLE, Inches(1.2), Inches(2.2), Inches(0.08), Inches(4.2))
    strip.fill.solid()
    strip.fill.fore_color.rgb = RGBColor(16, 185, 129)
    strip.line.fill.background()

    # =========================================================================
    # SLIDE 3: 03 THE SOLUTION (With Faded Background)
    # =========================================================================
    slide3 = prs.slides.add_slide(blank_layout)
    add_faded_slide_shell(
        slide3, "03", "08",
        title_text="03  The Solution",
        subtitle_text="Show how your idea directly solves the problem and why it is different."
    )

    sol_box = slide3.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.9), Inches(11.733), Inches(4.8))
    sol_box.fill.solid()
    sol_box.fill.fore_color.rgb = COLOR_SECONDARY_DARK
    sol_box.line.color.rgb = RGBColor(40, 48, 65)

    tf_sol = sol_box.text_frame
    tf_sol.word_wrap = True

    p_sol_h = tf_sol.paragraphs[0]
    r_sol_h = p_sol_h.add_run()
    r_sol_h.text = "NagarSetu: AI-Powered Civic Intelligence & Ground-Truth Accountability"
    r_sol_h.font.name = "Arial Black"
    r_sol_h.font.size = Pt(19)
    r_sol_h.font.color.rgb = COLOR_ACCENT

    p_sol_sub = tf_sol.add_paragraph()
    r_sol_sub = p_sol_sub.add_run()
    r_sol_sub.text = "A full-stack, closed-loop municipal intelligence platform that bridges citizens, field officers, and administrators.\n"
    r_sol_sub.font.name = "Arial"
    r_sol_sub.font.size = Pt(11.5)
    r_sol_sub.font.color.rgb = COLOR_WHITE

    pillars = [
        ("1. AI Defect Vision & Voice NLP", "Automatic CV defect localization (bounding boxes & severity score) + Web Speech NLP supporting Hindi, Punjabi & English vernacular audio reporting."),
        ("2. 50m Spatial Deduplication", "Haversine clustering detects existing complaints within 50m/72h. Citizens tap '+1 Endorse' to boost priority without flooding departments with duplicates."),
        ("3. Explainable 0-100 Priority Engine", "Transparent, formulaic prioritization: factors defect area, danger level, community endorsements, and SLA aging commitment (24h Critical to 7d Low)."),
        ("4. Citizen-Verified Ground Truth", "Officers must upload after-repair evidence. AI compares before vs after repair photos, and tickets CANNOT close without the reporting citizen's approval.")
    ]

    for p_title, p_desc in pillars:
        p_t = tf_sol.add_paragraph()
        r_t = p_t.add_run()
        r_t.text = f"✔ {p_title}: "
        r_t.font.name = "Arial"
        r_t.font.size = Pt(12)
        r_t.font.bold = True
        r_t.font.color.rgb = COLOR_ACCENT

        r_d = p_t.add_run()
        r_d.text = f"{p_desc}\n"
        r_d.font.name = "Arial"
        r_d.font.size = Pt(10.5)
        r_d.font.color.rgb = COLOR_MUTED

    out_p = tf_sol.add_paragraph()
    r_out = out_p.add_run()
    r_out.text = "Outcome: Eliminates 60% duplicate tickets, prevents fake contractor closures, and cuts resolution turnaround by 45%."
    r_out.font.name = "Arial"
    r_out.font.size = Pt(12)
    r_out.font.bold = True
    r_out.font.color.rgb = COLOR_WHITE

    # =========================================================================
    # SLIDE 4: 04 HOW IT WORKS (With Faded Background & 4 White Cards)
    # =========================================================================
    slide4 = prs.slides.add_slide(blank_layout)
    add_faded_slide_shell(
        slide4, "04", "08",
        title_text="04  How It Works",
        subtitle_text="Walk judges through the user journey or system flow in a few clear steps."
    )

    steps = [
        ("01", "INPUT", "Citizen Intake", "• Citizen captures photo/video with GPS location.\n• Optional voice description in Hindi, Punjabi, or English.\n• Automatic browser geolocation capture with pin refinement."),
        ("02", "PROCESS", "AI Pre-Triage", "• Computer vision segments defect with bounding boxes.\n• NLP extracts problem, urgency keywords, and location references.\n• 50m spatial check alerts if issue is already reported."),
        ("03", "CORE LOGIC", "Smart Triage & Routing", "• 0-100 Explainable Priority computed.\n• SLA target assigned (Critical: 24h, High: 48h, Mod: 5d).\n• Matrix router auto-assigns issue to 1 of 6 municipal departments."),
        ("04", "OUTPUT", "Closed-Loop Verification", "• Officer executes ground repair & uploads after-photo.\n• AI runs before/after difference comparison.\n• Citizen receives prompt to verify ground fix or reopen ticket.")
    ]

    card_width = Inches(2.7)
    card_height = Inches(4.7)
    card_gap = Inches(0.28)
    start_left = Inches(0.8)

    for i, (num, tag, title, body) in enumerate(steps):
        c_left = start_left + i * (card_width + card_gap)
        c_box = slide4.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, c_left, Inches(1.9), card_width, card_height)
        c_box.fill.solid()
        c_box.fill.fore_color.rgb = COLOR_CARD_BG
        c_box.line.color.rgb = COLOR_CARD_BORDER

        tf_c = c_box.text_frame
        tf_c.word_wrap = True

        p_n = tf_c.paragraphs[0]
        r_n = p_n.add_run()
        r_n.text = f"{num}\n"
        r_n.font.name = "Arial Black"
        r_n.font.size = Pt(14)
        r_n.font.color.rgb = RGBColor(16, 185, 129)

        p_tg = tf_c.add_paragraph()
        r_tg = p_tg.add_run()
        r_tg.text = f"{tag}\n"
        r_tg.font.name = "Arial Black"
        r_tg.font.size = Pt(13)
        r_tg.font.color.rgb = COLOR_DARK_TEXT

        p_t = tf_c.add_paragraph()
        r_t = p_t.add_run()
        r_t.text = f"{title}\n\n"
        r_t.font.name = "Arial"
        r_t.font.size = Pt(11)
        r_t.font.bold = True
        r_t.font.color.rgb = RGBColor(107, 114, 128)

        p_b = tf_c.add_paragraph()
        r_b = p_b.add_run()
        r_b.text = body
        r_b.font.name = "Arial"
        r_b.font.size = Pt(10)
        r_b.font.color.rgb = RGBColor(55, 65, 81)

    # =========================================================================
    # SLIDE 5: 05 BUSINESS MODEL (With Faded Background & 3 White Cards)
    # =========================================================================
    slide5 = prs.slides.add_slide(blank_layout)
    add_faded_slide_shell(
        slide5, "05", "08",
        title_text="05  Business Model",
        subtitle_text="Show how the idea creates value in the real world and how it can be sustained."
    )

    bm_cards = [
        ("01", "Primary User / Customer", [
            ("Municipal Corporations (ULBs / Smart City SPVs):", "B2G SaaS enterprise subscription for city-wide dashboard, SLA enforcement, and automated dispatch."),
            ("Utility & Infrastructure Contractors:", "PWD, DISCOMs, Jal Board, NHAI for transparent repair audits and performance scorecards."),
            ("Citizens (Free Co-Governors):", "Zero-friction progressive web app (PWA) with instant voice/image reporting and community endorsement.")
        ]),
        ("02", "Practical Use Case", [
            ("Scenario:", "Heavy rain creates a dangerous pothole near a school road in Barakhamba."),
            ("Citizen Report:", "Commuter records voice note in Hindi: 'Sadak par bahut bada gaddha hai'. NagarSetu AI annotates defect, scores Priority 88/100, assigns 24h SLA."),
            ("Community Validation:", "12 other commuters tap '+1 Endorse' on the public live map."),
            ("Resolution & Audit:", "Road Dept repairs road, uploads photo. AI calculates 92% clearance. Original citizen inspects and verifies resolution on their smartphone.")
        ]),
        ("03", "Value Created", [
            ("60% Reduction in Duplicate Work:", "Consolidates multiple complaints into single actionable work-orders."),
            ("Elimination of Fake Closures:", "No contractor gets paid without verified after-photo and citizen sign-off."),
            ("Litigation & Accident Prevention:", "Rapid remediation of high-voltage wires and hazardous road craters saves lives and protects public funds.")
        ])
    ]

    bm_width = Inches(3.7)
    bm_height = Inches(4.7)
    bm_gap = Inches(0.31)
    bm_start_left = Inches(0.8)

    for i, (num, heading, items) in enumerate(bm_cards):
        b_left = bm_start_left + i * (bm_width + bm_gap)
        b_box = slide5.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, b_left, Inches(1.9), bm_width, bm_height)
        b_box.fill.solid()
        b_box.fill.fore_color.rgb = COLOR_CARD_BG
        b_box.line.color.rgb = COLOR_CARD_BORDER

        tf_b = b_box.text_frame
        tf_b.word_wrap = True

        p_num = tf_b.paragraphs[0]
        r_num = p_num.add_run()
        r_num.text = f"{num}\n"
        r_num.font.name = "Arial Black"
        r_num.font.size = Pt(13)
        r_num.font.color.rgb = RGBColor(16, 185, 129)

        p_hd = tf_b.add_paragraph()
        r_hd = p_hd.add_run()
        r_hd.text = f"{heading}\n\n"
        r_hd.font.name = "Arial Black"
        r_hd.font.size = Pt(13)
        r_hd.font.color.rgb = COLOR_DARK_TEXT

        for sub_h, text in items:
            p_it = tf_b.add_paragraph()
            r_sh = p_it.add_run()
            r_sh.text = f"• {sub_h} "
            r_sh.font.name = "Arial"
            r_sh.font.size = Pt(10)
            r_sh.font.bold = True
            r_sh.font.color.rgb = COLOR_DARK_TEXT

            r_tx = p_it.add_run()
            r_tx.text = f"{text}\n"
            r_tx.font.name = "Arial"
            r_tx.font.size = Pt(9.5)
            r_tx.font.color.rgb = RGBColor(75, 85, 99)

    # =========================================================================
    # SLIDE 6: 06 TECH STACK (With Faded Background & 3 Spec Cards)
    # =========================================================================
    slide6 = prs.slides.add_slide(blank_layout)
    add_faded_slide_shell(
        slide6, "06", "08",
        title_text="06  Tech Stack",
        subtitle_text="Keep the stack factual. Highlight the technologies that make the prototype work."
    )

    tech_categories = [
        ("Frontend & PWA", "Client-Side", [
            ("Framework", "React 19, TypeScript, Vite"),
            ("Styling & UI", "Tailwind CSS, Lucide React, Glassmorphism"),
            ("Geospatial UI", "Leaflet, React-Leaflet, OpenStreetMap"),
            ("Audio Interface", "Web Speech API (Hindi, Punjabi, English Voice)")
        ]),
        ("Backend & APIs", "Server-Side", [
            ("API Engine", "FastAPI (Python 3.13), Uvicorn"),
            ("Data Modeling", "Pydantic v2, SQLAlchemy ORM"),
            ("Security & Auth", "OAuth2, JWT Tokens, Passlib / BCrypt"),
            ("Database", "SQLite (Development) / PostgreSQL (Production)")
        ]),
        ("AI, CV & Spatial", "Intelligence Core", [
            ("Computer Vision", "OpenCV Headless, Defect Bounding Box Gen"),
            ("Evidence Audit", "Structural Image Differencing & SSIM"),
            ("Spatial Deduplication", "Haversine Proximity Matrix (50m Radius)"),
            ("Predictive Engine", "DBSCAN Spatial Density & Recurrence Risk")
        ])
    ]

    t_width = Inches(3.7)
    t_height = Inches(4.7)
    t_gap = Inches(0.31)
    t_start_left = Inches(0.8)

    for i, (cat_title, cat_badge, specs) in enumerate(tech_categories):
        t_left = t_start_left + i * (t_width + t_gap)
        t_box = slide6.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, t_left, Inches(1.9), t_width, t_height)
        t_box.fill.solid()
        t_box.fill.fore_color.rgb = COLOR_SECONDARY_DARK
        t_box.line.color.rgb = RGBColor(40, 48, 65)

        tf_t = t_box.text_frame
        tf_t.word_wrap = True

        p_t_hd = tf_t.paragraphs[0]
        r_t_hd = p_t_hd.add_run()
        r_t_hd.text = f"{cat_title}\n"
        r_t_hd.font.name = "Arial Black"
        r_t_hd.font.size = Pt(14)
        r_t_hd.font.color.rgb = COLOR_ACCENT

        p_t_sub = tf_t.add_paragraph()
        r_t_sub = p_t_sub.add_run()
        r_t_sub.text = f"[{cat_badge}]\n\n"
        r_t_sub.font.name = "Arial"
        r_t_sub.font.size = Pt(9.5)
        r_t_sub.font.color.rgb = COLOR_MUTED

        for label, val in specs:
            p_s = tf_t.add_paragraph()
            r_lb = p_s.add_run()
            r_lb.text = f"• {label}:\n  "
            r_lb.font.name = "Arial"
            r_lb.font.size = Pt(10)
            r_lb.font.bold = True
            r_lb.font.color.rgb = COLOR_WHITE

            r_v = p_s.add_run()
            r_v.text = f"{val}\n"
            r_v.font.name = "Arial"
            r_v.font.size = Pt(9.5)
            r_v.font.color.rgb = COLOR_MUTED

    # =========================================================================
    # SLIDE 7: 07 THE ROLLOUT PLAN (With Faded Background & 3 White Cards)
    # =========================================================================
    slide7 = prs.slides.add_slide(blank_layout)
    add_faded_slide_shell(
        slide7, "07", "08",
        title_text="07  The Rollout Plan",
        subtitle_text="Show a credible path from hackathon prototype to pilot and wider adoption."
    )

    phases = [
        ("01", "NOW", "Build & Validate", "Working Prototype & Core Testing", [
            ("Fully Operational Platform:", "11 civic defect categories, 13 lifecycle states, 6 municipal departments."),
            ("AI Engine Live:", "CV defect bounding boxes, Hindi/Punjabi/English NLP, 50m spatial deduplication."),
            ("Tested & Audited:", "End-to-end Python test suite passing with 100% test coverage.")
        ]),
        ("02", "NEXT", "Pilot", "Municipal Ward Sandbox (90 Days)", [
            ("Target Deployment:", "Pilot in 2 high-density municipal zones (e.g., NDMC Central Delhi)."),
            ("User Onboarding:", "50 ward junior engineers, 10 sanitary inspectors, and 5,000 citizens."),
            ("Key Metrics:", "Measure Mean Time to Repair (MTTR), duplicate reduction %, and citizen satisfaction.")
        ]),
        ("03", "THEN", "Improve & Scale", "City-Wide Scaling & Integration", [
            ("Smart City ICCC Integration:", "Connect with Integrated Command & Control Centers via National Urban Digital Mission (NUDM) APIs."),
            ("Edge AI on Municipal Fleets:", "Mount camera inference modules on city buses/garbage trucks for automated road defect discovery."),
            ("Predictive Budget Allocation:", "Use hotspot recurrence data for preventive annual municipal budget allocation.")
        ])
    ]

    r_width = Inches(3.7)
    r_height = Inches(4.7)
    r_gap = Inches(0.31)
    r_start_left = Inches(0.8)

    for i, (num, phase_tag, title, subtitle, bullets) in enumerate(phases):
        r_left = r_start_left + i * (r_width + r_gap)
        r_box = slide7.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, r_left, Inches(1.9), r_width, r_height)
        r_box.fill.solid()
        r_box.fill.fore_color.rgb = COLOR_CARD_BG
        r_box.line.color.rgb = COLOR_CARD_BORDER

        tf_r = r_box.text_frame
        tf_r.word_wrap = True

        p_n = tf_r.paragraphs[0]
        r_n = p_n.add_run()
        r_n.text = f"{num}   "
        r_n.font.name = "Arial Black"
        r_n.font.size = Pt(13)
        r_n.font.color.rgb = RGBColor(16, 185, 129)

        r_pt = p_n.add_run()
        r_pt.text = f"{phase_tag}\n"
        r_pt.font.name = "Arial"
        r_pt.font.size = Pt(10)
        r_pt.font.bold = True
        r_pt.font.color.rgb = COLOR_MUTED

        p_t = tf_r.add_paragraph()
        r_t = p_t.add_run()
        r_t.text = f"{title}\n"
        r_t.font.name = "Arial Black"
        r_t.font.size = Pt(13)
        r_t.font.color.rgb = COLOR_DARK_TEXT

        p_sub = tf_r.add_paragraph()
        r_sub = p_sub.add_run()
        r_sub.text = f"{subtitle}\n\n"
        r_sub.font.name = "Arial"
        r_sub.font.size = Pt(9.5)
        r_sub.font.color.rgb = RGBColor(107, 114, 128)

        for b_hd, b_tx in bullets:
            p_b = tf_r.add_paragraph()
            r_bh = p_b.add_run()
            r_bh.text = f"• {b_hd} "
            r_bh.font.name = "Arial"
            r_bh.font.size = Pt(10)
            r_bh.font.bold = True
            r_bh.font.color.rgb = COLOR_DARK_TEXT

            r_bt = p_b.add_run()
            r_bt.text = f"{b_tx}\n"
            r_bt.font.name = "Arial"
            r_bt.font.size = Pt(9.5)
            r_bt.font.color.rgb = RGBColor(75, 85, 99)

    # =========================================================================
    # SLIDE 8: 08 OPTIONAL SLIDE - COMPETITIVE ADVANTAGE (With Faded Background)
    # =========================================================================
    slide8 = prs.slides.add_slide(blank_layout)
    add_faded_slide_shell(
        slide8, "08", "08",
        title_text="08  Competitive Advantage & Municipal Impact",
        subtitle_text="Additions from our side: Why NagarSetu outperforms legacy grievance portals."
    )

    moat_box = slide8.shapes.add_shape(MSO_SHAPE.ROUNDED_RECTANGLE, Inches(0.8), Inches(1.9), Inches(11.733), Inches(4.8))
    moat_box.fill.solid()
    moat_box.fill.fore_color.rgb = COLOR_SECONDARY_DARK
    moat_box.line.color.rgb = RGBColor(40, 48, 65)

    tf_m = moat_box.text_frame
    tf_m.word_wrap = True

    p_m_hd = tf_m.paragraphs[0]
    r_m_hd = p_m_hd.add_run()
    r_m_hd.text = "How NagarSetu Compares to Existing Grievance Portals\n"
    r_m_hd.font.name = "Arial Black"
    r_m_hd.font.size = Pt(17)
    r_m_hd.font.color.rgb = COLOR_ACCENT

    table_data = [
        ("Feature Dimension", "Legacy Apps (CPGRAMS / Swachhata)", "NagarSetu AI Platform"),
        ("Defect Intake", "Manual text form, easily mistyped", "Computer Vision bounding boxes + Hindi/English Voice"),
        ("Duplicate Handling", "No deduplication; identical complaints clog queue", "50m Spatial Clustering + 1-Tap Community Endorsements"),
        ("Priority Triage", "First-in first-out (FIFO) or subjective officer whim", "Explainable 0-100 Score with strict SLA countdowns"),
        ("Resolution Verification", "Unilateral closure by officer with no validation", "Mandatory Before/After Photo AI Audit + Citizen Sign-Off"),
        ("Analytics & Maintenance", "Static monthly PDF grievance counts", "Predictive Density Hotspots & Recurrence Risk Forecasting")
    ]

    for f_dim, leg, ns in table_data[1:]:
        p_row = tf_m.add_paragraph()
        r_f = p_row.add_run()
        r_f.text = f"• {f_dim}: "
        r_f.font.name = "Arial"
        r_f.font.size = Pt(11.5)
        r_f.font.bold = True
        r_f.font.color.rgb = COLOR_WHITE

        r_vs = p_row.add_run()
        r_vs.text = f"Legacy: {leg}  ➜  "
        r_vs.font.name = "Arial"
        r_vs.font.size = Pt(10)
        r_vs.font.color.rgb = COLOR_MUTED

        r_ns = p_row.add_run()
        r_ns.text = f"NagarSetu: {ns}\n"
        r_ns.font.name = "Arial"
        r_ns.font.size = Pt(10.5)
        r_ns.font.bold = True
        r_ns.font.color.rgb = COLOR_ACCENT

    p_bot = tf_m.add_paragraph()
    r_bot = p_bot.add_run()
    r_bot.text = "Key Municipal Value: Transitions civic governance from reactive complaint-handling to proactive, accountable smart-city intelligence."
    r_bot.font.name = "Arial"
    r_bot.font.size = Pt(12)
    r_bot.font.bold = True
    r_bot.font.color.rgb = COLOR_WHITE

    # Attempt to save to target or next available version if file is open in PowerPoint
    candidate_paths = [
        output_path,
        output_path.replace(".pptx", "_v2.pptx"),
        output_path.replace(".pptx", "_v3.pptx"),
        output_path.replace(".pptx", "_v4.pptx"),
        output_path.replace(".pptx", "_Latest.pptx")
    ]

    saved_path = None
    for p in candidate_paths:
        try:
            prs.save(p)
            saved_path = p
            print(f"Presentation successfully saved to: {p}")
            break
        except PermissionError:
            continue

    if not saved_path:
        import time
        ts_path = output_path.replace(".pptx", f"_{int(time.time())}.pptx")
        prs.save(ts_path)
        print(f"All standard names locked by PowerPoint. Saved to: {ts_path}")

if __name__ == "__main__":
    out_file = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "NagarSetu_The_Builders_Theory_Presentation.pptx")
    create_nagarsetu_presentation(out_file)
