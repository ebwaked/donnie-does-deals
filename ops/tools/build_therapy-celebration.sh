#!/usr/bin/env bash
# Therapy Ep. 4 "The Celebration". Lip-sync v3: no offsets. D1 OTS 5.60 | T1 1.70 | card 1.40 | listen+VO 4.10 | T2 2.25 | D3 3.30 (1.0s hold)
set -euo pipefail
S=/tmp/claude-0/-home-claude/78ec04d5-29fd-5ca6-94f4-999a4ff9e093/scratchpad; P=$S/p7; B=$S/pilot1/build
FONTS=/home/claude/donnie-does-deals/brand/fonts
C3=${C3:-c3.mp4}; OUT=${OUT:-therapy-celebration_v1.mp4}
C1=${C1:-"crop=iw*0.80:iw*0.80*16/9:iw*0.18:ih*0.05,scale=1080:1920:flags=lanczos"}
C6=${C6:-"crop=iw*0.90:iw*0.90*16/9:iw*0.05:ih*0.03,scale=1080:1920:flags=lanczos"}
PT="scale=1080:1920:flags=lanczos"
NV="fps=30,setsar=1,format=yuv420p,settb=AVTB"; NA="aresample=48000,aformat=sample_fmts=fltp:channel_layouts=stereo,asettb=AVTB"
cd $P
T=18.35
ffmpeg -loglevel error -y -i c1.mp4 -i th1.mp4 -loop 1 -i card.png -i listen.mp4 -i th2.mp4 -i $C3 -i d1.wav -i th1.wav -i tw.wav -i th2.wav -loop 1 -i hook.png -i bed.wav -filter_complex "
 [0:v]$C1,$NV,trim=0.3:5.90,setpts=PTS-STARTPTS[v1];
 [1:v]$PT,$NV,trim=0.3:2.00,setpts=PTS-STARTPTS[v2];
 [2:v]$PT,$NV,trim=0:1.40,setpts=PTS-STARTPTS[v3];
 [3:v]$PT,$NV,trim=0:4.10,setpts=PTS-STARTPTS[v4];
 [4:v]$PT,$NV,trim=0.5:2.75,setpts=PTS-STARTPTS[v5];
 [5:v]$C6,$NV,trim=0.3:3.60,setpts=PTS-STARTPTS[v6];
 [6:a]$NA,atrim=0.3:5.90,asetpts=PTS-STARTPTS[a1];
 [7:a]$NA,atrim=0.3:2.00,asetpts=PTS-STARTPTS[a2];
 [8:a]$NA,asplit=3[w1][w2][w3];
 [w1]atrim=7.30:8.70,asetpts=PTS-STARTPTS[a3];
 [w2]atrim=9.45:13.55,asetpts=PTS-STARTPTS[a4];
 [9:a]$NA,atrim=0.5:2.75,asetpts=PTS-STARTPTS[a5];
 [w3]atrim=14.55:17.14,asetpts=PTS-STARTPTS,apad=whole_dur=3.30[a6];
 [v1][a1][v2][a2][v3][a3][v4][a4][v5][a5][v6][a6]concat=n=6:v=1:a=1[cv][ca];
 [10:v]format=rgba,trim=0:2.6,fade=t=out:st=2.3:d=0.3:alpha=1,setpts=PTS-STARTPTS[hk];
 [cv][hk]overlay=0:0:eof_action=pass:enable='lte(t,2.6)',ass=subs.ass:fontsdir=$FONTS,$NV[vout];
 [11:a]$NA,atrim=0:$T,asetpts=PTS-STARTPTS,volume=0.13,afade=t=in:d=0.5,afade=t=out:st=17.75:d=0.6[bed];
 [ca][bed]amix=inputs=2:normalize=0:duration=first,loudnorm=I=-16:TP=-1.5:LRA=11,$NA,atrim=0:$T[aout]" \
 -map "[vout]" -map "[aout]" -t $T -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k body.tmp.mp4 && mv body.tmp.mp4 body.mp4
ffmpeg -loglevel error -y -i body.mp4 -i $B/endcard.mp4 -filter_complex "[0:v]$NV[v0];[1:v]$NV[v1];[0:a]$NA[a0];[1:a]$NA[a1];[v0][a0][v1][a1]concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart out.tmp.mp4 && mv out.tmp.mp4 $OUT
echo built $OUT
