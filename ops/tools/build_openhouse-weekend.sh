#!/usr/bin/env bash
# "Open House Weekend". Shots: D1 3.14 | [cookie insert 1.61 + D2 1.68] | D3 3.73 | D4 3.60 (0.8s hold after "Call me.")
set -euo pipefail
S=/tmp/claude-0/-home-claude/78ec04d5-29fd-5ca6-94f4-999a4ff9e093/scratchpad; P=$S/p5; B=$S/pilot1/build
FONTS=/home/claude/donnie-does-deals/brand/fonts
O1=${O1:-0}; O2=${O2:-0}; O3=${O3:-0}; O4=${O4:-0}
CA=${CA:-"crop=iw*0.85:iw*0.85*16/9:iw*0.075:ih*0.02,scale=1080:1920:flags=lanczos"}
CB=${CB:-"crop=iw*0.80:iw*0.80*16/9:iw*0.10:ih*0.03,scale=1080:1920:flags=lanczos"}
NV="fps=30,setsar=1,format=yuv420p,settb=AVTB"; NA="aresample=48000,aformat=sample_fmts=fltp:channel_layouts=stereo,asettb=AVTB"
r(){ python3 -c "print(round($1,3))"; }
cd $P
ffmpeg -loglevel error -y -i c1.mp4 -i c2.mp4 -i c3.mp4 -i c4.mp4 -framerate 30 -i cookie_1080.png -i tw.wav -loop 1 -i hook.png -i bed.wav -filter_complex "
 [0:v]$CA,$NV,trim=$(r 0.3+$O1):$(r 0.3+$O1+3.14),setpts=PTS-STARTPTS[v1];
 [4:v]format=yuv420p,loop=-1:1,trim=duration=1.61,$NV,setpts=PTS-STARTPTS[vi];
 [1:v]$CB,$NV,trim=$(r 0.3+$O2+1.61):$(r 0.3+$O2+3.29),setpts=PTS-STARTPTS[v2];
 [2:v]$CA,$NV,trim=$(r 0.3+$O3):$(r 0.3+$O3+3.73),setpts=PTS-STARTPTS[v3];
 [3:v]$CB,$NV,trim=$(r 0.3+$O4):$(r 0.3+$O4+3.60),setpts=PTS-STARTPTS[v4];
 [v1][vi][v2][v3][v4]concat=n=5:v=1:a=0[cv];
 [5:a]$NA,atrim=0.10:13.86,asetpts=PTS-STARTPTS[vo];
 [6:v]format=rgba,trim=0:2.6,fade=t=out:st=2.3:d=0.3:alpha=1,setpts=PTS-STARTPTS[hk];
 [cv][hk]overlay=0:0:eof_action=pass:enable='lte(t,2.6)',ass=subs.ass:fontsdir=$FONTS,$NV[vout];
 [7:a]$NA,atrim=0:13.76,asetpts=PTS-STARTPTS,volume=0.13,afade=t=in:d=0.5,afade=t=out:st=13.16:d=0.6[bed];
 [vo][bed]amix=inputs=2:normalize=0:duration=first,loudnorm=I=-16:TP=-1.5:LRA=11,$NA,atrim=0:13.76[aout]" \
 -map "[vout]" -map "[aout]" -t 13.76 -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k body.tmp.mp4 && mv body.tmp.mp4 body.mp4
ffmpeg -loglevel error -y -i body.mp4 -i $B/endcard.mp4 -filter_complex "[0:v]$NV[v0];[1:v]$NV[v1];[0:a]$NA[a0];[1:a]$NA[a1];[v0][a0][v1][a1]concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart openhouse.tmp.mp4 && mv openhouse.tmp.mp4 openhouse-weekend_v1.mp4
echo built
