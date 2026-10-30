# Mouth strip: mouth crops at 10 fps with the voice level under each frame, for eyeballing lip sync.
import sys, os, subprocess, wave, tempfile, numpy as np, cv2, mediapipe as mp
from mediapipe.tasks.python import vision, BaseOptions
from PIL import Image, ImageDraw
def strip(path, out, t0=0.0, t1=None, step=0.1):
    fm=vision.FaceLandmarker.create_from_options(vision.FaceLandmarkerOptions(base_options=BaseOptions(model_asset_path=os.path.join(os.path.dirname(os.path.abspath(__file__)),'face_landmarker.task')),running_mode=vision.RunningMode.IMAGE,num_faces=1))
    cap=cv2.VideoCapture(path); fps=cap.get(cv2.CAP_PROP_FPS); n=int(cap.get(cv2.CAP_PROP_FRAME_COUNT)); t1=t1 or n/fps
    tmp=tempfile.mktemp(suffix='.wav'); subprocess.run(['ffmpeg','-loglevel','error','-y','-i',path,'-ac','1','-ar','16000',tmp])
    w=wave.open(tmp); a=np.frombuffer(w.readframes(w.getnframes()),dtype=np.int16).astype(np.float32)/32768
    tiles=[]; box=None
    for t in np.arange(t0,t1,step):
        cap.set(cv2.CAP_PROP_POS_FRAMES,int(t*fps)); ok,f=cap.read()
        if not ok: break
        r=fm.detect(mp.Image(image_format=mp.ImageFormat.SRGB,data=cv2.cvtColor(f,cv2.COLOR_BGR2RGB)))
        if r.face_landmarks:
            l=r.face_landmarks[0]; h,wd=f.shape[:2]; cx=(l[61].x+l[291].x)/2*wd; cy=(l[13].y+l[14].y)/2*h; s=abs(l[291].x-l[61].x)*wd*1.6
            box=(int(cx-s),int(cy-s*0.7),int(cx+s),int(cy+s*0.7))
        if box is None: continue
        im=Image.fromarray(cv2.cvtColor(f,cv2.COLOR_BGR2RGB)).crop(box).resize((120,84))
        seg=a[int(t*16000):int((t+step)*16000)]; db=20*np.log10(np.sqrt(np.mean(seg**2))+1e-9)
        c=Image.new('RGB',(120,110),'white'); c.paste(im,(0,0)); d=ImageDraw.Draw(c)
        bar=max(0,int((db+50)*2.2)); d.rectangle([0,90,bar,104],fill=(200,60,60)); d.text((2,86),f"{t:.1f}",fill=(0,0,0))
        tiles.append(c)
    cols=20; rows=(len(tiles)+cols-1)//cols; o=Image.new('RGB',(cols*122,rows*112),'gray')
    for i,c in enumerate(tiles): o.paste(c,((i%cols)*122,(i//cols)*112))
    o.save(out)
if __name__=='__main__':
    strip(sys.argv[1],sys.argv[2])
