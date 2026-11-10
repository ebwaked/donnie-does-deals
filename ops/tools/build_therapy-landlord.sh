#!/usr/bin/env bash
# Therapy Ep. 5 "The Landlord". Lip-sync v3: no offsets. Line 1 uses 0.5s audio lead (retake). D1 OTS 5.50 | T1 2.05 | card+VO 3.30 | T2 2.70 | D3 3.70
set -euo pipefail
S=/tmp/claude-0/-home-claude/78ec04d5-29fd-5ca6-94f4-999a4ff9e093/scratchpad; P=$S/p8; B=$S/pilot1/build
FONTS=/home/claude/donnie-does-deals/brand/fonts
C3=${C3:-c3.mp4}; D1V=${D1V:-c1c.mp4}; OUT=${OUT:-therapy-landlord_v1.mp4}
C1=${C1:-"crop=iw*0.80:iw*0.80*16/9:iw*0.18:ih*0.05,scale=1080:1920:flags=lanczos"}
C6=${C6:-"crop=iw*0.90:iw*0.90*16/9:iw*0.05:ih*0.03,scale=1080:1920:flags=lanczos"}
PT="scale=1080:1920:flags=lanczos"
NV="fps=30,setsar=1,format=yuv420p,settb=AVTB"; NA="aresample=48000,aformat=sample_fmts=fltp:channel_layouts=stereo,asettb=AVTB"
cd $P
T=17.25
ffmpeg -loglevel error -y -i $D1V -i th1.mp4 -loop 1 -i card0.png -loop 1 -i card1.png -i th2.mp4 -i $C3 -i d1b.wav -i th1.wav -i tw.wav -i th2.wav -i d3.wav -loop 1 -i hook.png -i bed.wav -filter_complex "
 [0:v]$C1,$NV,trim=0.5:6.00,setpts=PTS-STARTPTS[v1];
 [1:v]$PT,$NV,trim=0.3:2.35,setpts=PTS-STARTPTS[v2];
 [2:v]$PT,$NV,trim=0:1.59,setpts=PTS-STARTPTS[v3a];
 [3:v]$PT,$NV,trim=0:1.71,setpts=PTS-STARTPTS[v3b];
 [4:v]$PT,$NV,trim=0.3:3.00,setpts=PTS-STARTPTS[v5];
 [5:v]$C6,$NV,trim=0.3:4.00,setpts=PTS-STARTPTS[v6];
 [6:a]$NA,atrim=0.5:6.00,apad=whole_dur=5.5,asetpts=PTS-STARTPTS[a1];
 [7:a]$NA,atrim=0.3:2.35,asetpts=PTS-STARTPTS[a2];
 [8:a]$NA,asplit=2[w1][w2];
 [w1]atrim=6.45:8.04,asetpts=PTS-STARTPTS[a3a];
 [w2]atrim=8.04:9.75,asetpts=PTS-STARTPTS[a3b];
 [9:a]$NA,atrim=0.3:3.00,asetpts=PTS-STARTPTS[a5];
 [10:a]$NA,atrim=0.3:4.00,asetpts=PTS-STARTPTS[a6];
 [v1][a1][v2][a2][v3a][a3a][v3b][a3b][v5][a5][v6][a6]concat=n=6:v=1:a=1[cv][ca];
 [11:v]format=rgba,trim=0:2.6,fade=t=out:st=2.3:d=0.3:alpha=1,setpts=PTS-STARTPTS[hk];
 [cv][hk]overlay=0:0:eof_action=pass:enable='lte(t,2.6)',ass=subs.ass:fontsdir=$FONTS,$NV[vout];
 [12:a]$NA,atrim=0:$T,asetpts=PTS-STARTPTS,volume=0.13,afade=t=in:d=0.5,afade=t=out:st=16.65:d=0.6[bed];
 [ca][bed]amix=inputs=2:normalize=0:duration=first,loudnorm=I=-16:TP=-1.5:LRA=11,$NA,atrim=0:$T[aout]" \
 -map "[vout]" -map "[aout]" -t $T -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k body.tmp.mp4 && mv body.tmp.mp4 body.mp4
ffmpeg -loglevel error -y -i body.mp4 -i $B/endcard.mp4 -filter_complex "[0:v]$NV[v0];[1:v]$NV[v1];[0:a]$NA[a0];[1:a]$NA[a1];[v0][a0][v1][a1]concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart out.tmp.mp4 && mv out.tmp.mp4 $OUT
echo built $OUT
