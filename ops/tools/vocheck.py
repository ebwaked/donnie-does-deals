# VO gate: last 0.25s must be silent (take not cut off), and ASR words printed with timings.
import sys, subprocess, wave, numpy as np, tempfile
from faster_whisper import WhisperModel
m=WhisperModel("small.en",device="cpu",compute_type="int8"); ok=True
for f in sys.argv[1:]:
    t=tempfile.mktemp(suffix='.wav'); subprocess.run(['ffmpeg','-loglevel','error','-y','-i',f,'-ac','1','-ar','16000',t])
    w=wave.open(t); a=np.frombuffer(w.readframes(w.getnframes()),dtype=np.int16).astype(np.float32)/32768
    tail=20*np.log10(np.sqrt(np.mean(a[-4000:]**2))+1e-9)
    ws=[x for s in m.transcribe(a,word_timestamps=True)[0] for x in s.words]
    gap=len(a)/16000-(ws[-1].end if ws else 0)
    cut=(tail>-30) or (gap<0.15)   # still loud at the end, or last word runs into the end of the file
    print(f"{f}: dur {len(a)/16000:.2f}s tail {tail:.0f} dB gap-after-last-word {gap:.2f}s {'CUT OFF' if cut else 'ok'}")
    print('   '+' '.join(f"{x.word.strip()}[{x.start:.2f}-{x.end:.2f}]" for x in ws)); ok&=not cut
sys.exit(0 if ok else 1)
