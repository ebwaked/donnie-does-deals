#!/usr/bin/env bash
# Therapy Ep. 2 "Perfect Credit". Usage: build.sh <donnie clip1> [offset seconds for each of the 5 shots]
set -euo pipefail
S=/tmp/claude-0/-home-claude/78ec04d5-29fd-5ca6-94f4-999a4ff9e093/scratchpad; P=$S/p4; B=$S/pilot1/build
FONTS=/home/claude/donnie-does-deals/brand/fonts
C1=${1:-c1.mp4}; O1=${2:-0}; O2=${3:-0}; O3=${4:-0}; O4=${5:-0}; O5=${6:-0}
NV="fps=30,setsar=1,format=yuv420p,settb=AVTB"; NA="aresample=48000,aformat=sample_fmts=fltp:channel_layouts=stereo,asettb=AVTB"
# Donnie clips come back wider than the keyframe: punch in ~1.55x on the face (static crop, no zoom move).
PD1="crop=iw*0.64:iw*0.64*16/9:iw*0.18:ih*0.04,scale=1080:1920:flags=lanczos"
PD2="crop=iw*0.70:iw*0.70*16/9:iw*0.15:ih*0.06,scale=1080:1920:flags=lanczos"
PT="scale=1080:1920:flags=lanczos"
PC1=${PC1:-$PD1}
PC5=${PC5:-$PD1}
r(){ python3 -c "print(round($1,3))"; }
cd $P
# shot durations: D1 3.24 | T1 1.00 | D2 4.53 | T2 1.80 | D3 2.92 (incl. 0.8s hold after the punchline)
ffmpeg -loglevel error -y -i $C1 -i th1.mp4 -i c2.mp4 -i th2.mp4 -i c3.mp4 -i tw.wav -i th1.wav -i th2.wav -loop 1 -i hook.png -i bed.wav -filter_complex "
 [0:v]$PC1,$NV,trim=$(r 0.3+$O1):$(r 0.3+$O1+3.24),setpts=PTS-STARTPTS[v1];
 [1:v]$PT,$NV,trim=$(r 0.3+$O2):$(r 0.3+$O2+1.00),setpts=PTS-STARTPTS[v2];
 [2:v]$PD2,$NV,trim=$(r 0.3+$O3):$(r 0.3+$O3+4.53),setpts=PTS-STARTPTS[v3];
 [3:v]$PT,$NV,trim=$(r 0.3+$O4):$(r 0.3+$O4+1.80),setpts=PTS-STARTPTS[v4];
 [4:v]$PC5,$NV,trim=$(r 0.3+$O5):$(r 0.3+$O5+2.92),setpts=PTS-STARTPTS[v5];
 [5:a]$NA,asplit=3[w1][w2][w3];
 [w1]atrim=0.12:3.36,asetpts=PTS-STARTPTS[a1];
 [6:a]$NA,atrim=0.3:1.3,asetpts=PTS-STARTPTS[a2];
 [w2]atrim=3.36:7.89,asetpts=PTS-STARTPTS[a3];
 [7:a]$NA,atrim=0.3:2.1,asetpts=PTS-STARTPTS[a4];
 [w3]atrim=7.89:10.81,asetpts=PTS-STARTPTS[a5];
 [v1][a1][v2][a2][v3][a3][v4][a4][v5][a5]concat=n=5:v=1:a=1[cv][ca];
 [8:v]format=rgba,trim=0:2.6,fade=t=out:st=2.3:d=0.3:alpha=1,setpts=PTS-STARTPTS[hk];
 [cv][hk]overlay=0:0:eof_action=pass:enable='lte(t,2.6)',ass=subs.ass:fontsdir=$FONTS,$NV[vout];
 [9:a]$NA,atrim=0:13.49,asetpts=PTS-STARTPTS,volume=0.13,afade=t=in:d=0.5,afade=t=out:st=12.9:d=0.59[bed];
 [ca][bed]amix=inputs=2:normalize=0:duration=first,loudnorm=I=-16:TP=-1.5:LRA=11,$NA,atrim=0:13.49[aout]" \
 -map "[vout]" -map "[aout]" -t 13.49 -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k body.mp4
ffmpeg -loglevel error -y -i body.mp4 -i $B/endcard.mp4 -filter_complex "[0:v]$NV[v0];[1:v]$NV[v1];[0:a]$NA[a0];[1:a]$NA[a1];[v0][a0][v1][a1]concat=n=2:v=1:a=1[v][a]" -map "[v]" -map "[a]" -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart therapy-credit_v1.mp4
echo built
