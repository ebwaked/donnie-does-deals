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
