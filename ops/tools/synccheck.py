import sys, subprocess, numpy as np, cv2, wave, os, tempfile
import mediapipe as mp
def mouth_series(path):
    cap=cv2.VideoCapture(path); fps=cap.get(cv2.CAP_PROP_FPS) or 30
    from mediapipe.tasks.python import vision, BaseOptions
    fm=vision.FaceLandmarker.create_from_options(vision.FaceLandmarkerOptions(base_options=BaseOptions(model_asset_path=os.path.join(os.path.dirname(os.path.abspath(__file__)),'face_landmarker.task')),running_mode=vision.RunningMode.VIDEO,num_faces=1))
    vals=[]; i=0
    while True:
        ok,f=cap.read()
        if not ok: break
        r=fm.detect_for_video(mp.Image(image_format=mp.ImageFormat.SRGB,data=cv2.cvtColor(f,cv2.COLOR_BGR2RGB)),int(i*1000/fps)); i+=1
        if r.face_landmarks:
            l=r.face_landmarks[0]
            face=abs(l[10].y-l[152].y)+1e-6
            vals.append(abs(l[13].y-l[14].y)/face)
        else: vals.append(np.nan)
    return np.array(vals), fps
def audio_env(path,fps,n):
    t=tempfile.mktemp(suffix='.wav'); subprocess.run(['ffmpeg','-loglevel','error','-y','-i',path,'-ac','1','-ar','16000',t])
    w=wave.open(t); a=np.frombuffer(w.readframes(w.getnframes()),dtype=np.int16).astype(np.float32)/32768
    hop=16000/fps; return np.array([np.sqrt(np.mean(a[int(i*hop):int((i+1)*hop)]**2)+1e-9) for i in range(n)])
def z(x): x=np.nan_to_num(x,nan=np.nanmean(x)); return (x-x.mean())/(x.std()+1e-9)
for p in sys.argv[1:]:
    m,fps=mouth_series(p); e=audio_env(p,fps,len(m))
    det=np.mean(~np.isnan(m))
    le=np.log(e); sp=np.where(le>le.max()-3.5)[0]; a0=max(0,sp.min()-6); a1=min(len(m),sp.max()+7)
    m=m[a0:a1]; e=e[a0:a1]; mz=z(m); ez=z(np.log(e))
    lags=range(-12,13); cs=[np.mean(mz[max(0,k):len(mz)+min(0,k)]*ez[max(0,-k):len(ez)-max(0,k)]) for k in lags]
    best=int(np.argmax(cs)); 
    # onset check: after each pause, does the mouth start opening when the sound starts?
    le2=np.log(e); thr=le2.max()-3.0; on=[]
    for i in range(6,len(le2)):
        if le2[i]>thr and np.all(le2[i-6:i]<=thr):
            w0,w1=max(1,i-15),min(len(m)-1,i+10); d=np.diff(np.nan_to_num(m[w0:w1+1],nan=np.nanmean(m)))
            on.append((i-(w0+1+int(np.argmax(d))))/fps)
    lead=np.median(on) if on else float('nan')
    print(f"   onsets={len(on)} mouth leads sound by median {lead*1000:+.0f}ms (positive = mouth early)")
    print(f"{os.path.basename(p)}: face {det:.0%}, corr@0={cs[12]:.2f}, best lag={list(lags)[best]/fps*1000:+.0f}ms corr={cs[best]:.2f}, mouth range={np.nanpercentile(m,95)-np.nanpercentile(m,5):.3f}")
