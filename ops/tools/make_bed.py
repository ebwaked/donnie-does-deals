# Original Donnie Does Deals music bed: mandolin tremolo + walking upright bass + brushes. A minor, 92 BPM.
import numpy as np, wave
SR=44100; BPM=92; beat=60/BPM; bars=12; L=int(SR*beat*4*bars)+SR*2
rng=np.random.default_rng(7)
SOFT=0.6  # 0 = bright/twangy, 1 = very soft
def ks(freq,dur,decay=0.996,bright=0.5):
    n=int(SR*dur); p=int(SR/freq); buf=rng.uniform(-1,1,p)
    k=max(1,int(round(1+SOFT*8))); buf=np.convolve(np.tile(buf,3),np.ones(k)/k,'same')[p:2*p]
    buf=np.convolve(buf,[bright,1-bright],'same'); out=np.zeros(n)
    for i in range(n):
        out[i]=buf[i%p]; buf[i%p]=decay*0.5*(buf[i%p]+buf[(i+1)%p])
    a=int(SR*0.008); out[:a]*=np.linspace(0,1,a)
    return out
def nf(name):
    names={'C':0,'C#':1,'D':2,'D#':3,'E':4,'F':5,'F#':6,'G':7,'G#':8,'A':9,'A#':10,'B':11}
    n,o=name[:-1],int(name[-1]); return 440*2**((names[n]+12*(o-4)-9)/12)
mix=np.zeros(L)
def add(sig,t,g):
    i=int(t*SR); j=min(L,i+len(sig)); mix[i:j]+=g*sig[:j-i]
# progression (one chord per bar): Am Dm E7 Am / F Dm E7 Am / Am Dm E7 Am
prog=[('A3','C4','E4'),('D4','F4','A4'),('E4','G#4','D5'),('A3','C4','E4'),('F3','A3','C4'),('D4','F4','A4'),('E4','G#4','B4'),('A3','C4','E4')]*2
bass=[['A2','C3','E3','G#2'],['D2','F2','A2','C3'],['E2','G#2','B2','D3'],['A2','E2','A2','B2'],['F2','A2','C3','E3'],['D2','F2','A2','B2'],['E2','D3','B2','G#2'],['A2','E2','A2','A2']]*2
cache={}
def pl(n,dur,dec,br):
    k=(n,dur,dec,br)
    if k not in cache: cache[k]=ks(nf(n),dur,dec,br)
    return cache[k]
for b in range(bars):
    t0=b*4*beat; ch=prog[b]
    # mandolin tremolo: 8th-note-triplet picking on the top two chord tones, doubled strings slightly detuned
    step=beat/2
    for k in range(8):
        n=ch[1+(k%2)]; sig=pl(n,0.6,0.995,0.5)
        env=np.exp(-np.arange(len(sig))/SR*4); add(sig*env,t0+k*step,0.055 if k%2 else 0.075)
    # chord strum on beats 2 and 4 (light)
    d=int(SR*beat*4); tt=np.arange(d)/SR; envp=np.minimum(1,tt/0.35)*np.minimum(1,(d/SR-tt)/0.3)
    pad=sum(np.sin(2*np.pi*nf(n)*tt)+0.3*np.sin(4*np.pi*nf(n)*tt) for n in ch)*envp
    add(pad,t0,0.035)
    # walking bass, quarter notes
    for bt,n in enumerate(bass[b]): add(pl(n,beat*1.1,0.9985,0.85)*np.exp(-np.arange(int(SR*beat*1.1))/SR*2.5),t0+bt*beat,0.55)
    # brushes: soft noise swish each beat, accent 2 and 4
    for bt in range(4):
        d=int(SR*0.18); sw=rng.normal(0,1,d)*np.hanning(d)
        sw=np.convolve(sw,np.ones(6)/6,'same'); add(sw,t0+bt*beat,0.02 if bt in (1,3) else 0.01)
# simple room reverb
ir_n=int(SR*1.6); ir=rng.normal(0,1,ir_n)*np.exp(-np.arange(ir_n)/SR*4.5); ir[0]=1
wet=np.fft.irfft(np.fft.rfft(mix,len(mix)+ir_n)*np.fft.rfft(ir,len(mix)+ir_n))[:L]
out=mix*0.75+wet/np.max(np.abs(wet))*np.max(np.abs(mix))*0.35
fade=int(SR*1.5); out[-fade:]*=np.linspace(1,0,fade); out/=np.max(np.abs(out))*1.12
st=np.stack([out,np.roll(out,int(SR*0.011))],1)
w=wave.open('ddd_bed_v2.wav','wb'); w.setnchannels(2); w.setsampwidth(2); w.setframerate(SR); w.writeframes((st*32767).astype(np.int16).tobytes()); w.close()
print('dur',len(out)/SR)
