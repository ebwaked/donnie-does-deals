# Production rules — Donnie on camera

Standing rules for every episode. Added 2026-10-28 after Eddie flagged that Donnie's voice and mouth didn't sync well.

## Why the early episodes synced badly
Measured with `ops/tools/synccheck.py` (correlation between mouth opening and voice loudness, frame by frame; 1.0 = perfect):

| Clip | Framing | Score |
|---|---|---|
| Therapist reverse shots (pilot 1) | Close-up, face fills frame, 3s per line | 0.72–0.76 |
| Donnie on the couch (pilot 1) | Wide, face small, 12s single take | 0.31 (face found in only 38% of frames) |
| Donnie in the diner (pilot 2) | Medium-wide, waving a folder, 9s take | 0.09–0.18 |

The model syncs well when the face is big and the shot is short and simple. It drifts when the face is small,
the take is long, or the prompt asks for prop business (slapping folders, pulling phones).

## Rules
1. **Framing:** tight medium close-up or closer. Donnie's face is at least a third of the frame width in the keyframe.
2. **One line per clip, 3–5 seconds.** Cut between lines. Never one long take for the whole script.
3. **Pad each line:** 0.3s silence in front, padded to the clip length (3 or 5s), mp3. Cut the clip from 0.3s.
4. **Prompt for the mouth, not the hands:** "speaks directly into the camera, lips precisely synced to the audio with
   clear, well-articulated mouth shapes; head mostly still; hands out of frame; camera locked off." Put actions
   (props, phone, key fob) in B-roll or type cards, not in talking shots.
5. **1080p**, not 720p (wan2_7 at 2.5 credits/s). Then a static 1.2x crop in the edit so the face reads bigger on a phone.
   Vary the crop (1.2x / 1.35x) between lines so cuts don't look like jump cuts.
6. **Gate:** run `ops/tools/synccheck.py` on every talking clip and look at the mouth. Re-take anything that looks off
   before it goes in the cut. Note the score is unreliable on lines that end in a big grin or are one unbroken run of
   speech; check those by eye.
7. Use the clean VO track for the final mix (not the clip's audio), so all lines match in level.

## Reference build
`ops/tools/build_fuhged-newcar.sh` (pilot 3): three per-line clips, punch-in crops, hook, captions, bed, endcard.

## Ending (added 2026-10-28)
Pilot 3's punchline ("Car keys after.") ended 0.04s before the cut to the endcard, so it felt clipped. From now on:
- Hold **at least 0.7s** on Donnie after the last word of the punchline (let the reaction land), then cut to the endcard.
- QC gate: last word's end time (from the ASR word timings) must be ≥0.7s before the endcard cut, or the build fails.

## Music (added 2026-10-28)
- **Never use MindShark's beds** (`bed_swagger` etc.). Donnie gets his own sound.
- Until a Donnie track is chosen, use the original bed from `ops/tools/make_bed.py` (v2, softened per Eddie 2026-10-28: SOFT=0.6, mix with lowpass 4.5 kHz)
  or no music. A licensed track Eddie picks replaces it when there is one.

## Voice takes (added 2026-10-28)
Seed Audio stops at the end of the `[00:00-00:XX]` window even mid-word. Ep. 2's first take cut off "eight hundred".
- Give the window at least 30% more time than the read needs.
- Gate: `ops/tools/vocheck.py` on every take. Fails if the file is still loud at the end or the last word runs to
  within 0.15s of the end. Re-record on fail.

## Framing note (2026-10-28)
wan2_7 sometimes returns a wider shot than the keyframe. Crop per shot in the edit, and check the reaction beat at the
end stays inside the crop (Ep. 2's head-back reaction needed a looser crop).

## Lip-sync check by eye (added 2026-10-30)
The numeric score in `synccheck.py` is unreliable on Donnie (beard and mustache confuse the face tracker). Use
`ops/tools/mouthstrip.py <clip> <out.png>`: mouth crops every 0.1s with the voice level under each frame. Read it:
the mouth should open when the red bar starts, not before.
- Found 2026-10-30: wan2_7 often opens Donnie's mouth **0.25–0.4s before the sound** (anticipation), especially on the
  first word after a pause. Fix per shot in the edit by delaying the video (negative offset in the build script,
  e.g. `O2=-0.4`), re-check with the strip, or re-take if it's worse than that.
- The therapist clips track well; still strip-check them.
- Tried Grok Video 1.5 as an alternative: it can't take a start frame together with audio, and the test job failed.
  Seedance 2.5 with audio costs ~16 credits/s (vs 2.5 for wan). Staying on wan2_7 + strip check + offsets.
