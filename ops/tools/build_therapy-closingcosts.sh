#!/usr/bin/env bash
# Therapy Ep. 3 "Closing Costs". D1 5.04 | T1 1.40 | D2 4.66 | T2 2.85 | D3 4.35 (0.8s hold after punchline)
set -euo pipefail
S=/tmp/claude-0/-home-claude/78ec04d5-29fd-5ca6-94f4-999a4ff9e093/scratchpad; P=$S/p6; B=$S/pilot1/build
FONTS=/home/claude/donnie-does-deals/brand/fonts
O1=${O1:-0}; O2=${O2:-0}; O3=${O3:-0}; O4=${O4:-0}; O5=${O5:-0}
C1=${C1:-"crop=iw*0.85:iw*0.85*16/9:iw*0.11:ih*0.03,scale=1080:1920:flags=lanczos"}
C3=${C3:-"crop=iw*0.70:iw*0.70*16/9:iw*0.15:ih*0.06,scale=1080:1920:flags=lanczos"}
C5=${C5:-"crop=iw*0.85:iw*0.85*16/9:iw*0.08:ih*0.03,scale=1080:1920:flags=lanczos"}
PT="scale=1080:1920:flags=lanczos"
NV="fps=30,setsar=1,format=yuv420p,settb=AVTB"; NA="aresample=48000,aformat=sample_fmts=fltp:channel_layouts=stereo,asettb=AVTB"
r(){ python3 -c "print(round($1,3))"; }
cd $P
ffmpeg -loglevel error -y -i c1.mp4 -i th1.mp4 -i c2.mp4 -i th2.mp4 -i c3.mp4 -i tw.wav -i th1.wav -i th2.wav -loop 1 -i hook.png -i bed.wav -filter_complex "
 [0:v]$C1,$NV,trim=$(r 0.3+$O1):$(r 0.3+$O1+5.04),setpts=PTS-STARTPTS[v1];
 [1:v]$PT,$NV,trim=$(r 0.3+$O2):$(r 0.3+$O2+1.40),setpts=PTS-STARTPTS[v2];
 [2:v]$C3,$NV,trim=$(r 0.3+$O3):$(r 0.3+$O3+4.66),setpts=PTS-STARTPTS[v3];
 [3:v]$PT,$NV,trim=$(r 0.3+$O4):$(r 0.3+$O4+2.85),setpts=PTS-STARTPTS[v4];
 [4:v]$C5,$NV,trim=$(r 0.3+$O5):$(r 0.3+$O5+4.35),setpts=PTS-STARTPTS[v5];
 [5:a]$NA,asplit=3[w1][w2][w3];
 [w1]atrim=0.25:5.29,asetpts=PTS-STARTPTS[a1];
 [6:a]$NA,atrim=0.3:1.7,asetpts=PTS-STARTPTS[a2];
 [w2]atrim=5.29:9.95,asetpts=PTS-STARTPTS[a3];
 [7:a]$NA,atrim=0.3:3.15,asetpts=PTS-STARTPTS[a4];
 [w3]atrim=9.95:14.30,asetpts=PTS-STARTPTS[a5];
 [v1][a1][v2][a2][v3][a3][v4][a4][v5][a5]concat=n=5:v=1:a=1[cv][ca];
 [8:v]format=rgba,trim=0:2.6,fade=t=out:st=2.3:d=0.3:alpha=1,setpts=PTS-STARTPTS[hk];
 [cv][hk]overlay=0:0:eof_action=pass:enable='lte(t,2.6)',ass=subs.ass:fontsdir=$FONTS,$NV[vout];
 [9:a]$NA,atrim=0:18.30,asetpts=PTS-STARTPTS,volume=0.13,afade=t=in:d=0.5,afade=t=out:st=17.7:d=0.6[bed];
 [ca][bed]amix=inputs=2:normalize=0:duration=first,loudnorm=I=-16:TP=-1.5:LRA=11,$NA,atrim=0:18.30[aout]" \
 -map "[vout]" -map "[aout]" -t 18.30 -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k body.tmp.mp4 && mv body.tmp.mp4 body.mp4
ffmpeg -loglevel error -y -i body.mp4 -i $B/endcard.mp4 -filter_complex "[0:v]$NV[v0];[1:v]$NV[v1];[0:a]$NA[a0];[1:a]$NA[a1];[v0][a0][v1][a1]concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart out.tmp.mp4 && mv out.tmp.mp4 therapy-closingcosts_v1.mp4
echo built
